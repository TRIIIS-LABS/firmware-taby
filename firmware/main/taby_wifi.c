#include "taby_wifi.h"

#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "esp_check.h"
#include "esp_event.h"
#include "esp_log.h"
#include "esp_netif.h"
#include "esp_timer.h"
#include "esp_wifi.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "lwip/inet.h"
#include "mdns.h"
#include "nvs.h"
#include "taby_http_server.h"
#include "taby_mqtt.h"
#include "taby_onboarding.h"
#include "taby_transport_prefs.h"

static const char *TAG = "taby_wifi";
static const char *TABY_WIFI_NAMESPACE = "taby_wifi";
static const char *TABY_WIFI_LAST_SUCCESS_SSID_KEY = "last_ssid";
static const char *TABY_WIFI_SETUP_HOST = "192.168.4.1";
#define TABY_WIFI_SCAN_CACHE_MAX 16
static const uint8_t TABY_WIFI_ONBOARDING_AUTH_RETRY_LIMIT = 4;
static const int64_t TABY_WIFI_SCAN_CACHE_TTL_US = 15 * 1000 * 1000;

typedef struct {
    bool initialized;
    bool driver_started;
    bool connected;
    bool provisioned;
    bool mdns_started;
    bool mdns_retry_pending;
    taby_wifi_mode_t mode;
    char ip_address[16];
    char station_ssid[33];
    char ap_ssid[33];
    char ap_password[17];
    char mdns_hostname[32];
    char last_error[48];
} taby_wifi_status_t;

static taby_wifi_status_t s_status = {0};
static esp_netif_t *s_wifi_ap_netif = NULL;
static esp_netif_t *s_wifi_sta_netif = NULL;
static taby_wifi_profile_t s_profiles[TABY_WIFI_MAX_PROFILES] = {0};
static size_t s_profile_count = 0;
static taby_wifi_nearby_network_t s_nearby_cache[TABY_WIFI_SCAN_CACHE_MAX] = {0};
static size_t s_nearby_cache_count = 0;
static int64_t s_nearby_cache_at_us = 0;
static bool s_station_join_via_setup_ap = false;
static bool s_finalize_station_task_pending = false;
static bool s_station_connected_task_pending = false;
static uint8_t s_onboarding_auth_retry_count = 0;

static esp_err_t start_setup_ap(const taby_identity_t *identity);
static esp_err_t load_profiles_from_nvs(void);
static esp_err_t store_last_success_ssid(const char *ssid);
static bool onboarding_wifi_in_progress(void);
static void start_mdns_if_needed(void);
static void schedule_mdns_retry(void);

static void build_mdns_hostname(const taby_identity_t *identity, char *out, size_t out_size) {
    if (!out || out_size == 0) {
        return;
    }

    out[0] = '\0';
    if (!identity || identity->device_id[0] == '\0') {
        snprintf(out, out_size, "taby");
        return;
    }

    const char *device_id = identity->device_id;
    size_t device_id_len = strlen(device_id);
    const char *suffix = device_id_len > 6 ? device_id + (device_id_len - 6) : device_id;
    snprintf(out, out_size, "taby-%.6s", suffix);
}

static void ensure_wifi_network_services_started(void) {
    esp_err_t http_err = taby_http_server_start();
    if (http_err != ESP_OK) {
        ESP_LOGW(TAG, "http server start skipped: %s", esp_err_to_name(http_err));
    }
}

static void finalize_station_mode_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(10000));

    if (s_status.connected &&
        s_status.mode == TABY_WIFI_MODE_SETUP_AP &&
        taby_transport_onboarding_complete() &&
        taby_transport_preferred_mode() == TABY_TRANSPORT_PREF_WIFI) {
        esp_err_t err = esp_wifi_set_mode(WIFI_MODE_STA);
        if (err == ESP_OK) {
            s_status.mode = TABY_WIFI_MODE_STATION;
            ESP_LOGI(TAG, "setup AP stopped after successful onboarding");
        } else {
            ESP_LOGW(TAG, "failed to stop setup AP after onboarding: %s", esp_err_to_name(err));
        }
    }

    s_finalize_station_task_pending = false;
    vTaskDelete(NULL);
}

static void station_connected_task(void *arg) {
    (void)arg;

    store_last_success_ssid(s_status.station_ssid);
    load_profiles_from_nvs();

    if (onboarding_wifi_in_progress()) {
        taby_onboarding_notify_wifi_provisioned();
        if (s_status.mode == TABY_WIFI_MODE_SETUP_AP && !s_finalize_station_task_pending) {
            s_finalize_station_task_pending = true;
            if (xTaskCreate(finalize_station_mode_task, "taby_wifi_finalize", 3072, NULL, 4, NULL) != pdPASS) {
                s_finalize_station_task_pending = false;
                ESP_LOGW(TAG, "failed to schedule setup AP finalize task");
            }
        }
    }

    start_mdns_if_needed();
    s_station_connected_task_pending = false;
    vTaskDelete(NULL);
}

static void mdns_retry_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(2000));
    s_status.mdns_retry_pending = false;
    start_mdns_if_needed();
    vTaskDelete(NULL);
}

static void copy_string_field(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0) {
        return;
    }

    if (!source) {
        destination[0] = '\0';
        return;
    }

    size_t copy_len = 0;
    while (copy_len + 1 < destination_size && source[copy_len] != '\0') {
        destination[copy_len] = source[copy_len];
        copy_len++;
    }
    destination[copy_len] = '\0';
}

static void set_last_error(const char *error) {
    copy_string_field(s_status.last_error, sizeof(s_status.last_error), error);
}

static void clear_last_error(void) {
    s_status.last_error[0] = '\0';
}

