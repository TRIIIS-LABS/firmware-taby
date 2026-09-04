#pragma once

#include <stdbool.h>

#include <stdint.h>

typedef struct {
    const char *asset_pack_path;
    uint16_t width;
    uint16_t height;
} taby_reusable_icon_asset_t;

bool taby_reusable_icon_lookup(const char *icon_id, taby_reusable_icon_asset_t *out_asset);
