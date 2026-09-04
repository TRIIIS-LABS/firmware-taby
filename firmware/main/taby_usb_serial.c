#include "taby_usb_serial.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "board_amoled_1_64.h"
#include "cJSON.h"
#include "driver/usb_serial_jtag.h"
#include "esp_attr.h"
#include "esp_log.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "taby_ble_transport.h"
#include "taby_build_info.h"
#include "taby_identity.h"
#include "taby_mqtt.h"
#include "taby_onboarding.h"
#include "taby_power.h"
#include "taby_reusable_preview.h"
#include "taby_reusable_ui.h"
#include "taby_runtime.h"
#include "taby_state_machine.h"
#include "taby_transport_prefs.h"
#include "taby_transport_protocol.h"
#include "taby_wifi.h"

static const char *TAG = "taby_usb";
#define TABY_USB_LINE_BUFFER_SIZE 2048
#define TABY_USB_TASK_STACK_SIZE 16384
#define TABY_USB_WRITE_CHUNK_SIZE 256U
#define TABY_USB_EVENT_RING_SIZE 8
#define TABY_USB_EVENT_SIZE 96
#define TABY_USB_MODE_NAME "serial_jtag_app"
static TaskHandle_t s_usb_task_handle = NULL;
static char s_usb_line_buffer[TABY_USB_LINE_BUFFER_SIZE];
static RTC_DATA_ATTR uint32_t s_usb_boot_count = 0;
static bool s_usb_bridge_ready = false;
static uint32_t s_usb_command_count = 0;
static uint32_t s_usb_rejected_command_count = 0;
static char s_usb_last_command[96] = "";
static char s_usb_last_reject_reason[96] = "";
static char s_usb_recent_events[TABY_USB_EVENT_RING_SIZE][TABY_USB_EVENT_SIZE];
static size_t s_usb_recent_event_index = 0;
static size_t s_usb_recent_event_count = 0;

static void add_usb_capabilities(cJSON *root);

static void delayed_restart_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(400));
    esp_restart();
}

static void delayed_wifi_connect_task(void *arg) {
    (void)arg;
    vTaskDelay(pdMS_TO_TICKS(250));
    esp_err_t err = taby_wifi_connect_saved_networks();
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "saved wifi connect failed: %s", esp_err_to_name(err));
    }
    vTaskDelete(NULL);
}

static void usb_write_bytes_all(const uint8_t *data, size_t length) {
    if (!data || length == 0) {
        return;
    }

    size_t written = 0;
    while (written < length) {
        size_t write_length = length - written;
        if (write_length > TABY_USB_WRITE_CHUNK_SIZE) {
            write_length = TABY_USB_WRITE_CHUNK_SIZE;
        }
        int chunk = usb_serial_jtag_write_bytes(
            data + written,
            write_length,
            pdMS_TO_TICKS(100));
        if (chunk <= 0) {
            break;
        }
        written += (size_t)chunk;
    }
}

static void usb_write_line(const char *text) {
    if (!text) {
        return;
    }

    usb_write_bytes_all((const uint8_t *)text, strlen(text));
    usb_write_bytes_all((const uint8_t *)"\n", 1);
}

static void usb_write_prefixed_json(const char *prefix, cJSON *root, const char *encode_error) {
    char *body = cJSON_PrintUnformatted(root);
    if (!body) {
        usb_write_line(encode_error);
        return;
    }

    usb_write_bytes_all((const uint8_t *)prefix, strlen(prefix));
    usb_write_bytes_all((const uint8_t *)body, strlen(body));
    usb_write_bytes_all((const uint8_t *)"\n", 1);
    cJSON_free(body);
}

static void usb_copy_text(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0) {
        return;
    }

    if (!source) {
        destination[0] = '\0';
        return;
    }

    snprintf(destination, destination_size, "%s", source);
}

static void usb_record_event(const char *event, const char *detail) {
    char *slot = s_usb_recent_events[s_usb_recent_event_index];
    snprintf(
        slot,
        TABY_USB_EVENT_SIZE,
        "%s%s%s",
        event ? event : "event",
        detail && detail[0] ? " " : "",
        detail && detail[0] ? detail : "");
    s_usb_recent_event_index = (s_usb_recent_event_index + 1U) % TABY_USB_EVENT_RING_SIZE;
    if (s_usb_recent_event_count < TABY_USB_EVENT_RING_SIZE) {
        s_usb_recent_event_count++;
    }
}

