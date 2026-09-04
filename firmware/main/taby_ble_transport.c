#include "taby_ble_transport.h"

#include <ctype.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "esp_check.h"
#include "esp_err.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/queue.h"
#include "freertos/task.h"
#include "host/ble_gap.h"
#include "host/ble_gatt.h"
#include "host/ble_hs.h"
#include "host/ble_hs_adv.h"
#include "host/ble_hs_mbuf.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "os/os_mbuf.h"
#include "services/gap/ble_svc_gap.h"
#include "services/gatt/ble_svc_gatt.h"
#include "taby_mqtt.h"
#include "taby_power.h"
#include "taby_build_info.h"
#include "taby_reusable_preview.h"
#include "taby_reusable_ui.h"
#include "taby_runtime.h"
#include "taby_transport_protocol.h"

static const char *TAG = "taby_ble_transport";

#define TABY_BLE_DEVICE_NAME_SIZE 32
#define TABY_BLE_EVENT_PAYLOAD_SIZE 128
#define TABY_BLE_COMMAND_BUFFER_SIZE 256
#define TABY_BLE_COMMAND_QUEUE_LENGTH 4
#define TABY_BLE_COMMAND_TASK_STACK_SIZE 4096
#define TABY_BLE_FAST_CONN_ITVL_MIN 12
#define TABY_BLE_FAST_CONN_ITVL_MAX 24
#define TABY_BLE_FAST_CONN_LATENCY 0
#define TABY_BLE_FAST_CONN_SUPERVISION_TIMEOUT 400

static const ble_uuid128_t k_taby_service_uuid =
    BLE_UUID128_INIT(0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0,
                     0x00, 0x40, 0x00, 0x00, 0x59, 0x42, 0x41, 0x54);
static const ble_uuid128_t k_taby_command_characteristic_uuid =
    BLE_UUID128_INIT(0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0,
                     0x00, 0x40, 0x00, 0x00, 0x59, 0x42, 0x41, 0x54);
static const ble_uuid128_t k_taby_event_characteristic_uuid =
    BLE_UUID128_INIT(0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0,
                     0x00, 0x40, 0x00, 0x00, 0x59, 0x42, 0x41, 0x54);
static const ble_uuid128_t k_taby_state_characteristic_uuid =
    BLE_UUID128_INIT(0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0,
                     0x00, 0x40, 0x00, 0x00, 0x59, 0x42, 0x41, 0x54);
static const ble_uuid128_t k_taby_power_characteristic_uuid =
    BLE_UUID128_INIT(0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0,
                     0x00, 0x40, 0x00, 0x00, 0x59, 0x42, 0x41, 0x54);

static char s_device_name[TABY_BLE_DEVICE_NAME_SIZE] = "Taby";
static char s_last_event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = "READY";
static char s_last_error[96] = "";
static uint8_t s_own_addr_type = BLE_OWN_ADDR_PUBLIC;
static uint16_t s_connection_handle = BLE_HS_CONN_HANDLE_NONE;
static uint16_t s_command_value_handle = 0;
static uint16_t s_event_value_handle = 0;
static uint16_t s_state_value_handle = 0;
static uint16_t s_power_value_handle = 0;
static bool s_notify_enabled = false;
static bool s_started = false;
static bool s_advertising = false;
static bool s_synced = false;
static bool s_nimble_initialized = false;
static QueueHandle_t s_command_queue = NULL;
static TaskHandle_t s_command_task_handle = NULL;

#if __has_include("esp_bt.h")
#include "esp_bt.h"
#define TABY_BLE_HAS_CONTROLLER_STATUS 1
#else
#define TABY_BLE_HAS_CONTROLLER_STATUS 0
#endif

typedef struct {
    bool is_ui_command;
    bool is_brightness_command;
    bool is_display_orientation_command;
    uint8_t brightness_percent;
    taby_display_orientation_mode_t display_orientation_mode;
    taby_transport_resolution_t resolution;
    TaskHandle_t requester;
    uint8_t att_error;
    char command_text[TABY_BLE_COMMAND_BUFFER_SIZE];
    char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE];
} taby_ble_command_job_t;

static const struct ble_gatt_svc_def k_gatt_services[];

static int bt_controller_status_for_log(void) {
#if TABY_BLE_HAS_CONTROLLER_STATUS
    return (int)esp_bt_controller_get_status();
#else
    return -1;
#endif
}

