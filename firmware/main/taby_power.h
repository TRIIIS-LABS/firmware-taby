#pragma once

#include <stdbool.h>

#include "esp_err.h"

typedef struct {
    bool valid;
    int power_voltage_mv;
    int battery_percent;
    bool external_power;
} taby_power_status_t;

esp_err_t taby_power_init(void);
taby_power_status_t taby_power_get_status(void);
