#include "board_amoled_1_64.h"
#include "esp_log.h"
#include "taby_asset_store.h"
#include "taby_ble_transport.h"
#include "taby_identity.h"
#include "taby_onboarding.h"
#include "taby_power.h"
#include "taby_power_button.h"
#include "taby_reusable_ui.h"
#include "taby_runtime.h"
#include "taby_transport_prefs.h"
#include "taby_usb_serial.h"
#include "taby_wifi.h"

static const char *TAG = "taby_firmware";

static void apply_factory_usb_shipping_default_if_needed(void) {
    const taby_identity_t *identity = taby_identity_get();
    if (!identity || !identity->has_factory_data) {
        return;
    }

    if (taby_transport_onboarding_complete()) {
        return;
    }

    if (taby_transport_preferred_mode() != TABY_TRANSPORT_PREF_UNKNOWN) {
        return;
    }

    esp_err_t err = taby_transport_mark_onboarded(TABY_TRANSPORT_PREF_USB);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to apply factory USB shipping default: %s", esp_err_to_name(err));
    } else {
        ESP_LOGI(TAG, "Applied factory USB shipping default for fresh board");
    }
}

void app_main(void) {
    ESP_LOGI(TAG, "Booting new Taby production firmware scaffold");
    ESP_LOGI(TAG, "Boot mode: ambient_runtime");
    ESP_LOGI(TAG, "Next blockers: provisioning, MQTT transport, recovery/update flow");

    // Identity initializes NVS before display bring-up so device-owned display
    // orientation is restored before the first visible frame is rendered.
    ESP_ERROR_CHECK(taby_identity_init());
    ESP_ERROR_CHECK(board_amoled_1_64_init());
    taby_reusable_ui_start();
    taby_asset_store_init();
    taby_runtime_start();
    ESP_ERROR_CHECK(taby_power_button_start());
    ESP_ERROR_CHECK(taby_usb_serial_init());
    ESP_ERROR_CHECK(taby_transport_prefs_init());
    ESP_ERROR_CHECK(taby_transport_reset_incomplete_on_boot());
    apply_factory_usb_shipping_default_if_needed();
    ESP_ERROR_CHECK(taby_power_init());
    ESP_ERROR_CHECK(taby_wifi_init(taby_identity_get()));
    taby_transport_pref_t preferred_transport = taby_transport_preferred_mode();
    bool onboarding_complete = taby_transport_onboarding_complete();
    bool should_start_bluetooth =
        preferred_transport == TABY_TRANSPORT_PREF_BLUETOOTH ||
        (!onboarding_complete && preferred_transport == TABY_TRANSPORT_PREF_UNKNOWN);
    if (should_start_bluetooth) {
        esp_err_t ble_err = taby_ble_transport_init(taby_identity_get());
        if (ble_err != ESP_OK) {
            ESP_LOGE(TAG, "Bluetooth transport init failed: %s", esp_err_to_name(ble_err));
        }
    }
    taby_onboarding_start();
}