static void ble_host_task(void *param);
static void ble_command_task(void *param);
static void start_advertising(void);
static void request_fast_connection_params(uint16_t conn_handle);

static const char *reusable_ui_command_from_command(const char *text) {
    if (!text) {
        return NULL;
    }

    return strncmp(text, "UI/", 3) == 0 ? text : NULL;
}

static bool parse_brightness_command(const char *text, uint8_t *percent, char *error, size_t error_size) {
    if (!text || strncmp(text, "BRIGHTNESS ", 11) != 0) {
        return false;
    }

    const char *value_text = text + 11;
    while (*value_text && isspace((unsigned char)*value_text)) {
        value_text++;
    }

    char *end = NULL;
    long value = strtol(value_text, &end, 10);
    while (end && *end && isspace((unsigned char)*end)) {
        end++;
    }

    if (value_text[0] == '\0' || (end && *end != '\0') || value < 0 || value > 100) {
        if (error && error_size > 0) {
            snprintf(error, error_size, "%s", "brightness_invalid_value");
        }
        return true;
    }

    if (percent) {
        *percent = (uint8_t)value;
    }
    return true;
}

static bool parse_display_orientation_command(
    const char *text,
    bool *is_query,
    taby_display_orientation_mode_t *mode,
    char *error,
    size_t error_size) {
    if (!text) {
        return false;
    }

    if (strcmp(text, "DISPLAY_ORIENTATION") == 0 ||
        strcmp(text, "DISPLAY_ORIENTATION?") == 0) {
        if (is_query) {
            *is_query = true;
        }
        return true;
    }

    if (strncmp(text, "DISPLAY_ORIENTATION ", 20) != 0) {
        return false;
    }

    if (is_query) {
        *is_query = false;
    }
    if (!board_amoled_1_64_parse_display_orientation_mode(text + 20, mode)) {
        if (error && error_size > 0) {
            snprintf(error, error_size, "%s", "display_orientation_invalid_value");
        }
    }
    return true;
}

static void format_display_orientation_event(char *event_payload, size_t event_payload_size) {
    taby_display_orientation_status_t status = {0};
    board_amoled_1_64_display_orientation_status(&status);
    snprintf(
        event_payload,
        event_payload_size,
        "OK DISPLAY_ORIENTATION %u %s %s %u %s",
        (unsigned int)status.rotation_degrees,
        status.mode_name,
        status.orientation_name,
        status.auto_supported ? 1U : 0U,
        taby_display_shape());
}

static int init_gatt_services(void) {
    ble_svc_gap_init();
    ble_svc_gatt_init();

    int rc = ble_gatts_count_cfg(k_gatt_services);
    if (rc != 0) {
        return rc;
    }

    return ble_gatts_add_svcs(k_gatt_services);
}

static void set_last_event_payload(const char *payload) {
    if (!payload || payload[0] == '\0') {
        s_last_event_payload[0] = '\0';
        return;
    }

    snprintf(s_last_event_payload, sizeof(s_last_event_payload), "%s", payload);
}

static void clear_last_error(void) {
    s_last_error[0] = '\0';
}

static void set_last_error(const char *error) {
    if (!error || error[0] == '\0') {
        clear_last_error();
        return;
    }

    snprintf(s_last_error, sizeof(s_last_error), "%s", error);
}

static void notify_last_event_payload(void) {
    if (!s_notify_enabled ||
        s_connection_handle == BLE_HS_CONN_HANDLE_NONE ||
        s_event_value_handle == 0 ||
        s_last_event_payload[0] == '\0') {
        return;
    }

    struct os_mbuf *om = ble_hs_mbuf_from_flat(
        s_last_event_payload,
        strlen(s_last_event_payload));
    if (!om) {
        ESP_LOGW(TAG, "notify payload allocation failed");
        return;
    }

    int rc = ble_gatts_notify_custom(s_connection_handle, s_event_value_handle, om);
    if (rc != 0) {
        ESP_LOGW(TAG, "notify failed rc=%d", rc);
    }
}

static void publish_event_payload(const char *payload, bool notify) {
    set_last_event_payload(payload);
    if (notify) {
        notify_last_event_payload();
    }
}

static void reset_transport_runtime_state(void) {
    s_started = false;
    s_advertising = false;
    s_synced = false;
    s_connection_handle = BLE_HS_CONN_HANDLE_NONE;
    s_notify_enabled = false;
    s_command_value_handle = 0;
    s_event_value_handle = 0;
    s_state_value_handle = 0;
    s_power_value_handle = 0;
    publish_event_payload("READY", false);
}

