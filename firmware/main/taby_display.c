#include "taby_display.h"

#include <ctype.h>
#include <stdint.h>
#include <string.h>

#include "board_amoled_1_64.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "lvgl.h"
#include "taby_animation_assets.h"
#include "taby_asset_store.h"
#include "taby_reusable_ui.h"

static const char *TAG = "taby_display";
static const lv_coord_t TABY_FALLBACK_CANVAS_W = 220;
static const lv_coord_t TABY_FALLBACK_CANVAS_H = 380;
static const lv_coord_t TABY_BUSY_TEXT_OFFSET_X = 2;
static const lv_coord_t TABY_BUSY_TEXT_OFFSET_Y = 18;
static const lv_coord_t TABY_BUSY_TEXT_MAX_ROTATED_W = 244;
static const lv_coord_t TABY_BUSY_TEXT_MAX_ROTATED_H = 420;
static const lv_coord_t TABY_BUSY_TEXT_SAFE_ROTATED_W = TABY_BUSY_TEXT_MAX_ROTATED_W - 28;
static const lv_coord_t TABY_BUSY_TEXT_SAFE_ROTATED_H = TABY_BUSY_TEXT_MAX_ROTATED_H - 32;
static const uint8_t TABY_BUSY_TEXT_DEFAULT_COLOR_R = 0xFF;
static const uint8_t TABY_BUSY_TEXT_DEFAULT_COLOR_G = 0x45;
static const uint8_t TABY_BUSY_TEXT_DEFAULT_COLOR_B = 0x3A;

static lv_obj_t *s_animation_obj = NULL;
static lv_img_dsc_t s_animation_dsc;
static uint8_t *s_animation_asset_data = NULL;
static size_t s_animation_asset_size = 0;
static taby_state_t s_animation_state = TABY_STATE_AMBIENT_STARTUP;
static taby_display_animation_complete_cb_t s_animation_complete_cb = NULL;
static void *s_animation_complete_ctx = NULL;
static lv_timer_t *s_animation_completion_timer = NULL;
static bool s_animation_complete_on_ready = false;
static lv_obj_t *s_fallback_canvas = NULL;
static lv_color_t *s_fallback_canvas_buf = NULL;

typedef struct {
    const lv_font_t *font;
    uint16_t zoom;
    lv_coord_t letter_space;
    lv_coord_t line_space;
} taby_busy_text_layout_t;

typedef struct {
    lv_color_t text_color;
    uint32_t replay_interval_ms;
    char replay_animation_id[64];
} taby_busy_text_options_t;