static esp_err_t taby_wifi_nvs_open(nvs_open_mode_t mode, nvs_handle_t *out_handle) {
    return nvs_open(TABY_WIFI_NAMESPACE, mode, out_handle);
}

static void make_profile_key(char *buffer, size_t buffer_size, size_t slot, const char *suffix) {
    snprintf(buffer, buffer_size, "p%u_%s", (unsigned)slot, suffix);
}

static void clear_profiles_cache(void) {
    memset(s_profiles, 0, sizeof(s_profiles));
    s_profile_count = 0;
}

static esp_err_t nvs_get_string_or_empty(nvs_handle_t handle,
                                         const char *key,
                                         char *buffer,
                                         size_t buffer_size) {
    if (!buffer || buffer_size == 0) {
        return ESP_ERR_INVALID_ARG;
    }

    buffer[0] = '\0';
    size_t value_size = buffer_size;
    esp_err_t err = nvs_get_str(handle, key, buffer, &value_size);
    if (err == ESP_ERR_NVS_NOT_FOUND) {
        return ESP_OK;
    }
    return err;
}

static esp_err_t load_profiles_from_nvs(void) {
    clear_profiles_cache();

    nvs_handle_t handle;
    esp_err_t open_err = taby_wifi_nvs_open(NVS_READONLY, &handle);
    if (open_err == ESP_ERR_NVS_NOT_FOUND) {
        return ESP_OK;
    }
    if (open_err != ESP_OK) {
        return open_err;
    }

    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        taby_wifi_profile_t *profile = &s_profiles[slot];
        char key[16];

        make_profile_key(key, sizeof(key), slot, "ssid");
        ESP_ERROR_CHECK_WITHOUT_ABORT(nvs_get_string_or_empty(handle, key, profile->ssid, sizeof(profile->ssid)));
        make_profile_key(key, sizeof(key), slot, "pwd");
        ESP_ERROR_CHECK_WITHOUT_ABORT(nvs_get_string_or_empty(handle, key, profile->password, sizeof(profile->password)));
        make_profile_key(key, sizeof(key), slot, "lbl");
        ESP_ERROR_CHECK_WITHOUT_ABORT(nvs_get_string_or_empty(handle, key, profile->label, sizeof(profile->label)));

        if (profile->ssid[0] == '\0' || profile->password[0] == '\0') {
            memset(profile, 0, sizeof(*profile));
            continue;
        }

        uint8_t priority = 0;
        make_profile_key(key, sizeof(key), slot, "pri");
        if (nvs_get_u8(handle, key, &priority) != ESP_OK) {
            priority = (uint8_t)(TABY_WIFI_MAX_PROFILES - slot);
        }

        uint8_t auto_join = 1;
        make_profile_key(key, sizeof(key), slot, "auto");
        if (nvs_get_u8(handle, key, &auto_join) != ESP_OK) {
            auto_join = 1;
        }

        profile->occupied = true;
        profile->priority = priority;
        profile->auto_join = auto_join != 0;
        if (profile->label[0] == '\0') {
            copy_string_field(profile->label, sizeof(profile->label), profile->ssid);
        }
        s_profile_count++;
    }

    char last_success_ssid[33] = {0};
    if (nvs_get_string_or_empty(handle,
                                TABY_WIFI_LAST_SUCCESS_SSID_KEY,
                                last_success_ssid,
                                sizeof(last_success_ssid)) == ESP_OK &&
        last_success_ssid[0] != '\0') {
        for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
            if (s_profiles[slot].occupied && strcmp(s_profiles[slot].ssid, last_success_ssid) == 0) {
                s_profiles[slot].last_success = true;
                break;
            }
        }
    }

    int preferred_index = -1;
    uint8_t preferred_priority = 0;
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (!s_profiles[slot].occupied) {
            continue;
        }
        if (preferred_index < 0 || s_profiles[slot].priority > preferred_priority) {
            preferred_index = (int)slot;
            preferred_priority = s_profiles[slot].priority;
        }
    }
    if (preferred_index >= 0) {
        s_profiles[preferred_index].preferred = true;
    }

    nvs_close(handle);
    return ESP_OK;
}

static esp_err_t save_profile_slot(nvs_handle_t handle, size_t slot, const taby_wifi_profile_t *profile) {
    char key[16];

    make_profile_key(key, sizeof(key), slot, "ssid");
    ESP_RETURN_ON_ERROR(nvs_set_str(handle, key, profile->ssid), TAG, "save ssid failed");
    make_profile_key(key, sizeof(key), slot, "pwd");
    ESP_RETURN_ON_ERROR(nvs_set_str(handle, key, profile->password), TAG, "save password failed");
    make_profile_key(key, sizeof(key), slot, "lbl");
    ESP_RETURN_ON_ERROR(nvs_set_str(handle, key, profile->label), TAG, "save label failed");
    make_profile_key(key, sizeof(key), slot, "pri");
    ESP_RETURN_ON_ERROR(nvs_set_u8(handle, key, profile->priority), TAG, "save priority failed");
    make_profile_key(key, sizeof(key), slot, "auto");
    ESP_RETURN_ON_ERROR(nvs_set_u8(handle, key, profile->auto_join ? 1 : 0), TAG, "save auto flag failed");
    return ESP_OK;
}

static void erase_profile_slot(nvs_handle_t handle, size_t slot) {
    char key[16];
    const char *suffixes[] = {"ssid", "pwd", "lbl", "pri", "auto"};
    for (size_t i = 0; i < sizeof(suffixes) / sizeof(suffixes[0]); ++i) {
        make_profile_key(key, sizeof(key), slot, suffixes[i]);
        nvs_erase_key(handle, key);
    }
}