static void usb_set_last_reject_reason(const char *reason) {
    s_usb_rejected_command_count++;
    usb_copy_text(s_usb_last_reject_reason, sizeof(s_usb_last_reject_reason), reason);
    usb_record_event("reject", reason);
}

static void usb_write_error_reason(const char *reason) {
    char response[160];
    usb_set_last_reject_reason(reason);
    snprintf(response, sizeof(response), "TABY:ERR %.120s", reason ? reason : "unknown_error");
    usb_write_line(response);
}

static void usb_record_command(const char *line) {
    char sanitized[96] = {0};
    const char *label = line ? line : "";

    if (strncmp(label, "PROVISION ", 10) == 0) {
        label = "PROVISION <redacted>";
    } else if (strncmp(label, "CLAIM ", 6) == 0) {
        label = "CLAIM <redacted>";
    }

    usb_copy_text(sanitized, sizeof(sanitized), label);
    usb_copy_text(s_usb_last_command, sizeof(s_usb_last_command), sanitized);
    s_usb_command_count++;
    usb_record_event("cmd", sanitized);
}

static const char *reset_reason_name(esp_reset_reason_t reason) {
    switch (reason) {
        case ESP_RST_POWERON:
            return "power_on";
        case ESP_RST_EXT:
            return "external_reset";
        case ESP_RST_SW:
            return "software_reset";
        case ESP_RST_PANIC:
            return "panic";
        case ESP_RST_INT_WDT:
            return "interrupt_watchdog";
        case ESP_RST_TASK_WDT:
            return "task_watchdog";
        case ESP_RST_WDT:
            return "watchdog";
        case ESP_RST_DEEPSLEEP:
            return "deep_sleep";
        case ESP_RST_BROWNOUT:
            return "brownout";
        case ESP_RST_SDIO:
            return "sdio";
        case ESP_RST_UNKNOWN:
        default:
            return "unknown";
    }
}

static const char *skip_ascii_spaces(const char *text) {
    if (!text) {
        return "";
    }

    while (*text && isspace((unsigned char)*text)) {
        text++;
    }
    return text;
}

static const char *reusable_ui_command_from_command(const char *text) {
    if (!text) {
        return NULL;
    }

    return strncmp(text, "UI/", 3) == 0 ? text : NULL;
}

static void add_string_or_empty(cJSON *root, const char *key, const char *value) {
    cJSON_AddStringToObject(root, key, value ? value : "");
}

static void add_display_orientation_fields(cJSON *root, bool include_imu_diagnostics) {
    taby_display_orientation_status_t status = {0};
    board_amoled_1_64_display_orientation_status(&status);
    add_string_or_empty(
        root,
        "display_orientation_mode",
        status.mode_name);
    add_string_or_empty(
        root,
        "display_orientation",
        status.orientation_name);
    cJSON_AddNumberToObject(
        root,
        "display_rotation_degrees",
        status.rotation_degrees);
    cJSON_AddBoolToObject(
        root,
        "display_orientation_auto_supported",
        status.auto_supported);

    if (!include_imu_diagnostics) {
        return;
    }

    taby_orientation_imu_diagnostics_t imu = {0};
    board_amoled_1_64_orientation_imu_diagnostics(&imu);
    cJSON_AddBoolToObject(root, "display_orientation_imu_available", imu.available);
    cJSON_AddNumberToObject(root, "display_orientation_imu_who_am_i", imu.who_am_i);
    cJSON_AddNumberToObject(root, "display_orientation_imu_revision_id", imu.revision_id);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_x_raw", imu.accel_x_raw);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_y_raw", imu.accel_y_raw);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_z_raw", imu.accel_z_raw);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_x_mg", imu.accel_x_mg);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_y_mg", imu.accel_y_mg);
    cJSON_AddNumberToObject(root, "display_orientation_imu_accel_z_mg", imu.accel_z_mg);
    cJSON_AddNumberToObject(
        root,
        "display_orientation_imu_sample_age_ms",
        imu.sample_age_ms == UINT32_MAX ? -1 : (double)imu.sample_age_ms);
    cJSON_AddNumberToObject(root, "display_orientation_imu_sample_count", imu.sample_count);
    cJSON_AddNumberToObject(root, "display_orientation_imu_read_error_count", imu.read_error_count);
    add_string_or_empty(
        root,
        "display_orientation_auto_candidate",
        imu.candidate_valid
            ? (imu.candidate == TABY_DISPLAY_ORIENTATION_RIGHT ? "right" : "left")
            : "");
    cJSON_AddNumberToObject(root, "display_orientation_auto_stable_ms", imu.stable_ms);
    cJSON_AddNumberToObject(
        root,
        "display_orientation_auto_confidence_percent",
        imu.confidence_percent);
    add_string_or_empty(
        root,
        "display_orientation_auto_state",
        board_amoled_1_64_orientation_imu_state_name(imu.state));
}

