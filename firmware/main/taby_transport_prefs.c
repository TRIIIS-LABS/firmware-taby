#include "taby_transport_prefs.h"

#include <stdint.h>
#include <string.h>

#include "esp_check.h"
#include "nvs.h"

static const char *TAG = "taby_transport_prefs";
static const char *TABY_TRANSPORT_NAMESPACE = "taby_setup";
static const char *TABY_TRANSPORT_COMPLETE_KEY = "done";
static const char *TABY_TRANSPORT_PREF_KEY = "pref";

typedef struct {
    bool loaded;
    bool onboarding_complete;
    taby_transport_pref_t preferred_mode;
} taby_transport_prefs_state_t;

static taby_transport_prefs_state_t s_state = {
    .loaded = false,
    .onboarding_complete = false,
    .preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN,
};

static esp_err_t load_state_from_nvs(void) {
    nvs_handle_t handle;
    esp_err_t err = nvs_open(TABY_TRANSPORT_NAMESPACE, NVS_READONLY, &handle);
    if (err == ESP_ERR_NVS_NOT_FOUND) {
        s_state.loaded = true;
        s_state.onboarding_complete = false;
        s_state.preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
        return ESP_OK;
    }
    ESP_RETURN_ON_ERROR(err, TAG, "nvs open failed");

    uint8_t onboarding_complete = 0;
    uint8_t preferred_mode = (uint8_t)TABY_TRANSPORT_PREF_UNKNOWN;
    if (nvs_get_u8(handle, TABY_TRANSPORT_COMPLETE_KEY, &onboarding_complete) != ESP_OK) {
        onboarding_complete = 0;
    }
    if (nvs_get_u8(handle, TABY_TRANSPORT_PREF_KEY, &preferred_mode) != ESP_OK) {
        preferred_mode = (uint8_t)TABY_TRANSPORT_PREF_UNKNOWN;
    }
    nvs_close(handle);

    s_state.loaded = true;
    s_state.onboarding_complete = onboarding_complete != 0;
    s_state.preferred_mode = (preferred_mode <= TABY_TRANSPORT_PREF_BLUETOOTH)
        ? (taby_transport_pref_t)preferred_mode
        : TABY_TRANSPORT_PREF_UNKNOWN;
    return ESP_OK;
}

static esp_err_t ensure_loaded(void) {
    if (s_state.loaded) {
        return ESP_OK;
    }
    return load_state_from_nvs();
}

static esp_err_t persist_state(void) {
    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(nvs_open(TABY_TRANSPORT_NAMESPACE, NVS_READWRITE, &handle), TAG, "nvs open failed");
    ESP_RETURN_ON_ERROR(
        nvs_set_u8(handle, TABY_TRANSPORT_COMPLETE_KEY, s_state.onboarding_complete ? 1 : 0),
        TAG,
        "save onboarding complete failed");
    ESP_RETURN_ON_ERROR(
        nvs_set_u8(handle, TABY_TRANSPORT_PREF_KEY, (uint8_t)s_state.preferred_mode),
        TAG,
        "save preferred mode failed");
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit prefs failed");
    nvs_close(handle);
    return ESP_OK;
}

esp_err_t taby_transport_prefs_init(void) {
    return ensure_loaded();
}

bool taby_transport_onboarding_complete(void) {
    ensure_loaded();
    return s_state.onboarding_complete;
}

taby_transport_pref_t taby_transport_preferred_mode(void) {
    ensure_loaded();
    return s_state.preferred_mode;
}

const char *taby_transport_preferred_mode_name(void) {
    switch (taby_transport_preferred_mode()) {
        case TABY_TRANSPORT_PREF_USB:
            return "usb";
        case TABY_TRANSPORT_PREF_WIFI:
            return "wifi";
        case TABY_TRANSPORT_PREF_BLUETOOTH:
            return "bluetooth";
        case TABY_TRANSPORT_PREF_UNKNOWN:
        default:
            return "unknown";
    }
}

bool taby_transport_pref_from_name(const char *name, taby_transport_pref_t *out_mode) {
    if (!name || !out_mode) {
        return false;
    }

    if (strcmp(name, "usb") == 0) {
        *out_mode = TABY_TRANSPORT_PREF_USB;
        return true;
    }
    if (strcmp(name, "wifi") == 0) {
        *out_mode = TABY_TRANSPORT_PREF_WIFI;
        return true;
    }
    if (strcmp(name, "bluetooth") == 0 || strcmp(name, "ble") == 0) {
        *out_mode = TABY_TRANSPORT_PREF_BLUETOOTH;
        return true;
    }

    return false;
}

esp_err_t taby_transport_mark_onboarded(taby_transport_pref_t preferred_mode) {
    return taby_transport_set_preferred_mode(preferred_mode, true);
}

esp_err_t taby_transport_set_preferred_mode(
    taby_transport_pref_t preferred_mode,
    bool onboarding_complete) {
    if (preferred_mode != TABY_TRANSPORT_PREF_UNKNOWN &&
        preferred_mode != TABY_TRANSPORT_PREF_USB &&
        preferred_mode != TABY_TRANSPORT_PREF_WIFI &&
        preferred_mode != TABY_TRANSPORT_PREF_BLUETOOTH) {
        return ESP_ERR_INVALID_ARG;
    }

    ESP_RETURN_ON_ERROR(ensure_loaded(), TAG, "load prefs failed");
    s_state.preferred_mode = preferred_mode;
    s_state.onboarding_complete = onboarding_complete;
    return persist_state();
}

esp_err_t taby_transport_reset_incomplete_on_boot(void) {
    ESP_RETURN_ON_ERROR(ensure_loaded(), TAG, "load prefs failed");
    if (s_state.onboarding_complete || s_state.preferred_mode == TABY_TRANSPORT_PREF_UNKNOWN) {
        return ESP_OK;
    }

    s_state.preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
    s_state.onboarding_complete = false;
    return persist_state();
}

esp_err_t taby_transport_clear_onboarding(void) {
    ESP_RETURN_ON_ERROR(ensure_loaded(), TAG, "load prefs failed");
    s_state.preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
    s_state.onboarding_complete = false;
    return persist_state();
}
