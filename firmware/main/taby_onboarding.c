#include "taby_onboarding.h"

#include <stdio.h>
#include <string.h>

#include "board_amoled_1_64.h"
#include "esp_check.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "lvgl.h"
#include "extra/libs/qrcode/qrcodegen.h"
#include "taby_ble_transport.h"
#include "taby_display.h"
#include "taby_identity.h"
#include "taby_runtime.h"
#include "taby_transport_prefs.h"
#include "taby_wifi.h"

static const char *TAG = "taby_onboarding";

typedef enum {
    TABY_ONBOARDING_STAGE_INACTIVE = 0,
    TABY_ONBOARDING_STAGE_CHOOSE,
    TABY_ONBOARDING_STAGE_USB_HINT,
    TABY_ONBOARDING_STAGE_BLUETOOTH_HINT,
    TABY_ONBOARDING_STAGE_WIFI_SETUP,
} taby_onboarding_stage_t;

typedef enum {
    TABY_ONBOARDING_CHOICE_NONE = 0,
    TABY_ONBOARDING_CHOICE_WIRELESS,
    TABY_ONBOARDING_CHOICE_BLUETOOTH,
    TABY_ONBOARDING_CHOICE_USB,
} taby_onboarding_choice_t;

static const lv_coord_t TABY_ONBOARDING_WIFI_CANVAS_W = 270;
static const lv_coord_t TABY_ONBOARDING_WIFI_CANVAS_H = 430;
static const lv_coord_t TABY_ONBOARDING_LANDSCAPE_W = 456;
static const lv_coord_t TABY_ONBOARDING_LANDSCAPE_H = 280;
static const lv_coord_t TABY_ONBOARDING_CHOICE_BUTTON_W = 132;
static const lv_coord_t TABY_ONBOARDING_CHOICE_BUTTON_H = 136;
static const lv_coord_t TABY_ONBOARDING_CHOICE_BUTTON_Y = 92;
static const lv_coord_t TABY_ONBOARDING_CHOICE_MIDDLE_X = 162;
static const lv_coord_t TABY_ONBOARDING_WIFI_QR_SIZE = 188;
static const int64_t TABY_ONBOARDING_TAP_MIN_US = 20 * 1000;
static const int64_t TABY_ONBOARDING_TAP_MAX_US = 700 * 1000;
static const int64_t TABY_ONBOARDING_TAP_REARM_US = 120 * 1000;
static const int64_t TABY_ONBOARDING_CHOICE_COMMIT_US = 45 * 1000;

static bool s_task_started = false;
static bool s_touch_press_active = false;
static int64_t s_touch_press_start_us = 0;
static int64_t s_touch_last_tap_us = 0;
static uint16_t s_touch_last_x = 0;
static uint16_t s_touch_last_y = 0;
static bool s_render_pending = false;
static taby_onboarding_stage_t s_stage = TABY_ONBOARDING_STAGE_INACTIVE;
static taby_onboarding_choice_t s_pressed_choice = TABY_ONBOARDING_CHOICE_NONE;
static taby_onboarding_choice_t s_pending_choice = TABY_ONBOARDING_CHOICE_NONE;
static int64_t s_pending_choice_at_us = 0;
static lv_obj_t *s_canvas = NULL;
static lv_color_t *s_canvas_buf = NULL;

static void clear_choice_state(void);

static lv_color_t color_from_hex(uint32_t hex) {
    return lv_color_make(
        (uint8_t)((hex >> 16) & 0xFF),
        (uint8_t)((hex >> 8) & 0xFF),
        (uint8_t)(hex & 0xFF));
}

