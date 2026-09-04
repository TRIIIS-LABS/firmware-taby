#include "taby_runtime.h"

#include <stdlib.h>

#include "board_amoled_1_64.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "taby_display.h"
#include "taby_onboarding.h"
#include "taby_reusable_ui.h"

static const char *TAG = "taby_runtime";

static taby_state_machine_t s_machine;
static bool s_runtime_started = false;
static char s_fallback_title[TABY_TRANSPORT_LABEL_SIZE] = {0};
static char s_fallback_subtitle[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
static char s_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
static char s_next_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
static char s_transport_banner_title[TABY_TRANSPORT_LABEL_SIZE] = {0};
static char s_transport_banner_subtitle[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
static int64_t s_transport_banner_until_us = 0;
static taby_state_t s_last_rendered_state = TABY_STATE_AMBIENT_STARTUP;
static char s_last_rendered_title[TABY_TRANSPORT_LABEL_SIZE] = {0};
static char s_last_rendered_subtitle[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
static char s_last_rendered_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
static bool s_last_render_valid = false;
static bool s_custom_ui_active = false;
static char s_custom_transport_state[48] = {0};
static bool s_display_manually_off = false;
static uint8_t s_deferred_brightness_percent = 0;

static bool render_current_state_locked(void);
static void clear_custom_ui_state(void);
static void deactivate_custom_ui_state_locked(void);

static bool wake_display_locked(void) {
    if (s_display_manually_off) {
        return false;
    }

    if (board_amoled_1_64_display_enabled()) {
        return true;
    }

    esp_err_t err = board_amoled_1_64_set_display_enabled(true);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "failed to wake display: %s", esp_err_to_name(err));
        return false;
    }

    s_last_render_valid = false;
    return true;
}

static void clear_transport_banner_locked(void) {
    s_transport_banner_title[0] = '\0';
    s_transport_banner_subtitle[0] = '\0';
    s_transport_banner_until_us = 0;
}

static bool transport_banner_active_locked(void) {
    if (s_transport_banner_title[0] == '\0') {
        return false;
    }

    if (s_transport_banner_until_us <= esp_timer_get_time()) {
        clear_transport_banner_locked();
        return false;
    }

    return true;
}

static void transport_banner_clear_task(void *arg) {
    int64_t deadline_us = arg ? *((int64_t *)arg) : 0;
    free(arg);

    int64_t now_us = esp_timer_get_time();
    if (deadline_us > now_us) {
        uint32_t delay_ms = (uint32_t)((deadline_us - now_us + 999) / 1000);
        vTaskDelay(pdMS_TO_TICKS(delay_ms));
    }

    if (!board_amoled_1_64_lock(1000)) {
        vTaskDelete(NULL);
        return;
    }

    if (s_transport_banner_until_us <= deadline_us) {
        clear_transport_banner_locked();
        s_last_render_valid = false;
        render_current_state_locked();
    }

    board_amoled_1_64_unlock();
    vTaskDelete(NULL);
}

static void copy_text(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0) {
        return;
    }

    if (!source) {
        destination[0] = '\0';
        return;
    }

    size_t copy_len = 0;
    while (copy_len + 1 < destination_size && source[copy_len] != '\0') {
        destination[copy_len] = source[copy_len];
        copy_len++;
    }
    destination[copy_len] = '\0';
}

static void set_fallback_text(const char *title, const char *subtitle) {
    copy_text(s_fallback_title, sizeof(s_fallback_title), title);
    copy_text(s_fallback_subtitle, sizeof(s_fallback_subtitle), subtitle);
}

static void clear_custom_ui_state(void) {
    s_custom_ui_active = false;
    s_custom_transport_state[0] = '\0';
}

static void deactivate_custom_ui_state_locked(void) {
    if (s_custom_ui_active) {
        taby_reusable_ui_reset();
    }
    clear_custom_ui_state();
}

static bool text_equals(const char *left, const char *right) {
    if (left == NULL || right == NULL) {
        return left == right;
    }

    return strcmp(left, right) == 0;
}

static bool should_force_repeat_render(taby_state_t state) {
    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
        case TABY_STATE_VOICE_LISTENING:
        case TABY_STATE_VOICE_TALKING:
        case TABY_STATE_TOOL_USE:
        case TABY_STATE_TASK_DELETE:
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
        case TABY_STATE_AMBIENT_BUSY_TEXT:
        case TABY_STATE_CUSTOM_ANIMATION:
            return true;
        case TABY_STATE_AMBIENT_IDLE:
        case TABY_STATE_AMBIENT_WAITING:
        case TABY_STATE_FOCUS_TIMER:
        case TABY_STATE_BREAK_START:
        case TABY_STATE_MISSING_FEATURE:
        default:
            return false;
    }
}

