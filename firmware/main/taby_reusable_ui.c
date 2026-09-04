#include "taby_reusable_ui.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>

#include "taby_animation_assets.h"
#include "taby_asset_store.h"
#include "board_amoled_1_64.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "lvgl.h"
#include "generated/taby_reusable_icons.h"
#include "taby_display.h"
#include "taby_runtime.h"

static const lv_coord_t TABY_REUSABLE_CANVAS_W = 456;
static const lv_coord_t TABY_REUSABLE_CANVAS_H = 280;
static const char *TAG = "taby_reusable_ui";

static const lv_coord_t TABY_REUSABLE_CHOICE_BUTTON_W = 192;
static const lv_coord_t TABY_REUSABLE_CHOICE_BUTTON_H = 152;
static const lv_coord_t TABY_REUSABLE_CHOICE_LEFT_X = 16;
static const lv_coord_t TABY_REUSABLE_CHOICE_RIGHT_X = 248;
static const lv_coord_t TABY_REUSABLE_CHOICE_BUTTON_Y = 100;
static const int64_t TABY_REUSABLE_TAP_MIN_US = 20 * 1000;
static const int64_t TABY_REUSABLE_TAP_MAX_US = 700 * 1000;
static const int64_t TABY_REUSABLE_TAP_REARM_US = 120 * 1000;
static const size_t TABY_REUSABLE_TOUCH_REGION_COUNT = 2;

static lv_obj_t *s_canvas = NULL;
static lv_color_t *s_canvas_buf = NULL;
static lv_obj_t *s_primary_text_canvas = NULL;
static lv_color_t *s_primary_text_canvas_buf = NULL;
static lv_obj_t *s_decor_layer = NULL;
static TaskHandle_t s_touch_task_handle = NULL;
static volatile bool s_interactive_card_active = false;
static bool s_touch_press_active = false;
static int64_t s_touch_press_start_us = 0;
static int64_t s_touch_last_tap_us = 0;
static uint16_t s_touch_last_x = 0;
static uint16_t s_touch_last_y = 0;
static taby_reusable_choice_signal_t s_choice_signal = {0};
static portMUX_TYPE s_choice_signal_lock = portMUX_INITIALIZER_UNLOCKED;
static lv_timer_t *s_text_effect_timer = NULL;
static lv_timer_t *s_text_effect_stop_timer = NULL;
static lv_timer_t *s_animation_on_show_timer = NULL;
static lv_timer_t *s_animation_replay_timer = NULL;
static lv_timer_t *s_decor_effect_stop_timer = NULL;
static lv_timer_t *s_countdown_tick_timer = NULL;
static lv_timer_t *s_countdown_hide_timer = NULL;
static lv_obj_t *s_effect_target_label = NULL;
static bool s_effect_target_visible = true;
static taby_reusable_text_effect_t s_active_text_effect = TABY_REUSABLE_TEXT_EFFECT_NONE;
static char s_text_effect_base_text[96] = {0};
static uint8_t s_loading_dot_count = 0;

typedef struct {
    char headline[48];
    char title[96];
    char subtitle[128];
    char icon_id[24];
    char primary_action_label[48];
    char secondary_action_label[48];
    char animation_id[64];
    taby_reusable_card_t card;
    bool valid;
} taby_reusable_active_card_t;

static taby_reusable_active_card_t s_active_card = {0};

typedef struct {
    bool valid;
    lv_coord_t draw_width;
    lv_coord_t text_y;
    const lv_font_t *font;
    lv_coord_t letter_space;
    lv_coord_t line_space;
    uint32_t color_hex;
} taby_reusable_primary_text_canvas_state_t;

typedef struct {
    bool valid;
    lv_coord_t x;
    lv_coord_t y;
    lv_coord_t w;
    lv_coord_t h;
} taby_reusable_progress_rect_t;

typedef struct {
    bool valid;
    uint16_t x;
    uint16_t y;
    uint16_t w;
    uint16_t h;
    taby_reusable_choice_selection_t selection;
} taby_reusable_touch_region_t;

typedef struct {
    const char *icon_id;
    uint8_t *decoded_data;
    size_t decoded_data_size;
    lv_img_dsc_t img;
    bool loaded;
} taby_reusable_decor_icon_asset_t;

static taby_reusable_primary_text_canvas_state_t s_primary_text_canvas_state = {0};
static taby_reusable_progress_rect_t s_countdown_progress_rect = {0};
static taby_reusable_touch_region_t s_touch_regions[2] = {0};
static taby_reusable_decor_icon_asset_t s_decor_heart_asset = {.icon_id = "heart"};
static taby_reusable_decor_icon_asset_t s_decor_star_asset = {.icon_id = "star"};
static bool s_countdown_active = false;
static int64_t s_countdown_sync_us = 0;
static uint32_t s_countdown_base_remaining_seconds = 0;
static uint32_t s_countdown_last_remaining_seconds = 0;

static const char *card_kind_name(taby_reusable_card_kind_t kind) {
    switch (kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            return "title";
        case TABY_REUSABLE_CARD_TEXT:
            return "title_subtitle";
        case TABY_REUSABLE_CARD_ICON_ONLY:
            return "icon";
        case TABY_REUSABLE_CARD_ICON_TEXT:
            return "title_icon";
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
            return "title_icon_row";
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            return "title_icon_subtitle";
        case TABY_REUSABLE_CARD_ACTION:
            return "title_action";
        case TABY_REUSABLE_CARD_CHOICE_2:
            return "choice_2";
        case TABY_REUSABLE_CARD_COUNTDOWN:
            return "timer";
        case TABY_REUSABLE_CARD_PROGRESS:
            return "progress";
        default:
            return "unknown";
    }
}

static lv_color_t color_from_hex(uint32_t hex) {
    return lv_color_make(
        (uint8_t)((hex >> 16) & 0xFF),
        (uint8_t)((hex >> 8) & 0xFF),
        (uint8_t)(hex & 0xFF));
}

static bool has_text(const char *text) {
    return text && text[0] != '\0';
}

static void copy_optional_text(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0U) {
        return;
    }

    destination[0] = '\0';
    if (!source) {
        return;
    }

    snprintf(destination, destination_size, "%s", source);
}

static const char *stored_optional_text(char *buffer) {
    return has_text(buffer) ? buffer : NULL;
}

static void clear_countdown_behavior_state(void);
static void start_countdown_behavior(const taby_reusable_card_t *card);
static void format_countdown(char *buffer, size_t buffer_size, uint32_t seconds_remaining);
static void start_title_decor_effect(const taby_reusable_card_t *card);
static bool redraw_loading_dots_primary_text_canvas(uint8_t dot_count);

static size_t canvas_buffer_bytes(void) {
    return (size_t)TABY_REUSABLE_CANVAS_W * (size_t)TABY_REUSABLE_CANVAS_H * sizeof(lv_color_t);
}

static void clear_behavior_state(void) {
    clear_countdown_behavior_state();

    if (s_text_effect_timer) {
        lv_timer_del(s_text_effect_timer);
        s_text_effect_timer = NULL;
    }
    if (s_text_effect_stop_timer) {
        lv_timer_del(s_text_effect_stop_timer);
        s_text_effect_stop_timer = NULL;
    }
    if (s_animation_on_show_timer) {
        lv_timer_del(s_animation_on_show_timer);
        s_animation_on_show_timer = NULL;
    }
    if (s_animation_replay_timer) {
        lv_timer_del(s_animation_replay_timer);
        s_animation_replay_timer = NULL;
    }
    if (s_decor_effect_stop_timer) {
        lv_timer_del(s_decor_effect_stop_timer);
        s_decor_effect_stop_timer = NULL;
    }

    s_effect_target_label = NULL;
    s_effect_target_visible = true;
    s_active_text_effect = TABY_REUSABLE_TEXT_EFFECT_NONE;
    s_text_effect_base_text[0] = '\0';
    s_loading_dot_count = 0;
}

static void store_active_card(const taby_reusable_card_t *card) {
    if (!card) {
        s_active_card.valid = false;
        return;
    }

    memset(&s_active_card, 0, sizeof(s_active_card));
    s_active_card.card = *card;

    copy_optional_text(s_active_card.headline, sizeof(s_active_card.headline), card->headline);
    copy_optional_text(s_active_card.title, sizeof(s_active_card.title), card->title);
    copy_optional_text(s_active_card.subtitle, sizeof(s_active_card.subtitle), card->subtitle);
    copy_optional_text(s_active_card.icon_id, sizeof(s_active_card.icon_id), card->icon_id);
    copy_optional_text(
        s_active_card.primary_action_label,
        sizeof(s_active_card.primary_action_label),
        card->primary_action_label);
    copy_optional_text(
        s_active_card.secondary_action_label,
        sizeof(s_active_card.secondary_action_label),
        card->secondary_action_label);
    copy_optional_text(s_active_card.animation_id, sizeof(s_active_card.animation_id), card->behavior.animation_id);

    s_active_card.card.headline = stored_optional_text(s_active_card.headline);
    s_active_card.card.title = stored_optional_text(s_active_card.title);
    s_active_card.card.subtitle = stored_optional_text(s_active_card.subtitle);
    s_active_card.card.icon_id = stored_optional_text(s_active_card.icon_id);
    s_active_card.card.primary_action_label = stored_optional_text(s_active_card.primary_action_label);
    s_active_card.card.secondary_action_label = stored_optional_text(s_active_card.secondary_action_label);
    s_active_card.card.behavior.animation_id = stored_optional_text(s_active_card.animation_id);
    s_active_card.valid = true;
}

typedef struct {
    const lv_font_t *font;
    uint16_t zoom;
    lv_coord_t letter_space;
    lv_coord_t line_space;
} taby_reusable_scaled_text_layout_t;

typedef struct {
    const taby_reusable_scaled_text_layout_t *layout;
    lv_coord_t draw_width;
    lv_point_t text_size;
} taby_reusable_scaled_text_choice_t;

static const taby_reusable_scaled_text_layout_t k_reusable_scaled_text_layouts[] = {
    {&lv_font_montserrat_48, LV_IMG_ZOOM_NONE * 2, 2, 8},
    {&lv_font_montserrat_48, 448, 2, 8},
    {&lv_font_montserrat_48, 384, 1, 6},
    {&lv_font_montserrat_48, 320, 1, 4},
    {&lv_font_montserrat_28, 384, 1, 6},
    {&lv_font_montserrat_28, 352, 1, 6},
    {&lv_font_montserrat_28, 320, 0, 4},
    {&lv_font_montserrat_28, 288, 0, 4},
    {&lv_font_montserrat_28, 256, 0, 4},
    {&lv_font_montserrat_28, 224, 0, 4},
    {&lv_font_montserrat_20, 384, 0, 4},
    {&lv_font_montserrat_20, 320, 0, 4},
    {&lv_font_montserrat_20, 288, 0, 4},
    {&lv_font_montserrat_20, 256, 0, 4},
    {&lv_font_montserrat_20, 224, 0, 4},
    {&lv_font_montserrat_20, LV_IMG_ZOOM_NONE, 0, 4},
    {&lv_font_montserrat_16, 320, 0, 4},
    {&lv_font_montserrat_16, 288, 0, 4},
    {&lv_font_montserrat_16, 256, 0, 4},
    {&lv_font_montserrat_16, 224, 0, 4},
    {&lv_font_montserrat_16, 192, 0, 4},
    {&lv_font_montserrat_16, LV_IMG_ZOOM_NONE, 0, 2},
    {&lv_font_montserrat_12, 224, 0, 2},
    {&lv_font_montserrat_12, 192, 0, 2},
    {&lv_font_montserrat_12, 160, 0, 2},
    {&lv_font_montserrat_12, LV_IMG_ZOOM_NONE, 0, 2},
};

static const lv_font_t *const k_reusable_font_steps[] = {
    &lv_font_montserrat_12,
    &lv_font_montserrat_16,
    &lv_font_montserrat_20,
    &lv_font_montserrat_28,
    &lv_font_montserrat_48,
};

static uint16_t normalized_scale_percent(uint16_t scale_percent) {
    if (scale_percent == 0U) {
        return 100U;
    }
    if (scale_percent < 50U) {
        return 50U;
    }
    if (scale_percent > 200U) {
        return 200U;
    }
    return scale_percent;
}

static lv_coord_t clamp_coord(lv_coord_t value, lv_coord_t min_value, lv_coord_t max_value) {
    if (value < min_value) {
        return min_value;
    }
    if (value > max_value) {
        return max_value;
    }
    return value;
}

static const lv_font_t *font_step_at_index(int index) {
    if (index < 0) {
        index = 0;
    }
    int max_index = (int)(sizeof(k_reusable_font_steps) / sizeof(k_reusable_font_steps[0])) - 1;
    if (index > max_index) {
        index = max_index;
    }
    return k_reusable_font_steps[index];
}

static int font_step_index_for_font(const lv_font_t *font) {
    for (size_t i = 0; i < sizeof(k_reusable_font_steps) / sizeof(k_reusable_font_steps[0]); ++i) {
        if (k_reusable_font_steps[i] == font) {
            return (int)i;
        }
    }
    return 2;
}