static lv_obj_t *create_rotated_canvas(
    lv_color_t **buffer,
    lv_coord_t width,
    lv_coord_t height) {
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

static void release_canvas_buffer_only(void) {
    s_canvas = NULL;
    if (s_canvas_buf) {
        heap_caps_free(s_canvas_buf);
        s_canvas_buf = NULL;
    }
}

static void draw_centered_text(
    lv_coord_t x,
    lv_coord_t y,
    lv_coord_t width,
    lv_coord_t height,
    const char *text,
    const lv_font_t *font,
    lv_color_t color) {
    if (!s_canvas || !text || !text[0]) {
        return;
    }

    lv_draw_label_dsc_t label_dsc;
    lv_draw_label_dsc_init(&label_dsc);
    label_dsc.color = color;
    label_dsc.font = font;
    label_dsc.align = LV_TEXT_ALIGN_CENTER;

    lv_point_t text_size = {0};
    lv_txt_get_size(&text_size, text, font, 0, 0, width, LV_TEXT_FLAG_NONE);
    lv_coord_t text_y = y + ((height - text_size.y) / 2);

    lv_canvas_draw_text(
        s_canvas,
        x,
        text_y,
        width,
        &label_dsc,
        text);
}

static void draw_landscape_choice_button(
    lv_coord_t x,
    lv_coord_t y,
    const char *label,
    taby_onboarding_choice_t choice,
    bool selected) {
    lv_draw_rect_dsc_t rect_dsc;
    lv_draw_rect_dsc_init(&rect_dsc);
    rect_dsc.bg_opa = LV_OPA_COVER;
    if (choice == TABY_ONBOARDING_CHOICE_WIRELESS) {
        rect_dsc.bg_color = selected ? color_from_hex(0x24384D) : color_from_hex(0x18242F);
    } else if (choice == TABY_ONBOARDING_CHOICE_BLUETOOTH) {
        rect_dsc.bg_color = selected ? color_from_hex(0x273149) : color_from_hex(0x1A2232);
    } else {
        rect_dsc.bg_color = selected ? color_from_hex(0x313744) : color_from_hex(0x1F232A);
    }
    rect_dsc.radius = 26;
    rect_dsc.border_width = selected ? 3 : 2;
    rect_dsc.border_opa = LV_OPA_60;
    rect_dsc.border_color = choice == TABY_ONBOARDING_CHOICE_WIRELESS
        ? color_from_hex(0x6B8CAB)
        : choice == TABY_ONBOARDING_CHOICE_BLUETOOTH
            ? color_from_hex(0x7C90D4)
            : color_from_hex(0x9DA7B8);
    lv_canvas_draw_rect(
        s_canvas,
        x,
        y,
        TABY_ONBOARDING_CHOICE_BUTTON_W,
        TABY_ONBOARDING_CHOICE_BUTTON_H,
        &rect_dsc);

    draw_centered_text(
        x,
        y,
        TABY_ONBOARDING_CHOICE_BUTTON_W,
        TABY_ONBOARDING_CHOICE_BUTTON_H,
        label,
        strlen(label) <= 8 ? &lv_font_montserrat_28 : &lv_font_montserrat_20,
        lv_color_white());
}

static bool draw_qr_code(lv_coord_t x, lv_coord_t y, lv_coord_t size, const char *payload) {
    if (!s_canvas || !payload || !payload[0]) {
        return false;
    }

    uint8_t temp_buffer[qrcodegen_BUFFER_LEN_FOR_VERSION(10)];
    uint8_t qr_buffer[qrcodegen_BUFFER_LEN_FOR_VERSION(10)];
    if (!qrcodegen_encodeText(
            payload,
            temp_buffer,
            qr_buffer,
            qrcodegen_Ecc_MEDIUM,
            qrcodegen_VERSION_MIN,
            10,
            qrcodegen_Mask_AUTO,
            true)) {
        return false;
    }

    const int qr_size = qrcodegen_getSize(qr_buffer);
    if (qr_size <= 0) {
        return false;
    }

    lv_draw_rect_dsc_t qr_bg_dsc;
    lv_draw_rect_dsc_init(&qr_bg_dsc);
    qr_bg_dsc.bg_opa = LV_OPA_COVER;
    qr_bg_dsc.bg_color = lv_color_white();
    qr_bg_dsc.radius = 18;
    qr_bg_dsc.border_width = 0;
    lv_canvas_draw_rect(s_canvas, x, y, size, size, &qr_bg_dsc);

    const lv_coord_t inner_padding = 12;
    const lv_coord_t inner_size = size - (inner_padding * 2);
    const lv_coord_t module_size = inner_size / qr_size;
    if (module_size <= 0) {
        return false;
    }

    const lv_coord_t rendered_size = module_size * qr_size;
    const lv_coord_t qr_x = x + inner_padding + ((inner_size - rendered_size) / 2);
    const lv_coord_t qr_y = y + inner_padding + ((inner_size - rendered_size) / 2);

    lv_draw_rect_dsc_t module_dsc;
    lv_draw_rect_dsc_init(&module_dsc);
    module_dsc.bg_opa = LV_OPA_COVER;
    module_dsc.bg_color = lv_color_black();
    module_dsc.radius = 0;
    module_dsc.border_width = 0;

    for (int row = 0; row < qr_size; ++row) {
        for (int col = 0; col < qr_size; ++col) {
            if (!qrcodegen_getModule(qr_buffer, col, row)) {
                continue;
            }
            lv_canvas_draw_rect(
                s_canvas,
                qr_x + (col * module_size),
                qr_y + (row * module_size),
                module_size,
                module_size,
                &module_dsc);
        }
    }

    return true;
}

static void render_choose_screen(void) {
    s_canvas = create_rotated_canvas(
        &s_canvas_buf,
        TABY_ONBOARDING_LANDSCAPE_W,
        TABY_ONBOARDING_LANDSCAPE_H);
    if (!s_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_label_dsc_t title_dsc;
    lv_draw_label_dsc_init(&title_dsc);
    title_dsc.color = lv_color_white();
    title_dsc.font = &lv_font_montserrat_28;
    title_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(
        s_canvas,
        24,
        28,
        TABY_ONBOARDING_LANDSCAPE_W - 48,
        &title_dsc,
        "SET UP TABY");

    draw_landscape_choice_button(
        TABY_ONBOARDING_CHOICE_MIDDLE_X,
        TABY_ONBOARDING_CHOICE_BUTTON_Y,
        "USB-C",
        TABY_ONBOARDING_CHOICE_USB,
        true);
}

static void render_usb_hint_screen(void) {
    s_canvas = create_rotated_canvas(
        &s_canvas_buf,
        TABY_ONBOARDING_LANDSCAPE_W,
        TABY_ONBOARDING_LANDSCAPE_H);
    if (!s_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_rect_dsc_t card_dsc;
    lv_draw_rect_dsc_init(&card_dsc);
    card_dsc.bg_opa = LV_OPA_COVER;
    card_dsc.bg_color = color_from_hex(0x161A21);
    card_dsc.radius = 28;
    card_dsc.border_width = 2;
    card_dsc.border_opa = LV_OPA_60;
    card_dsc.border_color = color_from_hex(0x6C7684);
    lv_canvas_draw_rect(
        s_canvas,
        26,
        54,
        TABY_ONBOARDING_LANDSCAPE_W - 52,
        170,
        &card_dsc);

    draw_centered_text(
        34,
        88,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        42,
        "OPEN TABY",
        &lv_font_montserrat_28,
        lv_color_white());

    draw_centered_text(
        34,
        146,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        34,
        "USB-C",
        &lv_font_montserrat_20,
        color_from_hex(0xD7DEE7));
}

static void render_bluetooth_hint_screen(void) {
    s_canvas = create_rotated_canvas(
        &s_canvas_buf,
        TABY_ONBOARDING_LANDSCAPE_W,
        TABY_ONBOARDING_LANDSCAPE_H);
    if (!s_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_rect_dsc_t card_dsc;
    lv_draw_rect_dsc_init(&card_dsc);
    card_dsc.bg_opa = LV_OPA_COVER;
    card_dsc.bg_color = color_from_hex(0x171D2B);
    card_dsc.radius = 28;
    card_dsc.border_width = 2;
    card_dsc.border_opa = LV_OPA_60;
    card_dsc.border_color = color_from_hex(0x7C90D4);
    lv_canvas_draw_rect(
        s_canvas,
        26,
        40,
        TABY_ONBOARDING_LANDSCAPE_W - 52,
        196,
        &card_dsc);

    draw_centered_text(
        34,
        64,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        36,
        "READY TO PAIR",
        &lv_font_montserrat_28,
        lv_color_white());

    draw_centered_text(
        34,
        110,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        30,
        "BLUETOOTH",
        &lv_font_montserrat_20,
        color_from_hex(0xD7DEE7));

    draw_centered_text(
        34,
        146,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        30,
        taby_ble_transport_device_name(),
        &lv_font_montserrat_20,
        lv_color_white());

    const char *status = taby_ble_transport_is_connected()
        ? "CONNECTED"
        : taby_ble_transport_is_advertising()
            ? "ADVERTISING"
            : "STARTING RADIO";
    draw_centered_text(
        34,
        182,
        TABY_ONBOARDING_LANDSCAPE_W - 68,
        24,
        status,
        &lv_font_montserrat_16,
        color_from_hex(0x9FB0E5));
}

static void render_wifi_setup_screen(void) {
    taby_wifi_setup_info_t setup_info = {0};
    taby_wifi_get_setup_info(&setup_info);
    const char *wifi_error = taby_wifi_last_error();
    const bool has_wifi_error = wifi_error && wifi_error[0] != '\0';
    const char *title = "JOIN WI-FI";
    if (has_wifi_error) {
        if (strcmp(wifi_error, "Wrong password") == 0) {
            title = "WRONG PASSWORD";
        } else if (strcmp(wifi_error, "Wi-Fi not found") == 0) {
            title = "WI-FI NOT FOUND";
        } else {
            title = "TRY AGAIN";
        }
    }

    s_canvas = create_rotated_canvas(
        &s_canvas_buf,
        TABY_ONBOARDING_WIFI_CANVAS_W,
        TABY_ONBOARDING_WIFI_CANVAS_H);
    if (!s_canvas) {
        return;
    }

    lv_canvas_fill_bg(s_canvas, lv_color_black(), LV_OPA_COVER);

    lv_draw_label_dsc_t title_dsc;
    lv_draw_label_dsc_init(&title_dsc);
    title_dsc.color = lv_color_white();
    title_dsc.font = &lv_font_montserrat_20;
    title_dsc.align = LV_TEXT_ALIGN_CENTER;
    lv_canvas_draw_text(
        s_canvas,
        20,
        28,
        TABY_ONBOARDING_WIFI_CANVAS_W - 40,
        &title_dsc,
        title);

    if (has_wifi_error) {
        draw_centered_text(
            18,
            52,
            TABY_ONBOARDING_WIFI_CANVAS_W - 36,
            28,
            wifi_error,
            &lv_font_montserrat_16,
            color_from_hex(0xFF7A72));
    }

    const lv_coord_t qr_x = (TABY_ONBOARDING_WIFI_CANVAS_W - TABY_ONBOARDING_WIFI_QR_SIZE) / 2;
    const lv_coord_t qr_y = has_wifi_error ? 86 : 72;
    if (!draw_qr_code(qr_x, qr_y, TABY_ONBOARDING_WIFI_QR_SIZE, setup_info.qr_payload)) {
        draw_centered_text(
            22,
            has_wifi_error ? 140 : 126,
            TABY_ONBOARDING_WIFI_CANVAS_W - 44,
            80,
            setup_info.ssid,
            &lv_font_montserrat_20,
            lv_color_white());
    }

    draw_centered_text(
        8,
        316,
        TABY_ONBOARDING_WIFI_CANVAS_W - 16,
        44,
        setup_info.host,
        &lv_font_montserrat_28,
        color_from_hex(0xD7DEE7));
}

static void render_current_stage(void) {
    taby_display_clear();
    release_canvas_buffer_only();

    switch (s_stage) {
        case TABY_ONBOARDING_STAGE_CHOOSE:
            render_choose_screen();
            break;
        case TABY_ONBOARDING_STAGE_USB_HINT:
            render_usb_hint_screen();
            break;
        case TABY_ONBOARDING_STAGE_BLUETOOTH_HINT:
            render_bluetooth_hint_screen();
            break;
        case TABY_ONBOARDING_STAGE_WIFI_SETUP:
            render_wifi_setup_screen();
            break;
        case TABY_ONBOARDING_STAGE_INACTIVE:
        default:
            break;
    }

    if (s_canvas) {
        lv_refr_now(board_amoled_1_64_display());
    }
}

static void queue_render(taby_onboarding_stage_t next_stage) {
    s_stage = next_stage;
    s_render_pending = true;
}

esp_err_t taby_onboarding_persist_transport_choice(taby_transport_pref_t preferred_mode) {
    if (preferred_mode == TABY_TRANSPORT_PREF_USB) {
        return taby_transport_mark_onboarded(TABY_TRANSPORT_PREF_USB);
    }

    if (preferred_mode == TABY_TRANSPORT_PREF_BLUETOOTH) {
        return taby_transport_mark_onboarded(TABY_TRANSPORT_PREF_BLUETOOTH);
    }

    if (preferred_mode == TABY_TRANSPORT_PREF_WIFI) {
        bool wifi_ready_now =
            taby_wifi_mode() == TABY_WIFI_MODE_STATION && taby_wifi_is_connected();
        return wifi_ready_now
            ? taby_transport_mark_onboarded(TABY_TRANSPORT_PREF_WIFI)
            : taby_transport_set_preferred_mode(TABY_TRANSPORT_PREF_WIFI, false);
    }

    return ESP_ERR_INVALID_ARG;
}

static void choose_wireless_setup(void) {
    ESP_LOGI(TAG, "choose_wireless_setup");
    if (taby_onboarding_persist_transport_choice(TABY_TRANSPORT_PREF_WIFI) != ESP_OK) {
        ESP_LOGW(TAG, "failed to persist Wi-Fi onboarding selection");
    }
    if (taby_wifi_start_setup_mode(taby_identity_get()) != ESP_OK) {
        ESP_LOGW(TAG, "failed to start setup AP from chooser");
        clear_choice_state();
        queue_render(TABY_ONBOARDING_STAGE_CHOOSE);
        return;
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_WIFI_SETUP);
}

static void choose_usb_setup(void) {
    ESP_LOGI(TAG, "choose_usb_setup");
    if (taby_onboarding_persist_transport_choice(TABY_TRANSPORT_PREF_USB) != ESP_OK) {
        ESP_LOGW(TAG, "failed to persist USB onboarding selection");
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_USB_HINT);
}

static void choose_bluetooth_setup(void) {
    ESP_LOGI(TAG, "choose_bluetooth_setup");
    if (taby_onboarding_persist_transport_choice(TABY_TRANSPORT_PREF_BLUETOOTH) != ESP_OK) {
        ESP_LOGW(TAG, "failed to persist Bluetooth onboarding selection");
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_BLUETOOTH_HINT);
}

static void maybe_commit_pending_choice(void) {
    if (s_pending_choice == TABY_ONBOARDING_CHOICE_NONE ||
        esp_timer_get_time() < s_pending_choice_at_us) {
        return;
    }

    taby_onboarding_choice_t choice = s_pending_choice;
    s_pending_choice = TABY_ONBOARDING_CHOICE_NONE;

    if (choice == TABY_ONBOARDING_CHOICE_WIRELESS) {
        choose_wireless_setup();
        return;
    }

    if (choice == TABY_ONBOARDING_CHOICE_BLUETOOTH) {
        choose_bluetooth_setup();
        return;
    }

    if (choice == TABY_ONBOARDING_CHOICE_USB) {
        choose_usb_setup();
    }
}

static void clear_choice_state(void) {
    s_pressed_choice = TABY_ONBOARDING_CHOICE_NONE;
    s_pending_choice = TABY_ONBOARDING_CHOICE_NONE;
    s_pending_choice_at_us = 0;
}

static taby_onboarding_choice_t choice_for_touch(uint16_t x, uint16_t y) {
    (void)x;
    (void)y;
    return TABY_ONBOARDING_CHOICE_USB;
}

static void handle_tap(uint16_t x, uint16_t y) {
    if (s_stage != TABY_ONBOARDING_STAGE_CHOOSE) {
        return;
    }

    ESP_LOGI(TAG, "handle_tap x=%u y=%u", (unsigned)x, (unsigned)y);

    s_pressed_choice = choice_for_touch(x, y);
    s_pending_choice = s_pressed_choice;
    s_pending_choice_at_us = esp_timer_get_time() + TABY_ONBOARDING_CHOICE_COMMIT_US;
    queue_render(TABY_ONBOARDING_STAGE_CHOOSE);
}

static void poll_touch(void) {
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
        return;
    }

    if (!s_touch_press_active) {
        return;
    }

    int64_t press_us = now_us - s_touch_press_start_us;
    int64_t since_last_tap_us = now_us - s_touch_last_tap_us;
    s_touch_press_active = false;

    if (press_us < TABY_ONBOARDING_TAP_MIN_US ||
        press_us > TABY_ONBOARDING_TAP_MAX_US ||
        since_last_tap_us < TABY_ONBOARDING_TAP_REARM_US) {
        return;
    }

    s_touch_last_tap_us = now_us;
    handle_tap(s_touch_last_x, s_touch_last_y);
}

static void onboarding_task(void *arg) {
    (void)arg;

    while (true) {
        if (s_stage != TABY_ONBOARDING_STAGE_INACTIVE) {
            poll_touch();
            maybe_commit_pending_choice();
            if (s_render_pending && board_amoled_1_64_lock(10)) {
                s_render_pending = false;
                render_current_stage();
                board_amoled_1_64_unlock();
            }
        }

        vTaskDelay(pdMS_TO_TICKS(20));
    }
}

void taby_onboarding_start(void) {
    if (!s_task_started) {
        xTaskCreate(onboarding_task, "taby_onboarding", 4096, NULL, 4, NULL);
        s_task_started = true;
    }

    clear_choice_state();
    if (taby_transport_onboarding_complete()) {
        s_stage = TABY_ONBOARDING_STAGE_INACTIVE;
        s_render_pending = false;
        return;
    }

    if (taby_transport_preferred_mode() == TABY_TRANSPORT_PREF_WIFI) {
        queue_render(TABY_ONBOARDING_STAGE_WIFI_SETUP);
        return;
    }

    queue_render(TABY_ONBOARDING_STAGE_CHOOSE);
}

void taby_onboarding_show_usb_hint(void) {
    if (!s_task_started) {
        xTaskCreate(onboarding_task, "taby_onboarding", 4096, NULL, 4, NULL);
        s_task_started = true;
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_USB_HINT);
}

void taby_onboarding_show_bluetooth_hint(void) {
    if (!s_task_started) {
        xTaskCreate(onboarding_task, "taby_onboarding", 4096, NULL, 4, NULL);
        s_task_started = true;
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_BLUETOOTH_HINT);
}

void taby_onboarding_show_wifi_setup(void) {
    if (!s_task_started) {
        xTaskCreate(onboarding_task, "taby_onboarding", 4096, NULL, 4, NULL);
        s_task_started = true;
    }
    clear_choice_state();
    queue_render(TABY_ONBOARDING_STAGE_WIFI_SETUP);
}

void taby_onboarding_show_transport_banner(taby_transport_pref_t preferred_mode) {
    switch (preferred_mode) {
        case TABY_TRANSPORT_PREF_USB:
            taby_runtime_show_transport_banner("USB-C", "CONNECTED", 2200);
            return;
        case TABY_TRANSPORT_PREF_WIFI:
            if (!taby_wifi_is_provisioned()) {
                taby_onboarding_show_wifi_setup();
                return;
            }

            if (taby_wifi_is_connected()) {
                const char *ssid = taby_wifi_station_ssid();
                taby_runtime_show_transport_banner(
                    "WI-FI",
                    (ssid && ssid[0] != '\0') ? ssid : "CONNECTED",
                    2400);
            } else {
                taby_runtime_show_transport_banner("WI-FI", "CONNECTING", 2400);
            }
            return;
        case TABY_TRANSPORT_PREF_BLUETOOTH: {
            const char *subtitle = taby_ble_transport_is_connected()
                ? "CONNECTED"
                : taby_ble_transport_is_advertising()
                    ? "READY TO PAIR"
                    : "STARTING RADIO";
            taby_runtime_show_transport_banner("BT ACTIVE", subtitle, 2400);
            return;
        }
        case TABY_TRANSPORT_PREF_UNKNOWN:
        default:
            return;
    }
}

esp_err_t taby_onboarding_activate_transport_mode(taby_transport_pref_t preferred_mode) {
    switch (preferred_mode) {
        case TABY_TRANSPORT_PREF_USB:
            taby_onboarding_show_transport_banner(TABY_TRANSPORT_PREF_USB);
            return ESP_OK;
        case TABY_TRANSPORT_PREF_WIFI:
            ESP_RETURN_ON_ERROR(
                taby_ble_transport_shutdown(),
                TAG,
                "stop bluetooth before wifi failed");
            if (!taby_wifi_is_provisioned()) {
                ESP_RETURN_ON_ERROR(
                    taby_wifi_start_setup_mode(taby_identity_get()),
                    TAG,
                    "start wifi setup mode failed");
                taby_onboarding_show_wifi_setup();
                return ESP_OK;
            }

            if (taby_wifi_mode() != TABY_WIFI_MODE_STATION || !taby_wifi_is_connected()) {
                esp_err_t connect_err = taby_wifi_connect_saved_networks();
                if (connect_err != ESP_OK && connect_err != ESP_ERR_INVALID_STATE) {
                    return connect_err;
                }
            }
            taby_onboarding_show_transport_banner(TABY_TRANSPORT_PREF_WIFI);
            return ESP_OK;
        case TABY_TRANSPORT_PREF_BLUETOOTH:
            ESP_RETURN_ON_ERROR(
                taby_wifi_shutdown(),
                TAG,
                "stop wifi before bluetooth failed");
            ESP_RETURN_ON_ERROR(
                taby_ble_transport_init(taby_identity_get()),
                TAG,
                "start bluetooth transport failed");
            taby_ble_transport_ensure_advertising();
            taby_onboarding_show_transport_banner(TABY_TRANSPORT_PREF_BLUETOOTH);
            return ESP_OK;
        case TABY_TRANSPORT_PREF_UNKNOWN:
        default:
            return ESP_ERR_INVALID_ARG;
    }
}

esp_err_t taby_onboarding_set_transport_default(taby_transport_pref_t preferred_mode) {
    if (preferred_mode == TABY_TRANSPORT_PREF_USB) {
        ESP_RETURN_ON_ERROR(
            taby_onboarding_persist_transport_choice(preferred_mode),
            TAG,
            "persist usb transport choice failed");
        taby_onboarding_show_usb_hint();
        return ESP_OK;
    }

    if (preferred_mode == TABY_TRANSPORT_PREF_WIFI) {
        ESP_RETURN_ON_ERROR(
            taby_ble_transport_shutdown(),
            TAG,
            "stop bluetooth before wifi default failed");
        ESP_RETURN_ON_ERROR(
            taby_onboarding_persist_transport_choice(TABY_TRANSPORT_PREF_WIFI),
            TAG,
            "persist wifi transport choice failed");

        if (taby_wifi_is_provisioned()) {
            if (taby_wifi_mode() != TABY_WIFI_MODE_STATION || !taby_wifi_is_connected()) {
                esp_err_t connect_err = taby_wifi_connect_saved_networks();
                if (connect_err != ESP_OK && connect_err != ESP_ERR_INVALID_STATE) {
                    taby_onboarding_show_wifi_setup();
                    return ESP_OK;
                }
            }
            taby_runtime_refresh_current_state();
        } else {
            ESP_RETURN_ON_ERROR(
                taby_wifi_start_setup_mode(taby_identity_get()),
                TAG,
                "start wifi setup mode failed");
            taby_onboarding_show_wifi_setup();
        }
        return ESP_OK;
    }

    if (preferred_mode == TABY_TRANSPORT_PREF_BLUETOOTH) {
        ESP_RETURN_ON_ERROR(
            taby_wifi_shutdown(),
            TAG,
            "stop wifi before bluetooth default failed");
        ESP_RETURN_ON_ERROR(
            taby_ble_transport_init(taby_identity_get()),
            TAG,
            "start bluetooth transport default failed");
        ESP_RETURN_ON_ERROR(
            taby_onboarding_persist_transport_choice(TABY_TRANSPORT_PREF_BLUETOOTH),
            TAG,
            "persist bluetooth transport choice failed");
        taby_onboarding_show_bluetooth_hint();
        return ESP_OK;
    }

    return ESP_ERR_INVALID_ARG;
}

void taby_onboarding_notify_wifi_provisioned(void) {
    if (taby_transport_onboarding_complete()) {
        clear_choice_state();
        s_stage = TABY_ONBOARDING_STAGE_INACTIVE;
        s_render_pending = false;
        taby_runtime_refresh_current_state();
        return;
    }
    if (taby_transport_mark_onboarded(TABY_TRANSPORT_PREF_WIFI) != ESP_OK) {
        ESP_LOGW(TAG, "failed to persist Wi-Fi onboarding selection");
    }
    clear_choice_state();
    s_stage = TABY_ONBOARDING_STAGE_INACTIVE;
    s_render_pending = false;
    taby_runtime_refresh_current_state();
}

bool taby_onboarding_is_active(void) {
    return s_stage != TABY_ONBOARDING_STAGE_INACTIVE;
}

bool taby_onboarding_blocks_runtime(void) {
    return s_stage == TABY_ONBOARDING_STAGE_CHOOSE ||
           s_stage == TABY_ONBOARDING_STAGE_WIFI_SETUP;
}
