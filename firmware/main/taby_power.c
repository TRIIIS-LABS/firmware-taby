#include "taby_power.h"

#include <string.h>

#include "esp_adc/adc_cali.h"
#include "esp_adc/adc_cali_scheme.h"
#include "esp_adc/adc_oneshot.h"
#include "esp_check.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/semphr.h"

static const char *TAG = "taby_power";

#define TABY_POWER_ADC_CHANNEL ADC_CHANNEL_3
#define TABY_POWER_SAMPLE_MULTIPLIER 3
#define TABY_POWER_CACHE_TTL_US (30LL * 1000LL * 1000LL)
// A 1S LiPo should not sit above the charge CV range on its own. Treat higher
// readings as USB/charger rail presence instead of reporting a false 100%.
#define TABY_POWER_EXTERNAL_THRESHOLD_MV 4250

static SemaphoreHandle_t s_power_lock = NULL;
static adc_oneshot_unit_handle_t s_adc_unit = NULL;
static adc_cali_handle_t s_cali_handle = NULL;
static bool s_cali_available = false;
static bool s_initialized = false;
static int64_t s_cached_at_us = 0;
static taby_power_status_t s_cached_status = {
    .valid = false,
    .power_voltage_mv = 0,
    .battery_percent = -1,
    .external_power = false,
};

static int interpolate_percent(int mv, int low_mv, int high_mv, int low_percent, int high_percent) {
    if (mv <= low_mv) {
        return low_percent;
    }
    if (mv >= high_mv) {
        return high_percent;
    }

    int span_mv = high_mv - low_mv;
    int span_percent = high_percent - low_percent;
    return low_percent + ((mv - low_mv) * span_percent) / span_mv;
}

static int estimate_battery_percent(int mv) {
    if (mv <= 3300) {
        return 0;
    }
    if (mv <= 3600) {
        return interpolate_percent(mv, 3300, 3600, 0, 10);
    }
    if (mv <= 3700) {
        return interpolate_percent(mv, 3600, 3700, 10, 20);
    }
    if (mv <= 3800) {
        return interpolate_percent(mv, 3700, 3800, 20, 40);
    }
    if (mv <= 3900) {
        return interpolate_percent(mv, 3800, 3900, 40, 60);
    }
    if (mv <= 4000) {
        return interpolate_percent(mv, 3900, 4000, 60, 75);
    }
    if (mv <= 4100) {
        return interpolate_percent(mv, 4000, 4100, 75, 90);
    }
    if (mv <= 4200) {
        return interpolate_percent(mv, 4100, 4200, 90, 100);
    }
    return 100;
}

static esp_err_t ensure_power_init_locked(void) {
    if (s_initialized) {
        return ESP_OK;
    }

    adc_oneshot_unit_init_cfg_t init_cfg = {
        .unit_id = ADC_UNIT_1,
    };
    ESP_RETURN_ON_ERROR(adc_oneshot_new_unit(&init_cfg, &s_adc_unit), TAG, "adc unit init failed");

    adc_oneshot_chan_cfg_t channel_cfg = {
        .atten = ADC_ATTEN_DB_12,
        .bitwidth = ADC_BITWIDTH_12,
    };
    ESP_RETURN_ON_ERROR(
        adc_oneshot_config_channel(s_adc_unit, TABY_POWER_ADC_CHANNEL, &channel_cfg),
        TAG,
        "adc channel config failed");

    adc_cali_curve_fitting_config_t cali_cfg = {
        .unit_id = ADC_UNIT_1,
        .atten = ADC_ATTEN_DB_12,
        .bitwidth = ADC_BITWIDTH_12,
    };
    if (adc_cali_create_scheme_curve_fitting(&cali_cfg, &s_cali_handle) == ESP_OK) {
        s_cali_available = true;
    } else {
        ESP_LOGW(TAG, "adc calibration unavailable, falling back to raw scaling");
    }

    s_initialized = true;
    return ESP_OK;
}

static taby_power_status_t sample_power_status_locked(void) {
    taby_power_status_t status = {
        .valid = false,
        .power_voltage_mv = 0,
        .battery_percent = -1,
        .external_power = false,
    };

    if (ensure_power_init_locked() != ESP_OK) {
        return status;
    }

    int raw = 0;
    esp_err_t read_err = adc_oneshot_read(s_adc_unit, TABY_POWER_ADC_CHANNEL, &raw);
    if (read_err != ESP_OK) {
        ESP_LOGW(TAG, "adc read failed: %s", esp_err_to_name(read_err));
        return status;
    }

    int sensed_mv = 0;
    if (s_cali_available) {
        int calibrated_mv = 0;
        if (adc_cali_raw_to_voltage(s_cali_handle, raw, &calibrated_mv) == ESP_OK) {
            sensed_mv = calibrated_mv * TABY_POWER_SAMPLE_MULTIPLIER;
        }
    }

    if (sensed_mv <= 0) {
        sensed_mv = (raw * 3300 / 4095) * TABY_POWER_SAMPLE_MULTIPLIER;
    }

    status.valid = sensed_mv > 0;
    status.power_voltage_mv = sensed_mv;
    status.external_power = sensed_mv >= TABY_POWER_EXTERNAL_THRESHOLD_MV;
    status.battery_percent = status.external_power ? -1 : estimate_battery_percent(sensed_mv);
    return status;
}

esp_err_t taby_power_init(void) {
    if (!s_power_lock) {
        s_power_lock = xSemaphoreCreateMutex();
        if (!s_power_lock) {
            return ESP_ERR_NO_MEM;
        }
    }

    if (xSemaphoreTake(s_power_lock, pdMS_TO_TICKS(200)) != pdTRUE) {
        return ESP_ERR_TIMEOUT;
    }

    esp_err_t err = ensure_power_init_locked();
    xSemaphoreGive(s_power_lock);
    return err;
}

taby_power_status_t taby_power_get_status(void) {
    if (!s_power_lock && taby_power_init() != ESP_OK) {
        return s_cached_status;
    }

    if (xSemaphoreTake(s_power_lock, pdMS_TO_TICKS(200)) != pdTRUE) {
        return s_cached_status;
    }

    int64_t now_us = esp_timer_get_time();
    if ((now_us - s_cached_at_us) >= TABY_POWER_CACHE_TTL_US || !s_cached_status.valid) {
        s_cached_status = sample_power_status_locked();
        s_cached_at_us = now_us;
    }

    taby_power_status_t status = s_cached_status;
    xSemaphoreGive(s_power_lock);
    return status;
}