static void build_device_name(const taby_identity_t *identity) {
    snprintf(s_device_name, sizeof(s_device_name), "Taby");
    if (!identity || identity->device_id[0] == '\0') {
        return;
    }

    size_t id_len = strlen(identity->device_id);
    const char *suffix = identity->device_id + (id_len > 6 ? id_len - 6 : 0);
    snprintf(s_device_name, sizeof(s_device_name), "Taby %s", suffix);
}

static uint8_t queue_command_job(
    bool is_ui_command,
    bool is_brightness_command,
    bool is_display_orientation_command,
    uint8_t brightness_percent,
    taby_display_orientation_mode_t display_orientation_mode,
    const taby_transport_resolution_t *resolution,
    const char *command_text,
    char *event_payload,
    size_t event_payload_size) {
    if (!s_command_queue) {
        snprintf(event_payload, event_payload_size, "%s", "ERR runtime_unavailable");
        return BLE_ATT_ERR_UNLIKELY;
    }

    taby_ble_command_job_t *job = calloc(1, sizeof(*job));
    if (!job) {
        snprintf(event_payload, event_payload_size, "%s", "ERR command_alloc_failed");
        return BLE_ATT_ERR_INSUFFICIENT_RES;
    }

    job->is_ui_command = is_ui_command;
    job->is_brightness_command = is_brightness_command;
    job->is_display_orientation_command = is_display_orientation_command;
    job->brightness_percent = brightness_percent;
    job->display_orientation_mode = display_orientation_mode;
    if (resolution) {
        job->resolution = *resolution;
    }
    job->requester = xTaskGetCurrentTaskHandle();
    snprintf(job->command_text, sizeof(job->command_text), "%s", command_text);

    ulTaskNotifyTake(pdTRUE, 0);
    if (xQueueSend(s_command_queue, &job, pdMS_TO_TICKS(100)) != pdPASS) {
        free(job);
        snprintf(event_payload, event_payload_size, "%s", "ERR command_queue_full");
        return BLE_ATT_ERR_UNLIKELY;
    }

    ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
    snprintf(event_payload, event_payload_size, "%s", job->event_payload);
    uint8_t att_error = job->att_error;
    free(job);
    return att_error;
}

