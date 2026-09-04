#include "taby_identity.h"

#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "esp_check.h"
#include "esp_log.h"
#include "esp_mac.h"
#include "esp_partition.h"
#include "esp_rom_crc.h"
#include "nvs.h"
#include "nvs_flash.h"

static const char *TAG = "taby_identity";
static const char *TABY_IDENTITY_NAMESPACE = "taby_meta";
static const char *TABY_DEVICE_ID_KEY = "device_id";
static const char *TABY_CLAIMED_KEY = "claimed";
static const char *TABY_CLAIMED_BY_KEY = "claimed_by";
static const char *TABY_FACTORY_DATA_PARTITION = "factory_data";

#define TABY_FACTORY_MAGIC 0x59424154u
#define TABY_FACTORY_VERSION 1u

typedef struct __attribute__((packed)) {
    uint32_t magic;
    uint16_t version;
    uint16_t reserved0;
    char device_id[32];
    char device_secret[65];
    char hardware_revision[16];
    char manufacturing_batch[32];
    uint8_t reserved[64];
    uint32_t crc32;
} taby_factory_record_t;

static taby_identity_t s_identity = {0};
static bool s_identity_ready = false;

static void copy_string_field(char *destination, size_t destination_size, const char *source, size_t source_size) {
    if (!destination || destination_size == 0) {
        return;
    }

    destination[0] = '\0';
    if (!source || source_size == 0) {
        return;
    }

    size_t copy_len = 0;
    while (copy_len + 1 < destination_size && copy_len < source_size && source[copy_len] != '\0') {
        destination[copy_len] = source[copy_len];
        copy_len++;
    }
    destination[copy_len] = '\0';
}

static bool string_field_is_valid(const char *value, size_t value_size) {
    return value && memchr(value, '\0', value_size) != NULL && value[0] != '\0';
}

static esp_err_t taby_identity_ensure_nvs(void) {
    esp_err_t err = nvs_flash_init();
    if (err == ESP_ERR_NVS_NO_FREE_PAGES || err == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        err = nvs_flash_init();
    }
    return err;
}

static void build_device_id(char *out, size_t out_size) {
    uint8_t mac[6] = {0};
    esp_read_mac(mac, ESP_MAC_WIFI_STA);
    snprintf(out,
             out_size,
             "taby_%02x%02x%02x%02x%02x%02x",
             mac[0],
             mac[1],
             mac[2],
             mac[3],
             mac[4],
             mac[5]);
}

static esp_err_t load_factory_identity_from_partition(void) {
    const esp_partition_t *partition =
        esp_partition_find_first(ESP_PARTITION_TYPE_DATA, ESP_PARTITION_SUBTYPE_ANY, TABY_FACTORY_DATA_PARTITION);
    if (!partition) {
        return ESP_ERR_NOT_FOUND;
    }

    if (partition->size < sizeof(taby_factory_record_t)) {
        return ESP_ERR_INVALID_SIZE;
    }

    taby_factory_record_t record = {0};
    ESP_RETURN_ON_ERROR(esp_partition_read(partition, 0, &record, sizeof(record)), TAG, "factory data read failed");

    if (record.magic != TABY_FACTORY_MAGIC || record.version != TABY_FACTORY_VERSION) {
        return ESP_ERR_NOT_FOUND;
    }

    uint32_t expected_crc = esp_rom_crc32_le(0, (const uint8_t *)&record, offsetof(taby_factory_record_t, crc32));
    if (expected_crc != record.crc32) {
        return ESP_ERR_INVALID_CRC;
    }

    if (!string_field_is_valid(record.device_id, sizeof(record.device_id)) ||
        !string_field_is_valid(record.device_secret, sizeof(record.device_secret))) {
        return ESP_ERR_INVALID_RESPONSE;
    }

    copy_string_field(s_identity.device_id, sizeof(s_identity.device_id), record.device_id, sizeof(record.device_id));
    copy_string_field(
        s_identity.device_secret, sizeof(s_identity.device_secret), record.device_secret, sizeof(record.device_secret));
    s_identity.has_factory_data = true;
    return ESP_OK;
}