static int find_profile_index_by_ssid(const char *ssid) {
    if (!ssid || ssid[0] == '\0') {
        return -1;
    }

    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (s_profiles[slot].occupied && strcmp(s_profiles[slot].ssid, ssid) == 0) {
            return (int)slot;
        }
    }

    return -1;
}

static int find_empty_profile_slot(void) {
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (!s_profiles[slot].occupied) {
            return (int)slot;
        }
    }
    return -1;
}

static int preferred_profile_index(void) {
    int preferred_index = -1;
    uint8_t best_priority = 0;
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (!s_profiles[slot].occupied) {
            continue;
        }
        if (preferred_index < 0 || s_profiles[slot].priority > best_priority) {
            preferred_index = (int)slot;
            best_priority = s_profiles[slot].priority;
        }
    }
    return preferred_index;
}

static int preferred_auto_join_profile_index(void) {
    int preferred_index = -1;
    uint8_t best_priority = 0;
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (!s_profiles[slot].occupied || !s_profiles[slot].auto_join) {
            continue;
        }
        if (preferred_index < 0 || s_profiles[slot].priority > best_priority) {
            preferred_index = (int)slot;
            best_priority = s_profiles[slot].priority;
        }
    }
    return preferred_index;
}

static int select_boot_profile_index(void) {
    int preferred_index = preferred_auto_join_profile_index();
    if (preferred_index >= 0) {
        ESP_LOGI(TAG,
                 "selected preferred wifi profile ssid=%s priority=%u",
                 s_profiles[preferred_index].ssid,
                 (unsigned)s_profiles[preferred_index].priority);
        return preferred_index;
    }

    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        if (s_profiles[slot].occupied && s_profiles[slot].last_success && s_profiles[slot].auto_join) {
            ESP_LOGI(TAG, "selected last successful wifi profile ssid=%s", s_profiles[slot].ssid);
            return (int)slot;
        }
    }

    ESP_LOGW(TAG, "no auto-join wifi profile available");
    return -1;
}

static esp_err_t store_last_success_ssid(const char *ssid) {
    if (!ssid || ssid[0] == '\0') {
        return ESP_ERR_INVALID_ARG;
    }

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(taby_wifi_nvs_open(NVS_READWRITE, &handle), TAG, "nvs open failed");
    ESP_RETURN_ON_ERROR(nvs_set_str(handle, TABY_WIFI_LAST_SUCCESS_SSID_KEY, ssid), TAG, "save last success failed");
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit last success failed");
    nvs_close(handle);
    return ESP_OK;
}

static void build_setup_ap_credentials(const taby_identity_t *identity) {
    const char *device_id = identity ? identity->device_id : "taby_unknown";
    size_t len = strlen(device_id);
    const char *suffix = len > 6 ? device_id + (len - 6) : device_id;

    snprintf(s_status.ap_ssid, sizeof(s_status.ap_ssid), "taby-%s", suffix);
    snprintf(s_status.ap_password, sizeof(s_status.ap_password), "taby%s", suffix);
}

static const char *disconnect_reason_label(wifi_err_reason_t reason) {
    switch (reason) {
        case WIFI_REASON_AUTH_FAIL:
        case WIFI_REASON_AUTH_EXPIRE:
        case WIFI_REASON_HANDSHAKE_TIMEOUT:
        case WIFI_REASON_CONNECTION_FAIL:
            return "Wrong password";
        case WIFI_REASON_NO_AP_FOUND:
        case WIFI_REASON_NO_AP_FOUND_W_COMPATIBLE_SECURITY:
        case WIFI_REASON_NO_AP_FOUND_IN_AUTHMODE_THRESHOLD:
        case WIFI_REASON_NO_AP_FOUND_IN_RSSI_THRESHOLD:
            return "Wi-Fi not found";
        default:
            return "Could not connect";
    }
}

static bool should_retry_onboarding_disconnect(wifi_err_reason_t reason) {
    switch (reason) {
        case WIFI_REASON_AUTH_FAIL:
        case WIFI_REASON_AUTH_EXPIRE:
        case WIFI_REASON_HANDSHAKE_TIMEOUT:
        case WIFI_REASON_CONNECTION_FAIL:
            return true;
        default:
            return false;
    }
}

static bool onboarding_wifi_in_progress(void) {
    return !taby_transport_onboarding_complete() &&
           taby_transport_preferred_mode() == TABY_TRANSPORT_PREF_WIFI;
}

static void schedule_mdns_retry(void) {
    if (s_status.mdns_retry_pending || !s_status.connected) {
        return;
    }

    s_status.mdns_retry_pending = true;
    if (xTaskCreate(mdns_retry_task, "taby_mdns_retry", 3072, NULL, 3, NULL) != pdPASS) {
        s_status.mdns_retry_pending = false;
        ESP_LOGW(TAG, "failed to schedule mDNS retry");
    }
}

