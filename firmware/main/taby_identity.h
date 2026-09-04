#pragma once

#include <stdbool.h>

#include "esp_err.h"

typedef struct {
    char device_id[32];
    char device_secret[65];
    bool claimed;
    char claimed_by[64];
    bool has_factory_data;
} taby_identity_t;

esp_err_t taby_identity_init(void);
const taby_identity_t *taby_identity_get(void);
const char *taby_identity_source_name(void);
esp_err_t taby_identity_set_claim(const char *claimed_by);
esp_err_t taby_identity_clear_claim(void);