static bool render_matches_current_state(taby_state_t state) {
    return s_last_render_valid &&
           s_last_rendered_state == state &&
           text_equals(s_last_rendered_title, s_fallback_title) &&
           text_equals(s_last_rendered_subtitle, s_fallback_subtitle) &&
           text_equals(s_last_rendered_animation_id, s_animation_id);
}

static void handle_animation_complete(taby_state_t state, void *ctx) {
    (void)state;
    (void)ctx;

    if (state == TABY_STATE_CUSTOM_ANIMATION && s_next_animation_id[0] != '\0') {
        ESP_LOGI(TAG, "animation_complete chained_to=%s", s_next_animation_id);
        copy_text(s_animation_id, sizeof(s_animation_id), s_next_animation_id);
        s_next_animation_id[0] = '\0';
        s_last_render_valid = false;
        if (taby_display_swap_custom_animation(s_animation_id)) {
            return;
        }
        render_current_state_locked();
        return;
    }

    taby_state_t next_state = taby_state_machine_on_animation_complete(&s_machine);
    ESP_LOGI(TAG, "animation_complete next_state=%s", taby_state_name(next_state));
    if (state == TABY_STATE_CUSTOM_ANIMATION) {
        s_animation_id[0] = '\0';
        s_next_animation_id[0] = '\0';
    }
    if (state == TABY_STATE_AMBIENT_IDLE && next_state == TABY_STATE_AMBIENT_IDLE) {
        /* Idle is intentionally the one ambient loop that should replay forever. */
        s_last_render_valid = false;
    }
    render_current_state_locked();
}

static bool render_current_state_locked(void) {
    if (taby_onboarding_blocks_runtime()) {
        ESP_LOGI(TAG, "render_state skipped=1 reason=onboarding");
        return true;
    }

    if (transport_banner_active_locked()) {
        bool rendered = taby_display_render_state(
            TABY_STATE_AMBIENT_BUSY_TEXT,
            NULL,
            NULL,
            s_transport_banner_title,
            s_transport_banner_subtitle,
            NULL);
        ESP_LOGI(
            TAG,
            "render_transport_banner title=%s subtitle=%s rendered=%d",
            s_transport_banner_title,
            s_transport_banner_subtitle,
            rendered ? 1 : 0);
        if (rendered) {
            s_last_rendered_state = TABY_STATE_AMBIENT_BUSY_TEXT;
            copy_text(
                s_last_rendered_title,
                sizeof(s_last_rendered_title),
                s_transport_banner_title);
            copy_text(
                s_last_rendered_subtitle,
                sizeof(s_last_rendered_subtitle),
                s_transport_banner_subtitle);
            copy_text(s_last_rendered_animation_id, sizeof(s_last_rendered_animation_id), NULL);
            s_last_render_valid = true;
        }
        return rendered;
    }

    taby_state_t state = s_machine.current_state;
    bool has_animation = taby_state_has_animation(state);

    if (render_matches_current_state(state) && !should_force_repeat_render(state)) {
        ESP_LOGI(TAG,
                 "render_state=%s skipped=1 reason=duplicate",
                 taby_state_name(state));
        return true;
    }

    bool rendered = taby_display_render_state(
        state,
        has_animation ? handle_animation_complete : NULL,
        NULL,
        s_fallback_title,
        s_fallback_subtitle,
        s_animation_id);

    ESP_LOGI(
        TAG,
        "render_state=%s has_animation=%d rendered=%d",
        taby_state_name(state),
        has_animation ? 1 : 0,
        rendered ? 1 : 0);

    if (rendered) {
        s_last_rendered_state = state;
        copy_text(s_last_rendered_title, sizeof(s_last_rendered_title), s_fallback_title);
        copy_text(s_last_rendered_subtitle, sizeof(s_last_rendered_subtitle), s_fallback_subtitle);
        copy_text(s_last_rendered_animation_id, sizeof(s_last_rendered_animation_id), s_animation_id);
        s_last_render_valid = true;
    }
    return rendered;
}