static int command_characteristic_access(
    uint16_t conn_handle,
    uint16_t attr_handle,
    struct ble_gatt_access_ctxt *ctxt,
    void *arg) {
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;

    if (ctxt->op != BLE_GATT_ACCESS_OP_WRITE_CHR) {
        return BLE_ATT_ERR_UNLIKELY;
    }

    uint16_t packet_len = OS_MBUF_PKTLEN(ctxt->om);
    if (packet_len == 0 || packet_len >= TABY_BLE_COMMAND_BUFFER_SIZE) {
        publish_event_payload("ERR invalid_command_length", true);
        return BLE_ATT_ERR_INVALID_ATTR_VALUE_LEN;
    }

    char command_buffer[TABY_BLE_COMMAND_BUFFER_SIZE] = {0};
    if (os_mbuf_copydata(ctxt->om, 0, packet_len, command_buffer) != 0) {
        publish_event_payload("ERR command_copy_failed", true);
        return BLE_ATT_ERR_UNLIKELY;
    }
    command_buffer[packet_len] = '\0';

    const char *reusable_ui_command = reusable_ui_command_from_command(command_buffer);
    if (reusable_ui_command) {
        char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = {0};
        uint8_t att_error = queue_command_job(
            true,
            false,
            false,
            0,
            TABY_DISPLAY_ORIENTATION_MODE_LEFT,
            NULL,
            reusable_ui_command,
            event_payload,
            sizeof(event_payload));
        publish_event_payload(event_payload, true);
        return att_error;
    }

    uint8_t brightness_percent = 0;
    char brightness_error[48] = {0};
    if (parse_brightness_command(command_buffer, &brightness_percent, brightness_error, sizeof(brightness_error))) {
        char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = {0};
        if (brightness_error[0] != '\0') {
            snprintf(event_payload, sizeof(event_payload), "ERR %s", brightness_error);
            publish_event_payload(event_payload, true);
            return BLE_ATT_ERR_VALUE_NOT_ALLOWED;
        }

        uint8_t att_error = queue_command_job(
            false,
            true,
            false,
            brightness_percent,
            TABY_DISPLAY_ORIENTATION_MODE_LEFT,
            NULL,
            command_buffer,
            event_payload,
            sizeof(event_payload));
        publish_event_payload(event_payload, true);
        return att_error;
    }

    bool display_orientation_query = false;
    taby_display_orientation_mode_t display_orientation_mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
    char display_orientation_error[48] = {0};
    if (parse_display_orientation_command(
            command_buffer,
            &display_orientation_query,
            &display_orientation_mode,
            display_orientation_error,
            sizeof(display_orientation_error))) {
        char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = {0};
        if (display_orientation_error[0] != '\0') {
            snprintf(event_payload, sizeof(event_payload), "ERR %s", display_orientation_error);
            publish_event_payload(event_payload, true);
            return BLE_ATT_ERR_VALUE_NOT_ALLOWED;
        }

        if (display_orientation_query) {
            format_display_orientation_event(event_payload, sizeof(event_payload));
            publish_event_payload(event_payload, true);
            return 0;
        }

        if (display_orientation_mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO &&
            !board_amoled_1_64_display_orientation_auto_supported()) {
            snprintf(
                event_payload,
                sizeof(event_payload),
                "%s",
                "ERR display_orientation_auto_unsupported");
            publish_event_payload(event_payload, true);
            return BLE_ATT_ERR_VALUE_NOT_ALLOWED;
        }

        uint8_t att_error = queue_command_job(
            false,
            false,
            true,
            0,
            display_orientation_mode,
            NULL,
            command_buffer,
            event_payload,
            sizeof(event_payload));
        publish_event_payload(event_payload, true);
        return att_error;
    }

    taby_transport_resolution_t resolution = {0};
    if (!taby_transport_resolve_text(command_buffer, &resolution)) {
        char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = {0};
        snprintf(event_payload, sizeof(event_payload), "ERR unsupported_command");
        publish_event_payload(event_payload, true);
        ESP_LOGW(TAG, "unsupported BLE command: %s", command_buffer);
        return BLE_ATT_ERR_VALUE_NOT_ALLOWED;
    }

    char event_payload[TABY_BLE_EVENT_PAYLOAD_SIZE] = {0};
    uint8_t att_error = queue_command_job(
        false,
        false,
        false,
        0,
        TABY_DISPLAY_ORIENTATION_MODE_LEFT,
        &resolution,
        command_buffer,
        event_payload,
        sizeof(event_payload));
    publish_event_payload(event_payload, true);
    return att_error;
}

static int event_characteristic_access(
    uint16_t conn_handle,
    uint16_t attr_handle,
    struct ble_gatt_access_ctxt *ctxt,
    void *arg) {
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;

    if (ctxt->op != BLE_GATT_ACCESS_OP_READ_CHR) {
        return BLE_ATT_ERR_UNLIKELY;
    }

    if (os_mbuf_append(ctxt->om, s_last_event_payload, strlen(s_last_event_payload)) != 0) {
        return BLE_ATT_ERR_INSUFFICIENT_RES;
    }

    return 0;
}

static int state_characteristic_access(
    uint16_t conn_handle,
    uint16_t attr_handle,
    struct ble_gatt_access_ctxt *ctxt,
    void *arg) {
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;

    if (ctxt->op != BLE_GATT_ACCESS_OP_READ_CHR) {
        return BLE_ATT_ERR_UNLIKELY;
    }

    const char *state_name = taby_transport_state_name(taby_runtime_current_state());
    if (os_mbuf_append(ctxt->om, state_name, strlen(state_name)) != 0) {
        return BLE_ATT_ERR_INSUFFICIENT_RES;
    }

    return 0;
}

static int power_characteristic_access(
    uint16_t conn_handle,
    uint16_t attr_handle,
    struct ble_gatt_access_ctxt *ctxt,
    void *arg) {
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;

    if (ctxt->op != BLE_GATT_ACCESS_OP_READ_CHR) {
        return BLE_ATT_ERR_UNLIKELY;
    }

    taby_power_status_t power = taby_power_get_status();
    char payload[96];
    snprintf(
        payload,
        sizeof(payload),
        "{\"power_voltage_mv\":%d,\"battery_percent\":%d,\"external_power\":%s}",
        power.valid ? power.power_voltage_mv : 0,
        power.valid ? power.battery_percent : -1,
        (power.valid && power.external_power) ? "true" : "false");

    if (os_mbuf_append(ctxt->om, payload, strlen(payload)) != 0) {
        return BLE_ATT_ERR_INSUFFICIENT_RES;
    }

    return 0;
}