static void start_mdns_if_needed(void) {
    if (s_status.mdns_started || !s_status.connected) {
        return;
    }

    esp_err_t err = mdns_init();
    if (err == ESP_ERR_INVALID_STATE) {
        mdns_free();
        err = mdns_init();
    }
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "mDNS init failed: %s", esp_err_to_name(err));
        schedule_mdns_retry();
        return;
    }

    const char *hostname = s_status.mdns_hostname[0] ? s_status.mdns_hostname : "taby";
    err = mdns_hostname_set(hostname);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "mDNS hostname set failed: %s", esp_err_to_name(err));
        mdns_free();
        schedule_mdns_retry();
        return;
    }

    char instance_name[48];
    if (s_status.mdns_hostname[0] != '\0' && strcmp(s_status.mdns_hostname, "taby") != 0) {
        snprintf(instance_name, sizeof(instance_name), "Taby %.6s", s_status.mdns_hostname + 5);
    } else {
        snprintf(instance_name, sizeof(instance_name), "Taby Device");
    }
    err = mdns_instance_name_set(instance_name);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "mDNS instance name set failed: %s", esp_err_to_name(err));
        mdns_free();
        schedule_mdns_retry();
        return;
    }

    err = mdns_service_add(NULL, "_http", "_tcp", 80, NULL, 0);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "mDNS service add failed: %s", esp_err_to_name(err));
        mdns_free();
        schedule_mdns_retry();
        return;
    }

    s_status.mdns_started = true;
    ESP_LOGI(TAG, "mDNS ready at %s.local", hostname);
}

static void wifi_event_handler(void *arg, esp_event_base_t event_base, int32_t event_id, void *event_data) {
    (void)arg;

    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED) {
        wifi_event_sta_disconnected_t *event = (wifi_event_sta_disconnected_t *)event_data;
        s_status.connected = false;
        s_status.ip_address[0] = '\0';
        if (s_status.mode == TABY_WIFI_MODE_STATION && s_status.station_ssid[0] != '\0') {
            if (onboarding_wifi_in_progress()) {
                set_last_error(disconnect_reason_label((wifi_err_reason_t)event->reason));
                ESP_LOGW(TAG,
                         "wifi onboarding failed, returning to setup AP ssid=%s reason=%d",
                         s_status.station_ssid,
                         (int)event->reason);
                if (start_setup_ap(taby_identity_get()) == ESP_OK) {
                    taby_onboarding_show_wifi_setup();
                    return;
                }
                ESP_LOGW(TAG, "failed to restart setup AP after onboarding failure");
            }
            ESP_LOGW(TAG, "wifi disconnected, reconnecting");
            esp_wifi_connect();
            return;
        }

        if (s_status.mode == TABY_WIFI_MODE_SETUP_AP && onboarding_wifi_in_progress() && s_station_join_via_setup_ap) {
            wifi_err_reason_t reason = (wifi_err_reason_t)event->reason;
            if (should_retry_onboarding_disconnect(reason) &&
                s_onboarding_auth_retry_count < TABY_WIFI_ONBOARDING_AUTH_RETRY_LIMIT) {
                s_onboarding_auth_retry_count++;
                clear_last_error();
                ESP_LOGW(TAG,
                         "wifi onboarding auth retry %u/%u after reason=%d",
                         (unsigned)s_onboarding_auth_retry_count,
                         (unsigned)TABY_WIFI_ONBOARDING_AUTH_RETRY_LIMIT,
                         (int)reason);
                ESP_ERROR_CHECK_WITHOUT_ABORT(esp_wifi_connect());
                return;
            }

            s_onboarding_auth_retry_count = 0;
            set_last_error(disconnect_reason_label(reason));
            s_station_join_via_setup_ap = false;
            ESP_LOGW(TAG,
                     "wifi onboarding failed while setup AP stayed alive, reason=%d",
                     (int)event->reason);
            ESP_ERROR_CHECK_WITHOUT_ABORT(esp_wifi_disconnect());
            ESP_ERROR_CHECK_WITHOUT_ABORT(esp_wifi_set_mode(WIFI_MODE_AP));
            s_status.driver_started = true;
            s_status.mode = TABY_WIFI_MODE_SETUP_AP;
            s_status.connected = false;
            s_status.ip_address[0] = '\0';
            taby_onboarding_show_wifi_setup();
        }
        return;
    }

    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_AP_START) {
        ESP_LOGI(TAG,
                 "setup AP ready ssid=%s password=%s url=http://%s",
                 s_status.ap_ssid,
                 s_status.ap_password,
                 TABY_WIFI_SETUP_HOST);
        return;
    }

    if (event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP) {
        ip_event_got_ip_t *event = (ip_event_got_ip_t *)event_data;
        s_status.connected = true;
        snprintf(s_status.ip_address,
                 sizeof(s_status.ip_address),
                 IPSTR,
                 IP2STR(&event->ip_info.ip));
        clear_last_error();
        ESP_LOGI(TAG, "wifi connected ip=%s ssid=%s", s_status.ip_address, s_status.station_ssid);
        s_station_join_via_setup_ap = false;
        s_onboarding_auth_retry_count = 0;
        ensure_wifi_network_services_started();
        esp_err_t mqtt_err = taby_mqtt_init(taby_identity_get());
        if (mqtt_err != ESP_OK) {
            ESP_LOGW(TAG, "mqtt init skipped: %s", esp_err_to_name(mqtt_err));
        }
        if (!s_station_connected_task_pending) {
            s_station_connected_task_pending = true;
            if (xTaskCreate(station_connected_task, "taby_wifi_connected", 4096, NULL, 4, NULL) != pdPASS) {
                s_station_connected_task_pending = false;
                ESP_LOGW(TAG, "failed to schedule station connected task");
            }
        }
    }
}

static esp_err_t ensure_network_stack(void) {
    esp_err_t err = esp_netif_init();
    if (err != ESP_OK && err != ESP_ERR_INVALID_STATE) {
        return err;
    }

    err = esp_event_loop_create_default();
    if (err != ESP_OK && err != ESP_ERR_INVALID_STATE) {
        return err;
    }

    return ESP_OK;
}

