#pragma once

#include <stdbool.h>

#include "esp_err.h"
#include "taby_identity.h"

esp_err_t taby_ble_transport_init(const taby_identity_t *identity);
esp_err_t taby_ble_transport_shutdown(void);
void taby_ble_transport_ensure_advertising(void);
bool taby_ble_transport_is_ready(void);
bool taby_ble_transport_is_advertising(void);
bool taby_ble_transport_is_connected(void);
const char *taby_ble_transport_device_name(void);
const char *taby_ble_transport_last_error(void);