static void add_common_info_fields(cJSON *root, bool include_setup_ap_password) {
    const taby_identity_t *identity = taby_identity_get();
    taby_wifi_setup_info_t setup_info = {0};
    taby_power_status_t power = taby_power_get_status();
    taby_wifi_get_setup_info(&setup_info);

    add_string_or_empty(root, "firmware_version", taby_firmware_version());
    add_string_or_empty(root, "assets_version", taby_assets_version());
    add_string_or_empty(root, "hardware_target", taby_hardware_target());
    add_string_or_empty(root, "display_shape", taby_display_shape());
    cJSON_AddNumberToObject(root, "display_width", taby_display_width());
    cJSON_AddNumberToObject(root, "display_height", taby_display_height());
    add_string_or_empty(root, "device_id", identity ? identity->device_id : "");
    cJSON_AddBoolToObject(root, "claimed", identity ? identity->claimed : false);
    add_string_or_empty(root, "claimed_by", (identity && identity->claimed_by[0]) ? identity->claimed_by : "");
    add_string_or_empty(root, "wifi_mode", taby_wifi_mode_name());
    add_string_or_empty(root, "state", taby_transport_state_name(taby_runtime_current_state()));
    add_string_or_empty(root, "ip", taby_wifi_ip_address());
    add_string_or_empty(root, "mdns_host", taby_wifi_mdns_hostname());
    add_string_or_empty(root, "station_ssid", taby_wifi_station_ssid());
    add_string_or_empty(root, "setup_ap_ssid", setup_info.ssid);
    add_string_or_empty(root, "setup_ap_password", include_setup_ap_password ? setup_info.password : "");
    add_string_or_empty(root, "setup_ap_host", setup_info.host);
    add_string_or_empty(root, "wifi_error", taby_wifi_last_error());
    cJSON_AddBoolToObject(root, "transport_onboarding_complete", taby_transport_onboarding_complete());
    add_string_or_empty(root, "preferred_transport", taby_transport_preferred_mode_name());
    cJSON_AddBoolToObject(root, "bluetooth_ready", taby_ble_transport_is_ready());
    cJSON_AddBoolToObject(root, "bluetooth_advertising", taby_ble_transport_is_advertising());
    cJSON_AddBoolToObject(root, "bluetooth_connected", taby_ble_transport_is_connected());
    add_string_or_empty(root, "bluetooth_name", taby_ble_transport_device_name());
    add_string_or_empty(root, "bluetooth_error", taby_ble_transport_last_error());
    cJSON_AddNumberToObject(root, "power_voltage_mv", power.valid ? power.power_voltage_mv : 0);
    cJSON_AddNumberToObject(root, "battery_percent", power.valid ? power.battery_percent : -1);
    cJSON_AddBoolToObject(root, "external_power", power.valid && power.external_power);
    cJSON_AddBoolToObject(root, "mqtt_enabled", taby_mqtt_enabled());
    cJSON_AddBoolToObject(root, "mqtt_connected", taby_mqtt_connected());
    add_string_or_empty(root, "identity_source", taby_identity_source_name());
    cJSON_AddBoolToObject(root, "has_factory_data", identity && identity->has_factory_data);
    add_string_or_empty(root, "usb_mode", TABY_USB_MODE_NAME);
    cJSON_AddBoolToObject(root, "usb_bridge_ready", s_usb_bridge_ready);
    add_string_or_empty(root, "reset_reason", reset_reason_name(esp_reset_reason()));
    cJSON_AddNumberToObject(root, "boot_count", s_usb_boot_count);
    add_string_or_empty(root, "last_command", s_usb_last_command);
    add_string_or_empty(root, "last_reject_reason", s_usb_last_reject_reason);
    cJSON_AddNumberToObject(root, "usb_command_count", s_usb_command_count);
    cJSON_AddNumberToObject(root, "usb_rejected_command_count", s_usb_rejected_command_count);
    cJSON_AddNumberToObject(root, "brightness_percent", board_amoled_1_64_brightness_percent());
    cJSON_AddNumberToObject(root, "brightness_raw", board_amoled_1_64_brightness_raw());
    add_display_orientation_fields(root, true);
    cJSON_AddNumberToObject(root, "free_heap_bytes", esp_get_free_heap_size());
    cJSON_AddNumberToObject(root, "minimum_free_heap_bytes", esp_get_minimum_free_heap_size());
}