static esp_err_t ensure_wifi_driver(void) {
    if (s_status.initialized) {
        return ESP_OK;
    }

    ESP_RETURN_ON_ERROR(ensure_network_stack(), TAG, "network stack init failed");

    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_RETURN_ON_ERROR(esp_wifi_init(&cfg), TAG, "esp_wifi_init failed");
    ESP_RETURN_ON_ERROR(esp_event_handler_register(WIFI_EVENT, ESP_EVENT_ANY_ID, wifi_event_handler, NULL),
                        TAG,
                        "register wifi event failed");
    ESP_RETURN_ON_ERROR(esp_event_handler_register(IP_EVENT, IP_EVENT_STA_GOT_IP, wifi_event_handler, NULL),
                        TAG,
                        "register ip event failed");
    ESP_RETURN_ON_ERROR(esp_wifi_set_storage(WIFI_STORAGE_RAM), TAG, "set wifi storage failed");

    s_status.initialized = true;
    return ESP_OK;
}

static esp_err_t stop_wifi_if_running(void) {
    if (s_status.driver_started) {
        esp_wifi_stop();
        s_status.driver_started = false;
    }
    return ESP_OK;
}

static esp_err_t start_setup_ap(const taby_identity_t *identity) {
    ESP_RETURN_ON_ERROR(ensure_wifi_driver(), TAG, "wifi driver init failed");
    build_setup_ap_credentials(identity);

    if (!s_wifi_ap_netif) {
        s_wifi_ap_netif = esp_netif_create_default_wifi_ap();
    }

    wifi_config_t ap_config = {0};
    copy_string_field((char *)ap_config.ap.ssid, sizeof(ap_config.ap.ssid), s_status.ap_ssid);
    copy_string_field((char *)ap_config.ap.password, sizeof(ap_config.ap.password), s_status.ap_password);
    ap_config.ap.ssid_len = strlen(s_status.ap_ssid);
    ap_config.ap.channel = 1;
    ap_config.ap.max_connection = 4;
    ap_config.ap.authmode = WIFI_AUTH_WPA_WPA2_PSK;

    s_status.station_ssid[0] = '\0';
    s_station_join_via_setup_ap = false;
    s_onboarding_auth_retry_count = 0;
    ESP_RETURN_ON_ERROR(stop_wifi_if_running(), TAG, "stop wifi before ap failed");
    /* Keep first-run setup in AP-only mode. Creating the temporary setup
       network in APSTA before the STA netif is actively in use can leave the
       station side in a bad state and crash as soon as the real Wi-Fi join
       starts receiving traffic. We only switch to APSTA at the moment we
       actually begin connecting to the saved Wi-Fi profile. */
    ESP_RETURN_ON_ERROR(esp_wifi_set_mode(WIFI_MODE_AP), TAG, "set ap mode failed");
    ESP_RETURN_ON_ERROR(esp_wifi_set_config(WIFI_IF_AP, &ap_config), TAG, "set ap config failed");
    ESP_RETURN_ON_ERROR(esp_wifi_start(), TAG, "start ap failed");
    s_status.driver_started = true;
    ensure_wifi_network_services_started();

    s_status.connected = false;
    s_status.provisioned = s_profile_count > 0;
    s_status.mode = TABY_WIFI_MODE_SETUP_AP;
    s_status.ip_address[0] = '\0';
    s_status.station_ssid[0] = '\0';
    return ESP_OK;
}

static void set_wifi_idle_state(const taby_identity_t *identity, bool has_saved_profiles) {
    build_setup_ap_credentials(identity);
    s_status.connected = false;
    s_status.provisioned = has_saved_profiles;
    s_status.mode = TABY_WIFI_MODE_NONE;
    s_status.ip_address[0] = '\0';
    s_status.station_ssid[0] = '\0';
}

static esp_err_t start_station_from_profile_index(int profile_index, bool keep_setup_ap_alive) {
    ESP_RETURN_ON_ERROR(ensure_wifi_driver(), TAG, "wifi driver init failed");

    if (!s_wifi_sta_netif) {
        s_wifi_sta_netif = esp_netif_create_default_wifi_sta();
    }

    if (profile_index < 0 || profile_index >= TABY_WIFI_MAX_PROFILES || !s_profiles[profile_index].occupied) {
        return ESP_ERR_INVALID_ARG;
    }

    const taby_wifi_profile_t *profile = &s_profiles[profile_index];
    wifi_config_t station_config = {0};
    s_onboarding_auth_retry_count = 0;
    copy_string_field(s_status.station_ssid, sizeof(s_status.station_ssid), profile->ssid);
    copy_string_field((char *)station_config.sta.ssid, sizeof(station_config.sta.ssid), profile->ssid);
    copy_string_field((char *)station_config.sta.password, sizeof(station_config.sta.password), profile->password);

    if (keep_setup_ap_alive) {
        if (s_status.driver_started) {
            /* A previous AP+STA attempt can still be winding down when the
               user retries quickly after a bad password. Disconnect first so
               stale auth-failure events do not leak into the new attempt. */
            s_station_join_via_setup_ap = false;
            esp_err_t disconnect_err = esp_wifi_disconnect();
            if (disconnect_err != ESP_OK &&
                disconnect_err != ESP_FAIL &&
                disconnect_err != ESP_ERR_WIFI_NOT_STARTED) {
                ESP_LOGW(TAG,
                         "pre-connect disconnect returned %s",
                         esp_err_to_name(disconnect_err));
            }
            vTaskDelay(pdMS_TO_TICKS(120));
        }
        ESP_RETURN_ON_ERROR(esp_wifi_set_mode(WIFI_MODE_APSTA), TAG, "keep apsta mode failed");
        ESP_RETURN_ON_ERROR(esp_wifi_set_config(WIFI_IF_STA, &station_config), TAG, "set sta config failed");
        if (!s_status.driver_started) {
            ESP_RETURN_ON_ERROR(esp_wifi_start(), TAG, "start apsta failed");
            s_status.driver_started = true;
        }
        s_station_join_via_setup_ap = true;
        ESP_RETURN_ON_ERROR(esp_wifi_connect(), TAG, "connect sta failed");
        s_status.mode = TABY_WIFI_MODE_SETUP_AP;
    } else {
        ESP_RETURN_ON_ERROR(stop_wifi_if_running(), TAG, "stop wifi before station failed");
        ESP_RETURN_ON_ERROR(esp_wifi_set_mode(WIFI_MODE_STA), TAG, "set sta mode failed");
        ESP_RETURN_ON_ERROR(esp_wifi_set_config(WIFI_IF_STA, &station_config), TAG, "set sta config failed");
        s_status.mode = TABY_WIFI_MODE_STATION;
        ESP_RETURN_ON_ERROR(esp_wifi_start(), TAG, "start sta failed");
        s_status.driver_started = true;
        s_station_join_via_setup_ap = false;
        /* Trigger the first connect explicitly here. Relying on
           WIFI_EVENT_STA_START caused the direct boot path to race with our
           local state update, and calling esp_wifi_connect() from both the
           event callback and here could fail the saved-Wi-Fi boot path
           synchronously and bounce the board back into setup AP. */
        ESP_RETURN_ON_ERROR(esp_wifi_connect(), TAG, "connect sta failed");
    }

    s_status.provisioned = true;
    s_status.connected = false;
    s_status.ip_address[0] = '\0';
    clear_last_error();
    return ESP_OK;
}

