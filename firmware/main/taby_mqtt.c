#include "taby_mqtt.h"

#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include "cJSON.h"
#include "esp_check.h"
#include "esp_crt_bundle.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "mqtt_client.h"
#include "taby_identity.h"
#include "taby_runtime.h"
#include "taby_state_machine.h"
#include "taby_transport_protocol.h"
#include "taby_wifi.h"

static const char *TAG = "taby_mqtt";
static const char *TABY_MQTT_BROKER_URI = "mqtts://mqtt.heytaby.com:8883";
static const char *TABY_MQTT_TOPIC_PREFIX = "devices";
static const uint32_t TABY_MQTT_STATE_INTERVAL_MS = 15000;

typedef struct {
    bool initialized;
    bool enabled;
    bool connected;
    esp_mqtt_client_handle_t client;
    char topic_cmd[96];
    char topic_ack[96];
    char topic_state[96];
} taby_mqtt_status_t;

static taby_mqtt_status_t s_status = {0};
static TaskHandle_t s_state_task_handle = NULL;

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

static void set_resolution_from_command(taby_transport_resolution_t *resolution, taby_command_t command) {
    if (!resolution) {
        return;
    }

    memset(resolution, 0, sizeof(*resolution));
    resolution->command = command;
}

static void publish_json(const char *topic, cJSON *root) {
    if (!s_status.connected || !s_status.client || !topic || !root) {
        return;
    }

    char *payload = cJSON_PrintUnformatted(root);
    if (!payload) {
        return;
    }

    int msg_id = esp_mqtt_client_publish(s_status.client, topic, payload, 0, 1, 0);
    if (msg_id < 0) {
        ESP_LOGW(TAG, "mqtt publish failed topic=%s", topic);
    }
    cJSON_free(payload);
}

static void publish_state_internal(const char *reason) {
    const taby_identity_t *identity = taby_identity_get();
    if (!identity || !s_status.enabled || !s_status.connected) {
        return;
    }

    cJSON *root = cJSON_CreateObject();
    if (!root) {
        return;
    }

    cJSON_AddStringToObject(root, "device_id", identity->device_id);
    cJSON_AddStringToObject(root, "state", taby_state_name(taby_runtime_current_state()));
    cJSON_AddStringToObject(root, "wifi_mode", taby_wifi_mode_name());
    cJSON_AddBoolToObject(root, "connected", taby_wifi_is_connected());
    if (reason && reason[0] != '\0') {
        cJSON_AddStringToObject(root, "reason", reason);
    }
    cJSON_AddNumberToObject(root, "ts_ms", (double)(esp_timer_get_time() / 1000));

    publish_json(s_status.topic_state, root);
    cJSON_Delete(root);
}

static void publish_ack(bool ok, const char *input, const char *resolved_command, const char *error_message) {
    const taby_identity_t *identity = taby_identity_get();
    if (!identity || !s_status.enabled || !s_status.connected) {
        return;
    }

    cJSON *root = cJSON_CreateObject();
    if (!root) {
        return;
    }

    cJSON_AddBoolToObject(root, "ok", ok);
    cJSON_AddStringToObject(root, "device_id", identity->device_id);
    cJSON_AddStringToObject(root, "state", taby_state_name(taby_runtime_current_state()));
    if (input && input[0] != '\0') {
        cJSON_AddStringToObject(root, "input", input);
    }
    if (resolved_command && resolved_command[0] != '\0') {
        cJSON_AddStringToObject(root, "command", resolved_command);
    }
    if (error_message && error_message[0] != '\0') {
        cJSON_AddStringToObject(root, "error", error_message);
    }

    publish_json(s_status.topic_ack, root);
    cJSON_Delete(root);
}

static bool parse_payload_to_resolution(
    const char *payload,
    size_t payload_len,
    taby_transport_resolution_t *out_resolution,
    char *input_name,
    size_t input_name_size) {
    if (!payload || !out_resolution || !input_name || input_name_size == 0) {
        return false;
    }

    input_name[0] = '\0';

    char buffer[384];
    if (payload_len >= sizeof(buffer)) {
        return false;
    }
    memcpy(buffer, payload, payload_len);
    buffer[payload_len] = '\0';

    cJSON *root = cJSON_Parse(buffer);
    if (!root) {
        taby_command_t command = TABY_COMMAND_NONE;
        if (taby_transport_resolve_text(buffer, out_resolution)) {
            copy_string_field(input_name, input_name_size, buffer);
            return true;
        }
        if (taby_command_from_string(buffer, &command)) {
            set_resolution_from_command(out_resolution, command);
            copy_string_field(input_name, input_name_size, buffer);
            return true;
        }
        return false;
    }

    const cJSON *command = cJSON_GetObjectItemCaseSensitive(root, "command");

    bool parsed = false;
    if (cJSON_IsString(command) && command->valuestring) {
        taby_command_t mapped_command = TABY_COMMAND_NONE;
        parsed = taby_transport_resolve_text(command->valuestring, out_resolution);
        if (!parsed && taby_transport_command_from_text(command->valuestring, &mapped_command)) {
            set_resolution_from_command(out_resolution, mapped_command);
            parsed = true;
        }
        if (parsed) {
            copy_string_field(input_name, input_name_size, command->valuestring);
        }
    }

    cJSON_Delete(root);
    return parsed;
}