static void write_wifi_networks_json(void) {
    taby_wifi_profile_t profiles[TABY_WIFI_MAX_PROFILES] = {0};
    size_t profile_count = 0;
    taby_wifi_get_profiles(profiles, TABY_WIFI_MAX_PROFILES, &profile_count);

    cJSON *root = cJSON_CreateObject();
    cJSON *networks = cJSON_CreateArray();
    for (size_t i = 0; i < profile_count; ++i) {
        const taby_wifi_profile_t *profile = &profiles[i];
        cJSON *entry = cJSON_CreateObject();
        cJSON_AddStringToObject(entry, "ssid", profile->ssid);
        cJSON_AddStringToObject(entry, "label", profile->label);
        cJSON_AddNumberToObject(entry, "priority", profile->priority);
        cJSON_AddBoolToObject(entry, "auto_join", profile->auto_join);
        cJSON_AddBoolToObject(entry, "preferred", profile->preferred);
        cJSON_AddBoolToObject(entry, "last_success", profile->last_success);
        cJSON_AddItemToArray(networks, entry);
    }
    cJSON_AddItemToObject(root, "networks", networks);

    char *body = cJSON_PrintUnformatted(root);
    if (body) {
        char response[1024];
        snprintf(response, sizeof(response), "TABY:WIFI_NETWORKS %s", body);
        usb_write_line(response);
        cJSON_free(body);
    } else {
        usb_write_line("TABY:ERR wifi_networks_encode_failed");
    }
    cJSON_Delete(root);
}

static void write_nearby_wifi_networks_json(void) {
    taby_wifi_nearby_network_t networks[16] = {0};
    size_t network_count = 0;
    taby_wifi_scan_nearby_networks(networks, 16, &network_count);

    cJSON *root = cJSON_CreateObject();
    cJSON *items = cJSON_CreateArray();
    for (size_t i = 0; i < network_count; ++i) {
        cJSON *entry = cJSON_CreateObject();
        cJSON_AddStringToObject(entry, "ssid", networks[i].ssid);
        cJSON_AddNumberToObject(entry, "rssi", networks[i].rssi);
        cJSON_AddBoolToObject(entry, "secure", networks[i].secure);
        cJSON_AddItemToArray(items, entry);
    }
    cJSON_AddItemToObject(root, "networks", items);

    char *body = cJSON_PrintUnformatted(root);
    if (body) {
        char response[2048];
        snprintf(response, sizeof(response), "TABY:WIFI_NEARBY %s", body);
        usb_write_line(response);
        cJSON_free(body);
    } else {
        usb_write_line("TABY:ERR wifi_nearby_encode_failed");
    }
    cJSON_Delete(root);
}

static void write_setup_info_json(void) {
    taby_wifi_setup_info_t setup_info = {0};
    const taby_identity_t *identity = taby_identity_get();
    taby_wifi_get_setup_info(&setup_info);
    taby_wifi_profile_t profiles[TABY_WIFI_MAX_PROFILES] = {0};
    size_t profile_count = 0;
    taby_wifi_get_profiles(profiles, TABY_WIFI_MAX_PROFILES, &profile_count);

    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "device_id", identity ? identity->device_id : "");
    cJSON_AddStringToObject(root, "wifi_mode", taby_wifi_mode_name());
    cJSON_AddBoolToObject(root, "provisioned", taby_wifi_is_provisioned());
    cJSON_AddStringToObject(root, "wifi_error", taby_wifi_last_error() ? taby_wifi_last_error() : "");
    cJSON_AddBoolToObject(root, "transport_onboarding_complete", taby_transport_onboarding_complete());
    cJSON_AddStringToObject(root, "preferred_transport", taby_transport_preferred_mode_name());

    cJSON *setup_ap = cJSON_CreateObject();
    cJSON_AddStringToObject(setup_ap, "ssid", setup_info.ssid);
    cJSON_AddStringToObject(setup_ap, "password", setup_info.password);
    cJSON_AddStringToObject(setup_ap, "host", setup_info.host);
    cJSON_AddStringToObject(setup_ap, "qr_payload", setup_info.qr_payload);
    cJSON_AddItemToObject(root, "setup_ap", setup_ap);

    cJSON *networks = cJSON_CreateArray();
    for (size_t i = 0; i < profile_count; ++i) {
        const taby_wifi_profile_t *profile = &profiles[i];
        cJSON *entry = cJSON_CreateObject();
        cJSON_AddStringToObject(entry, "ssid", profile->ssid);
        cJSON_AddStringToObject(entry, "label", profile->label);
        cJSON_AddNumberToObject(entry, "priority", profile->priority);
        cJSON_AddBoolToObject(entry, "auto_join", profile->auto_join);
        cJSON_AddBoolToObject(entry, "preferred", profile->preferred);
        cJSON_AddBoolToObject(entry, "last_success", profile->last_success);
        cJSON_AddItemToArray(networks, entry);
    }
    cJSON_AddItemToObject(root, "saved_networks", networks);

    char *body = cJSON_PrintUnformatted(root);
    if (body) {
        char response[1400];
        snprintf(response, sizeof(response), "TABY:SETUP %s", body);
        usb_write_line(response);
        cJSON_free(body);
    } else {
        usb_write_line("TABY:ERR setup_encode_failed");
    }
    cJSON_Delete(root);
}

