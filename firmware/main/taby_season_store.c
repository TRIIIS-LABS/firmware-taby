#include "taby_season_store.h"

#include <stdbool.h>
#include <stdint.h>

#include "esp_log.h"
#include "nvs.h"

static const char *TAG = "taby_season";
/* The namespace that keeps the Eyes setting and the display orientation. */
#define PREFS_NAMESPACE "taby_display"
#define SEASON_KEY "season"

/* What NVS holds now, so the look told every 30 minutes is not written again. */
static bool s_stored = false;
static uint8_t s_value = 0;

taby_season_look_t taby_season_store_load(void) {
    nvs_handle_t handle;
    uint8_t value = 0;
    bool stored = false;
    if (nvs_open(PREFS_NAMESPACE, NVS_READONLY, &handle) == ESP_OK) {
        stored = nvs_get_u8(handle, SEASON_KEY, &value) == ESP_OK;
        nvs_close(handle);
    }
    s_stored = stored;
    s_value = value;
    taby_season_look_t look = taby_season_look_from_stored(stored, value);
    ESP_LOGI(TAG, "season loaded look=%s told=%d", taby_season_look_name(look), stored ? 1 : 0);
    return look;
}

esp_err_t taby_season_store_save(taby_season_look_t look) {
    if (!taby_season_needs_store(s_stored, s_value, look)) {
        return ESP_OK;
    }
    nvs_handle_t handle;
    esp_err_t err = nvs_open(PREFS_NAMESPACE, NVS_READWRITE, &handle);
    if (err != ESP_OK) {
        return err;
    }
    const uint8_t value = taby_season_stored_value(look);
    err = nvs_set_u8(handle, SEASON_KEY, value);
    if (err == ESP_OK) {
        err = nvs_commit(handle);
    }
    nvs_close(handle);
    if (err == ESP_OK) {
        s_stored = true;
        s_value = value;
    }
    return err;
}