static int scale_step_delta(uint16_t scale_percent) {
    uint16_t normalized = normalized_scale_percent(scale_percent);
    if (normalized >= 170U) {
        return 2;
    }
    if (normalized >= 110U) {
        return 1;
    }
    if (normalized <= 65U) {
        return -2;
    }
    if (normalized <= 85U) {
        return -1;
    }
    return 0;
}

static const lv_font_t *support_text_font(const char *text) {
    size_t text_len = text ? strlen(text) : 0U;
    if (text_len > 0U && text_len <= 14U) {
        return &lv_font_montserrat_28;
    }
    if (text_len <= 32U) {
        return &lv_font_montserrat_20;
    }
    return &lv_font_montserrat_16;
}

static const lv_font_t *support_text_font_scaled(const char *text, uint16_t scale_percent) {
    const lv_font_t *base_font = support_text_font(text);
    return font_step_at_index(font_step_index_for_font(base_font) + scale_step_delta(scale_percent));
}

static lv_coord_t button_text_inner_width(lv_coord_t button_width) {
    const lv_coord_t horizontal_padding = 24;
    return button_width > horizontal_padding ? button_width - horizontal_padding : button_width;
}

static bool text_fits_single_line(const char *text, const lv_font_t *font, lv_coord_t width) {
    if (!has_text(text) || !font) {
        return true;
    }

    lv_point_t text_size = {0};
    lv_txt_get_size(&text_size, text, font, 0, 0, LV_COORD_MAX, LV_TEXT_FLAG_NONE);
    return text_size.x <= width;
}

static const lv_font_t *button_text_font(lv_coord_t button_width, const char *text) {
    static const lv_font_t *fonts[] = {
        &lv_font_montserrat_28,
        &lv_font_montserrat_20,
        &lv_font_montserrat_16,
        &lv_font_montserrat_12,
    };
    lv_coord_t inner_width = button_text_inner_width(button_width);

    for (size_t i = 0; i < sizeof(fonts) / sizeof(fonts[0]); ++i) {
        if (text_fits_single_line(text, fonts[i], inner_width)) {
            return fonts[i];
        }
    }

    return &lv_font_montserrat_12;
}

static const char *humanized_icon_label(const char *icon_id, char *buffer, size_t buffer_size) {
    if (!buffer || buffer_size == 0U) {
        return NULL;
    }

    buffer[0] = '\0';
    if (!has_text(icon_id)) {
        return NULL;
    }

    size_t write_index = 0;
    for (size_t i = 0; icon_id[i] != '\0' && write_index + 1 < buffer_size; ++i) {
        unsigned char ch = (unsigned char)icon_id[i];
        if (!isalnum(ch)) {
            if (write_index > 0U && buffer[write_index - 1] != ' ') {
                buffer[write_index++] = ' ';
            }
            continue;
        }
        buffer[write_index++] = (char)toupper(ch);
    }

    while (write_index > 0U && buffer[write_index - 1] == ' ') {
        write_index--;
    }
    buffer[write_index] = '\0';
    return buffer[0] ? buffer : NULL;
}

static void clear_touch_regions(void) {
    memset(s_touch_regions, 0, sizeof(s_touch_regions));
}

static void set_touch_region(
    size_t index,
    lv_coord_t canvas_x,
    lv_coord_t canvas_y,
    lv_coord_t canvas_w,
    lv_coord_t canvas_h,
    taby_reusable_choice_selection_t selection) {
    if (index >= TABY_REUSABLE_TOUCH_REGION_COUNT || selection == TABY_REUSABLE_CHOICE_NONE) {
        return;
    }

    lv_coord_t screen_x = TABY_REUSABLE_CANVAS_H - (canvas_y + canvas_h);
    lv_coord_t screen_y = canvas_x;
    lv_coord_t screen_w = canvas_h;
    lv_coord_t screen_h = canvas_w;

    const lv_coord_t max_w = board_amoled_1_64_width();
    const lv_coord_t max_h = board_amoled_1_64_height();

    if (screen_x < 0) {
        screen_w += screen_x;
        screen_x = 0;
    }
    if (screen_y < 0) {
        screen_h += screen_y;
        screen_y = 0;
    }
    if (screen_x + screen_w > max_w) {
        screen_w = max_w - screen_x;
    }
    if (screen_y + screen_h > max_h) {
        screen_h = max_h - screen_y;
    }
    if (screen_w <= 0 || screen_h <= 0) {
        return;
    }

    s_touch_regions[index] = (taby_reusable_touch_region_t){
        .valid = true,
        .x = (uint16_t)screen_x,
        .y = (uint16_t)screen_y,
        .w = (uint16_t)screen_w,
        .h = (uint16_t)screen_h,
        .selection = selection,
    };
}

static taby_reusable_choice_selection_t choice_selection_for_touch(uint16_t x, uint16_t y) {
    for (size_t index = 0; index < TABY_REUSABLE_TOUCH_REGION_COUNT; ++index) {
        const taby_reusable_touch_region_t *region = &s_touch_regions[index];
        if (!region->valid) {
            continue;
        }

        if (x >= region->x &&
            x < (uint16_t)(region->x + region->w) &&
            y >= region->y &&
            y < (uint16_t)(region->y + region->h)) {
            return region->selection;
        }
    }

    return TABY_REUSABLE_CHOICE_NONE;
}

static void publish_choice_signal(taby_reusable_choice_selection_t selection) {
    if (selection == TABY_REUSABLE_CHOICE_NONE) {
        return;
    }

    taskENTER_CRITICAL(&s_choice_signal_lock);
    s_choice_signal.signal += 1U;
    s_choice_signal.selection = selection;
    taskEXIT_CRITICAL(&s_choice_signal_lock);
}

static void clear_choice_signal_selection(void) {
    taskENTER_CRITICAL(&s_choice_signal_lock);
    s_choice_signal.selection = TABY_REUSABLE_CHOICE_NONE;
    taskEXIT_CRITICAL(&s_choice_signal_lock);
}

static void reusable_touch_task(void *arg) {
    (void)arg;

    while (true) {
        if (!s_interactive_card_active) {
            s_touch_press_active = false;
            vTaskDelay(pdMS_TO_TICKS(20));
            continue;
        }

        board_amoled_1_64_touch_sample_t sample = {0};
        board_amoled_1_64_last_touch(&sample);
        int64_t now_us = esp_timer_get_time();

        if (sample.pressed) {
            if (!s_touch_press_active) {
                s_touch_press_active = true;
                s_touch_press_start_us = now_us;
                s_touch_last_x = sample.x;
                s_touch_last_y = sample.y;
            } else {
                s_touch_last_x = sample.x;
                s_touch_last_y = sample.y;
            }
            vTaskDelay(pdMS_TO_TICKS(20));
            continue;
        }

        if (!s_touch_press_active) {
            vTaskDelay(pdMS_TO_TICKS(20));
            continue;
        }

        int64_t press_us = now_us - s_touch_press_start_us;
        int64_t since_last_tap_us = now_us - s_touch_last_tap_us;
        s_touch_press_active = false;

        if (press_us >= TABY_REUSABLE_TAP_MIN_US &&
            press_us <= TABY_REUSABLE_TAP_MAX_US &&
            since_last_tap_us >= TABY_REUSABLE_TAP_REARM_US) {
            s_touch_last_tap_us = now_us;
            publish_choice_signal(choice_selection_for_touch(s_touch_last_x, s_touch_last_y));
        }

        vTaskDelay(pdMS_TO_TICKS(20));
    }
}

static bool render_card_internal(const taby_reusable_card_t *card, bool remember_card, bool allow_play_on_show);

static void stop_text_effect(void) {
    if (s_text_effect_timer) {
        lv_timer_del(s_text_effect_timer);
        s_text_effect_timer = NULL;
    }
    if (s_text_effect_stop_timer) {
        lv_timer_del(s_text_effect_stop_timer);
        s_text_effect_stop_timer = NULL;
    }

    s_effect_target_visible = true;
    if (s_effect_target_label) {
        lv_obj_clear_flag(s_effect_target_label, LV_OBJ_FLAG_HIDDEN);
        if (s_active_text_effect == TABY_REUSABLE_TEXT_EFFECT_LOADING_DOTS) {
            redraw_loading_dots_primary_text_canvas(3);
        }
        lv_obj_invalidate(s_effect_target_label);
    }
    s_active_text_effect = TABY_REUSABLE_TEXT_EFFECT_NONE;
    s_text_effect_base_text[0] = '\0';
    s_loading_dot_count = 0;
}

static void handle_text_effect_timer(lv_timer_t *timer) {
    if (timer != s_text_effect_timer || !s_effect_target_label) {
        return;
    }

    if (s_active_text_effect == TABY_REUSABLE_TEXT_EFFECT_LOADING_DOTS) {
        s_loading_dot_count = (uint8_t)((s_loading_dot_count + 1U) % 4U);
        redraw_loading_dots_primary_text_canvas(s_loading_dot_count);
        lv_refr_now(board_amoled_1_64_display());
        return;
    }

    s_effect_target_visible = !s_effect_target_visible;
    if (s_effect_target_visible) {
        lv_obj_clear_flag(s_effect_target_label, LV_OBJ_FLAG_HIDDEN);
    } else {
        lv_obj_add_flag(s_effect_target_label, LV_OBJ_FLAG_HIDDEN);
    }

    lv_obj_invalidate(s_effect_target_label);
    lv_refr_now(board_amoled_1_64_display());
}

static void handle_text_effect_stop_timer(lv_timer_t *timer) {
    if (timer == s_text_effect_stop_timer) {
        s_text_effect_stop_timer = NULL;
    }

    stop_text_effect();
    lv_refr_now(board_amoled_1_64_display());
}

static bool active_card_has_animation(void) {
    if (!s_active_card.valid || !has_text(s_active_card.card.behavior.animation_id)) {
        return false;
    }

    taby_animation_asset_t asset = {0};
    return taby_animation_asset_for_id(s_active_card.card.behavior.animation_id, &asset);
}

static bool render_active_card(bool allow_play_on_show) {
    if (!s_active_card.valid) {
        return false;
    }

    taby_display_clear();
    return render_card_internal(&s_active_card.card, false, allow_play_on_show);
}

static void handle_reusable_animation_complete(taby_state_t state, void *ctx) {
    (void)state;
    (void)ctx;
    render_active_card(false);
}

static bool show_active_card_animation(void) {
    if (!active_card_has_animation()) {
        return false;
    }

    char hint[72] = {0};
    snprintf(hint, sizeof(hint), "!%s", s_active_card.card.behavior.animation_id);

    taby_reusable_ui_reset();
    bool rendered = taby_display_render_state(
        TABY_STATE_AMBIENT_BUSY_ANIMATION,
        handle_reusable_animation_complete,
        NULL,
        NULL,
        hint,
        NULL);
    if (rendered) {
        taby_runtime_invalidate_render_cache();
    }
    return rendered;
}

static void handle_animation_on_show_timer(lv_timer_t *timer) {
    if (timer == s_animation_on_show_timer) {
        s_animation_on_show_timer = NULL;
    }

    if (!show_active_card_animation()) {
        render_active_card(false);
    }
}

static void handle_animation_replay_timer(lv_timer_t *timer) {
    if (timer == s_animation_replay_timer) {
        s_animation_replay_timer = NULL;
    }

    if (!show_active_card_animation()) {
        render_active_card(false);
    }
}

static lv_obj_t *create_rotated_canvas(void) {
    if (!s_canvas_buf) {
        s_canvas_buf = heap_caps_malloc(
            canvas_buffer_bytes(),
            MALLOC_CAP_SPIRAM);
    }
    if (!s_canvas_buf) {
        return NULL;
    }

    s_canvas = lv_canvas_create(lv_scr_act());
    lv_canvas_set_buffer(s_canvas, s_canvas_buf, TABY_REUSABLE_CANVAS_W, TABY_REUSABLE_CANVAS_H, LV_IMG_CF_TRUE_COLOR);
    lv_img_set_angle(s_canvas, 900);
    lv_img_set_pivot(s_canvas, TABY_REUSABLE_CANVAS_W / 2, TABY_REUSABLE_CANVAS_H / 2);
    lv_obj_align(s_canvas, LV_ALIGN_CENTER, 0, 0);
    return s_canvas;
}

static void fill_background(const taby_reusable_style_t *style) {
    lv_canvas_fill_bg(s_canvas, color_from_hex(style->background_hex), LV_OPA_COVER);
}

static bool card_supports_decor_effect(const taby_reusable_card_t *card) {
    return card &&
           card->behavior.decor_effect != TABY_REUSABLE_DECOR_EFFECT_NONE &&
           card->behavior.decor_effect_seconds > 0U &&
           (card->kind == TABY_REUSABLE_CARD_HEADLINE || card->kind == TABY_REUSABLE_CARD_TEXT);
}

static bool canvas_rect_to_screen_rect(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    lv_coord_t *out_x,
    lv_coord_t *out_y,
    lv_coord_t *out_w,
    lv_coord_t *out_h) {
    if (!out_x || !out_y || !out_w || !out_h || w <= 0 || h <= 0) {
        return false;
    }

    *out_x = TABY_REUSABLE_CANVAS_H - (y + h);
    *out_y = x;
    *out_w = h;
    *out_h = w;
    return *out_w > 0 && *out_h > 0;
}