static void write_info_json(void) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        usb_write_error_reason("info_encode_failed");
        return;
    }
    add_common_info_fields(root, true);
    add_usb_capabilities(root);
    usb_write_prefixed_json("TABY:INFO ", root, "TABY:ERR info_encode_failed");
    cJSON_Delete(root);
}

static void add_usb_recent_events(cJSON *root) {
    cJSON *events = cJSON_CreateArray();
    if (!events) {
        return;
    }

    size_t first_index = s_usb_recent_event_count < TABY_USB_EVENT_RING_SIZE
        ? 0
        : s_usb_recent_event_index;
    for (size_t i = 0; i < s_usb_recent_event_count; ++i) {
        size_t index = (first_index + i) % TABY_USB_EVENT_RING_SIZE;
        cJSON_AddItemToArray(events, cJSON_CreateString(s_usb_recent_events[index]));
    }
    cJSON_AddItemToObject(root, "recent_usb_events", events);
}

static void add_usb_capabilities(cJSON *root) {
    cJSON *capabilities = cJSON_CreateArray();
    if (!capabilities) {
        return;
    }

    cJSON_AddItemToArray(capabilities, cJSON_CreateString("info"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("diag"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("logs"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("brightness"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("display_orientation"));
    if (board_amoled_1_64_display_orientation_auto_supported()) {
        cJSON_AddItemToArray(capabilities, cJSON_CreateString("display_orientation_auto"));
    }
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("transport_default"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("reusable_ui"));
    cJSON_AddItemToArray(capabilities, cJSON_CreateString("wifi_setup"));
    cJSON_AddItemToObject(root, "capabilities", capabilities);
}

static void write_diag_json(void) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        usb_write_error_reason("diag_encode_failed");
        return;
    }

    add_string_or_empty(root, "schema", "taby_usb_diag_v1");
    add_common_info_fields(root, false);
    add_usb_capabilities(root);
    add_usb_recent_events(root);
    usb_write_prefixed_json("TABY:DIAG ", root, "TABY:ERR diag_encode_failed");
    cJSON_Delete(root);
}

static void write_logs_json(void) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        usb_write_error_reason("logs_encode_failed");
        return;
    }

    add_string_or_empty(root, "schema", "taby_usb_logs_v1");
    add_usb_recent_events(root);
    usb_write_prefixed_json("TABY:LOGS ", root, "TABY:ERR logs_encode_failed");
    cJSON_Delete(root);
}

static void write_brightness_json(void) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        usb_write_error_reason("brightness_encode_failed");
        return;
    }

    cJSON_AddNumberToObject(root, "percent", board_amoled_1_64_brightness_percent());
    cJSON_AddNumberToObject(root, "raw", board_amoled_1_64_brightness_raw());
    usb_write_prefixed_json("TABY:BRIGHTNESS ", root, "TABY:ERR brightness_encode_failed");
    cJSON_Delete(root);
}

static bool handle_brightness_command(const char *command_text) {
    if (!command_text) {
        return false;
    }

    if (strcmp(command_text, "BRIGHTNESS") == 0 || strcmp(command_text, "BRIGHTNESS?") == 0) {
        write_brightness_json();
        return true;
    }

    if (strncmp(command_text, "BRIGHTNESS ", 11) != 0) {
        return false;
    }

    const char *value_text = skip_ascii_spaces(command_text + 11);
    char *end = NULL;
    long value = strtol(value_text, &end, 10);
    while (end && *end && isspace((unsigned char)*end)) {
        end++;
    }
    if (value_text[0] == '\0' || (end && *end != '\0') || value < 0 || value > 100) {
        usb_write_error_reason("brightness_invalid_value");
        return true;
    }

    if (!taby_runtime_set_brightness_percent((uint8_t)value)) {
        usb_write_error_reason("brightness_set_failed");
        return true;
    }
    write_brightness_json();
    return true;
}

