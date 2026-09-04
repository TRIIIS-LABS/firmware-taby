#include "taby_visual_smoke.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdint.h>

#include "board_amoled_1_64.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "esp_heap_caps.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "lvgl.h"
#include "taby_display.h"
#include "taby_state_machine.h"

typedef enum {
    TABY_SMOKE_SCENE_CARD = 0,
    TABY_SMOKE_SCENE_STATE,
} taby_smoke_scene_kind_t;

typedef struct {
    taby_smoke_scene_kind_t kind;
    taby_state_t state;
    const char *title;
    const char *subtitle;
    uint32_t dwell_ms;
    uint32_t background_hex;
    uint32_t accent_hex;
    uint32_t text_hex;
} taby_smoke_scene_t;

static const char *TAG = "taby_visual_smoke";
static const int64_t k_tap_min_us = 60 * 1000LL;
static const int64_t k_tap_max_us = 700 * 1000LL;
static const int64_t k_tap_rearm_us = 180 * 1000LL;

#define SMOKE_CARD_CANVAS_W 320
#define SMOKE_CARD_CANVAS_H 180
#define SMOKE_HUD_CANVAS_W 340
#define SMOKE_HUD_CANVAS_H 56

static const taby_smoke_scene_t k_smoke_scenes[] = {
    {
        .kind = TABY_SMOKE_SCENE_CARD,
        .state = TABY_STATE_AMBIENT_IDLE,
        .title = "PANEL WHITE",
        .subtitle = "Static full-screen color test",
        .dwell_ms = 1500,
        .background_hex = 0xFFFFFF,
        .accent_hex = 0x111111,
        .text_hex = 0x111111,
    },
    {
        .kind = TABY_SMOKE_SCENE_CARD,
        .state = TABY_STATE_AMBIENT_IDLE,
        .title = "PANEL GREEN",
        .subtitle = "Static card and text contrast",
        .dwell_ms = 1500,
        .background_hex = 0x08140E,
        .accent_hex = 0x2DE087,
        .text_hex = 0xF4FFF8,
    },
    {
        .kind = TABY_SMOKE_SCENE_CARD,
        .state = TABY_STATE_FOCUS_TIMER,
        .title = "FOCUS TIMER",
        .subtitle = "Fallback label screen",
        .dwell_ms = 2500,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_AMBIENT_STARTUP,
        .title = "AMBIENT STARTUP",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_AMBIENT_IDLE,
        .title = "AMBIENT IDLE",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_AMBIENT_WAITING,
        .title = "AMBIENT WAITING",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_VOICE_LISTENING,
        .title = "VOICE LISTENING",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_VOICE_TALKING,
        .title = "VOICE TALKING",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
    {
        .kind = TABY_SMOKE_SCENE_STATE,
        .state = TABY_STATE_TOOL_USE,
        .title = "TOOL USE",
        .subtitle = "Generated AMOLED asset",
        .dwell_ms = 0,
        .background_hex = 0x000000,
        .accent_hex = 0x2DE087,
        .text_hex = 0xFFFFFF,
    },
};

static size_t s_current_scene_index = 0;
static size_t s_pending_scene_index = 0;
static volatile bool s_render_pending = false;
static lv_timer_t *s_scene_timer = NULL;
static bool s_touch_press_active = false;
static int64_t s_touch_press_start_us = 0;
static int64_t s_touch_last_tap_us = 0;
static lv_obj_t *s_smoke_card_canvas = NULL;
static lv_color_t *s_smoke_card_canvas_buf = NULL;
static lv_obj_t *s_smoke_hud_canvas = NULL;
static lv_color_t *s_smoke_hud_canvas_buf = NULL;

static lv_color_t color_from_hex(uint32_t hex) {
    return lv_color_make(
        (uint8_t)((hex >> 16) & 0xFF),
        (uint8_t)((hex >> 8) & 0xFF),
        (uint8_t)(hex & 0xFF));
}

static size_t scene_count(void) {
    return sizeof(k_smoke_scenes) / sizeof(k_smoke_scenes[0]);
}

static size_t next_scene_index(void) {
    return (s_current_scene_index + 1U) % scene_count();
}

static void queue_next_scene(const char *reason) {
    s_pending_scene_index = next_scene_index();
    s_render_pending = true;
    ESP_LOGI(TAG, "queue_next_scene reason=%s next=%u",
             reason,
             (unsigned int)s_pending_scene_index);
}

static void cancel_scene_timer(void) {
    if (!s_scene_timer) {
        return;
    }
    lv_timer_del(s_scene_timer);
    s_scene_timer = NULL;
}

static void destroy_smoke_canvases(void) {
    if (s_smoke_card_canvas) {
        lv_obj_del(s_smoke_card_canvas);
        s_smoke_card_canvas = NULL;
    }
    if (s_smoke_hud_canvas) {
        lv_obj_del(s_smoke_hud_canvas);
        s_smoke_hud_canvas = NULL;
    }
    if (s_smoke_card_canvas_buf) {
        heap_caps_free(s_smoke_card_canvas_buf);
        s_smoke_card_canvas_buf = NULL;
    }
    if (s_smoke_hud_canvas_buf) {
        heap_caps_free(s_smoke_hud_canvas_buf);
        s_smoke_hud_canvas_buf = NULL;
    }
}

static lv_obj_t *create_rotated_canvas(
    lv_color_t **buffer,
    lv_coord_t width,
    lv_coord_t height,
    lv_coord_t x_ofs,
    lv_coord_t y_ofs) {
    if (!*buffer) {
        *buffer = heap_caps_malloc(
            (size_t)width * (size_t)height * sizeof(lv_color_t),
            MALLOC_CAP_SPIRAM);
    }
    if (!*buffer) {
        return NULL;
    }

    lv_obj_t *canvas = lv_canvas_create(lv_scr_act());
    lv_canvas_set_buffer(canvas, *buffer, width, height, LV_IMG_CF_TRUE_COLOR);
    lv_img_set_angle(canvas, 900);
    lv_img_set_pivot(canvas, width / 2, height / 2);
    lv_obj_align(canvas, LV_ALIGN_CENTER, x_ofs, y_ofs);
    return canvas;
}

static void handle_scene_timer(lv_timer_t *timer) {
    if (timer == s_scene_timer) {
        s_scene_timer = NULL;
    }
    queue_next_scene("scene_timer");
}

static void handle_animation_complete(taby_state_t state, void *ctx) {
    (void)ctx;
    ESP_LOGI(TAG, "animation_complete state=%s", taby_state_name(state));
    queue_next_scene("animation_complete");
}

static void render_smoke_hud(const taby_smoke_scene_t *scene) {
    s_smoke_hud_canvas = create_rotated_canvas(
        &s_smoke_hud_canvas_buf,
        SMOKE_HUD_CANVAS_W,
        SMOKE_HUD_CANVAS_H,
        -102,
        0);
    if (!s_smoke_hud_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_smoke_hud_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_rect_dsc_t border_dsc;
    lv_draw_rect_dsc_init(&border_dsc);
    border_dsc.bg_opa = LV_OPA_COVER;
    border_dsc.bg_color = lv_color_black();
    border_dsc.border_opa = LV_OPA_COVER;
    border_dsc.border_width = 1;
    border_dsc.border_color = color_from_hex(scene->accent_hex);
    border_dsc.radius = 16;
    lv_canvas_draw_rect(s_smoke_hud_canvas, 4, 4, SMOKE_HUD_CANVAS_W - 8, SMOKE_HUD_CANVAS_H - 8, &border_dsc);

    lv_draw_label_dsc_t title_dsc;
    lv_draw_label_dsc_init(&title_dsc);
    title_dsc.color = color_from_hex(scene->accent_hex);
    title_dsc.font = &lv_font_montserrat_16;
    title_dsc.align = LV_TEXT_ALIGN_LEFT;

    char title_buf[128];
    snprintf(
        title_buf,
        sizeof(title_buf),
        "%u/%u %s",
        (unsigned int)(s_current_scene_index + 1U),
        (unsigned int)scene_count(),
        scene->title);
    lv_canvas_draw_text(s_smoke_hud_canvas, 20, 10, 230, &title_dsc, title_buf);

    lv_draw_label_dsc_t hint_dsc;
    lv_draw_label_dsc_init(&hint_dsc);
    hint_dsc.color = lv_color_make(0x9A, 0xA0, 0x9D);
    hint_dsc.font = &lv_font_montserrat_16;
    hint_dsc.align = LV_TEXT_ALIGN_RIGHT;
    lv_canvas_draw_text(s_smoke_hud_canvas, 220, 13, 100, &hint_dsc, "Tap to advance");
}

static void render_state_hint(const taby_smoke_scene_t *scene) {
    s_smoke_card_canvas = create_rotated_canvas(
        &s_smoke_card_canvas_buf,
        SMOKE_CARD_CANVAS_W,
        SMOKE_CARD_CANVAS_H,
        96,
        0);
    if (!s_smoke_card_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_smoke_card_canvas, lv_color_black(), LV_OPA_TRANSP);

    lv_draw_rect_dsc_t card_dsc;
    lv_draw_rect_dsc_init(&card_dsc);
    card_dsc.bg_opa = LV_OPA_70;
    card_dsc.bg_color = lv_color_black();
    card_dsc.border_opa = LV_OPA_40;
    card_dsc.border_width = 1;
    card_dsc.border_color = color_from_hex(scene->accent_hex);
    card_dsc.radius = 24;
    lv_canvas_draw_rect(s_smoke_card_canvas, 12, 10, SMOKE_CARD_CANVAS_W - 24, SMOKE_CARD_CANVAS_H - 20, &card_dsc);

    lv_draw_label_dsc_t title_dsc;
    lv_draw_label_dsc_init(&title_dsc);
    title_dsc.color = color_from_hex(scene->text_hex);
    title_dsc.font = &lv_font_montserrat_20;
    title_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(s_smoke_card_canvas, 24, 36, SMOKE_CARD_CANVAS_W - 48, &title_dsc, scene->title);

    lv_draw_label_dsc_t subtitle_dsc;
    lv_draw_label_dsc_init(&subtitle_dsc);
    subtitle_dsc.color = lv_color_make(0xB8, 0xBC, 0xBF);
    subtitle_dsc.font = &lv_font_montserrat_16;
    subtitle_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(s_smoke_card_canvas, 24, 98, SMOKE_CARD_CANVAS_W - 48, &subtitle_dsc, scene->subtitle);
}

static void render_static_card(const taby_smoke_scene_t *scene) {
    lv_obj_t *screen = lv_scr_act();
    lv_obj_set_style_bg_color(screen, color_from_hex(scene->background_hex), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    render_state_hint(scene);
}

static void poll_touch_advance(void) {
    board_amoled_1_64_touch_sample_t sample = {0};
    board_amoled_1_64_last_touch(&sample);

    int64_t now_us = esp_timer_get_time();

    if (sample.pressed) {
        if (!s_touch_press_active) {
            s_touch_press_active = true;
            s_touch_press_start_us = now_us;
        }
        return;
    }

    if (!s_touch_press_active) {
        return;
    }

    int64_t press_us = now_us - s_touch_press_start_us;
    int64_t since_last_tap_us = now_us - s_touch_last_tap_us;
    s_touch_press_active = false;

    if (press_us < k_tap_min_us || press_us > k_tap_max_us || since_last_tap_us < k_tap_rearm_us) {
        return;
    }

    s_touch_last_tap_us = now_us;
    queue_next_scene("tap");
}

static void render_scene(size_t scene_index) {
    const taby_smoke_scene_t *scene = &k_smoke_scenes[scene_index];
    bool animation_started = false;

    cancel_scene_timer();
    destroy_smoke_canvases();
    taby_display_clear();

    if (scene->kind == TABY_SMOKE_SCENE_CARD) {
        render_static_card(scene);
        render_smoke_hud(scene);
    } else {
        animation_started = taby_display_render_state(
            scene->state,
            taby_state_has_animation(scene->state) ? handle_animation_complete : NULL,
            NULL,
            NULL,
            NULL,
            NULL);

        if (!animation_started) {
            render_state_hint(scene);
            render_smoke_hud(scene);
        }
    }

    if (scene->dwell_ms > 0 && (scene->kind == TABY_SMOKE_SCENE_CARD || !animation_started)) {
        s_scene_timer = lv_timer_create(handle_scene_timer, scene->dwell_ms, NULL);
        lv_timer_set_repeat_count(s_scene_timer, 1);
    }

    s_current_scene_index = scene_index;

    ESP_LOGI(
        TAG,
        "render_scene index=%u kind=%s state=%s animation_started=%s",
        (unsigned int)scene_index,
        scene->kind == TABY_SMOKE_SCENE_CARD ? "card" : "state",
        taby_state_name(scene->state),
        animation_started ? "true" : "false");
}

static void visual_smoke_task(void *arg) {
    (void)arg;

    while (true) {
        poll_touch_advance();

        if (s_render_pending && board_amoled_1_64_lock(10)) {
            s_render_pending = false;
            render_scene(s_pending_scene_index);
            board_amoled_1_64_unlock();
        }

        vTaskDelay(pdMS_TO_TICKS(20));
    }
}

void taby_visual_smoke_start(void) {
    s_current_scene_index = 0;
    s_pending_scene_index = 0;
    s_render_pending = false;

    if (board_amoled_1_64_lock(-1)) {
        taby_display_init();
        render_scene(0);
        lv_refr_now(board_amoled_1_64_display());
        board_amoled_1_64_unlock();
    }

    xTaskCreate(visual_smoke_task, "taby_smoke", 4096, NULL, 4, NULL);
}