static const struct ble_gatt_svc_def k_gatt_services[] = {
    {
        .type = BLE_GATT_SVC_TYPE_PRIMARY,
        .uuid = &k_taby_service_uuid.u,
        .characteristics = (struct ble_gatt_chr_def[]) {
            {
                .uuid = &k_taby_command_characteristic_uuid.u,
                .access_cb = command_characteristic_access,
                .flags = BLE_GATT_CHR_F_WRITE | BLE_GATT_CHR_F_WRITE_NO_RSP,
                .val_handle = &s_command_value_handle,
            },
            {
                .uuid = &k_taby_event_characteristic_uuid.u,
                .access_cb = event_characteristic_access,
                .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_NOTIFY,
                .val_handle = &s_event_value_handle,
            },
            {
                .uuid = &k_taby_state_characteristic_uuid.u,
                .access_cb = state_characteristic_access,
                .flags = BLE_GATT_CHR_F_READ,
                .val_handle = &s_state_value_handle,
            },
            {
                .uuid = &k_taby_power_characteristic_uuid.u,
                .access_cb = power_characteristic_access,
                .flags = BLE_GATT_CHR_F_READ,
                .val_handle = &s_power_value_handle,
            },
            {0},
        },
    },
    {0},
};

static void request_fast_connection_params(uint16_t conn_handle) {
    struct ble_gap_upd_params params = {
        .itvl_min = TABY_BLE_FAST_CONN_ITVL_MIN,
        .itvl_max = TABY_BLE_FAST_CONN_ITVL_MAX,
        .latency = TABY_BLE_FAST_CONN_LATENCY,
        .supervision_timeout = TABY_BLE_FAST_CONN_SUPERVISION_TIMEOUT,
        .min_ce_len = 0,
        .max_ce_len = 0,
    };

    int rc = ble_gap_update_params(conn_handle, &params);
    if (rc != 0) {
        ESP_LOGW(TAG, "fast conn params request failed handle=%u rc=%d", conn_handle, rc);
    } else {
        ESP_LOGI(
            TAG,
            "fast conn params requested handle=%u itvl=%u-%u latency=%u timeout=%u",
            conn_handle,
            (unsigned int)params.itvl_min,
            (unsigned int)params.itvl_max,
            (unsigned int)params.latency,
            (unsigned int)params.supervision_timeout);
    }
}

static int gap_event_handler(struct ble_gap_event *event, void *arg) {
    (void)arg;

    switch (event->type) {
        case BLE_GAP_EVENT_CONNECT:
            if (event->connect.status == 0) {
                s_connection_handle = event->connect.conn_handle;
                s_notify_enabled = false;
                s_advertising = false;
                publish_event_payload("READY", false);
                clear_last_error();
                ESP_LOGI(TAG, "client connected handle=%u", event->connect.conn_handle);
                request_fast_connection_params(event->connect.conn_handle);
            } else {
                char error[64];
                snprintf(error, sizeof(error), "connect_status_%d", event->connect.status);
                set_last_error(error);
                ESP_LOGW(TAG, "connect failed status=%d", event->connect.status);
                start_advertising();
            }
            return 0;
        case BLE_GAP_EVENT_DISCONNECT:
            ESP_LOGI(
                TAG,
                "client disconnected handle=%u reason=%d",
                event->disconnect.conn.conn_handle,
                event->disconnect.reason);
            s_connection_handle = BLE_HS_CONN_HANDLE_NONE;
            s_notify_enabled = false;
            s_advertising = false;
            start_advertising();
            return 0;
        case BLE_GAP_EVENT_SUBSCRIBE:
            if (event->subscribe.attr_handle == s_event_value_handle) {
                s_notify_enabled = event->subscribe.cur_notify != 0;
                ESP_LOGI(TAG, "notify subscription=%d", s_notify_enabled ? 1 : 0);
                if (s_notify_enabled) {
                    notify_last_event_payload();
                }
            }
            return 0;
        case BLE_GAP_EVENT_CONN_UPDATE:
            ESP_LOGI(
                TAG,
                "conn params update handle=%u status=%d",
                event->conn_update.conn_handle,
                event->conn_update.status);
            return 0;
        case BLE_GAP_EVENT_ADV_COMPLETE:
            ESP_LOGI(TAG, "advertising complete reason=%d", event->adv_complete.reason);
            s_advertising = false;
            start_advertising();
            return 0;
        case BLE_GAP_EVENT_MTU:
            ESP_LOGI(TAG, "mtu updated value=%u", event->mtu.value);
            return 0;
        default:
            return 0;
    }
}