static void write_display_orientation_json(void) {
    cJSON *root = cJSON_CreateObject();
    if (!root) {
        usb_write_error_reason("display_orientation_encode_failed");
        return;
    }

    taby_display_orientation_status_t status = {0};
    board_amoled_1_64_display_orientation_status(&status);
    add_string_or_empty(root, "mode", status.mode_name);
    add_string_or_empty(root, "orientation", status.orientation_name);
    cJSON_AddNumberToObject(root, "rotation_degrees", status.rotation_degrees);
    cJSON_AddBoolToObject(root, "auto_supported", status.auto_supported);
    add_string_or_empty(root, "display_shape", taby_display_shape());
    usb_write_prefixed_json(
        "TABY:DISPLAY_ORIENTATION ",
        root,
        "TABY:ERR display_orientation_encode_failed");
    cJSON_Delete(root);
}

static bool handle_display_orientation_command(const char *command_text) {
    if (!command_text) {
        return false;
    }

    if (strcmp(command_text, "DISPLAY_ORIENTATION") == 0 ||
        strcmp(command_text, "DISPLAY_ORIENTATION?") == 0) {
        write_display_orientation_json();
        return true;
    }

    if (strncmp(command_text, "DISPLAY_ORIENTATION ", 20) != 0) {
        return false;
    }

    taby_display_orientation_mode_t mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
    if (!board_amoled_1_64_parse_display_orientation_mode(
            skip_ascii_spaces(command_text + 20),
            &mode)) {
        usb_write_error_reason("display_orientation_invalid_value");
        return true;
    }

    if (mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO &&
        !board_amoled_1_64_display_orientation_auto_supported()) {
        usb_write_error_reason("display_orientation_auto_unsupported");
        return true;
    }

    if (!taby_runtime_set_display_orientation_mode(mode)) {
        usb_write_error_reason("display_orientation_set_failed");
        return true;
    }

    write_display_orientation_json();
    return true;
}

static void trim_ascii_spaces(char *text) {
    if (!text) {
        return;
    }

    char *start = text;
    while (*start && isspace((unsigned char)*start)) {
        start++;
    }

    if (start != text) {
        memmove(text, start, strlen(start) + 1);
    }

    size_t len = strlen(text);
    while (len > 0 && isspace((unsigned char)text[len - 1])) {
        text[len - 1] = '\0';
        len--;
    }
}