static esp_err_t load_mutable_identity_state_from_nvs(nvs_handle_t handle) {
    uint8_t claimed = 0;
    esp_err_t err = nvs_get_u8(handle, TABY_CLAIMED_KEY, &claimed);
    if (err == ESP_OK) {
        s_identity.claimed = claimed != 0;
    } else if (err == ESP_ERR_NVS_NOT_FOUND) {
        s_identity.claimed = false;
    } else {
        return err;
    }

    s_identity.claimed_by[0] = '\0';
    size_t claimed_by_size = sizeof(s_identity.claimed_by);
    err = nvs_get_str(handle, TABY_CLAIMED_BY_KEY, s_identity.claimed_by, &claimed_by_size);
    if (err != ESP_OK && err != ESP_ERR_NVS_NOT_FOUND) {
        return err;
    }

    return ESP_OK;
}

esp_err_t taby_identity_init(void) {
    if (s_identity_ready) {
        return ESP_OK;
    }

    ESP_RETURN_ON_ERROR(taby_identity_ensure_nvs(), TAG, "nvs init failed");

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(nvs_open(TABY_IDENTITY_NAMESPACE, NVS_READWRITE, &handle), TAG, "nvs open failed");

    memset(&s_identity, 0, sizeof(s_identity));

    esp_err_t factory_err = load_factory_identity_from_partition();
    if (factory_err != ESP_OK && factory_err != ESP_ERR_NOT_FOUND) {
        ESP_LOGW(TAG, "factory identity invalid, falling back to mutable identity: %s", esp_err_to_name(factory_err));
    }

    if (!s_identity.has_factory_data) {
        size_t id_size = sizeof(s_identity.device_id);
        esp_err_t err = nvs_get_str(handle, TABY_DEVICE_ID_KEY, s_identity.device_id, &id_size);
        if (err == ESP_ERR_NVS_NOT_FOUND) {
            build_device_id(s_identity.device_id, sizeof(s_identity.device_id));
            ESP_ERROR_CHECK(nvs_set_str(handle, TABY_DEVICE_ID_KEY, s_identity.device_id));
            ESP_ERROR_CHECK(nvs_commit(handle));
        } else if (err != ESP_OK) {
            nvs_close(handle);
            return err;
        }
    }

    ESP_RETURN_ON_ERROR(load_mutable_identity_state_from_nvs(handle), TAG, "load mutable identity state failed");

    nvs_close(handle);
    s_identity_ready = true;

    ESP_LOGI(TAG,
             "identity ready device_id=%s source=%s claimed=%d claimed_by=%s",
             s_identity.device_id,
             taby_identity_source_name(),
             s_identity.claimed ? 1 : 0,
             s_identity.claimed_by[0] ? s_identity.claimed_by : "<none>");

    return ESP_OK;
}

const taby_identity_t *taby_identity_get(void) {
    return s_identity_ready ? &s_identity : NULL;
}

const char *taby_identity_source_name(void) {
    return s_identity.has_factory_data ? "factory_data" : "mac_fallback";
}

esp_err_t taby_identity_set_claim(const char *claimed_by) {
    ESP_RETURN_ON_ERROR(taby_identity_init(), TAG, "identity init failed");

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(nvs_open(TABY_IDENTITY_NAMESPACE, NVS_READWRITE, &handle), TAG, "nvs open failed");

    s_identity.claimed = true;
    snprintf(s_identity.claimed_by, sizeof(s_identity.claimed_by), "%s", claimed_by ? claimed_by : "claimed");

    ESP_ERROR_CHECK(nvs_set_u8(handle, TABY_CLAIMED_KEY, 1));
    ESP_ERROR_CHECK(nvs_set_str(handle, TABY_CLAIMED_BY_KEY, s_identity.claimed_by));
    ESP_ERROR_CHECK(nvs_commit(handle));
    nvs_close(handle);
    return ESP_OK;
}

esp_err_t taby_identity_clear_claim(void) {
    ESP_RETURN_ON_ERROR(taby_identity_init(), TAG, "identity init failed");

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(nvs_open(TABY_IDENTITY_NAMESPACE, NVS_READWRITE, &handle), TAG, "nvs open failed");

    s_identity.claimed = false;
    s_identity.claimed_by[0] = '\0';

    ESP_ERROR_CHECK(nvs_set_u8(handle, TABY_CLAIMED_KEY, 0));
    esp_err_t erase_err = nvs_erase_key(handle, TABY_CLAIMED_BY_KEY);
    if (erase_err != ESP_OK && erase_err != ESP_ERR_NVS_NOT_FOUND) {
        nvs_close(handle);
        return erase_err;
    }
    ESP_ERROR_CHECK(nvs_commit(handle));
    nvs_close(handle);
    return ESP_OK;
}