static const taby_busy_text_layout_t k_busy_text_layouts[] = {
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

static void reset_scene(void) {
    lv_obj_t *screen = lv_scr_act();

    if (s_animation_completion_timer) {
        lv_timer_del(s_animation_completion_timer);
        s_animation_completion_timer = NULL;
    }

    s_animation_obj = NULL;
    s_animation_complete_cb = NULL;
    s_animation_complete_ctx = NULL;
    s_animation_complete_on_ready = false;
    s_animation_state = TABY_STATE_AMBIENT_STARTUP;
    s_animation_asset_size = 0;

    if (s_fallback_canvas) {
        lv_obj_del(s_fallback_canvas);
        s_fallback_canvas = NULL;
    }

    if (s_fallback_canvas_buf) {
        heap_caps_free(s_fallback_canvas_buf);
        s_fallback_canvas_buf = NULL;
    }

    lv_obj_clean(screen);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(screen, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);

    if (s_animation_asset_data) {
        taby_asset_store_free_file(s_animation_asset_data);
        s_animation_asset_data = NULL;
    }
    memset(&s_animation_dsc, 0, sizeof(s_animation_dsc));
}

static void handle_animation_completion_timer(lv_timer_t *timer) {
    if (timer == s_animation_completion_timer) {
        s_animation_completion_timer = NULL;
    }

    if (!s_animation_complete_cb) {
        return;
    }

    s_animation_complete_cb(s_animation_state, s_animation_complete_ctx);
}

static void complete_scene_async(void *ctx) {
    (void)ctx;

    if (s_animation_complete_cb) {
        s_animation_complete_cb(s_animation_state, s_animation_complete_ctx);
        return;
    }

    taby_display_render_state(TABY_STATE_AMBIENT_IDLE, NULL, NULL, NULL, NULL, NULL);
}

static void handle_gif_ready(lv_event_t *event) {
    if ((s_animation_state == TABY_STATE_AMBIENT_BUSY_ANIMATION || s_animation_complete_on_ready) && s_animation_obj) {
        lv_async_call(complete_scene_async, NULL);
        return;
    }

    (void)event;
    ESP_LOGI(TAG, "gif_ready state=%s", taby_state_name(s_animation_state));
}

static bool apply_animation_asset_to_object(
    taby_state_t state,
    lv_obj_t *animation_obj,
    const taby_animation_asset_t *asset) {
    if (!asset) {
        return false;
    }

    uint8_t *next_asset_data = NULL;
    size_t next_asset_size = 0;
    const uint8_t *next_data = NULL;
    size_t next_data_size = 0;

    if (taby_asset_store_load_file(asset->asset_pack_path, &next_asset_data, &next_asset_size)) {
        ESP_LOGI(TAG,
                 "render_state=%s animation_id=%s source=asset_pack_memory bytes=%u",
                 taby_state_name(state),
                 asset->animation_id ? asset->animation_id : "<none>",
                 (unsigned int)next_asset_size);
        next_data = next_asset_data;
        next_data_size = next_asset_size;
    } else if (asset->compiled_data && asset->compiled_size > 0) {
        ESP_LOGI(TAG,
                 "render_state=%s animation_id=%s source=compiled_fallback",
                 taby_state_name(state),
                 asset->animation_id ? asset->animation_id : "<none>");
        next_data = asset->compiled_data;
        next_data_size = asset->compiled_size;
    } else {
        ESP_LOGW(TAG,
                 "render_state=%s animation_id=%s source=missing",
                 taby_state_name(state),
                 asset->animation_id ? asset->animation_id : "<none>");
        return false;
    }

    uint8_t *previous_asset_data = s_animation_asset_data;
    s_animation_asset_data = next_asset_data;
    s_animation_asset_size = next_data_size;
    s_animation_dsc.data_size = next_data_size;
    s_animation_dsc.data = next_data;
    lv_gif_set_src(animation_obj, &s_animation_dsc);

    if (previous_asset_data) {
        taby_asset_store_free_file(previous_asset_data);
    }
    return true;
}

static bool animation_asset_available(const taby_animation_asset_t *asset) {
    return asset &&
           ((asset->asset_pack_path && taby_asset_store_has_file(asset->asset_pack_path)) ||
            (asset->compiled_data && asset->compiled_size > 0));
}

bool taby_display_animation_available(const char *animation_id) {
    if (!animation_id || animation_id[0] == '\0') {
        return false;
    }

    taby_animation_asset_t asset = {0};
    return taby_animation_asset_for_id(animation_id, &asset) && animation_asset_available(&asset);
}

static bool create_animation_object_from_asset(taby_state_t state, const taby_animation_asset_t *asset) {
    lv_obj_t *screen = lv_scr_act();

    if (!asset) {
        return false;
    }

    s_animation_obj = lv_gif_create(screen);
    lv_obj_add_event_cb(s_animation_obj, handle_gif_ready, LV_EVENT_READY, NULL);

    if (!apply_animation_asset_to_object(state, s_animation_obj, asset)) {
        lv_obj_del(s_animation_obj);
        s_animation_obj = NULL;
        return false;
    }

    lv_obj_clear_flag(s_animation_obj, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(s_animation_obj, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_bg_color(s_animation_obj, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(s_animation_obj, LV_OPA_COVER, 0);
    lv_obj_clear_flag(s_animation_obj, LV_OBJ_FLAG_HIDDEN);
    lv_obj_center(s_animation_obj);
    lv_obj_move_foreground(s_animation_obj);
    lv_obj_invalidate(s_animation_obj);
    return true;
}

bool taby_display_swap_custom_animation(const char *animation_id) {
    if (!s_animation_obj || s_animation_state != TABY_STATE_CUSTOM_ANIMATION || !animation_id || animation_id[0] == '\0') {
        return false;
    }

    taby_animation_asset_t asset = {0};
    if (!taby_animation_asset_for_id(animation_id, &asset)) {
        return false;
    }

    if (!apply_animation_asset_to_object(TABY_STATE_CUSTOM_ANIMATION, s_animation_obj, &asset)) {
        return false;
    }

    s_animation_complete_on_ready = !asset.loop && s_animation_complete_cb != NULL;
    lv_obj_clear_flag(s_animation_obj, LV_OBJ_FLAG_HIDDEN);
    lv_obj_move_foreground(s_animation_obj);
    lv_obj_invalidate(s_animation_obj);
    lv_refr_now(board_amoled_1_64_display());
    return true;
}

static lv_obj_t *create_rotated_canvas(lv_color_t **buffer, lv_coord_t width, lv_coord_t height) {
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
    lv_obj_align(canvas, LV_ALIGN_CENTER, 0, 0);
    return canvas;
}

static void create_fallback_screen(
    taby_state_t state,
    const char *fallback_title,
    const char *fallback_subtitle) {
    const char *title = fallback_title && fallback_title[0] ? fallback_title : taby_state_label(state);
    const char *subtitle = fallback_subtitle && fallback_subtitle[0] ? fallback_subtitle : "Text preview";

    s_fallback_canvas = create_rotated_canvas(
        &s_fallback_canvas_buf,
        TABY_FALLBACK_CANVAS_W,
        TABY_FALLBACK_CANVAS_H);
    if (!s_fallback_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_fallback_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_rect_dsc_t card_dsc;
    lv_draw_rect_dsc_init(&card_dsc);
    card_dsc.bg_opa = LV_OPA_90;
    card_dsc.bg_color = lv_color_black();
    card_dsc.border_opa = LV_OPA_40;
    card_dsc.border_width = 1;
    card_dsc.border_color = lv_color_make(0x76, 0x7F, 0x8A);
    card_dsc.radius = 28;
    lv_canvas_draw_rect(
        s_fallback_canvas,
        12,
        10,
        TABY_FALLBACK_CANVAS_W - 24,
        TABY_FALLBACK_CANVAS_H - 20,
        &card_dsc);

    lv_draw_label_dsc_t title_dsc;
    lv_draw_label_dsc_init(&title_dsc);
    title_dsc.color = lv_color_white();
    title_dsc.font = &lv_font_montserrat_20;
    title_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(
        s_fallback_canvas,
        22,
        90,
        TABY_FALLBACK_CANVAS_W - 44,
        &title_dsc,
        title);

    lv_draw_label_dsc_t subtitle_dsc;
    lv_draw_label_dsc_init(&subtitle_dsc);
    subtitle_dsc.color = lv_color_make(0x9B, 0xA2, 0xAA);
    subtitle_dsc.font = &lv_font_montserrat_16;
    subtitle_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(
        s_fallback_canvas,
        24,
        170,
        TABY_FALLBACK_CANVAS_W - 48,
        &subtitle_dsc,
        subtitle);
}

static int hex_digit_value(char ch) {
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    }

    char normalized = (char)toupper((unsigned char)ch);
    if (normalized >= 'A' && normalized <= 'F') {
        return 10 + (normalized - 'A');
    }

    return -1;
}

static lv_color_t default_busy_text_color(void) {
    return lv_color_make(
        TABY_BUSY_TEXT_DEFAULT_COLOR_R,
        TABY_BUSY_TEXT_DEFAULT_COLOR_G,
        TABY_BUSY_TEXT_DEFAULT_COLOR_B);
}

static bool parse_busy_text_color_token(const char *source, lv_color_t *out_color) {
    if (!source || !out_color || source[0] != '#') {
        return false;
    }

    int digits[6] = {0};
    for (size_t i = 0; i < 6; ++i) {
        if (source[i + 1] == '\0') {
            return false;
        }

        digits[i] = hex_digit_value(source[i + 1]);
        if (digits[i] < 0) {
            return false;
        }
    }

    *out_color = lv_color_make(
        (uint8_t)((digits[0] << 4) | digits[1]),
        (uint8_t)((digits[2] << 4) | digits[3]),
        (uint8_t)((digits[4] << 4) | digits[5]));
    return true;
}

static taby_busy_text_options_t busy_text_options_from_hint(const char *hint) {
    taby_busy_text_options_t options = {0};
    options.text_color = default_busy_text_color();

    if (!hint || hint[0] == '\0' || strcmp(hint, "Busy loop") == 0) {
        return options;
    }

    const char *cursor = hint;
    if (cursor[0] == '#') {
        lv_color_t parsed_color = default_busy_text_color();
        if (!parse_busy_text_color_token(cursor, &parsed_color)) {
            return options;
        }

        options.text_color = parsed_color;
        cursor += 7;
    }

    if (cursor[0] == '@') {
        uint32_t seconds = 0;
        size_t digit_count = 0;
        while (isdigit((unsigned char)cursor[digit_count + 1])) {
            uint32_t next_digit = (uint32_t)(cursor[digit_count + 1] - '0');
            if (seconds > 86400U) {
                seconds = 86400U;
            } else {
                seconds = seconds * 10U + next_digit;
                if (seconds > 86400U) {
                    seconds = 86400U;
                }
            }
            digit_count++;
        }

        if (digit_count == 0) {
            options.replay_interval_ms = 0;
            return options;
        }

        options.replay_interval_ms = seconds > 0 ? seconds * 1000U : 0;
        cursor += 1 + digit_count;
    }

    if (cursor[0] == '!') {
        size_t id_count = 0;
        while (isalnum((unsigned char)cursor[id_count + 1]) || cursor[id_count + 1] == '_') {
            id_count++;
        }

        if (id_count == 0 || id_count >= sizeof(options.replay_animation_id)) {
            options.replay_interval_ms = 0;
            return options;
        }

        for (size_t i = 0; i < id_count; ++i) {
            options.replay_animation_id[i] = (char)tolower((unsigned char)cursor[i + 1]);
        }
        options.replay_animation_id[id_count] = '\0';
        cursor += 1 + id_count;
    }

    if (cursor[0] != '\0') {
        options.text_color = default_busy_text_color();
        options.replay_interval_ms = 0;
        options.replay_animation_id[0] = '\0';
    }

    return options;
}

static void create_busy_text_screen(const char *display_text, const taby_busy_text_options_t *options) {
    const char *text = display_text && display_text[0] ? display_text : "BUSY";
    const taby_busy_text_layout_t *selected_layout = &k_busy_text_layouts[sizeof(k_busy_text_layouts) / sizeof(k_busy_text_layouts[0]) - 1];
    lv_coord_t selected_width = TABY_BUSY_TEXT_SAFE_ROTATED_H;
    lv_color_t text_color = options ? options->text_color : default_busy_text_color();

    for (size_t i = 0; i < sizeof(k_busy_text_layouts) / sizeof(k_busy_text_layouts[0]); ++i) {
        const taby_busy_text_layout_t *layout = &k_busy_text_layouts[i];
        lv_coord_t max_width = (TABY_BUSY_TEXT_SAFE_ROTATED_H * LV_IMG_ZOOM_NONE) / layout->zoom;
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

        // The label is rotated 90 degrees on the AMOLED, so its scaled height becomes
        // the final horizontal footprint and its scaled width becomes the vertical one.
        if (scaled_width <= TABY_BUSY_TEXT_SAFE_ROTATED_H && scaled_height <= TABY_BUSY_TEXT_SAFE_ROTATED_W) {
            selected_layout = layout;
            selected_width = max_width;
            break;
        }
    }

    lv_obj_t *label = lv_label_create(lv_scr_act());
    if (!label) {
        return;
    }

    lv_obj_set_width(label, selected_width);
    lv_obj_set_height(label, LV_SIZE_CONTENT);
    lv_label_set_long_mode(label, LV_LABEL_LONG_WRAP);
    lv_label_set_text(label, text);
    lv_obj_set_style_text_align(label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_set_style_text_color(label, text_color, 0);
    lv_obj_set_style_text_font(label, selected_layout->font, 0);
    lv_obj_set_style_text_letter_space(label, selected_layout->letter_space, 0);
    lv_obj_set_style_text_line_space(label, selected_layout->line_space, 0);
    lv_obj_set_style_bg_opa(label, LV_OPA_TRANSP, 0);
    lv_obj_set_scrollbar_mode(label, LV_SCROLLBAR_MODE_OFF);
    lv_obj_clear_flag(label, LV_OBJ_FLAG_SCROLLABLE);

    lv_obj_update_layout(label);
    lv_obj_set_style_transform_pivot_x(label, lv_obj_get_width(label) / 2, 0);
    lv_obj_set_style_transform_pivot_y(label, lv_obj_get_height(label) / 2, 0);
    lv_obj_set_style_transform_zoom(label, selected_layout->zoom, 0);
    lv_obj_set_style_transform_angle(label, 900, 0);
    lv_obj_align(label, LV_ALIGN_CENTER, TABY_BUSY_TEXT_OFFSET_X, TABY_BUSY_TEXT_OFFSET_Y);
    lv_obj_move_foreground(label);
}

void taby_display_init(void) {
    lv_obj_t *screen = lv_scr_act();
    taby_reusable_ui_deactivate_choice_input();
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(screen, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
}

void taby_display_clear(void) {
    taby_reusable_ui_deactivate_choice_input();
    reset_scene();
}

bool taby_display_render_state(
    taby_state_t state,
    taby_display_animation_complete_cb_t animation_complete_cb,
    void *animation_complete_ctx,
    const char *fallback_title,
    const char *fallback_subtitle,
    const char *animation_id) {
    taby_animation_asset_t asset = {0};
    taby_busy_text_options_t busy_text_options = busy_text_options_from_hint(fallback_subtitle);
    bool has_custom_busy_animation =
        state == TABY_STATE_AMBIENT_BUSY_ANIMATION &&
        busy_text_options.replay_animation_id[0] != '\0' &&
        taby_animation_asset_for_id(busy_text_options.replay_animation_id, &asset);
    bool has_custom_animation =
        state == TABY_STATE_CUSTOM_ANIMATION &&
        animation_id &&
        animation_id[0] != '\0' &&
        taby_animation_asset_for_id(animation_id, &asset);

    bool should_use_animation_asset =
        has_custom_busy_animation ||
        has_custom_animation ||
        (taby_state_has_animation(state) && taby_animation_asset_for_state(state, &asset));

    if (should_use_animation_asset && !animation_asset_available(&asset)) {
        ESP_LOGW(
            TAG,
            "render_state=%s animation_id=%s source=missing keep_current_scene=1",
            taby_state_name(state),
            asset.animation_id ? asset.animation_id : "<none>");
        return false;
    }

    taby_reusable_ui_deactivate_choice_input();
    reset_scene();

    s_animation_complete_cb = animation_complete_cb;
    s_animation_complete_ctx = animation_complete_ctx;
    s_animation_state = state;

    if (state == TABY_STATE_CUSTOM_ANIMATION && !has_custom_animation) {
        create_fallback_screen(state, fallback_title, fallback_subtitle);
        return true;
    }

    if (!has_custom_busy_animation && !has_custom_animation && !should_use_animation_asset) {
        create_fallback_screen(state, fallback_title, fallback_subtitle);
        return true;
    }

    if (state == TABY_STATE_AMBIENT_BUSY_TEXT) {
        create_busy_text_screen(fallback_title, &busy_text_options);
        if (s_animation_complete_cb && busy_text_options.replay_interval_ms > 0) {
            s_animation_completion_timer = lv_timer_create(
                handle_animation_completion_timer,
                busy_text_options.replay_interval_ms,
                NULL);
            lv_timer_set_repeat_count(s_animation_completion_timer, 1);
        }
        lv_refr_now(board_amoled_1_64_display());
        return true;
    }

    if (!taby_state_has_animation(state)) {
        create_fallback_screen(state, fallback_title, fallback_subtitle);
        return true;
    }

    s_animation_dsc.header.always_zero = 0;
    s_animation_dsc.header.cf = LV_IMG_CF_RAW;
    s_animation_dsc.header.w = 0;
    s_animation_dsc.header.h = 0;

    if (!create_animation_object_from_asset(state, &asset)) {
        return false;
    }

    s_animation_complete_on_ready =
        !asset.loop &&
        state != TABY_STATE_AMBIENT_BUSY_ANIMATION &&
        s_animation_complete_cb != NULL;

    lv_refr_now(board_amoled_1_64_display());

    return true;
}