static esp_err_t start_station_from_saved_credentials(bool keep_setup_ap_alive) {
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load wifi profiles failed");
    int profile_index = select_boot_profile_index();
    if (profile_index < 0) {
        return ESP_ERR_NOT_FOUND;
    }

    return start_station_from_profile_index(profile_index, keep_setup_ap_alive);
}

esp_err_t taby_wifi_init(const taby_identity_t *identity) {
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load wifi profiles failed");
    build_mdns_hostname(identity ? identity : taby_identity_get(),
                        s_status.mdns_hostname,
                        sizeof(s_status.mdns_hostname));
    bool has_saved_profiles = s_profile_count > 0;
    bool onboarding_complete = taby_transport_onboarding_complete();
    taby_transport_pref_t preferred_mode = taby_transport_preferred_mode();

    if (!onboarding_complete) {
        if (preferred_mode == TABY_TRANSPORT_PREF_WIFI) {
            if (!has_saved_profiles) {
                return start_setup_ap(identity);
            }

            esp_err_t station_err = start_station_from_saved_credentials(true);
            if (station_err == ESP_OK) {
                return ESP_OK;
            }

            ESP_LOGW(TAG,
                     "pending wifi onboarding failed to start station, falling back to setup AP: %s",
                     esp_err_to_name(station_err));
            set_last_error("Could not connect");
            return start_setup_ap(identity);
        }
        set_wifi_idle_state(identity, has_saved_profiles);
        return ESP_OK;
    }

    if (preferred_mode != TABY_TRANSPORT_PREF_WIFI) {
        set_wifi_idle_state(identity, has_saved_profiles);
        return ESP_OK;
    }

    if (!has_saved_profiles) {
        return start_setup_ap(identity);
    }

    esp_err_t station_err = start_station_from_saved_credentials(false);
    if (station_err == ESP_OK) {
        return ESP_OK;
    }

    ESP_LOGW(TAG, "saved wifi start failed, falling back to setup AP: %s", esp_err_to_name(station_err));
    return start_setup_ap(identity);
}

bool taby_wifi_is_provisioned(void) {
    return s_status.provisioned;
}

bool taby_wifi_is_connected(void) {
    return s_status.connected;
}

taby_wifi_mode_t taby_wifi_mode(void) {
    return s_status.mode;
}

const char *taby_wifi_mode_name(void) {
    switch (s_status.mode) {
        case TABY_WIFI_MODE_SETUP_AP:
            return "setup_ap";
        case TABY_WIFI_MODE_STATION:
            return "station";
        case TABY_WIFI_MODE_NONE:
        default:
            return "none";
    }
}

const char *taby_wifi_ip_address(void) {
    return s_status.ip_address[0] ? s_status.ip_address : NULL;
}

const char *taby_wifi_ap_ssid(void) {
    return s_status.ap_ssid[0] ? s_status.ap_ssid : NULL;
}

const char *taby_wifi_ap_password(void) {
    return s_status.ap_password[0] ? s_status.ap_password : NULL;
}

const char *taby_wifi_station_ssid(void) {
    return s_status.station_ssid[0] ? s_status.station_ssid : NULL;
}

const char *taby_wifi_mdns_hostname(void) {
    return s_status.mdns_hostname[0] ? s_status.mdns_hostname : NULL;
}

const char *taby_wifi_last_error(void) {
    return s_status.last_error[0] ? s_status.last_error : NULL;
}