static void free_decor_icon_asset(taby_reusable_decor_icon_asset_t *asset) {
    if (!asset || !asset->loaded) {
        return;
    }

    if (asset->decoded_data) {
        heap_caps_free(asset->decoded_data);
        asset->decoded_data = NULL;
    }
    memset(&asset->img, 0, sizeof(asset->img));
    asset->decoded_data_size = 0U;
    asset->loaded = false;
}

static bool load_decor_icon_asset(taby_reusable_decor_icon_asset_t *asset) {
    if (!asset || !asset->icon_id) {
        return false;
    }
    if (asset->loaded) {
        return true;
    }

    taby_reusable_icon_asset_t icon_asset = {0};
    if (!taby_reusable_icon_lookup(asset->icon_id, &icon_asset) || !icon_asset.asset_pack_path) {
        return false;
    }

    uint8_t *data = NULL;
    size_t data_size = 0U;
    if (!taby_asset_store_load_file(icon_asset.asset_pack_path, &data, &data_size)) {
        return false;
    }

    lv_img_dsc_t source_img = {
        .header.always_zero = 0,
        .header.w = icon_asset.width,
        .header.h = icon_asset.height,
        .header.cf = LV_IMG_CF_ALPHA_4BIT,
        .data_size = data_size,
        .data = data,
    };

    size_t decoded_bytes = LV_CANVAS_BUF_SIZE_TRUE_COLOR_ALPHA(icon_asset.width, icon_asset.height);
    uint8_t *decoded = heap_caps_malloc(decoded_bytes, MALLOC_CAP_SPIRAM);
    if (!decoded) {
        taby_asset_store_free_file(data);
        return false;
    }

    memset(decoded, 0, decoded_bytes);

    lv_img_dsc_t decoded_img = {
        .header.always_zero = 0,
        .header.w = icon_asset.width,
        .header.h = icon_asset.height,
        .header.cf = LV_IMG_CF_TRUE_COLOR_ALPHA,
        .data_size = decoded_bytes,
        .data = decoded,
    };

    const lv_color_t solid_white = lv_color_white();
    for (lv_coord_t y = 0; y < icon_asset.height; ++y) {
        for (lv_coord_t x = 0; x < icon_asset.width; ++x) {
            lv_opa_t alpha = lv_img_buf_get_px_alpha(&source_img, x, y);
            if (alpha == LV_OPA_TRANSP) {
                continue;
            }
            lv_img_buf_set_px_color(&decoded_img, x, y, solid_white);
            lv_img_buf_set_px_alpha(&decoded_img, x, y, alpha);
        }
    }

    taby_asset_store_free_file(data);

    asset->decoded_data = decoded;
    asset->decoded_data_size = decoded_bytes;
    asset->img.header.always_zero = 0;
    asset->img.header.w = icon_asset.width;
    asset->img.header.h = icon_asset.height;
    asset->img.header.cf = LV_IMG_CF_TRUE_COLOR_ALPHA;
    asset->img.data_size = decoded_bytes;
    asset->img.data = decoded;
    asset->loaded = true;
    return true;
}

static taby_reusable_decor_effect_t normalized_decor_effect(taby_reusable_decor_effect_t effect) {
    switch (effect) {
        case TABY_REUSABLE_DECOR_EFFECT_SHOOTING_STARS:
        case TABY_REUSABLE_DECOR_EFFECT_STAR_TWINKLE:
        case TABY_REUSABLE_DECOR_EFFECT_SUNBEAM_LINES:
            return TABY_REUSABLE_DECOR_EFFECT_SHOOTING_STARS;
        case TABY_REUSABLE_DECOR_EFFECT_COMET_BURST:
        case TABY_REUSABLE_DECOR_EFFECT_FLARE_FAN:
            return TABY_REUSABLE_DECOR_EFFECT_COMET_BURST;
        case TABY_REUSABLE_DECOR_EFFECT_FIREWORK_DOTS:
        case TABY_REUSABLE_DECOR_EFFECT_SQUARE_CONFETTI:
        case TABY_REUSABLE_DECOR_EFFECT_DIAMOND_BURST:
        case TABY_REUSABLE_DECOR_EFFECT_EMBER_DRIFT:
        case TABY_REUSABLE_DECOR_EFFECT_PIXEL_BURST:
        case TABY_REUSABLE_DECOR_EFFECT_CONFETTI_RAIN:
        case TABY_REUSABLE_DECOR_EFFECT_ORBIT_DOTS:
        case TABY_REUSABLE_DECOR_EFFECT_SPIRAL_SPARKS:
        case TABY_REUSABLE_DECOR_EFFECT_CHECKER_BURST:
            return TABY_REUSABLE_DECOR_EFFECT_FIREWORK_DOTS;
        case TABY_REUSABLE_DECOR_EFFECT_HEART_BURST:
        case TABY_REUSABLE_DECOR_EFFECT_PETAL_SWIRL:
            return TABY_REUSABLE_DECOR_EFFECT_HEART_BURST;
        case TABY_REUSABLE_DECOR_EFFECT_HEART_RAIN:
            return TABY_REUSABLE_DECOR_EFFECT_HEART_RAIN;
        case TABY_REUSABLE_DECOR_EFFECT_GLOW_WAVE:
            return TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP;
        case TABY_REUSABLE_DECOR_EFFECT_GOLD_RINGS:
        case TABY_REUSABLE_DECOR_EFFECT_BUBBLE_POP:
        case TABY_REUSABLE_DECOR_EFFECT_NEON_ARC:
            return TABY_REUSABLE_DECOR_EFFECT_GOLD_RINGS;
        case TABY_REUSABLE_DECOR_EFFECT_RIBBON_SWEEP:
            return TABY_REUSABLE_DECOR_EFFECT_RIBBON_SWEEP;
        case TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP:
        case TABY_REUSABLE_DECOR_EFFECT_PRISM_SHARDS:
            return TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP;
        default:
            return effect;
    }
}