static void handle_mqtt_command(const char *payload, size_t payload_len) {
    taby_transport_resolution_t resolution = {0};
    char input_name[64] = {0};

    if (!parse_payload_to_resolution(payload, payload_len, &resolution, input_name, sizeof(input_name))) {
        ESP_LOGW(TAG, "mqtt command rejected");
        publish_ack(false, input_name, NULL, "unsupported command");
        return;
    }

    if (!taby_runtime_apply_transport_resolution(&resolution)) {
        publish_ack(false, input_name, taby_state_name(taby_runtime_current_state()), "runtime unavailable");
        return;
    }

    publish_ack(true, input_name, taby_state_name(taby_runtime_current_state()), NULL);
    publish_state_internal("mqtt_command");
}

static void mqtt_state_task(void *arg) {
    (void)arg;

    while (true) {
        vTaskDelay(pdMS_TO_TICKS(TABY_MQTT_STATE_INTERVAL_MS));
        publish_state_internal("heartbeat");
    }
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data) {
    (void)handler_args;
    (void)base;

    esp_mqtt_event_handle_t event = event_data;
    if (!event) {
        return;
    }

    switch ((esp_mqtt_event_id_t)event_id) {
        case MQTT_EVENT_CONNECTED:
            s_status.connected = true;
            ESP_LOGI(TAG, "mqtt connected topic=%s", s_status.topic_cmd);
            esp_mqtt_client_subscribe(s_status.client, s_status.topic_cmd, 1);
            publish_state_internal("connected");
            break;
        case MQTT_EVENT_DISCONNECTED:
            s_status.connected = false;
            ESP_LOGW(TAG, "mqtt disconnected");
            break;
        case MQTT_EVENT_DATA: {
            if (!event->topic || !event->data) {
                break;
            }

            if ((size_t)event->topic_len == strlen(s_status.topic_cmd) &&
                strncmp(event->topic, s_status.topic_cmd, event->topic_len) == 0) {
                handle_mqtt_command(event->data, event->data_len);
            }
            break;
        }
        case MQTT_EVENT_ERROR:
            ESP_LOGW(TAG, "mqtt error event");
            break;
        default:
            break;
    }
}

esp_err_t taby_mqtt_init(const taby_identity_t *identity) {
    if (s_status.initialized) {
        return ESP_OK;
    }

    s_status.initialized = true;

    if (!identity || !identity->has_factory_data) {
        ESP_LOGW(TAG, "mqtt disabled: factory identity missing");
        return ESP_OK;
    }

    if (!taby_wifi_is_provisioned()) {
        ESP_LOGW(TAG, "mqtt disabled: wifi not provisioned");
        return ESP_OK;
    }

    snprintf(s_status.topic_cmd, sizeof(s_status.topic_cmd), "%s/%s/cmd", TABY_MQTT_TOPIC_PREFIX, identity->device_id);
    snprintf(s_status.topic_ack, sizeof(s_status.topic_ack), "%s/%s/ack", TABY_MQTT_TOPIC_PREFIX, identity->device_id);
    snprintf(s_status.topic_state, sizeof(s_status.topic_state), "%s/%s/state", TABY_MQTT_TOPIC_PREFIX, identity->device_id);

    esp_mqtt_client_config_t config = {
        .broker.address.uri = TABY_MQTT_BROKER_URI,
        .broker.verification.crt_bundle_attach = esp_crt_bundle_attach,
        .credentials.username = identity->device_id,
        .credentials.authentication.password = identity->device_secret,
        .session.keepalive = 30,
        .network.disable_auto_reconnect = false,
    };

    s_status.client = esp_mqtt_client_init(&config);
    if (!s_status.client) {
        return ESP_FAIL;
    }

    ESP_RETURN_ON_ERROR(
        esp_mqtt_client_register_event(s_status.client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL),
        TAG,
        "mqtt register event failed");
    ESP_RETURN_ON_ERROR(esp_mqtt_client_start(s_status.client), TAG, "mqtt start failed");

    s_status.enabled = true;
    if (!s_state_task_handle) {
        xTaskCreate(mqtt_state_task, "taby_mqtt_state", 4096, NULL, 4, &s_state_task_handle);
    }

    ESP_LOGI(TAG, "mqtt enabled broker=%s", TABY_MQTT_BROKER_URI);
    return ESP_OK;
}

void taby_mqtt_shutdown(void) {
    if (s_state_task_handle) {
        vTaskDelete(s_state_task_handle);
        s_state_task_handle = NULL;
    }

    if (s_status.client) {
        esp_mqtt_client_stop(s_status.client);
        esp_mqtt_client_destroy(s_status.client);
        s_status.client = NULL;
    }

    memset(&s_status, 0, sizeof(s_status));
    ESP_LOGI(TAG, "mqtt stopped");
}

bool taby_mqtt_enabled(void) {
    return s_status.enabled;
}

bool taby_mqtt_connected(void) {
    return s_status.connected;
}

const char *taby_mqtt_broker_uri(void) {
    return TABY_MQTT_BROKER_URI;
}

void taby_mqtt_notify_state_changed(const char *reason) {
    publish_state_internal(reason);
}
