#pragma once

#include <stdbool.h>

#include "taby_transport_prefs.h"

void taby_onboarding_start(void);
void taby_onboarding_show_usb_hint(void);
void taby_onboarding_show_bluetooth_hint(void);
void taby_onboarding_show_wifi_setup(void);
void taby_onboarding_show_transport_banner(taby_transport_pref_t preferred_mode);
esp_err_t taby_onboarding_activate_transport_mode(taby_transport_pref_t preferred_mode);
esp_err_t taby_onboarding_set_transport_default(taby_transport_pref_t preferred_mode);
void taby_onboarding_notify_wifi_provisioned(void);
esp_err_t taby_onboarding_persist_transport_choice(taby_transport_pref_t preferred_mode);
bool taby_onboarding_is_active(void);
bool taby_onboarding_blocks_runtime(void);
