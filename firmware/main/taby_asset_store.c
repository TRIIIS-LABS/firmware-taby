#include "taby_asset_store.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "cJSON.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_spiffs.h"

static const char *TAG = "taby_asset_store";
static const char *TABY_ASSET_BASE_PATH = "/assets";
static const char *TABY_ASSET_MANIFEST_PATH = "/assets/manifest.json";
static const char *TABY_ASSET_PARTITION_LABEL = "assets";
static const char TABY_LVGL_FS_LETTER = 'A';
#define TABY_ASSET_PACK_VERSION_SIZE 32

static bool s_asset_store_ready = false;
static char s_asset_pack_version[TABY_ASSET_PACK_VERSION_SIZE] = "";

static void load_asset_pack_version(void) {
    s_asset_pack_version[0] = '\0';

    struct stat st;
    if (stat(TABY_ASSET_MANIFEST_PATH, &st) != 0 || !S_ISREG(st.st_mode) || st.st_size <= 0) {
        ESP_LOGW(TAG, "asset pack manifest missing: %s", TABY_ASSET_MANIFEST_PATH);
        return;
    }
    if (st.st_size > 16 * 1024) {
        ESP_LOGW(TAG, "asset pack manifest too large: %s size=%u", TABY_ASSET_MANIFEST_PATH, (unsigned int)st.st_size);
        return;
    }

    size_t file_size = (size_t)st.st_size;
    char *buffer = malloc(file_size + 1);
    if (!buffer) {
        ESP_LOGW(TAG, "asset pack manifest allocation failed size=%u", (unsigned int)file_size);
        return;
    }

    FILE *file = fopen(TABY_ASSET_MANIFEST_PATH, "rb");
    if (!file) {
        ESP_LOGW(TAG, "asset pack manifest open failed: %s errno=%d", TABY_ASSET_MANIFEST_PATH, errno);
        free(buffer);
        return;
    }

    size_t bytes_read = fread(buffer, 1, file_size, file);
    fclose(file);
    if (bytes_read != file_size) {
        ESP_LOGW(TAG,
                 "asset pack manifest read failed: expected=%u actual=%u",
                 (unsigned int)file_size,
                 (unsigned int)bytes_read);
        free(buffer);
        return;
    }
    buffer[file_size] = '\0';

    cJSON *root = cJSON_Parse(buffer);
    free(buffer);
    if (!root) {
        ESP_LOGW(TAG, "asset pack manifest parse failed");
        return;
    }

    const cJSON *version = cJSON_GetObjectItemCaseSensitive(root, "version");
    if (!cJSON_IsString(version) || !version->valuestring || version->valuestring[0] == '\0') {
        ESP_LOGW(TAG, "asset pack manifest is missing version");
        cJSON_Delete(root);
        return;
    }

    snprintf(s_asset_pack_version, sizeof(s_asset_pack_version), "%s", version->valuestring);
    ESP_LOGI(TAG, "asset pack version=%s", s_asset_pack_version);
    cJSON_Delete(root);
}

void taby_asset_store_init(void) {
    if (s_asset_store_ready) {
        return;
    }

    esp_vfs_spiffs_conf_t conf = {
        .base_path = TABY_ASSET_BASE_PATH,
        .partition_label = TABY_ASSET_PARTITION_LABEL,
        .max_files = 8,
        .format_if_mount_failed = false,
    };

    esp_err_t err = esp_vfs_spiffs_register(&conf);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "asset pack mount failed: %s", esp_err_to_name(err));
        return;
    }

    size_t total = 0;
    size_t used = 0;
    err = esp_spiffs_info(TABY_ASSET_PARTITION_LABEL, &total, &used);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "asset pack info failed: %s", esp_err_to_name(err));
    } else {
        ESP_LOGI(TAG, "asset pack mounted used=%u total=%u", (unsigned int)used, (unsigned int)total);
    }

    load_asset_pack_version();
    s_asset_store_ready = true;
}

bool taby_asset_store_ready(void) {
    return s_asset_store_ready;
}

const char *taby_asset_store_pack_version(void) {
    return s_asset_pack_version;
}

bool taby_asset_store_has_file(const char *asset_pack_path) {
    if (!s_asset_store_ready || !asset_pack_path) {
        return false;
    }

    struct stat st;
    return stat(asset_pack_path, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0;
}

bool taby_asset_store_build_lvgl_path(const char *asset_pack_path, char *out_path, size_t out_path_size) {
    if (!s_asset_store_ready || !asset_pack_path || !out_path || out_path_size < 4) {
        return false;
    }

    struct stat st;
    if (stat(asset_pack_path, &st) != 0 || !S_ISREG(st.st_mode)) {
        ESP_LOGW(TAG, "asset missing from mounted pack: %s", asset_pack_path);
        return false;
    }

    int written = snprintf(out_path, out_path_size, "%c:%s", TABY_LVGL_FS_LETTER, asset_pack_path);
    if (written <= 0 || (size_t)written >= out_path_size) {
        ESP_LOGW(TAG, "asset LVGL path overflow for %s", asset_pack_path);
        return false;
    }

    return true;
}

bool taby_asset_store_load_file(const char *asset_pack_path, uint8_t **out_data, size_t *out_size) {
    if (!s_asset_store_ready || !asset_pack_path || !out_data || !out_size) {
        return false;
    }

    *out_data = NULL;
    *out_size = 0;

    struct stat st;
    if (stat(asset_pack_path, &st) != 0 || !S_ISREG(st.st_mode) || st.st_size <= 0) {
        ESP_LOGW(TAG, "asset missing from mounted pack: %s", asset_pack_path);
        return false;
    }

    size_t file_size = (size_t)st.st_size;
    uint8_t *buffer = heap_caps_malloc(file_size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    if (!buffer) {
        buffer = heap_caps_malloc(file_size, MALLOC_CAP_8BIT);
    }
    if (!buffer) {
        ESP_LOGW(TAG, "asset allocation failed: %s size=%u", asset_pack_path, (unsigned int)file_size);
        return false;
    }

    FILE *file = fopen(asset_pack_path, "rb");
    if (!file) {
        ESP_LOGW(TAG, "asset open failed: %s errno=%d", asset_pack_path, errno);
        heap_caps_free(buffer);
        return false;
    }

    size_t bytes_read = fread(buffer, 1, file_size, file);
    fclose(file);

    if (bytes_read != file_size) {
        ESP_LOGW(TAG,
                 "asset read failed: %s expected=%u actual=%u",
                 asset_pack_path,
                 (unsigned int)file_size,
                 (unsigned int)bytes_read);
        heap_caps_free(buffer);
        return false;
    }

    *out_data = buffer;
    *out_size = file_size;
    return true;
}

void taby_asset_store_free_file(uint8_t *data) {
    if (!data) {
        return;
    }
    heap_caps_free(data);
}