esp_err_t taby_wifi_store_credentials(const char *ssid, const char *password) {
    if (!ssid || ssid[0] == '\0' || !password) {
        return ESP_ERR_INVALID_ARG;
    }

    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load profiles failed");

    int slot = find_profile_index_by_ssid(ssid);
    if (slot < 0) {
        slot = find_empty_profile_slot();
    }
    if (slot < 0) {
        return ESP_ERR_NO_MEM;
    }

    int current_preferred = preferred_profile_index();
    uint8_t next_priority = 1;
    if (current_preferred >= 0 && s_profiles[current_preferred].priority > 0) {
        next_priority = (uint8_t)(s_profiles[current_preferred].priority + 1);
    }

    taby_wifi_profile_t profile = {0};
    profile.occupied = true;
    copy_string_field(profile.ssid, sizeof(profile.ssid), ssid);
    copy_string_field(profile.password, sizeof(profile.password), password);
    copy_string_field(profile.label, sizeof(profile.label), ssid);
    profile.priority = next_priority;
    profile.auto_join = true;

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(taby_wifi_nvs_open(NVS_READWRITE, &handle), TAG, "nvs open failed");
    ESP_RETURN_ON_ERROR(save_profile_slot(handle, (size_t)slot, &profile), TAG, "save profile failed");
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit profile failed");
    nvs_close(handle);
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "reload profiles failed");
    s_status.provisioned = true;
    clear_last_error();
    return ESP_OK;
}

esp_err_t taby_wifi_connect_saved_networks(void) {
    esp_err_t err = start_station_from_saved_credentials(onboarding_wifi_in_progress());
    if (err != ESP_OK) {
        set_last_error("Could not connect");
        if (onboarding_wifi_in_progress()) {
            ESP_LOGW(TAG,
                     "saved wifi join failed to start, returning to setup AP: %s",
                     esp_err_to_name(err));
            return start_setup_ap(taby_identity_get());
        }
    }
    return err;
}

esp_err_t taby_wifi_shutdown(void) {
    if (s_status.mdns_started) {
        mdns_free();
        s_status.mdns_started = false;
    }
    s_status.mdns_retry_pending = false;

    taby_mqtt_shutdown();
    taby_http_server_stop();

    s_station_join_via_setup_ap = false;
    s_onboarding_auth_retry_count = 0;

    if (s_status.driver_started) {
        esp_err_t disconnect_err = esp_wifi_disconnect();
        if (disconnect_err != ESP_OK &&
            disconnect_err != ESP_FAIL &&
            disconnect_err != ESP_ERR_WIFI_NOT_STARTED) {
            ESP_LOGW(TAG, "wifi disconnect before shutdown returned %s", esp_err_to_name(disconnect_err));
        }
        ESP_RETURN_ON_ERROR(stop_wifi_if_running(), TAG, "stop wifi during shutdown failed");
    }

    s_status.connected = false;
    s_status.mode = TABY_WIFI_MODE_NONE;
    s_status.ip_address[0] = '\0';
    s_status.station_ssid[0] = '\0';
    clear_last_error();
    s_status.provisioned = s_profile_count > 0;
    ESP_LOGI(TAG, "wifi transport shut down");
    return ESP_OK;
}

esp_err_t taby_wifi_clear_credentials(void) {
    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(taby_wifi_nvs_open(NVS_READWRITE, &handle), TAG, "nvs open failed");
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES; ++slot) {
        erase_profile_slot(handle, slot);
    }
    nvs_erase_key(handle, TABY_WIFI_LAST_SUCCESS_SSID_KEY);
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit clear credentials failed");
    nvs_close(handle);
    clear_profiles_cache();
    clear_last_error();
    s_status.provisioned = false;
    return ESP_OK;
}

esp_err_t taby_wifi_start_setup_mode(const taby_identity_t *identity) {
    return start_setup_ap(identity ? identity : taby_identity_get());
}

esp_err_t taby_wifi_get_setup_info(taby_wifi_setup_info_t *out_info) {
    if (!out_info) {
        return ESP_ERR_INVALID_ARG;
    }

    if (s_status.ap_ssid[0] == '\0' || s_status.ap_password[0] == '\0') {
        build_setup_ap_credentials(taby_identity_get());
    }

    memset(out_info, 0, sizeof(*out_info));
    copy_string_field(out_info->ssid, sizeof(out_info->ssid), s_status.ap_ssid);
    copy_string_field(out_info->password, sizeof(out_info->password), s_status.ap_password);
    copy_string_field(out_info->host, sizeof(out_info->host), TABY_WIFI_SETUP_HOST);
    snprintf(out_info->qr_payload,
             sizeof(out_info->qr_payload),
             "WIFI:T:WPA;S:%s;P:%s;H:false;;",
             s_status.ap_ssid,
             s_status.ap_password);
    return ESP_OK;
}

esp_err_t taby_wifi_get_profiles(taby_wifi_profile_t *out_profiles, size_t max_profiles, size_t *out_count) {
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load profiles failed");

    if (out_count) {
        *out_count = 0;
    }
    if (!out_profiles || max_profiles == 0) {
        return ESP_OK;
    }

    size_t written = 0;
    for (size_t slot = 0; slot < TABY_WIFI_MAX_PROFILES && written < max_profiles; ++slot) {
        if (!s_profiles[slot].occupied) {
            continue;
        }
        out_profiles[written++] = s_profiles[slot];
    }
    if (out_count) {
        *out_count = written;
    }
    return ESP_OK;
}

static void sort_nearby_networks_by_rssi(taby_wifi_nearby_network_t *networks, size_t count) {
    for (size_t i = 0; i < count; ++i) {
        for (size_t j = i + 1; j < count; ++j) {
            if (networks[j].rssi > networks[i].rssi) {
                taby_wifi_nearby_network_t tmp = networks[i];
                networks[i] = networks[j];
                networks[j] = tmp;
            }
        }
    }
}

