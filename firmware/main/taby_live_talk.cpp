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
#include "taby_runtime.h"
}
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/idf_additions.h"
#include "freertos/semphr.h"
#include "freertos/task.h"
#include "rive_plutovg.hpp"
#include "taby_character.hpp"
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
const char *const kTalking = "talking_default_loop";

/* The panel as the GIF pack is drawn, and the character's landscape. */
constexpr int kPanelW = 280;
constexpr int kPanelH = 456;
constexpr int kLandW = kPanelH;
constexpr int kLandH = kPanelW;
constexpr int64_t kFrameUs = 33333;

enum class Load : int
{
  idle,
  loading,
  ready,
  failed
};
std::atomic<Load> s_load{Load::idle};

/* Talking is drawn live only while the app drives the mouth: from a run that
   came in the last few seconds. An app that sends none keeps the talking GIF,
   whose mouth moves (Peter's app on the first board run, 2026-11-15). */
constexpr int64_t kDrivenUs = 4000000;
std::atomic<int64_t> s_lastRunUs{-1};

bool driven()
{
  const int64_t at = s_lastRunUs.load();
  return at >= 0 && esp_timer_get_time() - at < kDrivenUs;
}

/* "<talk> stop", as opposed to a run of frames. */
bool isStop(const char *args)
{
  const char *space = std::strchr(args, ' ');
  return space != nullptr && std::strcmp(space + 1, "stop") == 0;
}

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

struct Live
{
  rive_plutovg::Factory factory;
  taby::Character character;
  /* What the app sent; the serial and Bluetooth tasks write it. */
  taby::VoiceMotion voice;
  SemaphoreHandle_t voiceLock = nullptr;
  /* Premultiplied ARGB on black, in the panel's layout. */
  uint32_t *argb = nullptr;
  plutovg_canvas_t *canvas = nullptr;
  rive_plutovg::Renderer *renderer = nullptr;
  /* What the canvas object shows, in LVGL's colour format. */
  lv_color_t *pixels = nullptr;
  /* Set and cleared under the LVGL lock. */
  lv_obj_t *object = nullptr;
  std::atomic<bool> showing{false};
};
Live *s_live = nullptr;
TaskHandle_t s_task = nullptr;

double nowMs() { return esp_timer_get_time() / 1000.0; }

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

void renderTask(void *)
{
  if (!load())
  {
    s_load = Load::failed;
    vTaskDelete(nullptr);
    return;
  }
  s_load = Load::ready;
  taby::Character &character = s_live->character;
  // Landscape (u right, v down) onto the portrait panel: up is the panel's
  // +x, as in the GIF pack.
  const plutovg_matrix_t landscape = {0, 1, -1, 0, (float)kPanelW, 0};
  bool drawing = false;
  Box previous = Box::full();
  int64_t last = esp_timer_get_time();
  for (;;)
  {
    if (!s_live->showing.load())
    {
      if (drawing) character.setMode(taby::Mode::idle, nowMs());
      drawing = false;
      ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
      last = esp_timer_get_time();
      continue;
    }
    const int64_t frameStart = esp_timer_get_time();
    const double now = frameStart / 1000.0;
    const float dt = std::min(0.1f, (frameStart - last) / 1e6f);
    last = frameStart;
    if (!drawing)
    {
      character.setMode(taby::Mode::speaking, now);
      previous = Box::full();
      drawing = true;
    }
    taby::SpeechFrame frame;
    if (xSemaphoreTake(s_live->voiceLock, pdMS_TO_TICKS(5)) == pdTRUE)
    {
      frame = s_live->voice.at(now);
      xSemaphoreGive(s_live->voiceLock);
    }
    // The body takes a gesture once the action before it has let go.
    if (!character.layersFree()) frame.gesture = "idle";
    character.applySpeech(frame, now);
    character.advance(dt, now);

    clearBox(s_live->argb, previous);
    plutovg_canvas_reset_matrix(s_live->canvas);
    plutovg_canvas_transform(s_live->canvas, &landscape);
    s_live->renderer->resetDrawn();
    character.draw(s_live->renderer, kLandW, kLandH);
    float drawn[4];
    const Box current = s_live->renderer->drawn(drawn) ? boxFrom(drawn) : Box();
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
      if (s_live->showing.load() && s_live->object != nullptr)
      {
        toScreen(send);
        lv_area_t area = {(lv_coord_t)send.x0, (lv_coord_t)send.y0,
                          (lv_coord_t)(send.x1 - 1), (lv_coord_t)(send.y1 - 1)};
        lv_obj_invalidate_area(s_live->object, &area);
      }
      board_amoled_1_64_unlock();
    }
    const int64_t wait = kFrameUs - (esp_timer_get_time() - frameStart);
    vTaskDelay(wait > 1000 ? pdMS_TO_TICKS(wait / 1000) : 1);
  }
}

} // namespace

extern "C" void taby_live_talk_start(void)
{
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
}

extern "C" bool taby_live_talk_offered(void)
{
  const Load load = s_load.load();
  return load == Load::loading || load == Load::ready;
}

extern "C" bool taby_live_talk_ready(void) { return s_load.load() == Load::ready; }

extern "C" bool taby_live_talk_takes(const char *animation_id)
{
  return s_load.load() == Load::ready && animation_id != nullptr &&
         std::strcmp(animation_id, kTalking) == 0 && driven();
}

extern "C" lv_obj_t *taby_live_talk_show(lv_obj_t *parent)
{
  if (s_load.load() != Load::ready) return nullptr;
  lv_obj_t *canvas = lv_canvas_create(parent);
  if (canvas == nullptr) return nullptr;
  // Black until the first frame lands, a frame or two from now.
  std::memset(s_live->pixels, 0, kPanelW * kPanelH * sizeof(lv_color_t));
  lv_canvas_set_buffer(canvas, s_live->pixels, kPanelW, kPanelH, LV_IMG_CF_TRUE_COLOR);
  lv_obj_clear_flag(canvas, LV_OBJ_FLAG_SCROLLABLE);
  lv_obj_set_pos(canvas, 0, 0);
  s_live->object = canvas;
  s_live->showing = true;
  xTaskNotifyGive(s_task);
  return canvas;
}

extern "C" void taby_live_talk_hide(void)
{
  if (s_live == nullptr) return;
  s_live->showing = false;
  s_live->object = nullptr;
}

extern "C" bool taby_live_talk_voice_motion(const char *args)
{
  if (s_load.load() != Load::ready || args == nullptr) return false;
  if (xSemaphoreTake(s_live->voiceLock, pdMS_TO_TICKS(20)) != pdTRUE) return false;
  const bool taken = s_live->voice.take(args, nowMs());
  xSemaphoreGive(s_live->voiceLock);
  if (taken && !isStop(args))
  {
    s_lastRunUs = esp_timer_get_time();
    // A talk that began as its GIF goes live now.
    if (!s_live->showing.load()) taby_runtime_take_talk_live(kTalking);
  }
  return taken;
}