static void handle_usb_line(char *line) {
    trim_ascii_spaces(line);
    if (line[0] == '\0') {
        return;
    }
    usb_record_command(line);

    if (strcmp(line, "PING") == 0) {
        usb_write_line("TABY:PONG");
        return;
    }

    if (strcmp(line, "STATE") == 0) {
        char response[96];
        snprintf(
            response,
            sizeof(response),
            "TABY:STATE %s",
            taby_transport_state_name(taby_runtime_current_state()));
        usb_write_line(response);
        return;
    }

    if (strcmp(line, "INFO") == 0) {
        write_info_json();
        return;
    }

    if (strcmp(line, "DIAG") == 0 || strcmp(line, "USB_DEBUG") == 0 || strcmp(line, "TABY:USB_DEBUG") == 0) {
        write_diag_json();
        return;
    }

    if (strcmp(line, "LOGS") == 0 || strncmp(line, "LOGS ", 5) == 0) {
        write_logs_json();
        return;
    }

    if (handle_brightness_command(line)) {
        return;
    }

    if (handle_display_orientation_command(line)) {
        return;
    }

    if (strcmp(line, "SETUP_INFO") == 0) {
        write_setup_info_json();
        return;
    }

    if (strcmp(line, "SETUP_START") == 0) {
        if (taby_wifi_start_setup_mode(taby_identity_get()) != ESP_OK) {
            usb_write_error_reason("setup_start_failed");
            return;
        }
        taby_onboarding_show_wifi_setup();
        write_setup_info_json();
        return;
    }

    if (strcmp(line, "WIFI_NETWORKS") == 0) {
        write_wifi_networks_json();
        return;
    }

    if (strcmp(line, "WIFI_NEARBY") == 0) {
        write_nearby_wifi_networks_json();
        return;
    }

    if (strncmp(line, "WIFI_FORGET ", 12) == 0) {
        const char *ssid = skip_ascii_spaces(line + 12);
        if (taby_wifi_forget_network(ssid) != ESP_OK) {
            usb_write_error_reason("wifi_forget_failed");
            return;
        }
        usb_write_line("TABY:OK WIFI_FORGET");
        return;
    }

    if (strncmp(line, "WIFI_PREFER ", 12) == 0) {
        const char *ssid = skip_ascii_spaces(line + 12);
        if (taby_wifi_set_preferred_network(ssid) != ESP_OK) {
            usb_write_error_reason("wifi_prefer_failed");
            return;
        }
        usb_write_line("TABY:OK WIFI_PREFER");
        return;
    }

    if (strncmp(line, "PROVISION ", 10) == 0) {
        cJSON *root = cJSON_Parse(line + 10);
        if (!root) {
            usb_write_error_reason("provision_invalid_json");
            return;
        }

        const cJSON *ssid = cJSON_GetObjectItemCaseSensitive(root, "ssid");
        const cJSON *password = cJSON_GetObjectItemCaseSensitive(root, "password");
        if (!cJSON_IsString(ssid) || !ssid->valuestring || !cJSON_IsString(password) || !password->valuestring) {
            cJSON_Delete(root);
            usb_write_error_reason("provision_missing_fields");
            return;
        }

        esp_err_t provision_err = taby_wifi_store_credentials(ssid->valuestring, password->valuestring);
        cJSON_Delete(root);
        if (provision_err != ESP_OK) {
            usb_write_error_reason("provision_failed");
            return;
        }

        usb_write_line("TABY:OK PROVISION");
        xTaskCreate(delayed_wifi_connect_task, "taby_wifi_connect", 3072, NULL, 4, NULL);
        return;
    }

    if (strncmp(line, "CLAIM ", 6) == 0) {
        cJSON *root = cJSON_Parse(line + 6);
        if (!root) {
            usb_write_error_reason("claim_invalid_json");
            return;
        }

        const cJSON *claimed_by = cJSON_GetObjectItemCaseSensitive(root, "claimed_by");
        const char *value = (cJSON_IsString(claimed_by) && claimed_by->valuestring) ? claimed_by->valuestring : "claimed";
        esp_err_t claim_err = taby_identity_set_claim(value);
        cJSON_Delete(root);
        if (claim_err != ESP_OK) {
            usb_write_error_reason("claim_failed");
            return;
        }
        usb_write_line("TABY:OK CLAIM");
        return;
    }

    if (strncmp(line, "TRANSPORT_MODE ", 15) == 0) {
        const char *mode_text = skip_ascii_spaces(line + 15);
        taby_transport_pref_t preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
        if (!taby_transport_pref_from_name(mode_text, &preferred_mode)) {
            usb_write_error_reason("invalid_transport_mode");
            return;
        }
        if (taby_onboarding_activate_transport_mode(preferred_mode) != ESP_OK) {
            usb_write_error_reason("transport_mode_failed");
            return;
        }
        usb_write_line("TABY:OK TRANSPORT_MODE");
        return;
    }

    if (strncmp(line, "TRANSPORT_DEFAULT ", 18) == 0) {
        const char *mode_text = skip_ascii_spaces(line + 18);
        taby_transport_pref_t preferred_mode = TABY_TRANSPORT_PREF_UNKNOWN;
        if (!taby_transport_pref_from_name(mode_text, &preferred_mode)) {
            usb_write_error_reason("invalid_transport_mode");
            return;
        }
        if (taby_onboarding_set_transport_default(preferred_mode) != ESP_OK) {
            usb_write_error_reason("transport_default_failed");
            return;
        }
        usb_write_line("TABY:OK TRANSPORT_DEFAULT");
        return;
    }

    if (strcmp(line, "ONBOARDING_RESET") == 0) {
        if (taby_transport_clear_onboarding() != ESP_OK) {
            usb_write_error_reason("onboarding_reset_failed");
            return;
        }
        taby_onboarding_start();
        usb_write_line("TABY:OK ONBOARDING_RESET");
        return;
    }

    if (strcmp(line, "FACTORY_RESET") == 0) {
        esp_err_t wifi_err = taby_wifi_clear_credentials();
        esp_err_t claim_err = taby_identity_clear_claim();
        esp_err_t transport_err = taby_transport_clear_onboarding();
        bool display_orientation_ok = taby_runtime_reset_display_orientation();
        if (wifi_err != ESP_OK ||
            claim_err != ESP_OK ||
            transport_err != ESP_OK ||
            !display_orientation_ok) {
            usb_write_error_reason("factory_reset_failed");
            return;
        }
        usb_write_line("TABY:OK FACTORY_RESET");
        xTaskCreate(delayed_restart_task, "taby_usb_restart", 2048, NULL, 4, NULL);
        return;
    }

    if (strcmp(line, "CHOICE_SIGNAL") == 0) {
        taby_reusable_choice_signal_t signal = {0};
        taby_reusable_ui_read_choice_signal(&signal);

        char response[128];
        snprintf(
            response,
            sizeof(response),
            "TABY:CHOICE_SIGNAL {\"signal\":%u,\"selection\":\"%s\"}",
            (unsigned int)signal.signal,
            taby_reusable_ui_choice_selection_name(signal.selection));
        usb_write_line(response);
        return;
    }

    if (strcmp(line, "TOUCH_SIGNAL") == 0) {
        char response[64];
        snprintf(
            response,
            sizeof(response),
            "TABY:TOUCH_SIGNAL %u",
            (unsigned int)board_amoled_1_64_touch_signal());
        usb_write_line(response);
        return;
    }

    const char *command_text = line;
    if (strncmp(line, "CMD ", 4) == 0) {
        command_text = skip_ascii_spaces(line + 4);
    }

    if (handle_brightness_command(command_text)) {
        return;
    }

    if (handle_display_orientation_command(command_text)) {
        return;
    }

    const char *reusable_ui_command = reusable_ui_command_from_command(command_text);
    if (reusable_ui_command) {
        char ui_error[96] = {0};
        if (!taby_reusable_preview_render_ui_command(reusable_ui_command, ui_error, sizeof(ui_error))) {
            char response[160];
            usb_set_last_reject_reason(ui_error[0] ? ui_error : "ui_command_failed");
            snprintf(
                response,
                sizeof(response),
                "TABY:ERR ui_command_failed %.80s",
                ui_error[0] ? ui_error : "render failed");
            usb_write_line(response);
            return;
        }

        taby_mqtt_notify_state_changed("usb_ui_command");

        char response[96];
        snprintf(
            response,
            sizeof(response),
            "TABY:OK %s",
            taby_transport_state_name(taby_runtime_current_state()));
        usb_write_line(response);
        return;
    }

    taby_transport_resolution_t resolution = {0};
    if (!taby_transport_resolve_text(command_text, &resolution)) {
        char response[128];
        usb_set_last_reject_reason("unsupported_command");
        snprintf(response, sizeof(response), "TABY:ERR unsupported_command %.64s", command_text);
        usb_write_line(response);
        return;
    }

    if (!taby_runtime_apply_transport_resolution(&resolution)) {
        usb_write_error_reason("runtime_unavailable");
        return;
    }

    taby_mqtt_notify_state_changed("usb_command");

    char response[96];
    snprintf(
        response,
        sizeof(response),
        "TABY:OK %s",
        taby_transport_state_name(taby_runtime_current_state()));
    usb_write_line(response);
}

