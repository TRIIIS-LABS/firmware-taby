#pragma once

#include <stdbool.h>

#include "esp_err.h"
#include "taby_identity.h"

esp_err_t taby_mqtt_init(const taby_identity_t *identity);
void taby_mqtt_shutdown(void);
bool taby_mqtt_enabled(void);
bool taby_mqtt_connected(void);
const char *taby_mqtt_broker_uri(void);
void taby_mqtt_notify_state_changed(const char *reason);