static void start_advertising(void) {
    struct ble_hs_adv_fields fields;
    memset(&fields, 0, sizeof(fields));
    fields.flags = BLE_HS_ADV_F_DISC_GEN | BLE_HS_ADV_F_BREDR_UNSUP;
    fields.uuids128 = (ble_uuid128_t *)&k_taby_service_uuid;
    fields.num_uuids128 = 1;
    fields.uuids128_is_complete = 1;

    int rc = ble_gap_adv_set_fields(&fields);
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "adv_set_fields_rc_%d", rc);
        set_last_error(error);
        s_advertising = false;
        ESP_LOGE(TAG, "adv set fields failed rc=%d", rc);
        return;
    }

    struct ble_hs_adv_fields response_fields;
    memset(&response_fields, 0, sizeof(response_fields));
    response_fields.name = (const uint8_t *)s_device_name;
    response_fields.name_len = strlen(s_device_name);
    response_fields.name_is_complete = 1;

    rc = ble_gap_adv_rsp_set_fields(&response_fields);
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "adv_rsp_set_fields_rc_%d", rc);
        set_last_error(error);
        s_advertising = false;
        ESP_LOGE(TAG, "adv rsp set fields failed rc=%d", rc);
        return;
    }

    struct ble_gap_adv_params adv_params;
    memset(&adv_params, 0, sizeof(adv_params));
    adv_params.conn_mode = BLE_GAP_CONN_MODE_UND;
    adv_params.disc_mode = BLE_GAP_DISC_MODE_GEN;

    rc = ble_gap_adv_start(
        s_own_addr_type,
        NULL,
        BLE_HS_FOREVER,
        &adv_params,
        gap_event_handler,
        NULL);
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "adv_start_rc_%d", rc);
        set_last_error(error);
        s_advertising = false;
        ESP_LOGE(TAG, "adv start failed rc=%d", rc);
        return;
    }

    clear_last_error();
    s_advertising = true;
    ESP_LOGI(TAG, "advertising started name=%s", s_device_name);
}

static void on_sync(void) {
    s_synced = true;
    int rc = ble_hs_id_infer_auto(0, &s_own_addr_type);
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "infer_addr_rc_%d", rc);
        set_last_error(error);
        ESP_LOGE(TAG, "infer addr type failed rc=%d", rc);
        return;
    }

    clear_last_error();
    start_advertising();
}

static void on_reset(int reason) {
    s_synced = false;
    ESP_LOGW(TAG, "host reset reason=%d", reason);
}

static void ble_host_task(void *param) {
    (void)param;
    nimble_port_run();
    nimble_port_freertos_deinit();
}