void taby_runtime_start(void) {
    if (s_runtime_started) {
        return;
    }

    taby_state_machine_init(&s_machine);
    s_runtime_started = true;
    s_last_render_valid = false;
    clear_custom_ui_state();
    set_fallback_text(NULL, NULL);
    copy_text(s_animation_id, sizeof(s_animation_id), NULL);
    copy_text(s_next_animation_id, sizeof(s_next_animation_id), NULL);
    copy_text(s_last_rendered_title, sizeof(s_last_rendered_title), NULL);
    copy_text(s_last_rendered_subtitle, sizeof(s_last_rendered_subtitle), NULL);
    copy_text(s_last_rendered_animation_id, sizeof(s_last_rendered_animation_id), NULL);

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGE(TAG, "failed to acquire LVGL lock during runtime start");
        s_runtime_started = false;
        return;
    }

    taby_display_init();
    render_current_state_locked();
    board_amoled_1_64_unlock();
}

bool taby_runtime_apply_command(taby_command_t command) {
    if (!s_runtime_started) {
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for command");
        return false;
    }

    clear_custom_ui_state();
    set_fallback_text(NULL, NULL);
    copy_text(s_animation_id, sizeof(s_animation_id), NULL);
    copy_text(s_next_animation_id, sizeof(s_next_animation_id), NULL);
    wake_display_locked();
    taby_state_t next_state = taby_state_machine_apply_command(&s_machine, command);
    ESP_LOGI(TAG, "apply_command command=%d next_state=%s", (int)command, taby_state_name(next_state));
    bool rendered = render_current_state_locked();
    board_amoled_1_64_unlock();
    return rendered;
}

bool taby_runtime_apply_transport_resolution(const taby_transport_resolution_t *resolution) {
    if (!resolution) {
        return false;
    }

    if (!s_runtime_started) {
        return false;
    }

    if (resolution->command == TABY_COMMAND_CUSTOM_ANIMATION &&
        (!taby_display_animation_available(resolution->animation_id) ||
         (resolution->next_animation_id[0] != '\0' &&
          !taby_display_animation_available(resolution->next_animation_id)))) {
        ESP_LOGW(
            TAG,
            "reject_resolution reason=animation_missing animation_id=%s next_animation_id=%s",
            resolution->animation_id,
            resolution->next_animation_id);
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for transport resolution");
        return false;
    }

    deactivate_custom_ui_state_locked();
    set_fallback_text(resolution->title, resolution->subtitle);
    copy_text(s_animation_id, sizeof(s_animation_id), resolution->animation_id);
    copy_text(s_next_animation_id, sizeof(s_next_animation_id), resolution->next_animation_id);
    wake_display_locked();
    taby_state_t next_state = taby_state_machine_apply_command(&s_machine, resolution->command);
    ESP_LOGI(TAG,
             "apply_resolution command=%d next_state=%s title=%s subtitle=%s",
             (int)resolution->command,
             taby_state_name(next_state),
             s_fallback_title,
             s_fallback_subtitle);
    bool rendered = render_current_state_locked();
    board_amoled_1_64_unlock();
    return rendered;
}

void taby_runtime_show_transport_banner(
    const char *title,
    const char *subtitle,
    uint32_t duration_ms) {
    if (!s_runtime_started || !title || title[0] == '\0') {
        return;
    }

    uint32_t clamped_duration_ms = duration_ms == 0 ? 2200 : duration_ms;
    int64_t deadline_us =
        esp_timer_get_time() + ((int64_t)clamped_duration_ms * 1000);

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for transport banner");
        return;
    }

    deactivate_custom_ui_state_locked();
    wake_display_locked();
    copy_text(s_transport_banner_title, sizeof(s_transport_banner_title), title);
    copy_text(
        s_transport_banner_subtitle,
        sizeof(s_transport_banner_subtitle),
        subtitle);
    s_transport_banner_until_us = deadline_us;
    s_last_render_valid = false;
    render_current_state_locked();
    board_amoled_1_64_unlock();

    int64_t *deadline_copy = malloc(sizeof(*deadline_copy));
    if (!deadline_copy) {
        return;
    }

    *deadline_copy = deadline_us;
    if (xTaskCreate(
            transport_banner_clear_task,
            "taby_transport_banner",
            3072,
            deadline_copy,
            4,
            NULL) != pdPASS) {
        free(deadline_copy);
    }
}

bool taby_runtime_refresh_current_state(void) {
    if (!s_runtime_started) {
        return false;
    }

    if (s_custom_ui_active) {
        return true;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for runtime refresh");
        return false;
    }

    s_last_render_valid = false;
    render_current_state_locked();
    board_amoled_1_64_unlock();
    return true;
}

void taby_runtime_invalidate_render_cache(void) {
    s_last_render_valid = false;
}

taby_state_t taby_runtime_current_state(void) {
    return s_machine.current_state;
}

void taby_runtime_dismiss_reusable_card_locked(void) {
    if (!s_runtime_started || !s_custom_ui_active) {
        return;
    }

    deactivate_custom_ui_state_locked();
    s_last_render_valid = false;
    render_current_state_locked();
}