esp_err_t taby_wifi_scan_nearby_networks(taby_wifi_nearby_network_t *out_networks,
                                         size_t max_networks,
                                         size_t *out_count) {
    if (out_count) {
        *out_count = 0;
    }
    if (!out_networks || max_networks == 0) {
        return ESP_OK;
    }

    int64_t now_us = esp_timer_get_time();
    if (s_nearby_cache_count > 0 && (now_us - s_nearby_cache_at_us) < TABY_WIFI_SCAN_CACHE_TTL_US) {
        size_t copy_count = s_nearby_cache_count < max_networks ? s_nearby_cache_count : max_networks;
        memcpy(out_networks, s_nearby_cache, copy_count * sizeof(taby_wifi_nearby_network_t));
        if (out_count) {
            *out_count = copy_count;
        }
        return ESP_OK;
    }

    if (s_status.mode != TABY_WIFI_MODE_SETUP_AP && s_status.mode != TABY_WIFI_MODE_STATION) {
        return ESP_ERR_INVALID_STATE;
    }

    /* First-run onboarding now keeps the setup network in AP-only mode until
       the user actually submits Wi-Fi credentials. Active scanning from that
       AP-only state is unreliable on this board and was crashing the device
       as soon as the setup page loaded. Keep the page stable and fall back to
       manual SSID entry instead of attempting a scan here. */
    if (s_status.mode == TABY_WIFI_MODE_SETUP_AP && !s_station_join_via_setup_ap) {
        s_nearby_cache_count = 0;
        s_nearby_cache_at_us = now_us;
        return ESP_OK;
    }

    wifi_scan_config_t scan_config = {
        .show_hidden = false,
        .scan_type = WIFI_SCAN_TYPE_ACTIVE,
    };
    ESP_RETURN_ON_ERROR(esp_wifi_scan_start(&scan_config, true), TAG, "wifi scan start failed");

    uint16_t ap_count = 0;
    ESP_RETURN_ON_ERROR(esp_wifi_scan_get_ap_num(&ap_count), TAG, "wifi scan count failed");
    if (ap_count == 0) {
        s_nearby_cache_count = 0;
        s_nearby_cache_at_us = now_us;
        return ESP_OK;
    }

    wifi_ap_record_t records[16] = {0};
    uint16_t max_records = ap_count < 16 ? ap_count : 16;
    ESP_RETURN_ON_ERROR(esp_wifi_scan_get_ap_records(&max_records, records), TAG, "wifi scan records failed");

    size_t written = 0;
    for (uint16_t i = 0; i < max_records && written < TABY_WIFI_SCAN_CACHE_MAX; ++i) {
        if (records[i].ssid[0] == '\0') {
            continue;
        }
        bool duplicate = false;
        for (size_t j = 0; j < written; ++j) {
            if (strcmp(s_nearby_cache[j].ssid, (const char *)records[i].ssid) == 0) {
                duplicate = true;
                if (records[i].rssi > s_nearby_cache[j].rssi) {
                    s_nearby_cache[j].rssi = records[i].rssi;
                    s_nearby_cache[j].secure = records[i].authmode != WIFI_AUTH_OPEN;
                }
                break;
            }
        }
        if (duplicate) {
            continue;
        }

        memset(&s_nearby_cache[written], 0, sizeof(s_nearby_cache[written]));
        copy_string_field(s_nearby_cache[written].ssid,
                          sizeof(s_nearby_cache[written].ssid),
                          (const char *)records[i].ssid);
        s_nearby_cache[written].rssi = records[i].rssi;
        s_nearby_cache[written].secure = records[i].authmode != WIFI_AUTH_OPEN;
        written++;
    }

    sort_nearby_networks_by_rssi(s_nearby_cache, written);
    s_nearby_cache_count = written;
    s_nearby_cache_at_us = now_us;

    size_t copy_count = written < max_networks ? written : max_networks;
    memcpy(out_networks, s_nearby_cache, copy_count * sizeof(taby_wifi_nearby_network_t));
    if (out_count) {
        *out_count = copy_count;
    }
    return ESP_OK;
}

esp_err_t taby_wifi_forget_network(const char *ssid) {
    if (!ssid || ssid[0] == '\0') {
        return ESP_ERR_INVALID_ARG;
    }

    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load profiles failed");
    int slot = find_profile_index_by_ssid(ssid);
    if (slot < 0) {
        return ESP_ERR_NOT_FOUND;
    }

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(taby_wifi_nvs_open(NVS_READWRITE, &handle), TAG, "nvs open failed");
    erase_profile_slot(handle, (size_t)slot);
    if (s_profiles[slot].last_success) {
        nvs_erase_key(handle, TABY_WIFI_LAST_SUCCESS_SSID_KEY);
    }
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit forget network failed");
    nvs_close(handle);
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "reload profiles failed");
    return ESP_OK;
}

esp_err_t taby_wifi_set_preferred_network(const char *ssid) {
    if (!ssid || ssid[0] == '\0') {
        return ESP_ERR_INVALID_ARG;
    }

    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "load profiles failed");
    int slot = find_profile_index_by_ssid(ssid);
    if (slot < 0) {
        return ESP_ERR_NOT_FOUND;
    }

    uint8_t highest_priority = 0;
    for (size_t i = 0; i < TABY_WIFI_MAX_PROFILES; ++i) {
        if (s_profiles[i].occupied && s_profiles[i].priority > highest_priority) {
            highest_priority = s_profiles[i].priority;
        }
    }
    s_profiles[slot].priority = (uint8_t)(highest_priority + 1);

    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(taby_wifi_nvs_open(NVS_READWRITE, &handle), TAG, "nvs open failed");
    ESP_RETURN_ON_ERROR(save_profile_slot(handle, (size_t)slot, &s_profiles[slot]), TAG, "save preferred failed");
    ESP_RETURN_ON_ERROR(nvs_commit(handle), TAG, "commit preferred network failed");
    nvs_close(handle);
    ESP_RETURN_ON_ERROR(load_profiles_from_nvs(), TAG, "reload profiles failed");
    return ESP_OK;
}
