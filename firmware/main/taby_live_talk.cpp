#include "taby_live_talk.h"

#include <algorithm>
#include <atomic>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <new>
#include <string>

extern "C" {
#include "board_amoled_1_64.h"
#include "taby_display.h"
#include "taby_idle_eyes.h"
}
#include "esp_heap_caps.h"
#include "esp_random.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/idf_additions.h"
#include "freertos/semphr.h"
#include "freertos/task.h"
#include "rive_plutovg.hpp"
#include "taby_character.hpp"
#include "taby_face.hpp"
#include "taby_voice.hpp"

extern const uint8_t taby_talk_riv_start[] asm("_binary_taby_talk_riv_start");
extern const uint8_t taby_talk_riv_end[] asm("_binary_taby_talk_riv_end");

/*
 * The firmware's C++ is the live character (Rive and its renderer), and its
 * thousands of small objects go in PSRAM. malloc() keeps anything under
 * CONFIG_SPIRAM_MALLOC_ALWAYSINTERNAL in internal RAM, and the character's
 * load alone left 12 KB of it, so the Bluetooth controller could not start
 * and the board restarted at every boot (first board run, 2026-11-15).
 * Internal RAM is still used when PSRAM is out.
 */
namespace
{
void *cxxAlloc(std::size_t size)
{
  if (size == 0) size = 1;
  void *p = heap_caps_malloc(size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
  return p != nullptr ? p : std::malloc(size);
}
} // namespace

void *operator new(std::size_t size)
{
  void *p = cxxAlloc(size);
  if (p == nullptr) abort();
  return p;
}
void *operator new[](std::size_t size) { return operator new(size); }
void *operator new(std::size_t size, const std::nothrow_t &) noexcept { return cxxAlloc(size); }
void *operator new[](std::size_t size, const std::nothrow_t &) noexcept { return cxxAlloc(size); }
void operator delete(void *p) noexcept { std::free(p); }
void operator delete[](void *p) noexcept { std::free(p); }
void operator delete(void *p, std::size_t) noexcept { std::free(p); }
void operator delete[](void *p, std::size_t) noexcept { std::free(p); }
void operator delete(void *p, const std::nothrow_t &) noexcept { std::free(p); }
void operator delete[](void *p, const std::nothrow_t &) noexcept { std::free(p); }

namespace
{

const char *TAG = "taby_live_talk";

/* The panel as the GIF pack is drawn, and the character's landscape. */
constexpr int kPanelW = 280;
constexpr int kPanelH = 456;
constexpr int kLandW = kPanelH;
constexpr int kLandH = kPanelW;
/* A clip waiting for the face to rest shows after this whatever happens. */
constexpr int64_t kLeaveMaxUs = 1200 * 1000;

enum class Load : int
{
  idle,
  loading,
  ready,
  failed
};
std::atomic<Load> s_load{Load::idle};

/* A panel box, half-open: [x0, x1) x [y0, y1). */
struct Box
{
  int x0 = 0, y0 = 0, x1 = 0, y1 = 0;
  bool empty() const { return x1 <= x0 || y1 <= y0; }
  static Box full() { return {0, 0, kPanelW, kPanelH}; }
  Box unite(const Box &o) const
  {
    if (empty()) return o;
    if (o.empty()) return *this;
    return {std::min(x0, o.x0), std::min(y0, o.y0), std::max(x1, o.x1), std::max(y1, o.y1)};
  }
};

uint32_t boardRandom() { return esp_random(); }

struct Live
{
  rive_plutovg::Factory factory;
  taby::Character character;
  taby::LiveFace face{character, boardRandom};
  /* What the app sent; the serial and Bluetooth tasks write it. */
  taby::VoiceMotion voice;
  SemaphoreHandle_t voiceLock = nullptr;
  /* Premultiplied ARGB on black, in the panel's layout. */
  uint32_t *argb = nullptr;
  plutovg_canvas_t *canvas = nullptr;
  rive_plutovg::Renderer *renderer = nullptr;
  /* What the canvas object shows, in LVGL's colour format. */
  lv_color_t *pixels = nullptr;
  /* Written under the LVGL lock, read by the render task. */
  lv_obj_t *object = nullptr;
  std::atomic<bool> showing{false};
  std::atomic<int> wantFace{0};
  std::atomic<int> eyes{0};
  std::atomic<int> after{TABY_LIVE_AFTER_OTHER};
  /* A show the render task has not started yet. */
  std::atomic<bool> started{false};
  /* A clip waits for the face to rest; `left` tells the display. */
  std::atomic<bool> leaving{false};
  std::atomic<int64_t> leaveSince{0};
  lv_async_cb_t left = nullptr;
};
Live *s_live = nullptr;
TaskHandle_t s_task = nullptr;

double nowMs() { return esp_timer_get_time() / 1000.0; }

bool faceFor(const char *animation_id, taby::Face *face)
{
  if (animation_id == nullptr) return false;
  if (std::strcmp(animation_id, "idle_01_loop") == 0)
    *face = taby::Face::idle;
  else if (std::strcmp(animation_id, "listening_loop") == 0)
    *face = taby::Face::listening;
  else if (std::strcmp(animation_id, "talking_default_loop") == 0)
    *face = taby::Face::talking;
  else
    return false;
  return true;
}

Box boxFrom(const float f[4])
{
  Box b;
  b.x0 = std::max(0, (int)std::floor(f[0]));
  b.y0 = std::max(0, (int)std::floor(f[1]));
  b.x1 = std::min(kPanelW, (int)std::ceil(f[2]));
  b.y1 = std::min(kPanelH, (int)std::ceil(f[3]));
  return b;
}

void clearBox(uint32_t *pixels, const Box &b)
{
  for (int y = b.y0; y < b.y1; ++y)
    std::memset(pixels + y * kPanelW + b.x0, 0, (b.x1 - b.x0) * sizeof(uint32_t));
}

/* The box of the ARGB frame into the canvas's pixels. */
void toScreen(const Box &b)
{
  for (int y = b.y0; y < b.y1; ++y)
  {
    const uint32_t *from = s_live->argb + y * kPanelW;
    lv_color_t *to = s_live->pixels + y * kPanelW;
    for (int x = b.x0; x < b.x1; ++x)
    {
      const uint32_t p = from[x];
      to[x] = lv_color_make((p >> 16) & 0xff, (p >> 8) & 0xff, p & 0xff);
    }
  }
}

bool load()
{
  Live *live = new (std::nothrow) Live();
  if (live == nullptr) return false;
  const size_t argbBytes = kPanelW * kPanelH * sizeof(uint32_t);
  const size_t pixelBytes = kPanelW * kPanelH * sizeof(lv_color_t);
  live->argb = static_cast<uint32_t *>(heap_caps_aligned_alloc(64, argbBytes, MALLOC_CAP_SPIRAM));
  live->pixels = static_cast<lv_color_t *>(heap_caps_malloc(pixelBytes, MALLOC_CAP_SPIRAM));
  live->voiceLock = xSemaphoreCreateMutex();
  if (live->argb == nullptr || live->pixels == nullptr || live->voiceLock == nullptr)
  {
    ESP_LOGE(TAG, "no memory for the frames");
    return false;
  }
  std::memset(live->argb, 0, argbBytes);
  std::memset(live->pixels, 0, pixelBytes);
  live->canvas = plutovg_canvas_create(plutovg_surface_create_for_data(
      reinterpret_cast<unsigned char *>(live->argb), kPanelW, kPanelH, kPanelW * 4));
  live->renderer = new (std::nothrow) rive_plutovg::Renderer(live->canvas);
  std::string error;
  const double started = nowMs();
  const size_t before = heap_caps_get_free_size(MALLOC_CAP_SPIRAM);
  // Rive's arrays use malloc() itself: while it loads, small blocks go in
  // PSRAM too, and then malloc() keeps its usual limit.
  heap_caps_malloc_extmem_enable(0);
  const bool loaded =
      live->renderer != nullptr &&
      live->character.load(
          rive::Span<const uint8_t>(taby_talk_riv_start, taby_talk_riv_end - taby_talk_riv_start),
          &live->factory,
          &error);
  heap_caps_malloc_extmem_enable(CONFIG_SPIRAM_MALLOC_ALWAYSINTERNAL);
  if (!loaded)
  {
    ESP_LOGE(TAG, "character did not load: %s", error.c_str());
    return false;
  }
  ESP_LOGI(TAG,
           "character loaded in %.0f ms, %u KB; internal RAM free %u KB",
           nowMs() - started,
           (unsigned)((before - heap_caps_get_free_size(MALLOC_CAP_SPIRAM)) / 1024),
           (unsigned)(heap_caps_get_free_size(MALLOC_CAP_INTERNAL) / 1024));
  s_live = live;
  return true;
}

/* The face has rested (or the screen is dark): the clip may show. */
void notifyLeft(Live &live)
{
  if (!live.leaving.load() || !board_amoled_1_64_lock(50)) return;
  if (live.leaving.load() && live.left != nullptr)
  {
    live.leaving = false;
    lv_async_call(live.left, nullptr);
    live.left = nullptr;
  }
  board_amoled_1_64_unlock();
}

/* One frame of the character onto the panel: the box that changed. */
void drawFrame(Live &live, const plutovg_matrix_t &placement, Box &previous)
{
  clearBox(live.argb, previous);
  plutovg_canvas_reset_matrix(live.canvas);
  plutovg_canvas_transform(live.canvas, &placement);
  live.renderer->resetDrawn();
  live.character.draw(live.renderer, kLandW, kLandH);
  float drawn[4];
  const Box current = live.renderer->drawn(drawn) ? boxFrom(drawn) : Box();
  // The screen must lose what the last frame drew and gain this one; the
  // panel takes even edges.
  Box send = previous.unite(current);
  send.x0 &= ~1;
  send.y0 &= ~1;
  send.x1 = std::min(kPanelW, (send.x1 + 1) & ~1);
  send.y1 = std::min(kPanelH, (send.y1 + 1) & ~1);
  previous = current;
  if (!send.empty() && board_amoled_1_64_lock(50))
  {
    if (live.showing.load() && live.object != nullptr)
    {
      toScreen(send);
      lv_area_t area = {(lv_coord_t)send.x0, (lv_coord_t)send.y0,
                        (lv_coord_t)(send.x1 - 1), (lv_coord_t)(send.y1 - 1)};
      lv_obj_invalidate_area(live.object, &area);
    }
    board_amoled_1_64_unlock();
  }
}

[[maybe_unused]] void renderTask(void *)
{
  if (!load())
  {
    s_load = Load::failed;
    vTaskDelete(nullptr);
    return;
  }
  s_load = Load::ready;
  // A face the display drew as a GIF while the character loaded turns live.
  if (board_amoled_1_64_lock(1000))
  {
    lv_async_call(taby_display_live_ready, nullptr);
    board_amoled_1_64_unlock();
  }
  Live &live = *s_live;
  taby::LiveFace &face = live.face;
  const taby::Placement &p = taby::kPanelPlacement;
  const plutovg_matrix_t placement = {p.a, p.b, p.c, p.d, p.e, p.f};
  Box previous = Box::full();
  bool fresh = true;
  int64_t last = esp_timer_get_time();
  for (;;)
  {
    if (!live.showing.load())
    {
      ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
      last = esp_timer_get_time();
      continue;
    }
    if (!board_amoled_1_64_display_enabled())
    {
      // A dark screen draws nothing; a clip waiting for the face goes ahead.
      notifyLeft(live);
      vTaskDelay(pdMS_TO_TICKS(200));
      last = esp_timer_get_time();
      continue;
    }
    const int64_t frameStart = esp_timer_get_time();
    const double now = frameStart / 1000.0;
    const float dt = std::min(0.1f, (frameStart - last) / 1e6f);
    last = frameStart;
    if (live.started.exchange(false))
    {
      // Back from a clip, a card or nothing: the face starts on its neutral
      // rest, where the pack's clips end.
      if (live.after.load() != TABY_LIVE_AFTER_LIVE) face.startFromRest(now);
      previous = Box::full();
      fresh = true;
    }
    const taby::Face wanted = static_cast<taby::Face>(live.wantFace.load());
    face.show(wanted);
    face.setEyes(static_cast<taby::Eyes>(live.eyes.load()));
    const bool leaving = live.leaving.load();
    if (leaving)
      face.handOver();
    else
      face.takeBack();
    taby::SpeechFrame frame;
    const taby::SpeechFrame *speech = nullptr;
    if (wanted == taby::Face::talking && xSemaphoreTake(live.voiceLock, pdMS_TO_TICKS(5)) == pdTRUE)
    {
      frame = live.voice.at(now);
      xSemaphoreGive(live.voiceLock);
      speech = &frame;
    }
    if (face.advance(dt, now, speech) || fresh)
    {
      drawFrame(live, placement, previous);
      fresh = false;
    }
    if (leaving && (face.atRest(now) || frameStart - live.leaveSince.load() > kLeaveMaxUs))
    {
      notifyLeft(live);
    }
    const int64_t wait = (int64_t)(face.frameMs() * 1000) - (esp_timer_get_time() - frameStart);
    vTaskDelay(wait > 1000 ? pdMS_TO_TICKS(wait / 1000) : 1);
  }
}

} // namespace

extern "C" void taby_live_talk_start(void)
{
#if defined(TABY_HARDWARE_ROUND_1_32)
  // The character is drawn for the 1.64's 280 x 456 panel. The round board
  // keeps its GIFs and does not list voice_motion.
  return;
#else
  Load idle = Load::idle;
  if (!s_load.compare_exchange_strong(idle, Load::loading)) return;
  // Core 1, beside the LVGL task; the stack is in PSRAM, as Rive's draw
  // recursion wants room the internal RAM does not have to spare.
  if (xTaskCreatePinnedToCoreWithCaps(renderTask, "taby_live", 24 * 1024, nullptr, 3, &s_task, 1,
                                      MALLOC_CAP_SPIRAM) != pdPASS)
  {
    ESP_LOGE(TAG, "no task");
    s_load = Load::failed;
  }
#endif
}

extern "C" bool taby_live_talk_offered(void)
{
  const Load load = s_load.load();
  return load == Load::loading || load == Load::ready;
}

extern "C" bool taby_live_talk_ready(void) { return s_load.load() == Load::ready; }

extern "C" bool taby_live_talk_takes(const char *animation_id)
{
  taby::Face face;
  return s_load.load() == Load::ready && faceFor(animation_id, &face);
}

extern "C" void taby_live_talk_take_frame(lv_obj_t *gif)
{
  if (s_load.load() != Load::ready || gif == nullptr || !lv_obj_check_type(gif, &lv_gif_class)) return;
  const lv_gif_t *g = reinterpret_cast<const lv_gif_t *>(gif);
  const lv_img_dsc_t &shown = g->imgdsc;
  if (g->gif == nullptr || shown.data == nullptr || shown.header.w != kPanelW ||
      shown.header.h != kPanelH || shown.header.cf != LV_IMG_CF_TRUE_COLOR_ALPHA)
  {
    std::memset(s_live->pixels, 0, kPanelW * kPanelH * sizeof(lv_color_t));
    return;
  }
  // Two colour bytes and an alpha byte a pixel; what is clear shows black.
  const uint8_t *from = shown.data;
  for (int i = 0; i < kPanelW * kPanelH; ++i, from += LV_IMG_PX_SIZE_ALPHA_BYTE)
  {
    lv_color_t colour;
    std::memcpy(&colour, from, sizeof(colour));
    s_live->pixels[i] = from[LV_IMG_PX_SIZE_ALPHA_BYTE - 1] != 0 ? colour : lv_color_black();
  }
}

extern "C" lv_obj_t *taby_live_talk_show(lv_obj_t *parent, const char *animation_id,
                                         taby_live_after_t after)
{
  taby::Face face;
  if (s_load.load() != Load::ready || !faceFor(animation_id, &face)) return nullptr;
  lv_obj_t *canvas = lv_canvas_create(parent);
  if (canvas == nullptr) return nullptr;
  // Until the face's first frame lands: the last live frame, the clip's
  // last frame, or black.
  if (after == TABY_LIVE_AFTER_OTHER)
    std::memset(s_live->pixels, 0, kPanelW * kPanelH * sizeof(lv_color_t));
  lv_canvas_set_buffer(canvas, s_live->pixels, kPanelW, kPanelH, LV_IMG_CF_TRUE_COLOR);
  lv_obj_clear_flag(canvas, LV_OBJ_FLAG_SCROLLABLE);
  lv_obj_set_pos(canvas, 0, 0);
  s_live->object = canvas;
  s_live->wantFace = static_cast<int>(face);
  s_live->eyes = static_cast<int>(taby_idle_eyes_mode());
  s_live->after = after;
  s_live->leaving = false;
  s_live->left = nullptr;
  s_live->started = true;
  s_live->showing = true;
  xTaskNotifyGive(s_task);
  return canvas;
}

extern "C" void taby_live_talk_change(const char *animation_id)
{
  taby::Face face;
  if (s_live == nullptr || !faceFor(animation_id, &face)) return;
  s_live->wantFace = static_cast<int>(face);
  s_live->leaving = false;
  s_live->left = nullptr;
}

extern "C" bool taby_live_talk_leave(lv_async_cb_t left)
{
  if (s_live == nullptr || !s_live->showing.load() || left == nullptr ||
      !board_amoled_1_64_display_enabled())
    return false;
  s_live->left = left;
  s_live->leaveSince = esp_timer_get_time();
  s_live->leaving = true;
  return true;
}

extern "C" void taby_live_talk_hide(void)
{
  if (s_live == nullptr) return;
  s_live->showing = false;
  s_live->object = nullptr;
  s_live->leaving = false;
  s_live->left = nullptr;
}

extern "C" void taby_live_talk_set_eye_motion(int mode)
{
  if (s_live == nullptr) return;
  s_live->eyes = mode >= 0 && mode <= 2 ? mode : 0;
}

extern "C" bool taby_live_talk_voice_motion(const char *args)
{
  if (s_load.load() != Load::ready || args == nullptr) return false;
  if (xSemaphoreTake(s_live->voiceLock, pdMS_TO_TICKS(20)) != pdTRUE) return false;
  const bool taken = s_live->voice.take(args, nowMs());
  xSemaphoreGive(s_live->voiceLock);
  return taken;
}