static void usb_serial_task(void *arg) {
    (void)arg;

    char *buffer = s_usb_line_buffer;
    memset(buffer, 0, TABY_USB_LINE_BUFFER_SIZE);
    size_t length = 0;

    while (true) {
        uint8_t byte = 0;
        int read_len = usb_serial_jtag_read_bytes(&byte, 1, pdMS_TO_TICKS(20));
        if (read_len <= 0) {
            continue;
        }

        if (byte == '\r' || byte == '\n') {
            if (length > 0) {
                buffer[length] = '\0';
                handle_usb_line(buffer);
                length = 0;
                buffer[0] = '\0';
            }
            continue;
        }

        if (byte < 0x20 || byte > 0x7E) {
            continue;
        }

        if (length + 1 < TABY_USB_LINE_BUFFER_SIZE) {
            buffer[length++] = (char)byte;
            buffer[length] = '\0';
        } else {
            length = 0;
            buffer[0] = '\0';
            usb_write_error_reason("line_too_long");
        }
    }
}

esp_err_t taby_usb_serial_init(void) {
    if (s_usb_task_handle) {
        return ESP_OK;
    }

    usb_serial_jtag_driver_config_t config = {
        .rx_buffer_size = 2048,
        .tx_buffer_size = 2048,
    };
    ESP_ERROR_CHECK(usb_serial_jtag_driver_install(&config));

    xTaskCreate(usb_serial_task, "taby_usb_serial", TABY_USB_TASK_STACK_SIZE, NULL, 4, &s_usb_task_handle);
    s_usb_boot_count++;
    s_usb_bridge_ready = true;
    usb_record_event("ready", TABY_USB_MODE_NAME);
    ESP_LOGI(TAG, "usb serial command bridge ready");
    return ESP_OK;
}