static lv_obj_t *create_decor_layer(void) {
    if (s_decor_layer) {
        return s_decor_layer;
    }

    lv_obj_t *layer = lv_obj_create(lv_scr_act());
    if (!layer) {
        return NULL;
    }

    lv_obj_remove_style_all(layer);
    lv_obj_clear_flag(layer, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(layer, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_size(layer, board_amoled_1_64_width(), board_amoled_1_64_height());
    lv_obj_align(layer, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_obj_set_style_bg_opa(layer, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_opa(layer, LV_OPA_TRANSP, 0);
    lv_obj_set_style_pad_all(layer, 0, 0);
    lv_obj_move_foreground(layer);
    s_decor_layer = layer;
    return layer;
}

static void anim_obj_x(void *var, int32_t value) {
    lv_obj_set_x((lv_obj_t *)var, (lv_coord_t)value);
}

static void anim_obj_y(void *var, int32_t value) {
    lv_obj_set_y((lv_obj_t *)var, (lv_coord_t)value);
}

static void anim_obj_w(void *var, int32_t value) {
    lv_obj_set_width((lv_obj_t *)var, (lv_coord_t)value);
}

static void anim_obj_h(void *var, int32_t value) {
    lv_obj_set_height((lv_obj_t *)var, (lv_coord_t)value);
}

static void anim_obj_opa(void *var, int32_t value) {
    if (value < 0) {
        value = 0;
    } else if (value > LV_OPA_COVER) {
        value = LV_OPA_COVER;
    }
    lv_obj_set_style_opa((lv_obj_t *)var, (lv_opa_t)value, 0);
}

static void anim_img_zoom(void *var, int32_t value) {
    if (value < 16) {
        value = 16;
    }
    lv_img_set_zoom((lv_obj_t *)var, (uint16_t)value);
}

static void start_int_anim(
    void *var,
    lv_anim_exec_xcb_t exec_cb,
    uint32_t delay,
    uint32_t duration,
    int32_t from,
    int32_t to,
    lv_anim_path_cb_t path_cb) {
    if (!var || !exec_cb || duration == 0U) {
        return;
    }

    lv_anim_t anim;
    lv_anim_init(&anim);
    lv_anim_set_var(&anim, var);
    lv_anim_set_exec_cb(&anim, exec_cb);
    lv_anim_set_delay(&anim, delay);
    lv_anim_set_time(&anim, duration);
    lv_anim_set_values(&anim, from, to);
    lv_anim_set_path_cb(&anim, path_cb ? path_cb : lv_anim_path_ease_out);
    lv_anim_start(&anim);
}

static void start_pulse_opa(lv_obj_t *obj, uint32_t delay, uint32_t duration, lv_opa_t peak_opa) {
    if (!obj || duration == 0U) {
        return;
    }

    uint32_t fade_in_ms = duration / 3U;
    if (fade_in_ms < 120U) {
        fade_in_ms = duration / 2U;
    }
    uint32_t fade_out_ms = duration > fade_in_ms ? duration - fade_in_ms : fade_in_ms;

    lv_anim_t anim;
    lv_anim_init(&anim);
    lv_anim_set_var(&anim, obj);
    lv_anim_set_exec_cb(&anim, anim_obj_opa);
    lv_anim_set_delay(&anim, delay);
    lv_anim_set_time(&anim, fade_in_ms);
    lv_anim_set_values(&anim, 0, peak_opa);
    lv_anim_set_path_cb(&anim, lv_anim_path_ease_out);
    lv_anim_set_playback_time(&anim, fade_out_ms);
    lv_anim_set_playback_delay(&anim, 0U);
    lv_anim_start(&anim);
}

static lv_obj_t *create_decor_rect_obj(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    lv_coord_t radius,
    uint32_t color_hex) {
    lv_obj_t *layer = create_decor_layer();
    if (!layer) {
        return NULL;
    }

    lv_obj_t *obj = lv_obj_create(layer);
    if (!obj) {
        return NULL;
    }

    lv_obj_remove_style_all(obj);
    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(obj, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_pos(obj, x, y);
    lv_obj_set_size(obj, w, h);
    lv_obj_set_style_bg_color(obj, color_from_hex(color_hex), 0);
    lv_obj_set_style_bg_opa(obj, LV_OPA_COVER, 0);
    lv_obj_set_style_border_opa(obj, LV_OPA_TRANSP, 0);
    lv_obj_set_style_radius(obj, radius, 0);
    lv_obj_set_style_opa(obj, LV_OPA_TRANSP, 0);
    return obj;
}

static lv_obj_t *create_decor_rect_obj_canvas(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    lv_coord_t radius,
    uint32_t color_hex) {
    lv_coord_t screen_x = 0;
    lv_coord_t screen_y = 0;
    lv_coord_t screen_w = 0;
    lv_coord_t screen_h = 0;
    if (!canvas_rect_to_screen_rect(x, y, w, h, &screen_x, &screen_y, &screen_w, &screen_h)) {
        return NULL;
    }
    return create_decor_rect_obj(screen_x, screen_y, screen_w, screen_h, radius, color_hex);
}

static lv_obj_t *create_decor_ring_obj(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_coord_t border_width) {
    lv_obj_t *layer = create_decor_layer();
    if (!layer) {
        return NULL;
    }

    lv_obj_t *obj = lv_obj_create(layer);
    if (!obj) {
        return NULL;
    }

    lv_obj_remove_style_all(obj);
    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(obj, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_pos(obj, x, y);
    lv_obj_set_size(obj, size, size);
    lv_obj_set_style_bg_opa(obj, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_color(obj, color_from_hex(color_hex), 0);
    lv_obj_set_style_border_opa(obj, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(obj, border_width, 0);
    lv_obj_set_style_radius(obj, LV_RADIUS_CIRCLE, 0);
    lv_obj_set_style_opa(obj, LV_OPA_TRANSP, 0);
    return obj;
}

static lv_obj_t *create_decor_ring_obj_canvas(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_coord_t border_width) {
    lv_coord_t screen_x = 0;
    lv_coord_t screen_y = 0;
    lv_coord_t screen_w = 0;
    lv_coord_t screen_h = 0;
    if (!canvas_rect_to_screen_rect(x, y, size, size, &screen_x, &screen_y, &screen_w, &screen_h)) {
        return NULL;
    }
    lv_coord_t mapped_size = screen_w < screen_h ? screen_w : screen_h;
    return create_decor_ring_obj(screen_x, screen_y, mapped_size, color_hex, border_width);
}

static lv_obj_t *create_decor_icon_obj(
    taby_reusable_decor_icon_asset_t *asset,
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t size,
    uint32_t color_hex,
    uint16_t angle) {
    lv_obj_t *layer = create_decor_layer();
    if (!layer || !load_decor_icon_asset(asset)) {
        return NULL;
    }

    lv_obj_t *obj = lv_img_create(layer);
    if (!obj) {
        return NULL;
    }

    lv_img_set_src(obj, &asset->img);
    lv_obj_clear_flag(obj, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(obj, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_img_recolor(obj, color_from_hex(color_hex), 0);
    lv_obj_set_style_img_recolor_opa(obj, LV_OPA_COVER, 0);
    lv_obj_set_style_opa(obj, LV_OPA_TRANSP, 0);
    lv_obj_set_pos(obj, x, y);
    lv_img_set_pivot(obj, asset->img.header.w / 2, asset->img.header.h / 2);
    uint16_t zoom = (uint16_t)(((uint32_t)size * LV_IMG_ZOOM_NONE) / asset->img.header.w);
    if (zoom < 16U) {
        zoom = 16U;
    }
    lv_img_set_zoom(obj, zoom);
    if (angle > 0U) {
        lv_img_set_angle(obj, angle);
    }
    return obj;
}

static lv_obj_t *create_decor_icon_obj_canvas(
    taby_reusable_decor_icon_asset_t *asset,
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t size,
    uint32_t color_hex,
    uint16_t angle) {
    lv_coord_t screen_x = 0;
    lv_coord_t screen_y = 0;
    lv_coord_t screen_w = 0;
    lv_coord_t screen_h = 0;
    if (!canvas_rect_to_screen_rect(x, y, size, size, &screen_x, &screen_y, &screen_w, &screen_h)) {
        return NULL;
    }
    lv_coord_t mapped_size = screen_w < screen_h ? screen_w : screen_h;
    return create_decor_icon_obj(asset, screen_x, screen_y, mapped_size, color_hex, angle);
}

static void spawn_moving_rect(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t w,
    lv_coord_t h,
    lv_coord_t radius,
    uint32_t color_hex,
    lv_opa_t peak_opa) {
    lv_obj_t *obj = create_decor_rect_obj(from_x, from_y, w, h, radius, color_hex);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_x, to_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_y, to_y, lv_anim_path_ease_in_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
}

static void spawn_moving_rect_canvas(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t w,
    lv_coord_t h,
    lv_coord_t radius,
    uint32_t color_hex,
    lv_opa_t peak_opa) {
    lv_coord_t from_screen_x = 0;
    lv_coord_t from_screen_y = 0;
    lv_coord_t from_screen_w = 0;
    lv_coord_t from_screen_h = 0;
    lv_coord_t to_screen_x = 0;
    lv_coord_t to_screen_y = 0;
    lv_coord_t to_screen_w = 0;
    lv_coord_t to_screen_h = 0;
    if (!canvas_rect_to_screen_rect(from_x, from_y, w, h, &from_screen_x, &from_screen_y, &from_screen_w, &from_screen_h) ||
        !canvas_rect_to_screen_rect(to_x, to_y, w, h, &to_screen_x, &to_screen_y, &to_screen_w, &to_screen_h)) {
        return;
    }
    lv_obj_t *obj = create_decor_rect_obj(from_screen_x, from_screen_y, from_screen_w, from_screen_h, radius, color_hex);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_screen_x, to_screen_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_screen_y, to_screen_y, lv_anim_path_ease_in_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
}

static void spawn_moving_circle(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_opa_t peak_opa) {
    spawn_moving_rect(delay, duration, from_x, from_y, to_x, to_y, size, size, LV_RADIUS_CIRCLE, color_hex, peak_opa);
}

static void spawn_moving_circle_canvas(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_opa_t peak_opa) {
    spawn_moving_rect_canvas(delay, duration, from_x, from_y, to_x, to_y, size, size, LV_RADIUS_CIRCLE, color_hex, peak_opa);
}

static void spawn_ring_burst(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t center_x,
    lv_coord_t center_y,
    lv_coord_t start_size,
    lv_coord_t end_size,
    uint32_t color_hex,
    lv_coord_t border_width,
    lv_opa_t peak_opa) {
    lv_coord_t from_x = center_x - (start_size / 2);
    lv_coord_t from_y = center_y - (start_size / 2);
    lv_coord_t to_x = center_x - (end_size / 2);
    lv_coord_t to_y = center_y - (end_size / 2);
    lv_obj_t *obj = create_decor_ring_obj(from_x, from_y, start_size, color_hex, border_width);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_x, to_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_y, to_y, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_w, delay, duration, start_size, end_size, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_h, delay, duration, start_size, end_size, lv_anim_path_ease_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
}

static void spawn_ring_burst_canvas(
    uint32_t delay,
    uint32_t duration,
    lv_coord_t center_x,
    lv_coord_t center_y,
    lv_coord_t start_size,
    lv_coord_t end_size,
    uint32_t color_hex,
    lv_coord_t border_width,
    lv_opa_t peak_opa) {
    lv_coord_t from_x = center_x - (start_size / 2);
    lv_coord_t from_y = center_y - (start_size / 2);
    lv_coord_t to_x = center_x - (end_size / 2);
    lv_coord_t to_y = center_y - (end_size / 2);
    lv_coord_t from_screen_x = 0;
    lv_coord_t from_screen_y = 0;
    lv_coord_t from_screen_w = 0;
    lv_coord_t from_screen_h = 0;
    lv_coord_t to_screen_x = 0;
    lv_coord_t to_screen_y = 0;
    lv_coord_t to_screen_w = 0;
    lv_coord_t to_screen_h = 0;
    if (!canvas_rect_to_screen_rect(from_x, from_y, start_size, start_size, &from_screen_x, &from_screen_y, &from_screen_w, &from_screen_h) ||
        !canvas_rect_to_screen_rect(to_x, to_y, end_size, end_size, &to_screen_x, &to_screen_y, &to_screen_w, &to_screen_h)) {
        return;
    }
    lv_coord_t from_size_mapped = from_screen_w < from_screen_h ? from_screen_w : from_screen_h;
    lv_coord_t to_size_mapped = to_screen_w < to_screen_h ? to_screen_w : to_screen_h;
    lv_obj_t *obj = create_decor_ring_obj(from_screen_x, from_screen_y, from_size_mapped, color_hex, border_width);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_screen_x, to_screen_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_screen_y, to_screen_y, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_w, delay, duration, from_size_mapped, to_size_mapped, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_h, delay, duration, from_size_mapped, to_size_mapped, lv_anim_path_ease_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
}

static void spawn_icon_flight(
    taby_reusable_decor_icon_asset_t *asset,
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_opa_t peak_opa,
    uint16_t zoom_from,
    uint16_t zoom_to,
    uint16_t angle) {
    lv_obj_t *obj = create_decor_icon_obj(asset, from_x, from_y, size, color_hex, angle);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_x, to_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_y, to_y, lv_anim_path_ease_in_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
    if (zoom_from > 0U && zoom_to > 0U && zoom_from != zoom_to) {
        start_int_anim(obj, anim_img_zoom, delay, duration, zoom_from, zoom_to, lv_anim_path_ease_out);
    }
}

static void spawn_icon_flight_canvas(
    taby_reusable_decor_icon_asset_t *asset,
    uint32_t delay,
    uint32_t duration,
    lv_coord_t from_x,
    lv_coord_t from_y,
    lv_coord_t to_x,
    lv_coord_t to_y,
    lv_coord_t size,
    uint32_t color_hex,
    lv_opa_t peak_opa,
    uint16_t zoom_from,
    uint16_t zoom_to,
    uint16_t angle) {
    lv_coord_t from_screen_x = 0;
    lv_coord_t from_screen_y = 0;
    lv_coord_t from_screen_w = 0;
    lv_coord_t from_screen_h = 0;
    lv_coord_t to_screen_x = 0;
    lv_coord_t to_screen_y = 0;
    lv_coord_t to_screen_w = 0;
    lv_coord_t to_screen_h = 0;
    if (!canvas_rect_to_screen_rect(from_x, from_y, size, size, &from_screen_x, &from_screen_y, &from_screen_w, &from_screen_h) ||
        !canvas_rect_to_screen_rect(to_x, to_y, size, size, &to_screen_x, &to_screen_y, &to_screen_w, &to_screen_h)) {
        return;
    }
    lv_obj_t *obj = create_decor_icon_obj(
        asset,
        from_screen_x,
        from_screen_y,
        from_screen_w < from_screen_h ? from_screen_w : from_screen_h,
        color_hex,
        angle);
    if (!obj) {
        return;
    }
    start_int_anim(obj, anim_obj_x, delay, duration, from_screen_x, to_screen_x, lv_anim_path_ease_out);
    start_int_anim(obj, anim_obj_y, delay, duration, from_screen_y, to_screen_y, lv_anim_path_ease_in_out);
    start_pulse_opa(obj, delay, duration, peak_opa);
    if (zoom_from > 0U && zoom_to > 0U && zoom_from != zoom_to) {
        start_int_anim(obj, anim_img_zoom, delay, duration, zoom_from, zoom_to, lv_anim_path_ease_out);
    }
}

static uint32_t scaled_effect_ms(uint32_t total_ms, uint16_t permille, uint32_t minimum_ms) {
    uint32_t value = (total_ms * permille) / 1000U;
    return value < minimum_ms ? minimum_ms : value;
}

static void start_title_decor_effect(const taby_reusable_card_t *card) {
    if (!card_supports_decor_effect(card) || !create_decor_layer()) {
        return;
    }

    const uint32_t total_ms = card->behavior.decor_effect_seconds * 1000U;
    const lv_coord_t center_x = TABY_REUSABLE_CANVAS_W / 2;
    const uint32_t gold = 0xFFD54A;
    const uint32_t pale_gold = 0xFFF0B0;
    const uint32_t orange = 0xFF9B3D;
    const uint32_t red = 0xFF5E57;
    const uint32_t pink = 0xFF93C5;
    const uint32_t rose = 0xFFC1D8;
    const uint32_t mint = 0x7EF0C1;
    const uint32_t cyan = 0x9AE9FF;
    const uint32_t white = 0xFFFFFF;
    const taby_reusable_decor_effect_t effect = normalized_decor_effect(card->behavior.decor_effect);
    const uint32_t short_ms = scaled_effect_ms(total_ms, 220, 540);
    const uint32_t medium_ms = scaled_effect_ms(total_ms, 280, 680);
    const uint32_t long_ms = scaled_effect_ms(total_ms, 340, 820);

    switch (effect) {
        case TABY_REUSABLE_DECOR_EFFECT_SHOOTING_STARS:
            spawn_moving_rect_canvas(20, medium_ms, -76, 54, 70, 68, 118, 5, 999, pale_gold, LV_OPA_90);
            spawn_icon_flight_canvas(&s_decor_star_asset, 20, medium_ms, -18, 42, 92, 48, 26, gold, LV_OPA_COVER, 84, 130, 0U);
            spawn_moving_rect_canvas(110, medium_ms, TABY_REUSABLE_CANVAS_W + 12, 50, 332, 64, 116, 5, 999, gold, LV_OPA_90);
            spawn_icon_flight_canvas(&s_decor_star_asset, 110, medium_ms, TABY_REUSABLE_CANVAS_W - 10, 40, 350, 44, 24, white, (lv_opa_t)230, 82, 124, 0U);
            spawn_moving_rect_canvas(70, medium_ms, -70, 196, 94, 176, 94, 4, 999, white, (lv_opa_t)191);
            spawn_icon_flight_canvas(&s_decor_star_asset, 70, medium_ms, -8, 182, 116, 168, 22, pale_gold, (lv_opa_t)217, 80, 110, 0U);
            spawn_moving_rect_canvas(180, medium_ms, TABY_REUSABLE_CANVAS_W + 8, 204, 310, 186, 96, 4, 999, pale_gold, (lv_opa_t)191);
            spawn_icon_flight_canvas(&s_decor_star_asset, 180, medium_ms, TABY_REUSABLE_CANVAS_W - 6, 190, 300, 174, 22, gold, (lv_opa_t)217, 80, 110, 0U);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_COMET_BURST:
            spawn_moving_rect_canvas(18, long_ms, -130, 58, 164, 76, 168, 10, 999, orange, (lv_opa_t)217);
            spawn_moving_circle_canvas(18, long_ms, -8, 54, 176, 72, 22, pale_gold, LV_OPA_COVER);
            spawn_moving_rect_canvas(96, long_ms, TABY_REUSABLE_CANVAS_W + 26, 66, 246, 82, 176, 10, 999, red, (lv_opa_t)217);
            spawn_moving_circle_canvas(96, long_ms, TABY_REUSABLE_CANVAS_W - 10, 62, 236, 80, 24, white, (lv_opa_t)242);
            spawn_moving_rect_canvas(150, medium_ms, -96, 204, 134, 168, 126, 7, 999, pale_gold, (lv_opa_t)191);
            spawn_moving_circle_canvas(150, medium_ms, -2, 202, 146, 168, 16, gold, (lv_opa_t)217);
            spawn_moving_rect_canvas(212, medium_ms, TABY_REUSABLE_CANVAS_W + 18, 194, 286, 176, 118, 7, 999, orange, (lv_opa_t)179);
            spawn_moving_circle_canvas(212, medium_ms, TABY_REUSABLE_CANVAS_W - 6, 192, 280, 176, 14, pale_gold, (lv_opa_t)204);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_FIREWORK_DOTS:
            spawn_ring_burst_canvas(24, long_ms, 92, 76, 10, 88, pale_gold, 3, (lv_opa_t)179);
            spawn_moving_circle_canvas(24, long_ms, 92, 76, 42, 30, 18, gold, LV_OPA_COVER);
            spawn_moving_circle_canvas(74, long_ms, 92, 76, 146, 58, 16, orange, (lv_opa_t)242);
            spawn_moving_circle_canvas(118, medium_ms, 92, 76, 134, 134, 14, white, (lv_opa_t)217);
            spawn_moving_circle_canvas(164, medium_ms, 92, 76, 34, 146, 14, pale_gold, (lv_opa_t)204);
            spawn_ring_burst_canvas(56, long_ms, 356, 84, 10, 88, mint, 3, (lv_opa_t)166);
            spawn_moving_circle_canvas(56, long_ms, 356, 84, 408, 30, 18, cyan, LV_OPA_COVER);
            spawn_moving_circle_canvas(104, long_ms, 356, 84, 302, 44, 16, pink, (lv_opa_t)230);
            spawn_moving_circle_canvas(148, medium_ms, 356, 84, 296, 142, 14, white, (lv_opa_t)217);
            spawn_moving_circle_canvas(194, medium_ms, 356, 84, 398, 148, 14, pale_gold, (lv_opa_t)204);
            spawn_ring_burst_canvas(136, medium_ms, center_x, 166, 8, 62, gold, 2, (lv_opa_t)153);
            spawn_moving_circle_canvas(136, medium_ms, center_x, 166, center_x - 44, 124, 12, gold, (lv_opa_t)191);
            spawn_moving_circle_canvas(176, medium_ms, center_x, 166, center_x + 42, 124, 12, white, (lv_opa_t)191);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_HEART_BURST:
            spawn_icon_flight_canvas(&s_decor_heart_asset, 24, medium_ms, center_x - 26, 144, 56, 66, 54, red, LV_OPA_COVER, 160, 228, 0U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 76, medium_ms, center_x - 18, 150, 112, 186, 36, pink, (lv_opa_t)230, 128, 174, 0U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 42, medium_ms, center_x + 8, 144, 398, 64, 54, red, LV_OPA_COVER, 160, 228, 0U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 94, medium_ms, center_x + 16, 150, 344, 186, 36, rose, (lv_opa_t)224, 128, 174, 0U);
            spawn_moving_circle_canvas(86, short_ms, 108, 74, 134, 92, 12, rose, (lv_opa_t)191);
            spawn_moving_circle_canvas(126, short_ms, 346, 74, 320, 92, 12, gold, (lv_opa_t)179);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_HEART_RAIN:
            spawn_icon_flight_canvas(&s_decor_heart_asset, 18, long_ms, 60, -24, 80, 94, 22, pink, (lv_opa_t)217, 96, 118, 2700U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 72, long_ms, 114, -30, 128, 132, 26, red, LV_OPA_COVER, 100, 124, 2700U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 130, long_ms, 170, -22, 180, 102, 20, rose, (lv_opa_t)204, 92, 110, 2700U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 186, long_ms, 298, -28, 286, 138, 26, red, LV_OPA_COVER, 100, 124, 2700U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 244, long_ms, 352, -18, 340, 96, 22, pink, (lv_opa_t)217, 96, 118, 2700U);
            spawn_icon_flight_canvas(&s_decor_heart_asset, 302, long_ms, 406, -34, 394, 164, 20, rose, (lv_opa_t)191, 88, 106, 2700U);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_GOLD_RINGS:
            spawn_ring_burst_canvas(20, medium_ms, 68, 84, 12, 72, pale_gold, 3, LV_OPA_COVER);
            spawn_ring_burst_canvas(90, medium_ms, 90, 142, 10, 64, gold, 3, (lv_opa_t)230);
            spawn_ring_burst_canvas(150, short_ms, 114, 198, 8, 52, white, 2, (lv_opa_t)191);
            spawn_ring_burst_canvas(60, medium_ms, 388, 84, 12, 72, pale_gold, 3, LV_OPA_COVER);
            spawn_ring_burst_canvas(130, medium_ms, 366, 142, 10, 64, gold, 3, (lv_opa_t)230);
            spawn_ring_burst_canvas(190, short_ms, 342, 198, 8, 52, white, 2, (lv_opa_t)191);
            spawn_ring_burst_canvas(110, medium_ms, center_x, 146, 10, 58, gold, 3, (lv_opa_t)191);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP:
            spawn_moving_rect_canvas(20, long_ms, -124, 68, 112, 56, 136, 16, 999, cyan, (lv_opa_t)166);
            spawn_moving_rect_canvas(90, long_ms, -118, 124, 126, 112, 124, 14, 999, mint, (lv_opa_t)153);
            spawn_moving_rect_canvas(60, long_ms, TABY_REUSABLE_CANVAS_W + 12, 86, 230, 76, 132, 16, 999, pale_gold, (lv_opa_t)140);
            spawn_moving_rect_canvas(150, long_ms, TABY_REUSABLE_CANVAS_W + 8, 148, 218, 138, 116, 14, 999, gold, (lv_opa_t)140);
            spawn_moving_rect_canvas(120, long_ms, -108, 180, 170, 172, 108, 12, 999, white, (lv_opa_t)115);
            spawn_moving_rect_canvas(190, long_ms, TABY_REUSABLE_CANVAS_W + 4, 194, 198, 184, 100, 12, 999, cyan, (lv_opa_t)115);
            break;
        case TABY_REUSABLE_DECOR_EFFECT_RIBBON_SWEEP:
            spawn_moving_rect_canvas(20, long_ms, -126, 72, 96, 60, 132, 14, 999, pink, (lv_opa_t)166);
            spawn_moving_rect_canvas(90, long_ms, -120, 124, 114, 114, 122, 12, 999, white, (lv_opa_t)140);
            spawn_moving_rect_canvas(60, long_ms, TABY_REUSABLE_CANVAS_W + 10, 88, 252, 78, 128, 14, 999, pale_gold, (lv_opa_t)166);
            spawn_moving_rect_canvas(150, long_ms, TABY_REUSABLE_CANVAS_W + 6, 144, 246, 134, 116, 12, 999, gold, (lv_opa_t)153);
            spawn_moving_rect_canvas(210, medium_ms, -110, 182, 160, 170, 106, 10, 999, pale_gold, (lv_opa_t)128);
            spawn_moving_rect_canvas(250, medium_ms, TABY_REUSABLE_CANVAS_W + 4, 196, 214, 186, 98, 10, 999, white, (lv_opa_t)115);
            break;
        default:
            break;
    }

    if (s_decor_layer) {
        lv_obj_move_foreground(s_decor_layer);
    }
    if (s_primary_text_canvas) {
        lv_obj_move_foreground(s_primary_text_canvas);
    }
}

static void draw_text_block(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t width,
    const char *text,
    const lv_font_t *font,
    lv_color_t color,
    lv_text_align_t align) {
    if (!s_canvas || !has_text(text)) {
        return;
    }

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color;
    text_dsc.font = font;
    text_dsc.align = align;
    lv_canvas_draw_text(s_canvas, x, y, width, &text_dsc, text);
}

static void draw_centered_text(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t width,
    lv_coord_t height,
    const char *text,
    const lv_font_t *font,
    lv_color_t color) {
    if (!s_canvas || !has_text(text)) {
        return;
    }

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color;
    text_dsc.font = font;
    text_dsc.align = LV_TEXT_ALIGN_CENTER;

    lv_point_t text_size = {0};
    lv_txt_get_size(&text_size, text, font, 0, 0, width, LV_TEXT_FLAG_NONE);
    lv_coord_t text_y = y + ((height - text_size.y) / 2);

    lv_canvas_draw_text(s_canvas, x, text_y, width, &text_dsc, text);
}

static void draw_centered_button_text(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t width,
    lv_coord_t height,
    const char *text,
    const lv_font_t *font,
    lv_color_t color) {
    if (!s_canvas || !has_text(text)) {
        return;
    }

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color;
    text_dsc.font = font;
    text_dsc.align = LV_TEXT_ALIGN_CENTER;
    text_dsc.flag |= LV_TEXT_FLAG_EXPAND;

    lv_point_t text_size = {0};
    lv_txt_get_size(&text_size, text, font, 0, 0, LV_COORD_MAX, LV_TEXT_FLAG_EXPAND);
    lv_coord_t text_y = y + ((height - text_size.y) / 2);

    lv_canvas_draw_text(s_canvas, x, text_y, width, &text_dsc, text);
}

static bool select_scaled_text_layout(
    const char *text,
    lv_coord_t max_rotated_w,
    lv_coord_t max_rotated_h,
    taby_reusable_scaled_text_choice_t *out_choice) {
    if (!has_text(text) || !out_choice) {
        return false;
    }

    const taby_reusable_scaled_text_layout_t *selected_layout =
        &k_reusable_scaled_text_layouts[sizeof(k_reusable_scaled_text_layouts) /
                                        sizeof(k_reusable_scaled_text_layouts[0]) - 1];
    lv_coord_t selected_width = max_rotated_h;
    lv_point_t selected_size = {0};

    for (size_t i = 0; i < sizeof(k_reusable_scaled_text_layouts) / sizeof(k_reusable_scaled_text_layouts[0]); ++i) {
        const taby_reusable_scaled_text_layout_t *layout = &k_reusable_scaled_text_layouts[i];
        lv_coord_t max_width = (max_rotated_h * LV_IMG_ZOOM_NONE) / layout->zoom;
        if (max_width < 96) {
            max_width = 96;
        }

        lv_point_t size = {0};
        lv_txt_get_size(
            &size,
            text,
            layout->font,
            layout->letter_space,
            layout->line_space,
            max_width,
            LV_TEXT_FLAG_NONE);

        lv_coord_t scaled_width = (size.x * layout->zoom + LV_IMG_ZOOM_NONE - 1) / LV_IMG_ZOOM_NONE;
        lv_coord_t scaled_height = (size.y * layout->zoom + LV_IMG_ZOOM_NONE - 1) / LV_IMG_ZOOM_NONE;
        if (scaled_width <= max_rotated_h && scaled_height <= max_rotated_w) {
            selected_layout = layout;
            selected_width = max_width;
            selected_size = size;
            break;
        }
    }

    if (selected_size.x == 0 || selected_size.y == 0) {
        lv_txt_get_size(
            &selected_size,
            text,
            selected_layout->font,
            selected_layout->letter_space,
            selected_layout->line_space,
            selected_width,
            LV_TEXT_FLAG_NONE);
    }

    out_choice->layout = selected_layout;
    out_choice->draw_width = selected_width;
    out_choice->text_size = selected_size;
    return true;
}

static lv_obj_t *draw_scaled_rotated_label(
    const char *text,
    lv_coord_t max_rotated_w,
    lv_coord_t max_rotated_h,
    lv_coord_t offset_x,
    lv_coord_t offset_y,
    uint32_t color_hex,
    uint16_t scale_percent) {
    if (!has_text(text)) {
        return NULL;
    }

    taby_reusable_scaled_text_choice_t choice = {0};
    if (!select_scaled_text_layout(text, max_rotated_w, max_rotated_h, &choice)) {
        return NULL;
    }

    uint16_t applied_scale_percent = normalized_scale_percent(scale_percent);
    uint32_t applied_zoom = ((uint32_t)choice.layout->zoom * (uint32_t)applied_scale_percent) / 100U;
    if (applied_zoom < LV_IMG_ZOOM_NONE / 2U) {
        applied_zoom = LV_IMG_ZOOM_NONE / 2U;
    }

    lv_coord_t canvas_w = choice.draw_width;
    lv_coord_t canvas_h = (lv_coord_t)(((int32_t)max_rotated_w * LV_IMG_ZOOM_NONE + (lv_coord_t)applied_zoom - 1) /
                                       (lv_coord_t)applied_zoom);
    if (canvas_h < choice.text_size.y) {
        canvas_h = choice.text_size.y;
    }
    lv_coord_t text_y = (canvas_h - choice.text_size.y) / 2;
    size_t canvas_bytes = LV_CANVAS_BUF_SIZE_TRUE_COLOR_ALPHA(canvas_w, canvas_h);

    if (s_primary_text_canvas_buf) {
        heap_caps_free(s_primary_text_canvas_buf);
        s_primary_text_canvas_buf = NULL;
    }

    s_primary_text_canvas_buf = heap_caps_malloc(canvas_bytes, MALLOC_CAP_SPIRAM);
    if (!s_primary_text_canvas_buf) {
        return NULL;
    }

    s_primary_text_canvas = lv_canvas_create(lv_scr_act());
    if (!s_primary_text_canvas) {
        heap_caps_free(s_primary_text_canvas_buf);
        s_primary_text_canvas_buf = NULL;
        return NULL;
    }

    lv_canvas_set_buffer(
        s_primary_text_canvas,
        s_primary_text_canvas_buf,
        canvas_w,
        canvas_h,
        LV_IMG_CF_TRUE_COLOR_ALPHA);
    lv_canvas_fill_bg(s_primary_text_canvas, lv_color_black(), LV_OPA_TRANSP);

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color_from_hex(color_hex);
    text_dsc.font = choice.layout->font;
    text_dsc.align = LV_TEXT_ALIGN_CENTER;
    text_dsc.flag = LV_TEXT_FLAG_NONE;
    text_dsc.ofs_x = 0;
    text_dsc.ofs_y = 0;

    lv_canvas_draw_text(s_primary_text_canvas, 0, text_y, choice.draw_width, &text_dsc, text);
    s_primary_text_canvas_state = (taby_reusable_primary_text_canvas_state_t){
        .valid = true,
        .draw_width = choice.draw_width,
        .text_y = text_y,
        .font = choice.layout->font,
        .letter_space = choice.layout->letter_space,
        .line_space = choice.layout->line_space,
        .color_hex = color_hex,
    };

    lv_obj_clear_flag(s_primary_text_canvas, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(s_primary_text_canvas, LV_SCROLLBAR_MODE_OFF);
    lv_img_set_pivot(s_primary_text_canvas, canvas_w / 2, canvas_h / 2);
    lv_img_set_zoom(s_primary_text_canvas, (uint16_t)applied_zoom);
    lv_img_set_angle(s_primary_text_canvas, 900);
    if (s_canvas) {
        lv_obj_align_to(s_primary_text_canvas, s_canvas, LV_ALIGN_CENTER, offset_x, offset_y);
    } else {
        lv_obj_align(s_primary_text_canvas, LV_ALIGN_CENTER, offset_x, offset_y);
    }
    lv_obj_move_foreground(s_primary_text_canvas);
    return s_primary_text_canvas;
}

static bool redraw_primary_text_canvas(const char *text) {
    if (!s_primary_text_canvas || !s_primary_text_canvas_state.valid || !has_text(text)) {
        return false;
    }

    lv_canvas_fill_bg(s_primary_text_canvas, lv_color_black(), LV_OPA_TRANSP);

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color_from_hex(s_primary_text_canvas_state.color_hex);
    text_dsc.font = s_primary_text_canvas_state.font;
    text_dsc.align = LV_TEXT_ALIGN_CENTER;
    text_dsc.flag = LV_TEXT_FLAG_NONE;
    text_dsc.ofs_x = 0;
    text_dsc.ofs_y = 0;
    text_dsc.letter_space = s_primary_text_canvas_state.letter_space;
    text_dsc.line_space = s_primary_text_canvas_state.line_space;

    lv_canvas_draw_text(
        s_primary_text_canvas,
        0,
        s_primary_text_canvas_state.text_y,
        s_primary_text_canvas_state.draw_width,
        &text_dsc,
        text);
    lv_obj_invalidate(s_primary_text_canvas);
    return true;
}

static void copy_loading_dots_base_text(const char *text) {
    s_text_effect_base_text[0] = '\0';
    if (!text) {
        return;
    }

    snprintf(s_text_effect_base_text, sizeof(s_text_effect_base_text), "%s", text);
    size_t len = strlen(s_text_effect_base_text);
    while (len > 0U && (s_text_effect_base_text[len - 1U] == '.' || s_text_effect_base_text[len - 1U] == ' ')) {
        s_text_effect_base_text[len - 1U] = '\0';
        len--;
    }
}

static bool redraw_loading_dots_primary_text_canvas(uint8_t dot_count) {
    if (
        !s_primary_text_canvas ||
        !s_primary_text_canvas_state.valid ||
        !has_text(s_text_effect_base_text)
    ) {
        return false;
    }

    if (dot_count > 3U) {
        dot_count = 3U;
    }

    lv_canvas_fill_bg(s_primary_text_canvas, lv_color_black(), LV_OPA_TRANSP);

    lv_draw_label_dsc_t text_dsc;
    lv_draw_label_dsc_init(&text_dsc);
    text_dsc.color = color_from_hex(s_primary_text_canvas_state.color_hex);
    text_dsc.font = s_primary_text_canvas_state.font;
    text_dsc.align = LV_TEXT_ALIGN_LEFT;
    text_dsc.flag = LV_TEXT_FLAG_NONE;
    text_dsc.ofs_x = 0;
    text_dsc.ofs_y = 0;
    text_dsc.letter_space = s_primary_text_canvas_state.letter_space;
    text_dsc.line_space = s_primary_text_canvas_state.line_space;

    lv_point_t base_size = {0};
    lv_txt_get_size(
        &base_size,
        s_text_effect_base_text,
        s_primary_text_canvas_state.font,
        s_primary_text_canvas_state.letter_space,
        s_primary_text_canvas_state.line_space,
        s_primary_text_canvas_state.draw_width,
        LV_TEXT_FLAG_NONE);

    lv_point_t dots_size = {0};
    lv_txt_get_size(
        &dots_size,
        "...",
        s_primary_text_canvas_state.font,
        s_primary_text_canvas_state.letter_space,
        s_primary_text_canvas_state.line_space,
        s_primary_text_canvas_state.draw_width,
        LV_TEXT_FLAG_NONE);

    lv_coord_t total_width = base_size.x + dots_size.x;
    lv_coord_t start_x = (s_primary_text_canvas_state.draw_width - total_width) / 2;
    if (start_x < 0) {
        start_x = 0;
    }

    lv_canvas_draw_text(
        s_primary_text_canvas,
        start_x,
        s_primary_text_canvas_state.text_y,
        base_size.x + 2,
        &text_dsc,
        s_text_effect_base_text);

    if (dot_count > 0U) {
        char dots[4] = {0};
        for (uint8_t index = 0; index < dot_count && index < 3U; ++index) {
            dots[index] = '.';
        }
        dots[dot_count] = '\0';
        lv_canvas_draw_text(
            s_primary_text_canvas,
            start_x + base_size.x,
            s_primary_text_canvas_state.text_y,
            dots_size.x + 2,
            &text_dsc,
            dots);
    }

    lv_obj_invalidate(s_primary_text_canvas);
    return true;
}

static void draw_button_surface(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    uint32_t fill_hex,
    uint32_t border_hex) {
    lv_draw_rect_dsc_t button_dsc;
    lv_draw_rect_dsc_init(&button_dsc);
    button_dsc.bg_opa = LV_OPA_COVER;
    button_dsc.bg_color = color_from_hex(fill_hex);
    button_dsc.radius = 26;
    button_dsc.border_width = 2;
    button_dsc.border_opa = LV_OPA_70;
    button_dsc.border_color = color_from_hex(border_hex);
    lv_canvas_draw_rect(s_canvas, x, y, w, h, &button_dsc);
}

static void draw_choice_button(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    const char *label,
    uint32_t fill_hex,
    uint32_t border_hex,
    uint32_t text_hex) {
    if (!has_text(label)) {
        return;
    }

    draw_button_surface(x, y, w, h, fill_hex, border_hex);
    draw_centered_button_text(
        x,
        y,
        w,
        h,
        label,
        button_text_font(w, label),
        color_from_hex(text_hex));
}

static void draw_action_button(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    const char *label,
    const taby_reusable_style_t *style) {
    if (!has_text(label)) {
        return;
    }

    draw_button_surface(x, y, w, h, style->button_fill_hex, style->button_border_hex);
    draw_centered_button_text(x, y, w, h, label, button_text_font(w, label), color_from_hex(style->button_text_hex));
}

static void draw_progress_bar(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t w,
    lv_coord_t h,
    uint8_t progress_percent,
    const taby_reusable_style_t *style) {
    lv_draw_rect_dsc_t track_dsc;
    lv_draw_rect_dsc_init(&track_dsc);
    track_dsc.bg_opa = LV_OPA_COVER;
    track_dsc.bg_color = color_from_hex(style->progress_track_hex);
    track_dsc.border_opa = LV_OPA_TRANSP;
    track_dsc.radius = h / 2;
    lv_canvas_draw_rect(s_canvas, x, y, w, h, &track_dsc);

    if (progress_percent == 0U) {
        return;
    }

    lv_coord_t filled_width = (lv_coord_t)((uint32_t)w * progress_percent / 100U);
    if (filled_width < h) {
        filled_width = h;
    }
    if (filled_width > w) {
        filled_width = w;
    }

    lv_draw_rect_dsc_t fill_dsc;
    lv_draw_rect_dsc_init(&fill_dsc);
    fill_dsc.bg_opa = LV_OPA_COVER;
    fill_dsc.bg_color = color_from_hex(style->progress_fill_hex);
    fill_dsc.border_opa = LV_OPA_TRANSP;
    fill_dsc.radius = h / 2;
    lv_canvas_draw_rect(s_canvas, x, y, filled_width, h, &fill_dsc);
}

static uint8_t countdown_progress_percent(uint32_t remaining_seconds, uint32_t total_seconds) {
    if (total_seconds == 0U || remaining_seconds > total_seconds) {
        return 0U;
    }

    return (uint8_t)(((total_seconds - remaining_seconds) * 100U) / total_seconds);
}

static uint32_t current_countdown_remaining_seconds(void) {
    if (!s_active_card.valid || !s_active_card.card.behavior.countdown_running) {
        return s_countdown_base_remaining_seconds;
    }

    int64_t elapsed_us = esp_timer_get_time() - s_countdown_sync_us;
    uint32_t elapsed_seconds = elapsed_us > 0 ? (uint32_t)(elapsed_us / 1000000LL) : 0U;
    if (elapsed_seconds >= s_countdown_base_remaining_seconds) {
        return 0U;
    }

    return s_countdown_base_remaining_seconds - elapsed_seconds;
}

static void update_countdown_display(uint32_t remaining_seconds) {
    if (!s_active_card.valid || s_active_card.card.kind != TABY_REUSABLE_CARD_COUNTDOWN) {
        return;
    }

    char countdown_text[16] = {0};
    format_countdown(countdown_text, sizeof(countdown_text), remaining_seconds);
    redraw_primary_text_canvas(countdown_text);

    if (s_countdown_progress_rect.valid && s_canvas) {
        draw_progress_bar(
            s_countdown_progress_rect.x,
            s_countdown_progress_rect.y,
            s_countdown_progress_rect.w,
            s_countdown_progress_rect.h,
            countdown_progress_percent(remaining_seconds, s_active_card.card.countdown_total_seconds),
            &s_active_card.card.style);
        lv_obj_invalidate(s_canvas);
    }

    lv_refr_now(board_amoled_1_64_display());
}

static void handle_countdown_tick_timer(lv_timer_t *timer) {
    if (timer != s_countdown_tick_timer || !s_countdown_active) {
        return;
    }

    uint32_t remaining_seconds = current_countdown_remaining_seconds();
    if (remaining_seconds == s_countdown_last_remaining_seconds) {
        return;
    }

    s_countdown_last_remaining_seconds = remaining_seconds;
    if (s_active_card.valid) {
        s_active_card.card.countdown_remaining_seconds = remaining_seconds;
    }
    update_countdown_display(remaining_seconds);

    if (remaining_seconds == 0U && s_countdown_tick_timer) {
        lv_timer_del(s_countdown_tick_timer);
        s_countdown_tick_timer = NULL;
    }
}

static void handle_countdown_hide_timer(lv_timer_t *timer) {
    if (timer == s_countdown_hide_timer) {
        s_countdown_hide_timer = NULL;
    }

    taby_runtime_dismiss_reusable_card_locked();
}

static void clear_countdown_behavior_state(void) {
    if (s_countdown_tick_timer) {
        lv_timer_del(s_countdown_tick_timer);
        s_countdown_tick_timer = NULL;
    }
    if (s_countdown_hide_timer) {
        lv_timer_del(s_countdown_hide_timer);
        s_countdown_hide_timer = NULL;
    }

    s_countdown_active = false;
    s_countdown_sync_us = 0;
    s_countdown_base_remaining_seconds = 0;
    s_countdown_last_remaining_seconds = 0;
}

static void start_countdown_behavior(const taby_reusable_card_t *card) {
    if (!card || card->kind != TABY_REUSABLE_CARD_COUNTDOWN) {
        return;
    }

    if (!card->behavior.countdown_running && card->behavior.countdown_visible_seconds == 0U) {
        return;
    }

    s_countdown_active = true;
    s_countdown_sync_us = esp_timer_get_time();
    s_countdown_base_remaining_seconds = card->countdown_remaining_seconds;
    s_countdown_last_remaining_seconds = card->countdown_remaining_seconds;

    if (card->behavior.countdown_running && card->countdown_remaining_seconds > 0U) {
        s_countdown_tick_timer = lv_timer_create(handle_countdown_tick_timer, 1000, NULL);
    }

    if (card->behavior.countdown_visible_seconds > 0U) {
        uint32_t visible_ms = card->behavior.countdown_visible_seconds * 1000U;
        s_countdown_hide_timer = lv_timer_create(handle_countdown_hide_timer, visible_ms, NULL);
        if (s_countdown_hide_timer) {
            lv_timer_set_repeat_count(s_countdown_hide_timer, 1);
        }
    }
}

static bool draw_named_icon(
    const char *icon_id,
    lv_coord_t center_x,
    lv_coord_t top_y,
    lv_coord_t size,
    const taby_reusable_style_t *style) {
    taby_reusable_icon_asset_t icon_asset = {0};
    if (taby_reusable_icon_lookup(icon_id, &icon_asset) && icon_asset.asset_pack_path) {
        uint8_t *icon_data = NULL;
        size_t icon_data_size = 0;
        if (!taby_asset_store_load_file(icon_asset.asset_pack_path, &icon_data, &icon_data_size)) {
            ESP_LOGW(
                TAG,
                "icon asset load failed id='%s' path='%s'",
                icon_id ? icon_id : "",
                icon_asset.asset_pack_path);
            return false;
        }

        lv_img_dsc_t icon_image = {
            .header.always_zero = 0,
            .header.w = icon_asset.width,
            .header.h = icon_asset.height,
            .data_size = icon_data_size,
            .header.cf = LV_IMG_CF_ALPHA_4BIT,
            .data = icon_data,
        };
        lv_coord_t target_size = size > 0 ? size : 96;
        size_t transformed_bytes = LV_CANVAS_BUF_SIZE_TRUE_COLOR_ALPHA(target_size, target_size);
        void *transformed_buf = heap_caps_malloc(transformed_bytes, MALLOC_CAP_SPIRAM);
        if (!transformed_buf) {
            ESP_LOGW(TAG, "icon scale alloc failed id='%s' size=%d", icon_id ? icon_id : "", (int)target_size);
            taby_asset_store_free_file(icon_data);
            return false;
        }

        memset(transformed_buf, 0, transformed_bytes);

        lv_img_dsc_t transformed_img = {
            .header.always_zero = 0,
            .header.w = target_size,
            .header.h = target_size,
            .data_size = transformed_bytes,
            .header.cf = LV_IMG_CF_TRUE_COLOR_ALPHA,
            .data = transformed_buf,
        };

        const uint32_t src_w = icon_image.header.w;
        const uint32_t src_h = icon_image.header.h;
        const lv_color_t solid_white = lv_color_white();

        // Decode the packed alpha icon into a normal RGBA image first. This avoids
        // lv_canvas_transform on ALPHA_4BIT sources, which was producing noisy output.
        for (lv_coord_t dst_y = 0; dst_y < target_size; ++dst_y) {
            uint32_t src_y = (((uint32_t)dst_y * 2U + 1U) * src_h) / ((uint32_t)target_size * 2U);
            if (src_y >= src_h) {
                src_y = src_h - 1U;
            }

            for (lv_coord_t dst_x = 0; dst_x < target_size; ++dst_x) {
                uint32_t src_x = (((uint32_t)dst_x * 2U + 1U) * src_w) / ((uint32_t)target_size * 2U);
                if (src_x >= src_w) {
                    src_x = src_w - 1U;
                }

                lv_opa_t alpha = lv_img_buf_get_px_alpha(&icon_image, (lv_coord_t)src_x, (lv_coord_t)src_y);
                if (alpha == LV_OPA_TRANSP) {
                    continue;
                }

                lv_img_buf_set_px_color(&transformed_img, dst_x, dst_y, solid_white);
                lv_img_buf_set_px_alpha(&transformed_img, dst_x, dst_y, alpha);
            }
        }

        lv_draw_img_dsc_t draw_dsc;
        lv_draw_img_dsc_init(&draw_dsc);
        draw_dsc.recolor = color_from_hex(style->accent_hex);
        draw_dsc.recolor_opa = LV_OPA_COVER;
        lv_canvas_draw_img(
            s_canvas,
            center_x - (target_size / 2),
            top_y,
            &transformed_img,
            &draw_dsc);

        heap_caps_free(transformed_buf);
        taby_asset_store_free_file(icon_data);
        ESP_LOGI(
            TAG,
            "icon asset draw ok id='%s' path='%s' w=%d h=%d target=%d",
            icon_id ? icon_id : "",
            icon_asset.asset_pack_path,
            (int)icon_image.header.w,
            (int)icon_image.header.h,
            (int)target_size);
        return true;
    }

    ESP_LOGW(TAG, "icon asset missing id='%s'", icon_id ? icon_id : "");
    return false;
}

static void draw_icon_accent_label(const char *icon_id, const taby_reusable_style_t *style, lv_coord_t top_y) {
    char label[24] = {0};
    const char *icon_label = humanized_icon_label(icon_id, label, sizeof(label));
    if (!icon_label) {
        return;
    }

    draw_text_block(
        24,
        top_y,
        TABY_REUSABLE_CANVAS_W - 48,
        icon_label,
        &lv_font_montserrat_16,
        color_from_hex(style->accent_hex),
        LV_TEXT_ALIGN_CENTER);
}

static void draw_top_headline(const taby_reusable_card_t *card) {
    if (!has_text(card->headline)) {
        return;
    }

    draw_text_block(
        24,
        16,
        TABY_REUSABLE_CANVAS_W - 48,
        card->headline,
        &lv_font_montserrat_16,
        color_from_hex(card->style.headline_hex),
        LV_TEXT_ALIGN_CENTER);
}

static void handle_decor_effect_stop_timer(lv_timer_t *timer) {
    if (timer == s_decor_effect_stop_timer) {
        s_decor_effect_stop_timer = NULL;
    }
    taby_runtime_dismiss_reusable_card_locked();
}

static void format_countdown(char *buffer, size_t buffer_size, uint32_t seconds_remaining) {
    uint32_t hours = seconds_remaining / 3600U;
    uint32_t minutes = (seconds_remaining % 3600U) / 60U;
    uint32_t seconds = seconds_remaining % 60U;

    if (hours > 0U) {
        snprintf(buffer, buffer_size, "%02u:%02u:%02u", (unsigned int)hours, (unsigned int)minutes, (unsigned int)seconds);
        return;
    }

    snprintf(buffer, buffer_size, "%02u:%02u", (unsigned int)minutes, (unsigned int)seconds);
}

static void apply_card_behavior(const taby_reusable_card_t *card, lv_obj_t *primary_label, bool allow_play_on_show) {
    if (!card) {
        return;
    }

    s_effect_target_label = primary_label;
    s_effect_target_visible = true;
    s_active_text_effect = card->behavior.text_effect;
    s_text_effect_base_text[0] = '\0';
    s_loading_dot_count = 0;

    if (primary_label && card->behavior.text_effect == TABY_REUSABLE_TEXT_EFFECT_BLINK) {
        s_text_effect_timer = lv_timer_create(handle_text_effect_timer, 450, NULL);
        if (card->behavior.text_effect_seconds > 0U) {
            s_text_effect_stop_timer = lv_timer_create(
                handle_text_effect_stop_timer,
                card->behavior.text_effect_seconds * 1000U,
                NULL);
            lv_timer_set_repeat_count(s_text_effect_stop_timer, 1);
        }
    } else if (primary_label && card->behavior.text_effect == TABY_REUSABLE_TEXT_EFFECT_LOADING_DOTS) {
        copy_loading_dots_base_text(card->title);
        redraw_loading_dots_primary_text_canvas(0);
        s_text_effect_timer = lv_timer_create(handle_text_effect_timer, 360, NULL);
        if (card->behavior.text_effect_seconds > 0U) {
            s_text_effect_stop_timer = lv_timer_create(
                handle_text_effect_stop_timer,
                card->behavior.text_effect_seconds * 1000U,
                NULL);
            lv_timer_set_repeat_count(s_text_effect_stop_timer, 1);
        }
    }

    if (card_supports_decor_effect(card)) {
        if (s_decor_effect_stop_timer) {
            lv_timer_del(s_decor_effect_stop_timer);
            s_decor_effect_stop_timer = NULL;
        }
        s_decor_effect_stop_timer = lv_timer_create(
            handle_decor_effect_stop_timer,
            card->behavior.decor_effect_seconds * 1000U,
            NULL);
        if (s_decor_effect_stop_timer) {
            lv_timer_set_repeat_count(s_decor_effect_stop_timer, 1);
        }
        start_title_decor_effect(card);
    }

    start_countdown_behavior(card);

    if (!has_text(card->behavior.animation_id)) {
        return;
    }

    taby_animation_asset_t asset = {0};
    if (!taby_animation_asset_for_id(card->behavior.animation_id, &asset)) {
        return;
    }

    if (allow_play_on_show && card->behavior.animation_play_on_show) {
        s_animation_on_show_timer = lv_timer_create(handle_animation_on_show_timer, 1, NULL);
        lv_timer_set_repeat_count(s_animation_on_show_timer, 1);
        return;
    }

    if (card->behavior.animation_replay_seconds > 0U) {
        s_animation_replay_timer = lv_timer_create(
            handle_animation_replay_timer,
            card->behavior.animation_replay_seconds * 1000U,
            NULL);
        lv_timer_set_repeat_count(s_animation_replay_timer, 1);
    }
}

static lv_obj_t *render_headline_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    return draw_scaled_rotated_label(
        card->title,
        has_text(card->headline) ? 156 : 172,
        404,
        card->layout.title_offset_x,
        (has_text(card->headline) ? 12 : 18) + card->layout.title_offset_y,
        card->style.title_hex,
        card->layout.title_scale_percent);
}

static lv_obj_t *render_text_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    bool use_subtitle_layout = has_text(card->subtitle) || !has_text(card->headline);
    lv_obj_t *title_label = draw_scaled_rotated_label(
        card->title,
        use_subtitle_layout ? 136 : 150,
        392,
        card->layout.title_offset_x,
        (use_subtitle_layout ? -22 : 10) + card->layout.title_offset_y,
        card->style.title_hex,
        card->layout.title_scale_percent);
    if (has_text(card->subtitle)) {
        draw_centered_text(
            24 + card->layout.subtitle_offset_x,
            212 + card->layout.subtitle_offset_y,
            TABY_REUSABLE_CANVAS_W - 48,
            46,
            card->subtitle,
            support_text_font_scaled(card->subtitle, card->layout.subtitle_scale_percent),
            color_from_hex(card->style.body_hex));
    }
    return title_label;
}

static lv_obj_t *render_icon_only_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    bool has_drawn_icon = draw_named_icon(
        card->icon_id,
        (TABY_REUSABLE_CANVAS_W / 2) + card->layout.icon_offset_x,
        (has_text(card->headline) ? 32 : 22) + card->layout.icon_offset_y,
        card->layout.icon_size > 0U ? (lv_coord_t)card->layout.icon_size : 128,
        &card->style);
    if (!has_drawn_icon) {
        draw_icon_accent_label(card->icon_id, &card->style, (has_text(card->headline) ? 92 : 84) + card->layout.icon_offset_y);
    }
    return NULL;
}

static lv_obj_t *render_icon_text_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    ESP_LOGI(
        TAG,
        "render icon card title='%s' subtitle='%s' icon='%s'",
        card->title ? card->title : "",
        card->subtitle ? card->subtitle : "",
        card->icon_id ? card->icon_id : "");
    bool has_drawn_icon = draw_named_icon(
        card->icon_id,
        (TABY_REUSABLE_CANVAS_W / 2) + card->layout.icon_offset_x,
        (has_text(card->headline) ? 10 : 0) + card->layout.icon_offset_y,
        card->layout.icon_size > 0U ? (lv_coord_t)card->layout.icon_size : 96,
        &card->style);
    if (!has_drawn_icon) {
        ESP_LOGW(TAG, "icon card falling back to accent label icon='%s'", card->icon_id ? card->icon_id : "");
        draw_icon_accent_label(card->icon_id, &card->style, (has_text(card->headline) ? 48 : 38) + card->layout.icon_offset_y);
    }
    lv_obj_t *title_label = draw_scaled_rotated_label(
        card->title,
        has_text(card->subtitle) ? 110 : 136,
        336,
        card->layout.title_offset_x,
        (has_text(card->subtitle) ? 46 : 56) + card->layout.title_offset_y,
        card->style.title_hex,
        card->layout.title_scale_percent);
    if (has_text(card->subtitle)) {
        draw_centered_text(
            18 + card->layout.subtitle_offset_x,
            230 + card->layout.subtitle_offset_y,
            TABY_REUSABLE_CANVAS_W - 36,
            40,
            card->subtitle,
            support_text_font_scaled(card->subtitle, card->layout.subtitle_scale_percent),
            color_from_hex(card->style.body_hex));
    }
    return title_label;
}

static lv_obj_t *render_icon_text_row_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    ESP_LOGI(
        TAG,
        "render icon row card title='%s' icon='%s'",
        card->title ? card->title : "",
        card->icon_id ? card->icon_id : "");

    bool has_drawn_icon = draw_named_icon(
        card->icon_id,
        (TABY_REUSABLE_CANVAS_W / 2) + card->layout.icon_offset_x,
        (has_text(card->headline) ? 12 : 0) + card->layout.icon_offset_y,
        card->layout.icon_size > 0U ? (lv_coord_t)card->layout.icon_size : 96,
        &card->style);
    if (!has_drawn_icon) {
        ESP_LOGW(TAG, "icon row card falling back to accent label icon='%s'", card->icon_id ? card->icon_id : "");
        draw_icon_accent_label(card->icon_id, &card->style, (has_text(card->headline) ? 50 : 40) + card->layout.icon_offset_y);
    }

    return draw_scaled_rotated_label(
        card->title,
        132,
        273,
        card->layout.title_offset_x,
        card->layout.title_offset_y,
        card->style.title_hex,
        card->layout.title_scale_percent);
}

static lv_obj_t *render_action_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    const bool has_icon = has_text(card->icon_id);
    if (has_icon) {
        draw_named_icon(
            card->icon_id,
            112 + card->layout.icon_offset_x,
            86 + card->layout.icon_offset_y,
            card->layout.icon_size > 0U ? (lv_coord_t)card->layout.icon_size : 54,
            &card->style);
    }
    lv_obj_t *title_label = draw_scaled_rotated_label(
        card->title,
        136,
        has_icon ? 240 : 356,
        card->layout.title_offset_x,
        -38 + card->layout.title_offset_y,
        card->style.title_hex,
        card->layout.title_scale_percent);
    lv_coord_t action_button_w = clamp_coord(
        (TABY_REUSABLE_CANVAS_W - 64) + card->layout.action_button_width_delta,
        140,
        TABY_REUSABLE_CANVAS_W - 24);
    lv_coord_t action_button_h = clamp_coord(84 + card->layout.action_button_height_delta, 52, 128);
    lv_coord_t action_button_x = (TABY_REUSABLE_CANVAS_W - action_button_w) / 2;
    lv_coord_t action_button_y = (has_text(card->subtitle) ? 190 : 186) + card->layout.action_button_offset_y;
    draw_action_button(
        action_button_x,
        action_button_y,
        action_button_w,
        action_button_h,
        card->primary_action_label,
        &card->style);
    set_touch_region(0, action_button_x, action_button_y, action_button_w, action_button_h, TABY_REUSABLE_CHOICE_ACTION);
    return title_label;
}

static lv_obj_t *render_choice_card(const taby_reusable_card_t *card) {
    fill_background(&card->style);
    draw_top_headline(card);
    const bool has_icon = has_text(card->icon_id);
    if (has_icon) {
        draw_named_icon(
            card->icon_id,
            108 + card->layout.icon_offset_x,
            54 + card->layout.icon_offset_y,
            card->layout.icon_size > 0U ? (lv_coord_t)card->layout.icon_size : 44,
            &card->style);
    }
    lv_obj_t *title_label = draw_scaled_rotated_label(
        card->title,
        72,
        has_icon ? 236 : 408,
        card->layout.choice_title_offset_x,
        (has_text(card->headline) ? -82 : -96) + card->layout.choice_title_offset_y,
        card->style.title_hex,
        card->layout.choice_title_scale_percent);

    lv_coord_t button_y = TABY_REUSABLE_CHOICE_BUTTON_Y;
    if (has_text(card->subtitle)) {
        draw_text_block(
            48 + card->layout.subtitle_offset_x,
            (has_text(card->headline) ? 78 : 68) + card->layout.subtitle_offset_y,
            TABY_REUSABLE_CANVAS_W - 96,
            card->subtitle,
            support_text_font_scaled(card->subtitle, card->layout.subtitle_scale_percent),
            color_from_hex(card->style.body_hex),
            LV_TEXT_ALIGN_CENTER);
        button_y = 118;
    } else if (has_text(card->headline)) {
        button_y = 112;
    }
    button_y += card->layout.choice_button_offset_y;
    lv_coord_t choice_button_h = clamp_coord(
        TABY_REUSABLE_CHOICE_BUTTON_H + card->layout.choice_button_height_delta,
        72,
        188);

    draw_choice_button(
        TABY_REUSABLE_CHOICE_LEFT_X,
        button_y,
        TABY_REUSABLE_CHOICE_BUTTON_W,
        choice_button_h,
        card->primary_action_label,
        card->style.button_fill_hex,
        card->style.button_border_hex,
        card->style.button_text_hex);
    set_touch_region(0, TABY_REUSABLE_CHOICE_LEFT_X, button_y, TABY_REUSABLE_CHOICE_BUTTON_W, choice_button_h, TABY_REUSABLE_CHOICE_1);
    draw_choice_button(
        TABY_REUSABLE_CHOICE_RIGHT_X,
        button_y,
        TABY_REUSABLE_CHOICE_BUTTON_W,
        choice_button_h,
        card->secondary_action_label,
        card->style.secondary_button_fill_hex,
        card->style.secondary_button_border_hex,
        card->style.secondary_button_text_hex);
    set_touch_region(1, TABY_REUSABLE_CHOICE_RIGHT_X, button_y, TABY_REUSABLE_CHOICE_BUTTON_W, choice_button_h, TABY_REUSABLE_CHOICE_2);
    return title_label;
}

static lv_obj_t *render_countdown_card(const taby_reusable_card_t *card) {
    char countdown_text[16] = {0};
    const bool has_title = has_text(card->title);
    const lv_coord_t titleless_shift_y = has_title ? 0 : -18;
    uint8_t progress_percent =
        countdown_progress_percent(card->countdown_remaining_seconds, card->countdown_total_seconds);

    format_countdown(countdown_text, sizeof(countdown_text), card->countdown_remaining_seconds);

    fill_background(&card->style);
    draw_top_headline(card);
    draw_centered_text(
        28 + card->layout.title_offset_x,
        (has_text(card->headline) ? 36 : 28) + card->layout.title_offset_y,
        TABY_REUSABLE_CANVAS_W - 56,
        36,
        card->title,
        support_text_font_scaled(card->title, card->layout.title_scale_percent),
        color_from_hex(card->style.body_hex));
    lv_obj_t *title_label = draw_scaled_rotated_label(
        countdown_text,
        94,
        404,
        card->layout.value_offset_x + titleless_shift_y,
        10 + card->layout.value_offset_y,
        card->style.title_hex,
        card->layout.value_scale_percent);
    s_countdown_progress_rect = (taby_reusable_progress_rect_t){
        .valid = true,
        .x = 56,
        .y = 214 + card->layout.bar_offset_y + titleless_shift_y,
        .w = TABY_REUSABLE_CANVAS_W - 112,
        .h = 16,
    };
    draw_progress_bar(
        s_countdown_progress_rect.x,
        s_countdown_progress_rect.y,
        s_countdown_progress_rect.w,
        s_countdown_progress_rect.h,
        progress_percent,
        &card->style);
    if (has_text(card->subtitle)) {
        draw_centered_text(
            28 + card->layout.subtitle_offset_x,
            238 + card->layout.subtitle_offset_y + titleless_shift_y,
            TABY_REUSABLE_CANVAS_W - 56,
            24,
            card->subtitle,
            support_text_font_scaled(card->subtitle, card->layout.subtitle_scale_percent),
            color_from_hex(card->style.body_hex));
    }
    return title_label;
}

static lv_obj_t *render_progress_card(const taby_reusable_card_t *card) {
    char percent_text[8] = {0};
    uint8_t progress_percent = card->progress_percent > 100U ? 100U : card->progress_percent;
    const bool has_title = has_text(card->title);
    const lv_coord_t titleless_shift_y = has_title ? 0 : -18;
    snprintf(percent_text, sizeof(percent_text), "%u%%", (unsigned int)progress_percent);

    fill_background(&card->style);
    draw_top_headline(card);
    draw_centered_text(
        28 + card->layout.title_offset_x,
        (has_text(card->headline) ? 36 : 28) + card->layout.title_offset_y,
        TABY_REUSABLE_CANVAS_W - 56,
        36,
        card->title,
        support_text_font_scaled(card->title, card->layout.title_scale_percent),
        color_from_hex(card->style.body_hex));
    lv_obj_t *title_label = draw_scaled_rotated_label(
        percent_text,
        94,
        404,
        card->layout.value_offset_x + titleless_shift_y,
        10 + card->layout.value_offset_y,
        card->style.title_hex,
        card->layout.value_scale_percent);
    draw_progress_bar(
        56,
        214 + card->layout.bar_offset_y + titleless_shift_y,
        TABY_REUSABLE_CANVAS_W - 112,
        16,
        progress_percent,
        &card->style);
    if (has_text(card->subtitle)) {
        draw_centered_text(
            28 + card->layout.subtitle_offset_x,
            238 + card->layout.subtitle_offset_y + titleless_shift_y,
            TABY_REUSABLE_CANVAS_W - 56,
            24,
            card->subtitle,
            support_text_font_scaled(card->subtitle, card->layout.subtitle_scale_percent),
            color_from_hex(card->style.body_hex));
    }
    return title_label;
}

taby_reusable_style_t taby_reusable_ui_default_style(void) {
    return (taby_reusable_style_t){
        .background_hex = 0x000000,
        .card_hex = 0x161A21,
        .panel_border_hex = 0x6C7684,
        .accent_hex = 0x6C7684,
        .headline_hex = 0xD7DEE7,
        .title_hex = 0xFFFFFF,
        .body_hex = 0xD7DEE7,
        .button_fill_hex = 0x18242F,
        .button_text_hex = 0xF7F7F5,
        .button_border_hex = 0x6B8CAB,
        .secondary_button_fill_hex = 0x1F232A,
        .secondary_button_text_hex = 0xF7F7F5,
        .secondary_button_border_hex = 0x9DA7B8,
        .progress_track_hex = 0x27303B,
        .progress_fill_hex = 0x6B8CAB,
    };
}

void taby_reusable_ui_start(void) {
    if (s_touch_task_handle) {
        return;
    }

    xTaskCreate(reusable_touch_task, "taby_reusable_touch", 4096, NULL, 4, &s_touch_task_handle);
}

void taby_reusable_ui_deactivate_choice_input(void) {
    s_interactive_card_active = false;
    s_touch_press_active = false;
    clear_touch_regions();
    clear_choice_signal_selection();
}

void taby_reusable_ui_reset(void) {
    lv_obj_t *screen = lv_scr_act();

    s_interactive_card_active = false;
    s_touch_press_active = false;
    clear_choice_signal_selection();

    clear_behavior_state();
    lv_obj_clean(screen);

    s_canvas = NULL;
    s_primary_text_canvas = NULL;
    s_decor_layer = NULL;
    s_primary_text_canvas_state = (taby_reusable_primary_text_canvas_state_t){0};
    s_countdown_progress_rect = (taby_reusable_progress_rect_t){0};
    clear_touch_regions();
    if (s_canvas_buf) {
        heap_caps_free(s_canvas_buf);
        s_canvas_buf = NULL;
    }
    if (s_primary_text_canvas_buf) {
        heap_caps_free(s_primary_text_canvas_buf);
        s_primary_text_canvas_buf = NULL;
    }
    free_decor_icon_asset(&s_decor_heart_asset);
    free_decor_icon_asset(&s_decor_star_asset);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(screen, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
}

static bool render_card_internal(const taby_reusable_card_t *card, bool remember_card, bool allow_play_on_show) {
    if (!card) {
        return false;
    }

    if (remember_card) {
        store_active_card(card);
    }

    taby_reusable_ui_reset();

    if (!create_rotated_canvas()) {
        ESP_LOGW(TAG, "create rotated canvas failed kind=%s", card_kind_name(card->kind));
        return false;
    }

    s_interactive_card_active =
        card->kind == TABY_REUSABLE_CARD_CHOICE_2
        || card->kind == TABY_REUSABLE_CARD_ACTION;
    if (!s_interactive_card_active) {
        s_touch_press_active = false;
    }

    lv_obj_t *primary_label = NULL;
    switch (card->kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            primary_label = render_headline_card(card);
            break;
        case TABY_REUSABLE_CARD_TEXT:
            primary_label = render_text_card(card);
            break;
        case TABY_REUSABLE_CARD_ICON_ONLY:
            primary_label = render_icon_only_card(card);
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT:
            primary_label = render_icon_text_card(card);
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
            primary_label = render_icon_text_row_card(card);
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            primary_label = render_icon_text_card(card);
            break;
        case TABY_REUSABLE_CARD_ACTION:
            primary_label = render_action_card(card);
            break;
        case TABY_REUSABLE_CARD_CHOICE_2:
            primary_label = render_choice_card(card);
            break;
        case TABY_REUSABLE_CARD_COUNTDOWN:
            primary_label = render_countdown_card(card);
            break;
        case TABY_REUSABLE_CARD_PROGRESS:
            primary_label = render_progress_card(card);
            break;
        default:
            return false;
    }

    ESP_LOGI(
        TAG,
        "rendered card kind=%s title='%s' subtitle='%s' icon='%s'",
        card_kind_name(card->kind),
        card->title ? card->title : "",
        card->subtitle ? card->subtitle : "",
        card->icon_id ? card->icon_id : "");
    apply_card_behavior(card, primary_label, allow_play_on_show);
    taby_runtime_invalidate_render_cache();
    return true;
}

bool taby_reusable_ui_render_card(const taby_reusable_card_t *card) {
    return render_card_internal(card, true, true);
}

void taby_reusable_ui_read_choice_signal(taby_reusable_choice_signal_t *signal) {
    if (!signal) {
        return;
    }

    taskENTER_CRITICAL(&s_choice_signal_lock);
    *signal = s_choice_signal;
    taskEXIT_CRITICAL(&s_choice_signal_lock);
}

const char *taby_reusable_ui_choice_selection_name(taby_reusable_choice_selection_t selection) {
    switch (selection) {
        case TABY_REUSABLE_CHOICE_1:
            return "choice_1";
        case TABY_REUSABLE_CHOICE_2:
            return "choice_2";
        case TABY_REUSABLE_CHOICE_ACTION:
            return "action";
        case TABY_REUSABLE_CHOICE_NONE:
        default:
            return "none";
    }
}
