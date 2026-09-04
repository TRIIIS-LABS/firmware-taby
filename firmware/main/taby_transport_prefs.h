#pragma once

#include <stdbool.h>

#include "esp_err.h"

typedef enum {
    TABY_TRANSPORT_PREF_UNKNOWN = 0,
    TABY_TRANSPORT_PREF_USB,
    TABY_TRANSPORT_PREF_WIFI,
    TABY_TRANSPORT_PREF_BLUETOOTH,
} taby_transport_pref_t;

esp_err_t taby_transport_prefs_init(void);
bool taby_transport_onboarding_complete(void);
taby_transport_pref_t taby_transport_preferred_mode(void);
const char *taby_transport_preferred_mode_name(void);
bool taby_transport_pref_from_name(const char *name, taby_transport_pref_t *out_mode);
esp_err_t taby_transport_mark_onboarded(taby_transport_pref_t preferred_mode);
esp_err_t taby_transport_set_preferred_mode(
    taby_transport_pref_t preferred_mode,
    bool onboarding_complete);
esp_err_t taby_transport_reset_incomplete_on_boot(void);
esp_err_t taby_transport_clear_onboarding(void);
