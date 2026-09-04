#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "esp_err.h"
#include "taby_identity.h"

#define TABY_WIFI_MAX_PROFILES 5

typedef enum {
    TABY_WIFI_MODE_NONE = 0,
    TABY_WIFI_MODE_SETUP_AP,
    TABY_WIFI_MODE_STATION,
} taby_wifi_mode_t;

typedef struct {
    bool occupied;
    char ssid[33];
    char password[65];
    char label[33];
    uint8_t priority;
    bool auto_join;
    bool preferred;
    bool last_success;
} taby_wifi_profile_t;

typedef struct {
    char ssid[33];
    char password[17];
    char host[16];
    char qr_payload[96];
} taby_wifi_setup_info_t;

typedef struct {
    char ssid[33];
    int8_t rssi;
    bool secure;
} taby_wifi_nearby_network_t;

esp_err_t taby_wifi_init(const taby_identity_t *identity);
bool taby_wifi_is_provisioned(void);
bool taby_wifi_is_connected(void);
taby_wifi_mode_t taby_wifi_mode(void);
const char *taby_wifi_mode_name(void);
const char *taby_wifi_ip_address(void);
const char *taby_wifi_ap_ssid(void);
const char *taby_wifi_ap_password(void);
const char *taby_wifi_station_ssid(void);
const char *taby_wifi_mdns_hostname(void);
const char *taby_wifi_last_error(void);
esp_err_t taby_wifi_store_credentials(const char *ssid, const char *password);
esp_err_t taby_wifi_connect_saved_networks(void);
esp_err_t taby_wifi_shutdown(void);
esp_err_t taby_wifi_clear_credentials(void);
esp_err_t taby_wifi_start_setup_mode(const taby_identity_t *identity);
esp_err_t taby_wifi_get_setup_info(taby_wifi_setup_info_t *out_info);
esp_err_t taby_wifi_get_profiles(taby_wifi_profile_t *out_profiles, size_t max_profiles, size_t *out_count);
esp_err_t taby_wifi_scan_nearby_networks(taby_wifi_nearby_network_t *out_networks,
                                         size_t max_networks,
                                         size_t *out_count);
esp_err_t taby_wifi_forget_network(const char *ssid);
esp_err_t taby_wifi_set_preferred_network(const char *ssid);
