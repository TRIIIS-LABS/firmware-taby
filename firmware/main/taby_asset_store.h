#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

void taby_asset_store_init(void);
bool taby_asset_store_ready(void);
const char *taby_asset_store_pack_version(void);
bool taby_asset_store_has_file(const char *asset_pack_path);
bool taby_asset_store_build_lvgl_path(const char *asset_pack_path, char *out_path, size_t out_path_size);
bool taby_asset_store_load_file(const char *asset_pack_path, uint8_t **out_data, size_t *out_size);
void taby_asset_store_free_file(uint8_t *data);