bool taby_runtime_render_reusable_card(const taby_reusable_card_t *card, const char *transport_state_name) {
    if (!s_runtime_started || !card) {
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for reusable card");
        return false;
    }

    const char *effective_state_name =
        (transport_state_name && transport_state_name[0] != '\0') ? transport_state_name : "UI_ACTIVE";

    ESP_LOGI(
        TAG,
        "render reusable card state=%s kind=%d title='%s' subtitle='%s' icon='%s'",
        effective_state_name,
        (int)card->kind,
        card->title ? card->title : "",
        card->subtitle ? card->subtitle : "",
        card->icon_id ? card->icon_id : "");

    copy_text(s_custom_transport_state, sizeof(s_custom_transport_state), effective_state_name);
    s_custom_ui_active = true;
    wake_display_locked();
    taby_display_clear();
    bool rendered = taby_reusable_ui_render_card(card);
    if (rendered) {
        s_last_render_valid = false;
    }
    board_amoled_1_64_unlock();
    return rendered;
}

bool taby_runtime_set_display_awake(bool awake) {
    if (!s_runtime_started) {
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for display awake");
        return false;
    }

    esp_err_t err = ESP_OK;
    if (awake && s_deferred_brightness_percent > 0) {
        err = board_amoled_1_64_set_brightness_percent(s_deferred_brightness_percent);
        if (err == ESP_OK) {
            s_deferred_brightness_percent = 0;
        }
    } else {
        err = board_amoled_1_64_set_display_enabled(awake);
    }
    if (err == ESP_OK && awake) {
        s_display_manually_off = false;
        s_last_render_valid = false;
        if (!s_custom_ui_active) {
            render_current_state_locked();
        }
    } else if (err == ESP_OK) {
        s_display_manually_off = true;
    }
    board_amoled_1_64_unlock();

    if (err != ESP_OK) {
        ESP_LOGW(TAG, "failed to set display awake=%d: %s", awake ? 1 : 0, esp_err_to_name(err));
        return false;
    }
    return true;
}

bool taby_runtime_toggle_display_awake(void) {
    bool next_awake = !taby_runtime_display_awake();
    if (!taby_runtime_set_display_awake(next_awake)) {
        return taby_runtime_display_awake();
    }
    return next_awake;
}

bool taby_runtime_display_awake(void) {
    return board_amoled_1_64_display_enabled() && !s_display_manually_off;
}

bool taby_runtime_set_brightness_percent(uint8_t percent) {
    if (!s_runtime_started) {
        return false;
    }

    if (percent > 100) {
        percent = 100;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for brightness");
        return false;
    }

    if (s_display_manually_off && percent > 0) {
        s_deferred_brightness_percent = percent;
        board_amoled_1_64_unlock();
        return true;
    }

    esp_err_t err = board_amoled_1_64_set_brightness_percent(percent);
    if (err == ESP_OK && percent > 0) {
        s_last_render_valid = false;
        if (!s_custom_ui_active) {
            render_current_state_locked();
        }
    }
    board_amoled_1_64_unlock();

    if (err != ESP_OK) {
        ESP_LOGW(TAG, "failed to set brightness percent=%u: %s", (unsigned int)percent, esp_err_to_name(err));
        return false;
    }
    return true;
}

taby_display_orientation_t taby_runtime_display_orientation(void) {
    return board_amoled_1_64_display_orientation();
}

taby_display_orientation_mode_t taby_runtime_display_orientation_mode(void) {
    return board_amoled_1_64_display_orientation_mode();
}

bool taby_runtime_set_display_orientation_mode(taby_display_orientation_mode_t mode) {
    if (!s_runtime_started) {
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for display orientation");
        return false;
    }

    esp_err_t err = board_amoled_1_64_set_display_orientation_mode(mode);
    board_amoled_1_64_unlock();
    if (err != ESP_OK) {
        ESP_LOGW(
            TAG,
            "failed to set display orientation mode=%d: %s",
            (int)mode,
            esp_err_to_name(err));
        return false;
    }

    return true;
}

bool taby_runtime_reset_display_orientation(void) {
    if (!s_runtime_started) {
        return false;
    }

    if (!board_amoled_1_64_lock(1000)) {
        ESP_LOGW(TAG, "failed to acquire LVGL lock for display orientation reset");
        return false;
    }

    esp_err_t err = board_amoled_1_64_reset_display_orientation();
    board_amoled_1_64_unlock();
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "failed to reset display orientation: %s", esp_err_to_name(err));
        return false;
    }

    return true;
}