static void ble_command_task(void *param) {
    (void)param;

    taby_ble_command_job_t *job = NULL;
    for (;;) {
        if (xQueueReceive(s_command_queue, &job, portMAX_DELAY) != pdPASS || !job) {
            continue;
        }

        if (job->is_ui_command) {
            char ui_error[96] = {0};
            if (!taby_reusable_preview_render_ui_command(job->command_text, ui_error, sizeof(ui_error))) {
                snprintf(
                    job->event_payload,
                    sizeof(job->event_payload),
                    "ERR %s",
                    ui_error[0] ? ui_error : "ui_render_failed");
                job->att_error = BLE_ATT_ERR_VALUE_NOT_ALLOWED;
            } else {
                taby_mqtt_notify_state_changed("ble_ui_command");
                snprintf(
                    job->event_payload,
                    sizeof(job->event_payload),
                    "OK %s",
                    taby_transport_state_name(taby_runtime_current_state()));
                job->att_error = 0;
                ESP_LOGI(TAG, "ble ui command applied raw=%s mapped=%s", job->command_text, job->event_payload);
            }
        } else if (job->is_brightness_command) {
            if (!taby_runtime_set_brightness_percent(job->brightness_percent)) {
                snprintf(job->event_payload, sizeof(job->event_payload), "%s", "ERR brightness_set_failed");
                job->att_error = BLE_ATT_ERR_UNLIKELY;
            } else {
                snprintf(
                    job->event_payload,
                    sizeof(job->event_payload),
                    "OK BRIGHTNESS %u",
                    (unsigned int)job->brightness_percent);
                job->att_error = 0;
                ESP_LOGI(TAG, "ble brightness command applied raw=%s", job->command_text);
            }
        } else if (job->is_display_orientation_command) {
            if (!taby_runtime_set_display_orientation_mode(job->display_orientation_mode)) {
                snprintf(
                    job->event_payload,
                    sizeof(job->event_payload),
                    "%s",
                    "ERR display_orientation_set_failed");
                job->att_error = BLE_ATT_ERR_UNLIKELY;
            } else {
                format_display_orientation_event(
                    job->event_payload,
                    sizeof(job->event_payload));
                job->att_error = 0;
                ESP_LOGI(
                    TAG,
                    "ble display orientation command applied raw=%s rotation=%u",
                    job->command_text,
                    (unsigned int)board_amoled_1_64_display_rotation_degrees());
            }
        } else if (!taby_runtime_apply_transport_resolution(&job->resolution)) {
            snprintf(job->event_payload, sizeof(job->event_payload), "%s", "ERR runtime_unavailable");
            job->att_error = BLE_ATT_ERR_UNLIKELY;
        } else {
            taby_mqtt_notify_state_changed("ble_command");
            snprintf(
                job->event_payload,
                sizeof(job->event_payload),
                "OK %s",
                taby_transport_state_name(taby_runtime_current_state()));
            job->att_error = 0;
            ESP_LOGI(TAG, "ble command applied raw=%s mapped=%s", job->command_text, job->event_payload);
        }

        xTaskNotifyGive(job->requester);
    }
}

esp_err_t taby_ble_transport_init(const taby_identity_t *identity) {
    if (s_started) {
        return ESP_OK;
    }

    build_device_name(identity);
    clear_last_error();
    reset_transport_runtime_state();

    ESP_LOGI(
        TAG,
        "starting nimble device=%s controller_status=%d heap=%" PRIu32 " internal=%" PRIu32,
        s_device_name,
        bt_controller_status_for_log(),
        (uint32_t)esp_get_free_heap_size(),
        (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));

    esp_err_t nimble_err = nimble_port_init();
    if (nimble_err != ESP_OK) {
        if (nimble_err == ESP_ERR_INVALID_STATE && s_nimble_initialized) {
            ESP_LOGW(TAG, "nimble_port_init saw stale partial init; forcing deinit and retry");
            nimble_port_deinit();
            s_nimble_initialized = false;
            nimble_err = nimble_port_init();
        }
    }

    if (nimble_err != ESP_OK) {
        char error[64];
        snprintf(error, sizeof(error), "nimble_port_init_%s", esp_err_to_name(nimble_err));
        set_last_error(error);
        ESP_LOGE(
            TAG,
            "nimble_port_init failed err=%s controller_status=%d heap=%" PRIu32 " internal=%" PRIu32,
            esp_err_to_name(nimble_err),
            bt_controller_status_for_log(),
            (uint32_t)esp_get_free_heap_size(),
            (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));
        return nimble_err;
    }
    s_nimble_initialized = true;

    ESP_LOGI(
        TAG,
        "nimble_port_init ok controller_status=%d heap=%" PRIu32 " internal=%" PRIu32,
        bt_controller_status_for_log(),
        (uint32_t)esp_get_free_heap_size(),
        (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));

    int rc = init_gatt_services();
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "gatt_init_rc_%d", rc);
        set_last_error(error);
        ESP_LOGE(TAG, "gatt service init failed rc=%d", rc);
        nimble_port_deinit();
        s_nimble_initialized = false;
        reset_transport_runtime_state();
        return ESP_FAIL;
    }

    rc = ble_svc_gap_device_name_set(s_device_name);
    if (rc != 0) {
        char error[64];
        snprintf(error, sizeof(error), "gap_name_rc_%d", rc);
        set_last_error(error);
        ESP_LOGE(TAG, "gap device name set failed rc=%d", rc);
        nimble_port_deinit();
        s_nimble_initialized = false;
        reset_transport_runtime_state();
        return ESP_FAIL;
    }

    ble_hs_cfg.reset_cb = on_reset;
    ble_hs_cfg.sync_cb = on_sync;
    ble_hs_cfg.sm_bonding = 0;
    ble_hs_cfg.sm_mitm = 0;
    ble_hs_cfg.sm_sc = 0;

    if (!s_command_queue) {
        s_command_queue = xQueueCreate(TABY_BLE_COMMAND_QUEUE_LENGTH, sizeof(taby_ble_command_job_t *));
        if (!s_command_queue) {
            set_last_error("command_queue_create_failed");
            ESP_LOGE(TAG, "failed to create BLE command queue");
            nimble_port_deinit();
            s_nimble_initialized = false;
            reset_transport_runtime_state();
            return ESP_ERR_NO_MEM;
        }
    }

    if (!s_command_task_handle) {
        if (xTaskCreate(
                ble_command_task,
                "taby_ble_cmd",
                TABY_BLE_COMMAND_TASK_STACK_SIZE,
                NULL,
                4,
                &s_command_task_handle) != pdPASS) {
            set_last_error("command_task_create_failed");
            ESP_LOGE(
                TAG,
                "failed to create BLE command task stack=%d heap=%" PRIu32 " internal=%" PRIu32,
                TABY_BLE_COMMAND_TASK_STACK_SIZE,
                (uint32_t)esp_get_free_heap_size(),
                (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));
            vQueueDelete(s_command_queue);
            s_command_queue = NULL;
            nimble_port_deinit();
            s_nimble_initialized = false;
            reset_transport_runtime_state();
            return ESP_ERR_NO_MEM;
        }
    }

    nimble_port_freertos_init(ble_host_task);
    s_started = true;
    clear_last_error();
    ESP_LOGI(TAG, "nimble transport ready name=%s", s_device_name);
    return ESP_OK;
}

