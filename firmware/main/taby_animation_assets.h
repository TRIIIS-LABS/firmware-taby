#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "taby_state_machine.h"

typedef struct {
    const char *animation_id;
    const char *asset_pack_path;
    const uint8_t *compiled_data;
    size_t compiled_size;
    uint32_t duration_ms;
    bool loop;
} taby_animation_asset_t;

bool taby_animation_asset_for_state(taby_state_t state, taby_animation_asset_t *out_asset);
bool taby_animation_asset_for_id(const char *animation_id, taby_animation_asset_t *out_asset);
