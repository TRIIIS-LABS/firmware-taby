#include "taby_power_button.h"

#include <stdbool.h>

#include "driver/gpio.h"
#include "esp_log.h"
#include "esp_sleep.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "board_amoled_1_64.h"
#include "taby_runtime.h"

static const char *TAG = "taby_power_button";

#define TABY_BOOT_BUTTON_GPIO GPIO_NUM_0
#define TABY_BOOT_BUTTON_DEEP_SLEEP_PRESS_US (5000 * 1000LL)
#define TABY_BOOT_BUTTON_POLL_MS 50

static TaskHandle_t s_button_task_handle = NULL;

static void enter_deep_sleep(void) {
    ESP_LOGI(TAG, "BOOT long press entering deep sleep; wake with RST or USB-C reset");
    (void)taby_runtime_set_display_awake(false);

    esp_err_t err = esp_sleep_disable_wakeup_source(ESP_SLEEP_WAKEUP_ALL);
    if (err != ESP_OK) {
        ESP_LOGW(TAG, "failed to disable wake sources before deep sleep: %s", esp_err_to_name(err));
    }

    vTaskDelay(pdMS_TO_TICKS(150));
    esp_deep_sleep_start();
}

static void power_button_task(void *arg) {
    (void)arg;

    bool press_active = false;
    bool long_press_handled = false;
    int64_t press_start_us = 0;
    uint32_t last_touch_signal = board_amoled_1_64_touch_signal();

    while (true) {
        bool pressed = gpio_get_level(TABY_BOOT_BUTTON_GPIO) == 0;
        int64_t now_us = esp_timer_get_time();
        uint32_t touch_signal = board_amoled_1_64_touch_signal();

        if (touch_signal != last_touch_signal) {
            last_touch_signal = touch_signal;
            if (!taby_runtime_display_awake()) {
                (void)taby_runtime_set_display_awake(true);
                ESP_LOGI(TAG, "touch woke display");
            }
        }

        if (pressed && !press_active) {
            press_active = true;
            long_press_handled = false;
            press_start_us = now_us;
        } else if (pressed && !long_press_handled &&
                   now_us - press_start_us >= TABY_BOOT_BUTTON_DEEP_SLEEP_PRESS_US) {
            long_press_handled = true;
            enter_deep_sleep();
        } else if (!pressed) {
            press_active = false;
            long_press_handled = false;
        }

        vTaskDelay(pdMS_TO_TICKS(TABY_BOOT_BUTTON_POLL_MS));
    }
}

esp_err_t taby_power_button_start(void) {
    if (s_button_task_handle) {
        return ESP_OK;
    }

    gpio_config_t io_conf = {
        .pin_bit_mask = 1ULL << TABY_BOOT_BUTTON_GPIO,
        .mode = GPIO_MODE_INPUT,
        .pull_up_en = GPIO_PULLUP_ENABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    esp_err_t err = gpio_config(&io_conf);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "failed to configure BOOT GPIO: %s", esp_err_to_name(err));
        return err;
    }

    if (xTaskCreate(
            power_button_task,
            "taby_power_button",
            2048,
            NULL,
            4,
            &s_button_task_handle) != pdPASS) {
        s_button_task_handle = NULL;
        return ESP_ERR_NO_MEM;
    }

    ESP_LOGI(TAG, "BOOT long-press deep sleep enabled");
    return ESP_OK;
}