esp_err_t taby_ble_transport_shutdown(void) {
    if (!s_started && !s_nimble_initialized) {
        return ESP_OK;
    }

    ESP_LOGI(
        TAG,
        "stopping nimble controller_status=%d heap=%" PRIu32 " internal=%" PRIu32,
        bt_controller_status_for_log(),
        (uint32_t)esp_get_free_heap_size(),
        (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));

    if (s_advertising) {
        int adv_stop_rc = ble_gap_adv_stop();
        if (adv_stop_rc != 0 && adv_stop_rc != BLE_HS_EALREADY) {
            ESP_LOGW(TAG, "adv stop failed rc=%d", adv_stop_rc);
        }
    }

    if (s_connection_handle != BLE_HS_CONN_HANDLE_NONE) {
        int terminate_rc = ble_gap_terminate(s_connection_handle, BLE_ERR_REM_USER_CONN_TERM);
        if (terminate_rc != 0 && terminate_rc != BLE_HS_ENOTCONN) {
            ESP_LOGW(TAG, "connection terminate failed rc=%d", terminate_rc);
        }
    }

    if (s_started) {
        int stop_rc = nimble_port_stop();
        if (stop_rc != 0) {
            ESP_LOGE(TAG, "nimble_port_stop failed rc=%d", stop_rc);
            return ESP_FAIL;
        }
    }

    if (s_nimble_initialized) {
        nimble_port_deinit();
        s_nimble_initialized = false;
    }

    reset_transport_runtime_state();
    clear_last_error();

    ESP_LOGI(
        TAG,
        "nimble stopped controller_status=%d heap=%" PRIu32 " internal=%" PRIu32,
        bt_controller_status_for_log(),
        (uint32_t)esp_get_free_heap_size(),
        (uint32_t)heap_caps_get_free_size(MALLOC_CAP_INTERNAL));
    return ESP_OK;
}

void taby_ble_transport_ensure_advertising(void) {
    if (!s_started || !s_synced) {
        return;
    }

    if (s_connection_handle != BLE_HS_CONN_HANDLE_NONE || s_advertising) {
        return;
    }

    start_advertising();
}

bool taby_ble_transport_is_ready(void) {
    return s_started;
}

bool taby_ble_transport_is_advertising(void) {
    return s_advertising;
}

bool taby_ble_transport_is_connected(void) {
    return s_connection_handle != BLE_HS_CONN_HANDLE_NONE;
}

const char *taby_ble_transport_device_name(void) {
    return s_device_name;
}

const char *taby_ble_transport_last_error(void) {
    return s_last_error;
}
