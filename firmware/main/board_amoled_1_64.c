#include "board_amoled_1_64.h"

#include <assert.h>
#include <ctype.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "driver/gpio.h"
#include "driver/i2c.h"
#include "driver/spi_master.h"
#include "esp_check.h"
#include "esp_heap_caps.h"
#include "esp_lcd_panel_io.h"
#include "esp_lcd_panel_ops.h"
#include "esp_lcd_sh8601.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/semphr.h"
#include "freertos/task.h"
#include "nvs.h"

static const char *TAG = "board_1_64";

#define LCD_HOST SPI2_HOST
#define LCD_BIT_PER_PIXEL 16

#if TABY_HARDWARE_ROUND_1_32
#define PIN_NUM_LCD_CS GPIO_NUM_10
#define PIN_NUM_LCD_PCLK GPIO_NUM_11
#define PIN_NUM_LCD_DATA0 GPIO_NUM_12
#define PIN_NUM_LCD_DATA1 GPIO_NUM_13
#define PIN_NUM_LCD_DATA2 GPIO_NUM_14
#define PIN_NUM_LCD_DATA3 GPIO_NUM_15
#define PIN_NUM_LCD_RST GPIO_NUM_8
#define PIN_NUM_TOUCH_RST GPIO_NUM_7
#define PIN_NUM_SYSTEM_POWER GPIO_NUM_18

#define DISP_W 466
#define DISP_H 466
#define DISP_X_OFFSET 0x06
#define DISP_DRAW_BUF_LINES 30
#define BOARD_MODEL_LOG "Round 1.32 AMOLED"
#else
#define PIN_NUM_LCD_CS GPIO_NUM_9
#define PIN_NUM_LCD_PCLK GPIO_NUM_10
#define PIN_NUM_LCD_DATA0 GPIO_NUM_11
#define PIN_NUM_LCD_DATA1 GPIO_NUM_12
#define PIN_NUM_LCD_DATA2 GPIO_NUM_13
#define PIN_NUM_LCD_DATA3 GPIO_NUM_14
#define PIN_NUM_LCD_RST GPIO_NUM_21

#define DISP_W 280
#define DISP_H 456
#define DISP_X_OFFSET 0x14
#define DISP_DRAW_BUF_LINES (DISP_H / 4)
#define BOARD_MODEL_LOG "1.64 AMOLED"
#endif

#define BOARD_I2C_PORT I2C_NUM_0
#define BOARD_I2C_SCL GPIO_NUM_48
#define BOARD_I2C_SDA GPIO_NUM_47
#define BOARD_I2C_FREQ_HZ (300 * 1000)

#if TABY_HARDWARE_ROUND_1_32
#define TOUCH_ADDR 0x15
#else
#define TOUCH_ADDR 0x38
#endif
#define TOUCH_INIT_RETRY_COUNT 8
#define TOUCH_INIT_RETRY_DELAY_MS 25
#define TOUCH_TAP_MIN_US (60 * 1000LL)
#define TOUCH_TAP_MAX_US (700 * 1000LL)
#define TOUCH_TAP_REARM_US (180 * 1000LL)
#define LCD_CMD_MEMORY_ACCESS_CONTROL 0x36U
#define LCD_CMD_SET_BRIGHTNESS 0x51U
#define LCD_DEFAULT_BRIGHTNESS_PERCENT 100
#define TABY_DISPLAY_PREFS_NAMESPACE "taby_display"
#define TABY_DISPLAY_ORIENTATION_KEY "orientation"

#if TABY_HARDWARE_ROUND_1_32
#define TABY_DISPLAY_ORIENTATION_DEFAULT_MODE TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90
#else
#define TABY_DISPLAY_ORIENTATION_DEFAULT_MODE TABY_DISPLAY_ORIENTATION_MODE_AUTO
#define QMI8658_I2C_ADDR 0x6BU
#define QMI8658_REG_WHO_AM_I 0x00U
#define QMI8658_REG_REVISION_ID 0x01U
#define QMI8658_REG_CTRL1 0x02U
#define QMI8658_REG_CTRL2 0x03U
#define QMI8658_REG_CTRL3 0x04U
#define QMI8658_REG_CTRL5 0x06U
#define QMI8658_REG_CTRL7 0x08U
#define QMI8658_REG_ACCEL_X_L 0x35U
#define QMI8658_WHO_AM_I_VALUE 0x05U
#define QMI8658_CTRL1_AUTO_INCREMENT_LITTLE_ENDIAN 0x40U
#define QMI8658_CTRL2_ACCEL_2G_LOW_POWER_21HZ 0x0DU
#define QMI8658_CTRL5_ACCEL_LPF_MODE_3 0x07U
#define QMI8658_CTRL7_ACCEL_ONLY 0x01U
#define QMI8658_COUNTS_PER_G 16384
#define ORIENTATION_SAMPLE_INTERVAL_MS 100U
#define ORIENTATION_STABLE_MS 1200U
#define ORIENTATION_BOOT_SAMPLE_BUDGET_MS 1500U
#define ORIENTATION_AXIS_ENTER_RAW 8192
#define ORIENTATION_AXIS_HOLD_RAW 6554
#define ORIENTATION_CROSS_AXIS_MAX_RAW 14746
#define ORIENTATION_FLAT_AXIS_RAW 14746
#define ORIENTATION_MOVEMENT_DELTA_RAW 2949
#define ORIENTATION_NORM_MIN_SQUARED (int64_t)(11469LL * 11469LL)
#define ORIENTATION_NORM_MAX_SQUARED (int64_t)(26214LL * 26214LL)
#define ORIENTATION_DOMINANT_AXIS_MULTIPLIER 10
#define ORIENTATION_CROSS_AXIS_MULTIPLIER 11
// Physical calibration for the Waveshare 1.64 board: in the Right-side pose,
// gravity reads on +Y, so the inverse -Y pose is Left. Raw XYZ remains exposed
// through INFO/DIAG for hardware diagnostics.
#define ORIENTATION_LEFT_GRAVITY_SIGN -1
#endif

static esp_lcd_panel_handle_t s_panel_handle = NULL;
static esp_lcd_panel_io_handle_t s_panel_io_handle = NULL;
static SemaphoreHandle_t s_lvgl_mutex = NULL;
static SemaphoreHandle_t s_i2c_mutex = NULL;
static lv_disp_t *s_display = NULL;
static lv_indev_t *s_input_device = NULL;
static lv_disp_draw_buf_t s_draw_buf;
static lv_disp_drv_t s_disp_drv;
static lv_indev_drv_t s_indev_drv;
#if TABY_HARDWARE_ROUND_1_32
static lv_color_t *s_rotation_buf = NULL;
#endif
static esp_timer_handle_t s_tick_timer = NULL;
static board_amoled_1_64_touch_sample_t s_last_touch = {0};
static bool s_touch_press_active = false;
static int64_t s_touch_press_start_us = 0;
static int64_t s_touch_last_tap_us = 0;
static uint32_t s_touch_signal = 0;
static portMUX_TYPE s_touch_signal_lock = portMUX_INITIALIZER_UNLOCKED;
static uint8_t s_brightness_percent = LCD_DEFAULT_BRIGHTNESS_PERCENT;
static uint8_t s_resume_brightness_percent = LCD_DEFAULT_BRIGHTNESS_PERCENT;
static uint8_t s_brightness_raw = 0xFF;
static bool s_display_enabled = true;
static bool s_display_orientation_loaded = false;
static taby_display_orientation_t s_display_orientation = TABY_DISPLAY_ORIENTATION_LEFT;
static taby_display_orientation_mode_t s_display_orientation_mode =
    TABY_DISPLAY_ORIENTATION_DEFAULT_MODE;
static bool s_touch_suppress_until_release = false;
static portMUX_TYPE s_orientation_state_lock = portMUX_INITIALIZER_UNLOCKED;
static taby_orientation_imu_diagnostics_t s_orientation_imu = {
#if TABY_HARDWARE_ROUND_1_32
    .supported = false,
    .available = false,
    .state = TABY_ORIENTATION_IMU_UNAVAILABLE,
#else
    .supported = true,
    .available = false,
    .state = TABY_ORIENTATION_IMU_UNAVAILABLE,
#endif
};

#if !TABY_HARDWARE_ROUND_1_32
static bool s_orientation_imu_has_previous_sample = false;
static int16_t s_orientation_imu_previous_x = 0;
static int16_t s_orientation_imu_previous_y = 0;
static int16_t s_orientation_imu_previous_z = 0;
static int64_t s_orientation_imu_last_sample_us = 0;
static int64_t s_orientation_candidate_since_us = 0;
#endif

static const sh8601_lcd_init_cmd_t s_lcd_init_cmds[] = {
#if TABY_HARDWARE_ROUND_1_32
    {0xFE, (uint8_t[]){0x00}, 1, 0},
    {0xC4, (uint8_t[]){0x80}, 1, 0},
    {0x3A, (uint8_t[]){0x55}, 1, 0},
    {0x35, (uint8_t[]){0x00}, 1, 0},
    {0x53, (uint8_t[]){0x20}, 1, 0},
    {0x51, (uint8_t[]){0xFF}, 1, 0},
    {0x63, (uint8_t[]){0xFF}, 1, 0},
    {0x36, (uint8_t[]){0xC0}, 1, 0},
    {0x2A, (uint8_t[]){0x00, 0x06, 0x01, 0xD7}, 4, 0},
    {0x2B, (uint8_t[]){0x00, 0x00, 0x01, 0xD1}, 4, 0},
    {0x11, (uint8_t[]){0x00}, 0, 100},
    {0x29, (uint8_t[]){0x00}, 0, 0},
#else
    {0x11, (uint8_t[]){0x00}, 0, 80},
    {0xC4, (uint8_t[]){0x80}, 1, 0},
    {0x35, (uint8_t[]){0x00}, 1, 0},
    {0x53, (uint8_t[]){0x20}, 1, 1},
    {0x63, (uint8_t[]){0xFF}, 1, 1},
    {0x51, (uint8_t[]){0x00}, 1, 1},
    {0x29, (uint8_t[]){0x00}, 0, 10},
    {0x51, (uint8_t[]){0xFF}, 1, 0},
#endif
};

static uint32_t lcd_qspi_param_command(uint8_t command) {
    // SH8601 QSPI runtime register writes need the same command envelope used
    // by the Waveshare demo; sending plain 0x51 can ACK without changing OLED
    // brightness.
    uint32_t lcd_cmd = command;
    lcd_cmd &= 0xffU;
    lcd_cmd <<= 8;
    lcd_cmd |= 0x02U << 24;
    return lcd_cmd;
}

static const char *display_orientation_name_for_value(taby_display_orientation_t orientation) {
    switch (orientation) {
        case TABY_DISPLAY_ORIENTATION_RIGHT:
            return "right";
        case TABY_DISPLAY_ORIENTATION_ROTATE_90:
            return "90";
        case TABY_DISPLAY_ORIENTATION_ROTATE_270:
            return "270";
        case TABY_DISPLAY_ORIENTATION_LEFT:
        default:
            return "left";
    }
}

static uint16_t display_rotation_degrees_for_value(taby_display_orientation_t orientation) {
    switch (orientation) {
        case TABY_DISPLAY_ORIENTATION_RIGHT:
            return 180U;
        case TABY_DISPLAY_ORIENTATION_ROTATE_90:
            return 90U;
        case TABY_DISPLAY_ORIENTATION_ROTATE_270:
            return 270U;
        case TABY_DISPLAY_ORIENTATION_LEFT:
        default:
            return 0U;
    }
}

static const char *display_orientation_mode_name_for_value(taby_display_orientation_mode_t mode) {
    switch (mode) {
        case TABY_DISPLAY_ORIENTATION_MODE_AUTO:
            return "auto";
        case TABY_DISPLAY_ORIENTATION_MODE_RIGHT:
            return "right";
        case TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90:
            return "90";
        case TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270:
            return "270";
        case TABY_DISPLAY_ORIENTATION_MODE_LEFT:
        default:
            return "left";
    }
}

static bool display_orientation_mode_is_valid(taby_display_orientation_mode_t mode) {
    return mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO ||
           mode == TABY_DISPLAY_ORIENTATION_MODE_LEFT ||
           mode == TABY_DISPLAY_ORIENTATION_MODE_RIGHT ||
           mode == TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90 ||
           mode == TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270;
}

static bool display_orientation_mode_is_supported_for_target(
    taby_display_orientation_mode_t mode) {
#if TABY_HARDWARE_ROUND_1_32
    return mode != TABY_DISPLAY_ORIENTATION_MODE_AUTO;
#else
    return mode != TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90 &&
           mode != TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270;
#endif
}

static taby_display_orientation_t display_orientation_for_mode(
    taby_display_orientation_mode_t mode,
    taby_display_orientation_t fallback) {
    switch (mode) {
        case TABY_DISPLAY_ORIENTATION_MODE_LEFT:
            return TABY_DISPLAY_ORIENTATION_LEFT;
        case TABY_DISPLAY_ORIENTATION_MODE_RIGHT:
            return TABY_DISPLAY_ORIENTATION_RIGHT;
        case TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90:
            return TABY_DISPLAY_ORIENTATION_ROTATE_90;
        case TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270:
            return TABY_DISPLAY_ORIENTATION_ROTATE_270;
        case TABY_DISPLAY_ORIENTATION_MODE_AUTO:
        default:
            return fallback;
    }
}

static esp_err_t load_display_orientation(void) {
    if (s_display_orientation_loaded) {
        return ESP_OK;
    }

    s_display_orientation_mode = TABY_DISPLAY_ORIENTATION_DEFAULT_MODE;
    s_display_orientation = display_orientation_for_mode(
        TABY_DISPLAY_ORIENTATION_DEFAULT_MODE,
        TABY_DISPLAY_ORIENTATION_LEFT);

    nvs_handle_t handle;
    esp_err_t err = nvs_open(TABY_DISPLAY_PREFS_NAMESPACE, NVS_READONLY, &handle);
    if (err == ESP_ERR_NVS_NOT_FOUND) {
        s_display_orientation_loaded = true;
        ESP_LOGI(
            TAG,
            "display orientation default mode=%s effective=%s rotation=%u",
            display_orientation_mode_name_for_value(s_display_orientation_mode),
            display_orientation_name_for_value(s_display_orientation),
            display_rotation_degrees_for_value(s_display_orientation));
        return ESP_OK;
    }
    ESP_RETURN_ON_ERROR(err, TAG, "display prefs nvs open failed");

    uint8_t stored_mode = (uint8_t)TABY_DISPLAY_ORIENTATION_DEFAULT_MODE;
    err = nvs_get_u8(handle, TABY_DISPLAY_ORIENTATION_KEY, &stored_mode);
    nvs_close(handle);

    if (err != ESP_OK && err != ESP_ERR_NVS_NOT_FOUND) {
        return err;
    }

    if (err == ESP_OK &&
        display_orientation_mode_is_valid((taby_display_orientation_mode_t)stored_mode)) {
        taby_display_orientation_mode_t mode = (taby_display_orientation_mode_t)stored_mode;
        if (!display_orientation_mode_is_supported_for_target(mode)) {
            ESP_LOGW(
                TAG,
                "stored display orientation mode=%s is unsupported on this target; using default",
                display_orientation_mode_name_for_value(mode));
            mode = TABY_DISPLAY_ORIENTATION_DEFAULT_MODE;
        }
        s_display_orientation_mode = mode;
        s_display_orientation = display_orientation_for_mode(mode, s_display_orientation);
    } else if (err == ESP_OK) {
        ESP_LOGW(
            TAG,
            "invalid stored display orientation mode=%u; using target default",
            (unsigned int)stored_mode);
    }

    s_display_orientation_loaded = true;
    ESP_LOGI(
        TAG,
        "display orientation loaded mode=%s effective=%s rotation=%u",
        display_orientation_mode_name_for_value(s_display_orientation_mode),
        display_orientation_name_for_value(s_display_orientation),
        display_rotation_degrees_for_value(s_display_orientation));
    return ESP_OK;
}

static esp_err_t persist_display_orientation_mode(taby_display_orientation_mode_t mode) {
    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(
        nvs_open(TABY_DISPLAY_PREFS_NAMESPACE, NVS_READWRITE, &handle),
        TAG,
        "display prefs nvs open failed");

    esp_err_t err = nvs_set_u8(handle, TABY_DISPLAY_ORIENTATION_KEY, (uint8_t)mode);
    if (err == ESP_OK) {
        err = nvs_commit(handle);
    }
    nvs_close(handle);
    return err;
}

static esp_err_t erase_persisted_display_orientation(void) {
    nvs_handle_t handle;
    ESP_RETURN_ON_ERROR(
        nvs_open(TABY_DISPLAY_PREFS_NAMESPACE, NVS_READWRITE, &handle),
        TAG,
        "display prefs nvs open failed");

    esp_err_t err = nvs_erase_key(handle, TABY_DISPLAY_ORIENTATION_KEY);
    if (err == ESP_ERR_NVS_NOT_FOUND) {
        err = ESP_OK;
    }
    if (err == ESP_OK) {
        err = nvs_commit(handle);
    }
    nvs_close(handle);
    return err;
}

static uint8_t display_madctl_for_orientation(taby_display_orientation_t orientation) {
#if TABY_HARDWARE_ROUND_1_32
    // Waveshare's CO5300 setup keeps quarter-turn rotation in software. MV
    // produces writes outside the panel's 466x466 active window, so 90/270
    // keep the native MX|MY mapping and are transformed in lvgl_flush_cb.
    switch (orientation) {
        case TABY_DISPLAY_ORIENTATION_RIGHT:
            return 0x00U;
        case TABY_DISPLAY_ORIENTATION_ROTATE_90:
        case TABY_DISPLAY_ORIENTATION_ROTATE_270:
        case TABY_DISPLAY_ORIENTATION_LEFT:
        default:
            return 0xC0U;
    }
#else
    return orientation == TABY_DISPLAY_ORIENTATION_RIGHT ? 0xC0U : 0x00U;
#endif
}

static esp_err_t apply_display_orientation(taby_display_orientation_t orientation) {
    if (!s_panel_io_handle) {
        return ESP_ERR_INVALID_STATE;
    }

    uint8_t madctl = display_madctl_for_orientation(orientation);
    ESP_RETURN_ON_ERROR(
        esp_lcd_panel_io_tx_param(
            s_panel_io_handle,
            lcd_qspi_param_command(LCD_CMD_MEMORY_ACCESS_CONTROL),
            &madctl,
            1),
        TAG,
        "set display MADCTL failed");

    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_display_orientation = orientation;
    s_touch_suppress_until_release = true;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    s_touch_press_active = false;
    s_touch_press_start_us = 0;
    s_last_touch.pressed = false;
    if (s_input_device) {
        // Forget the pre-flip pressed object before the driver reports a
        // synthetic release, otherwise LVGL can emit CLICKED for that object.
        lv_indev_reset(s_input_device, NULL);
    }
    if (s_display) {
        lv_obj_t *active_screen = lv_disp_get_scr_act(s_display);
        if (active_screen) {
            // MADCTL changes the address mapping for future writes; invalidate
            // and refresh the whole active screen so static UI cannot retain
            // pixels from the previous orientation.
            lv_obj_invalidate(active_screen);
            lv_refr_now(s_display);
        }
    }
    ESP_LOGI(
        TAG,
        "display MADCTL=0x%02x orientation=%s rotation=%u",
        (unsigned int)madctl,
        display_orientation_name_for_value(orientation),
        display_rotation_degrees_for_value(orientation));
    return ESP_OK;
}

static void restore_display_orientation_after_persistence_failure(
    taby_display_orientation_mode_t previous_mode,
    taby_display_orientation_t previous_orientation) {
    esp_err_t rollback_err = apply_display_orientation(previous_orientation);
    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_display_orientation_mode = previous_mode;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    if (rollback_err != ESP_OK) {
        ESP_LOGE(
            TAG,
            "failed to restore display orientation=%d after persistence failure: %s",
            (int)previous_orientation,
            esp_err_to_name(rollback_err));
    }
}

static esp_err_t board_i2c_init(void) {
    if (!s_i2c_mutex) {
        s_i2c_mutex = xSemaphoreCreateMutex();
        if (!s_i2c_mutex) {
            return ESP_ERR_NO_MEM;
        }
    }

    i2c_config_t conf = {
        .mode = I2C_MODE_MASTER,
        .sda_io_num = BOARD_I2C_SDA,
        .sda_pullup_en = GPIO_PULLUP_ENABLE,
        .scl_io_num = BOARD_I2C_SCL,
        .scl_pullup_en = GPIO_PULLUP_ENABLE,
        .master.clk_speed = BOARD_I2C_FREQ_HZ,
        .clk_flags = 0,
    };

    ESP_RETURN_ON_ERROR(i2c_param_config(BOARD_I2C_PORT, &conf), TAG, "i2c_param_config failed");
    ESP_RETURN_ON_ERROR(i2c_driver_install(BOARD_I2C_PORT, conf.mode, 0, 0, 0), TAG, "i2c_driver_install failed");
    return ESP_OK;
}

#if !TABY_HARDWARE_ROUND_1_32
static esp_err_t board_i2c_write_reg(uint8_t addr, uint8_t reg, const uint8_t *data, size_t len) {
    uint8_t *tx_buf = malloc(len + 1);
    if (!tx_buf) {
        return ESP_ERR_NO_MEM;
    }

    tx_buf[0] = reg;
    if (len > 0 && data) {
        memcpy(tx_buf + 1, data, len);
    }

    if (!s_i2c_mutex || xSemaphoreTake(s_i2c_mutex, pdMS_TO_TICKS(1000)) != pdTRUE) {
        free(tx_buf);
        return ESP_ERR_TIMEOUT;
    }
    esp_err_t err = i2c_master_write_to_device(
        BOARD_I2C_PORT,
        addr,
        tx_buf,
        len + 1,
        pdMS_TO_TICKS(1000));
    xSemaphoreGive(s_i2c_mutex);
    free(tx_buf);
    return err;
}
#endif

static esp_err_t board_i2c_read_reg(uint8_t addr, uint8_t reg, uint8_t *data, size_t len) {
    if (!s_i2c_mutex || xSemaphoreTake(s_i2c_mutex, pdMS_TO_TICKS(1000)) != pdTRUE) {
        return ESP_ERR_TIMEOUT;
    }
    esp_err_t err = i2c_master_write_read_device(
        BOARD_I2C_PORT,
        addr,
        &reg,
        1,
        data,
        len,
        pdMS_TO_TICKS(1000));
    xSemaphoreGive(s_i2c_mutex);
    return err;
}

#if !TABY_HARDWARE_ROUND_1_32
static int32_t orientation_abs_i32(int32_t value) {
    return value < 0 ? -value : value;
}

static int32_t orientation_raw_to_mg(int16_t raw) {
    return ((int32_t)raw * 1000) / QMI8658_COUNTS_PER_G;
}

static void orientation_detector_reject_locked(taby_orientation_imu_state_t state) {
    s_orientation_imu.candidate_valid = false;
    s_orientation_imu.stable_ms = 0;
    s_orientation_imu.confidence_percent = 0;
    s_orientation_imu.state = state;
    s_orientation_candidate_since_us = 0;
}

static void orientation_detector_reset(void) {
    taskENTER_CRITICAL(&s_orientation_state_lock);
    orientation_detector_reject_locked(
        s_orientation_imu.available
            ? TABY_ORIENTATION_IMU_AMBIGUOUS
            : TABY_ORIENTATION_IMU_UNAVAILABLE);
    taskEXIT_CRITICAL(&s_orientation_state_lock);
}

static esp_err_t board_orientation_imu_init(void) {
    uint8_t who_am_i = 0;
    uint8_t revision_id = 0;
    esp_err_t err = board_i2c_read_reg(
        QMI8658_I2C_ADDR,
        QMI8658_REG_WHO_AM_I,
        &who_am_i,
        1);
    if (err == ESP_OK) {
        err = board_i2c_read_reg(
            QMI8658_I2C_ADDR,
            QMI8658_REG_REVISION_ID,
            &revision_id,
            1);
    }

    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_orientation_imu.who_am_i = who_am_i;
    s_orientation_imu.revision_id = revision_id;
    taskEXIT_CRITICAL(&s_orientation_state_lock);

    if (err != ESP_OK) {
        return err;
    }
    if (who_am_i != QMI8658_WHO_AM_I_VALUE) {
        return ESP_ERR_NOT_FOUND;
    }

    const uint8_t disabled = 0;
    const uint8_t ctrl1 = QMI8658_CTRL1_AUTO_INCREMENT_LITTLE_ENDIAN;
    const uint8_t ctrl2 = QMI8658_CTRL2_ACCEL_2G_LOW_POWER_21HZ;
    const uint8_t ctrl3 = 0;
    const uint8_t ctrl5 = QMI8658_CTRL5_ACCEL_LPF_MODE_3;
    const uint8_t ctrl7 = QMI8658_CTRL7_ACCEL_ONLY;
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL7, &disabled, 1),
        TAG,
        "disable QMI8658 sensors failed");
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL1, &ctrl1, 1),
        TAG,
        "configure QMI8658 interface failed");
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL2, &ctrl2, 1),
        TAG,
        "configure QMI8658 accelerometer failed");
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL3, &ctrl3, 1),
        TAG,
        "disable QMI8658 gyroscope failed");
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL5, &ctrl5, 1),
        TAG,
        "configure QMI8658 accelerometer filter failed");
    ESP_RETURN_ON_ERROR(
        board_i2c_write_reg(QMI8658_I2C_ADDR, QMI8658_REG_CTRL7, &ctrl7, 1),
        TAG,
        "enable QMI8658 accelerometer failed");

    vTaskDelay(pdMS_TO_TICKS(60));
    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_orientation_imu.available = true;
    s_orientation_imu.state = TABY_ORIENTATION_IMU_AMBIGUOUS;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    ESP_LOGI(
        TAG,
        "QMI8658 accelerometer ready who_am_i=0x%02x revision=0x%02x odr=21Hz gyro=off",
        (unsigned int)who_am_i,
        (unsigned int)revision_id);
    return ESP_OK;
}

static bool board_orientation_imu_sample(taby_display_orientation_t *stable_orientation) {
    uint8_t raw[6] = {0};
    esp_err_t err = board_i2c_read_reg(
        QMI8658_I2C_ADDR,
        QMI8658_REG_ACCEL_X_L,
        raw,
        sizeof(raw));
    if (err != ESP_OK) {
        taskENTER_CRITICAL(&s_orientation_state_lock);
        s_orientation_imu.read_error_count++;
        orientation_detector_reject_locked(TABY_ORIENTATION_IMU_READ_ERROR);
        taskEXIT_CRITICAL(&s_orientation_state_lock);
        return false;
    }

    const int16_t x = (int16_t)(((uint16_t)raw[1] << 8) | raw[0]);
    const int16_t y = (int16_t)(((uint16_t)raw[3] << 8) | raw[2]);
    const int16_t z = (int16_t)(((uint16_t)raw[5] << 8) | raw[4]);
    const int64_t now_us = esp_timer_get_time();
    const int32_t abs_x = orientation_abs_i32(x);
    const int32_t abs_y = orientation_abs_i32(y);
    const int32_t abs_z = orientation_abs_i32(z);
    const int64_t norm_squared =
        (int64_t)x * x + (int64_t)y * y + (int64_t)z * z;
    const bool moving = s_orientation_imu_has_previous_sample &&
        (orientation_abs_i32((int32_t)x - s_orientation_imu_previous_x) > ORIENTATION_MOVEMENT_DELTA_RAW ||
         orientation_abs_i32((int32_t)y - s_orientation_imu_previous_y) > ORIENTATION_MOVEMENT_DELTA_RAW ||
         orientation_abs_i32((int32_t)z - s_orientation_imu_previous_z) > ORIENTATION_MOVEMENT_DELTA_RAW);

    s_orientation_imu_previous_x = x;
    s_orientation_imu_previous_y = y;
    s_orientation_imu_previous_z = z;
    s_orientation_imu_has_previous_sample = true;

    taby_display_orientation_t candidate =
        ((int32_t)y * ORIENTATION_LEFT_GRAVITY_SIGN) >= 0
            ? TABY_DISPLAY_ORIENTATION_LEFT
            : TABY_DISPLAY_ORIENTATION_RIGHT;

    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_orientation_imu.accel_x_raw = x;
    s_orientation_imu.accel_y_raw = y;
    s_orientation_imu.accel_z_raw = z;
    s_orientation_imu.accel_x_mg = orientation_raw_to_mg(x);
    s_orientation_imu.accel_y_mg = orientation_raw_to_mg(y);
    s_orientation_imu.accel_z_mg = orientation_raw_to_mg(z);
    s_orientation_imu.sample_count++;
    s_orientation_imu_last_sample_us = now_us;

    const bool same_candidate =
        s_orientation_imu.candidate_valid &&
        s_orientation_imu.candidate == candidate;
    const int32_t axis_min = same_candidate
        ? ORIENTATION_AXIS_HOLD_RAW
        : ORIENTATION_AXIS_ENTER_RAW;

    // Z changes with the stand's forward/back lean and does not make the
    // screen's in-plane Left/Right direction ambiguous. Reject near-flat Z
    // separately, and compare Y dominance only against the in-plane X axis.
    if (moving) {
        orientation_detector_reject_locked(TABY_ORIENTATION_IMU_MOVING);
    } else if (abs_z >= ORIENTATION_FLAT_AXIS_RAW) {
        orientation_detector_reject_locked(TABY_ORIENTATION_IMU_FLAT);
    } else if (norm_squared < ORIENTATION_NORM_MIN_SQUARED ||
               norm_squared > ORIENTATION_NORM_MAX_SQUARED ||
               abs_y < axis_min ||
               abs_x > ORIENTATION_CROSS_AXIS_MAX_RAW ||
               abs_z > ORIENTATION_CROSS_AXIS_MAX_RAW ||
               (int64_t)abs_y * ORIENTATION_DOMINANT_AXIS_MULTIPLIER <
                   (int64_t)abs_x * ORIENTATION_CROSS_AXIS_MULTIPLIER) {
        orientation_detector_reject_locked(TABY_ORIENTATION_IMU_AMBIGUOUS);
    } else {
        if (!same_candidate) {
            s_orientation_imu.candidate_valid = true;
            s_orientation_imu.candidate = candidate;
            s_orientation_candidate_since_us = now_us;
        }

        uint32_t stable_ms = (uint32_t)((now_us - s_orientation_candidate_since_us) / 1000LL);
        if (stable_ms > ORIENTATION_STABLE_MS) {
            stable_ms = ORIENTATION_STABLE_MS;
        }
        s_orientation_imu.stable_ms = (uint16_t)stable_ms;
        s_orientation_imu.confidence_percent =
            (uint8_t)((stable_ms * 100U) / ORIENTATION_STABLE_MS);
        s_orientation_imu.state = stable_ms >= ORIENTATION_STABLE_MS
            ? TABY_ORIENTATION_IMU_STABLE
            : TABY_ORIENTATION_IMU_STABILIZING;
    }

    bool stable =
        s_orientation_imu.candidate_valid &&
        s_orientation_imu.state == TABY_ORIENTATION_IMU_STABLE;
    if (stable && stable_orientation) {
        *stable_orientation = s_orientation_imu.candidate;
    }
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    return stable;
}

static void board_orientation_sample_before_panel(void) {
    if (s_display_orientation_mode != TABY_DISPLAY_ORIENTATION_MODE_AUTO) {
        return;
    }

    const int64_t deadline_us =
        esp_timer_get_time() + (int64_t)ORIENTATION_BOOT_SAMPLE_BUDGET_MS * 1000LL;
    taby_display_orientation_t candidate = TABY_DISPLAY_ORIENTATION_LEFT;
    while (esp_timer_get_time() < deadline_us) {
        if (board_orientation_imu_sample(&candidate)) {
            taskENTER_CRITICAL(&s_orientation_state_lock);
            if (s_display_orientation_mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO) {
                s_display_orientation = candidate;
            }
            taskEXIT_CRITICAL(&s_orientation_state_lock);
            ESP_LOGI(
                TAG,
                "boot orientation stable=%s before first panel frame",
                display_orientation_name_for_value(candidate));
            return;
        }
        vTaskDelay(pdMS_TO_TICKS(ORIENTATION_SAMPLE_INTERVAL_MS));
    }

    ESP_LOGW(TAG, "boot orientation remained ambiguous; using left until stable");
}

static void board_orientation_monitor_task(void *arg) {
    (void)arg;

    while (true) {
        taby_display_orientation_t candidate = TABY_DISPLAY_ORIENTATION_LEFT;
        bool stable = board_orientation_imu_sample(&candidate);
        if (stable && board_amoled_1_64_lock(100)) {
            taby_display_orientation_mode_t mode;
            taby_display_orientation_t effective;
            taskENTER_CRITICAL(&s_orientation_state_lock);
            mode = s_display_orientation_mode;
            effective = s_display_orientation;
            taskEXIT_CRITICAL(&s_orientation_state_lock);

            // Re-check only after acquiring the display lock. A manual command
            // can therefore never be overwritten by a queued auto decision.
            if (mode == TABY_DISPLAY_ORIENTATION_MODE_AUTO && candidate != effective) {
                esp_err_t apply_err = apply_display_orientation(candidate);
                if (apply_err != ESP_OK) {
                    ESP_LOGW(
                        TAG,
                        "auto display orientation apply failed: %s",
                        esp_err_to_name(apply_err));
                } else {
                    ESP_LOGI(
                        TAG,
                        "auto display orientation effective=%s (not persisted)",
                        display_orientation_name_for_value(candidate));
                }
            }
            board_amoled_1_64_unlock();
        }

        vTaskDelay(pdMS_TO_TICKS(ORIENTATION_SAMPLE_INTERVAL_MS));
    }
}
#endif

static esp_err_t board_touch_init(void) {
#if TABY_HARDWARE_ROUND_1_32
    gpio_config_t reset_config = {
        .pin_bit_mask = 1ULL << PIN_NUM_TOUCH_RST,
        .mode = GPIO_MODE_OUTPUT,
        .pull_up_en = GPIO_PULLUP_ENABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    ESP_RETURN_ON_ERROR(gpio_config(&reset_config), TAG, "touch reset gpio config failed");
    gpio_set_level(PIN_NUM_TOUCH_RST, 1);
    vTaskDelay(pdMS_TO_TICKS(200));
    gpio_set_level(PIN_NUM_TOUCH_RST, 0);
    vTaskDelay(pdMS_TO_TICKS(200));
    gpio_set_level(PIN_NUM_TOUCH_RST, 1);
    vTaskDelay(pdMS_TO_TICKS(200));

    uint8_t probe[2] = {0};
    return board_i2c_read_reg(TOUCH_ADDR, 0x02, probe, sizeof(probe));
#else
    uint8_t mode = 0x00;
    esp_err_t last_err = ESP_FAIL;

    for (int attempt = 1; attempt <= TOUCH_INIT_RETRY_COUNT; ++attempt) {
        last_err = board_i2c_write_reg(TOUCH_ADDR, 0x00, &mode, 1);
        if (last_err == ESP_OK) {
            if (attempt > 1) {
                ESP_LOGW(TAG, "Touch init succeeded on retry %d", attempt);
            }
            return ESP_OK;
        }

        ESP_LOGW(TAG, "Touch init attempt %d/%d failed: %s",
                 attempt, TOUCH_INIT_RETRY_COUNT, esp_err_to_name(last_err));
        vTaskDelay(pdMS_TO_TICKS(TOUCH_INIT_RETRY_DELAY_MS));
    }

    return last_err;
#endif
}

static bool board_touch_read_raw(uint16_t *raw_x, uint16_t *raw_y) {
#if TABY_HARDWARE_ROUND_1_32
    uint8_t gesture[2] = {0};
    if (board_i2c_read_reg(TOUCH_ADDR, 0x02, gesture, sizeof(gesture)) != ESP_OK || gesture[0] == 0 || (gesture[1] >> 6) == 0x01) {
        return false;
    }
#else
    uint8_t points = 0;
    if (board_i2c_read_reg(TOUCH_ADDR, 0x02, &points, 1) != ESP_OK || points == 0) {
        return false;
    }
#endif

    uint8_t buf[4] = {0};
    if (board_i2c_read_reg(TOUCH_ADDR, 0x03, buf, sizeof(buf)) != ESP_OK) {
        return false;
    }

#if TABY_HARDWARE_ROUND_1_32
    *raw_x = ((((uint16_t)buf[0]) & 0x0F) << 8) | (uint16_t)buf[1];
    *raw_y = ((((uint16_t)buf[2]) & 0x0F) << 8) | (uint16_t)buf[3];
#else
    *raw_y = ((((uint16_t)buf[0]) & 0x0F) << 8) | (uint16_t)buf[1];
    *raw_x = ((((uint16_t)buf[2]) & 0x0F) << 8) | (uint16_t)buf[3];
#endif
    return true;
}

static void lvgl_flush_cb(lv_disp_drv_t *drv, const lv_area_t *area, lv_color_t *color_map) {
    (void)drv;
#if TABY_HARDWARE_ROUND_1_32
    const taby_display_orientation_t orientation =
        board_amoled_1_64_display_orientation();
    if (orientation == TABY_DISPLAY_ORIENTATION_ROTATE_90 ||
        orientation == TABY_DISPLAY_ORIENTATION_ROTATE_270) {
        const int source_width = area->x2 - area->x1 + 1;
        const int source_height = area->y2 - area->y1 + 1;
        const size_t pixel_count = (size_t)source_width * (size_t)source_height;
        assert(s_rotation_buf != NULL);
        assert(pixel_count <= (size_t)DISP_W * DISP_DRAW_BUF_LINES);

        int rotated_x1;
        int rotated_y1;
        if (orientation == TABY_DISPLAY_ORIENTATION_ROTATE_90) {
            rotated_x1 = DISP_H - 1 - area->y2;
            rotated_y1 = area->x1;
            for (int source_y = 0; source_y < source_height; ++source_y) {
                for (int source_x = 0; source_x < source_width; ++source_x) {
                    const int rotated_x = source_height - 1 - source_y;
                    const int rotated_y = source_x;
                    s_rotation_buf[rotated_y * source_height + rotated_x] =
                        color_map[source_y * source_width + source_x];
                }
            }
        } else {
            rotated_x1 = area->y1;
            rotated_y1 = DISP_W - 1 - area->x2;
            for (int source_y = 0; source_y < source_height; ++source_y) {
                for (int source_x = 0; source_x < source_width; ++source_x) {
                    const int rotated_x = source_y;
                    const int rotated_y = source_width - 1 - source_x;
                    s_rotation_buf[rotated_y * source_height + rotated_x] =
                        color_map[source_y * source_width + source_x];
                }
            }
        }

        esp_lcd_panel_draw_bitmap(
            s_panel_handle,
            rotated_x1 + DISP_X_OFFSET,
            rotated_y1,
            rotated_x1 + source_height + DISP_X_OFFSET,
            rotated_y1 + source_width,
            s_rotation_buf);
        return;
    }
#endif
    esp_lcd_panel_draw_bitmap(
        s_panel_handle,
        area->x1 + DISP_X_OFFSET,
        area->y1,
        area->x2 + DISP_X_OFFSET + 1,
        area->y2 + 1,
        color_map);
}

static bool lvgl_flush_ready(esp_lcd_panel_io_handle_t panel_io, esp_lcd_panel_io_event_data_t *edata, void *user_ctx) {
    (void)panel_io;
    (void)edata;
    lv_disp_flush_ready((lv_disp_drv_t *)user_ctx);
    return false;
}

static void lvgl_rounder_cb(struct _lv_disp_drv_t *disp_drv, lv_area_t *area) {
    (void)disp_drv;
    area->x1 = (area->x1 >> 1) << 1;
    area->y1 = (area->y1 >> 1) << 1;
    area->x2 = ((area->x2 >> 1) << 1) + 1;
    area->y2 = ((area->y2 >> 1) << 1) + 1;
}

static void lvgl_tick_cb(void *arg) {
    (void)arg;
    lv_tick_inc(2);
}

static void lvgl_touch_read_cb(lv_indev_drv_t *drv, lv_indev_data_t *data) {
    (void)drv;

    uint16_t raw_x = 0;
    uint16_t raw_y = 0;
    if (!board_touch_read_raw(&raw_x, &raw_y)) {
        taskENTER_CRITICAL(&s_orientation_state_lock);
        s_touch_suppress_until_release = false;
        taskEXIT_CRITICAL(&s_orientation_state_lock);
        if (s_touch_press_active) {
            const int64_t now_us = esp_timer_get_time();
            const int64_t press_us = now_us - s_touch_press_start_us;
            const int64_t since_last_tap_us = now_us - s_touch_last_tap_us;
            s_touch_press_active = false;
            if (press_us >= TOUCH_TAP_MIN_US
                && press_us <= TOUCH_TAP_MAX_US
                && since_last_tap_us >= TOUCH_TAP_REARM_US) {
                s_touch_last_tap_us = now_us;
                taskENTER_CRITICAL(&s_touch_signal_lock);
                s_touch_signal += 1U;
                taskEXIT_CRITICAL(&s_touch_signal_lock);
            }
        }
        s_last_touch.pressed = false;
        data->state = LV_INDEV_STATE_RELEASED;
        return;
    }

    bool suppress_touch = false;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    suppress_touch = s_touch_suppress_until_release;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    if (suppress_touch) {
        s_touch_press_active = false;
        s_last_touch.pressed = false;
        data->state = LV_INDEV_STATE_RELEASED;
        return;
    }

    if (!s_touch_press_active) {
      s_touch_press_active = true;
      s_touch_press_start_us = esp_timer_get_time();
    }

#if TABY_HARDWARE_ROUND_1_32
    uint16_t mapped_x = raw_x < DISP_W ? (DISP_W - 1U - raw_x) : 0;
    uint16_t mapped_y = raw_y < DISP_H ? (DISP_H - 1U - raw_y) : 0;
#else
    uint16_t mapped_x = raw_y;
    uint16_t mapped_y = raw_x;
#endif
    if (mapped_x >= DISP_W) mapped_x = DISP_W - 1;
    if (mapped_y >= DISP_H) mapped_y = DISP_H - 1;

    uint16_t logical_x = mapped_x;
    uint16_t logical_y = mapped_y;
    taby_display_orientation_t effective_orientation;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    effective_orientation = s_display_orientation;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    switch (effective_orientation) {
        case TABY_DISPLAY_ORIENTATION_RIGHT:
            logical_x = DISP_W - 1U - mapped_x;
            logical_y = DISP_H - 1U - mapped_y;
            break;
        case TABY_DISPLAY_ORIENTATION_ROTATE_90:
            logical_x = mapped_y;
            logical_y = DISP_H - 1U - mapped_x;
            break;
        case TABY_DISPLAY_ORIENTATION_ROTATE_270:
            logical_x = DISP_W - 1U - mapped_y;
            logical_y = mapped_x;
            break;
        case TABY_DISPLAY_ORIENTATION_LEFT:
        default:
            break;
    }

    // The panel owns output rotation, so both LVGL and firmware UIs consume
    // the same logical touch coordinates.
    s_last_touch.x = logical_x;
    s_last_touch.y = logical_y;
    s_last_touch.pressed = true;

    data->point.x = logical_x;
    data->point.y = logical_y;
    data->state = LV_INDEV_STATE_PRESSED;
}

static void lvgl_task(void *arg) {
    (void)arg;

    while (true) {
        if (board_amoled_1_64_lock(10)) {
            uint32_t delay_ms = lv_timer_handler();
            board_amoled_1_64_unlock();
            if (delay_ms > 500) delay_ms = 500;
            if (delay_ms < 1) delay_ms = 1;
            vTaskDelay(pdMS_TO_TICKS(delay_ms));
            continue;
        }
        vTaskDelay(pdMS_TO_TICKS(10));
    }
}

bool board_amoled_1_64_lock(int timeout_ms) {
    if (!s_lvgl_mutex) {
        return true;
    }

    TickType_t timeout = (timeout_ms < 0) ? portMAX_DELAY : pdMS_TO_TICKS(timeout_ms);
    return xSemaphoreTake(s_lvgl_mutex, timeout) == pdTRUE;
}

void board_amoled_1_64_unlock(void) {
    if (s_lvgl_mutex) {
        xSemaphoreGive(s_lvgl_mutex);
    }
}

lv_disp_t *board_amoled_1_64_display(void) {
    return s_display;
}

void board_amoled_1_64_last_touch(board_amoled_1_64_touch_sample_t *sample) {
    if (!sample) {
        return;
    }
    *sample = s_last_touch;
}

uint32_t board_amoled_1_64_touch_signal(void) {
    uint32_t signal = 0;
    taskENTER_CRITICAL(&s_touch_signal_lock);
    signal = s_touch_signal;
    taskEXIT_CRITICAL(&s_touch_signal_lock);
    return signal;
}

uint16_t board_amoled_1_64_width(void) {
    return DISP_W;
}

uint16_t board_amoled_1_64_height(void) {
    return DISP_H;
}

uint8_t board_amoled_1_64_brightness_percent(void) {
    return s_brightness_percent;
}

uint8_t board_amoled_1_64_brightness_raw(void) {
    return s_brightness_raw;
}

static uint8_t brightness_raw_for_percent(uint8_t percent) {
    return (uint8_t)(((uint16_t)percent * 255U + 50U) / 100U);
}

static esp_err_t apply_brightness_raw(uint8_t raw) {
    esp_err_t err = esp_lcd_panel_io_tx_param(
        s_panel_io_handle,
        lcd_qspi_param_command(LCD_CMD_SET_BRIGHTNESS),
        &raw,
        1);
    if (err == ESP_OK) {
        s_brightness_raw = raw;
    }
    return err;
}

esp_err_t board_amoled_1_64_set_brightness_percent(uint8_t percent) {
    if (!s_panel_io_handle) {
        return ESP_ERR_INVALID_STATE;
    }

    if (percent > 100) {
        percent = 100;
    }

    if (percent > 0) {
        s_resume_brightness_percent = percent;
        s_display_enabled = true;
    } else {
        s_display_enabled = false;
    }

    uint8_t raw = s_display_enabled ? brightness_raw_for_percent(percent) : 0;
    esp_err_t err = apply_brightness_raw(raw);
    if (err == ESP_OK) {
        s_brightness_percent = percent;
    }
    return err;
}

esp_err_t board_amoled_1_64_set_display_enabled(bool enabled) {
    if (!s_panel_io_handle) {
        return ESP_ERR_INVALID_STATE;
    }

    if (enabled && s_brightness_percent == 0) {
        s_brightness_percent = s_resume_brightness_percent > 0
            ? s_resume_brightness_percent
            : LCD_DEFAULT_BRIGHTNESS_PERCENT;
    }

    uint8_t raw = enabled ? brightness_raw_for_percent(s_brightness_percent) : 0;
    esp_err_t err = apply_brightness_raw(raw);
    if (err == ESP_OK) {
        s_display_enabled = enabled;
    }
    return err;
}

bool board_amoled_1_64_display_enabled(void) {
    return s_display_enabled;
}

taby_display_orientation_t board_amoled_1_64_display_orientation(void) {
    taby_display_orientation_t orientation;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    orientation = s_display_orientation;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    return orientation;
}

const char *board_amoled_1_64_display_orientation_name(void) {
    return display_orientation_name_for_value(board_amoled_1_64_display_orientation());
}

uint16_t board_amoled_1_64_display_rotation_degrees(void) {
    return display_rotation_degrees_for_value(board_amoled_1_64_display_orientation());
}

taby_display_orientation_mode_t board_amoled_1_64_display_orientation_mode(void) {
    taby_display_orientation_mode_t mode;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    mode = s_display_orientation_mode;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    return mode;
}

const char *board_amoled_1_64_display_orientation_mode_name(void) {
    return display_orientation_mode_name_for_value(
        board_amoled_1_64_display_orientation_mode());
}

bool board_amoled_1_64_display_orientation_auto_supported(void) {
#if TABY_HARDWARE_ROUND_1_32
    return false;
#else
    return true;
#endif
}

void board_amoled_1_64_display_orientation_status(
    taby_display_orientation_status_t *status) {
    if (!status) {
        return;
    }

    taskENTER_CRITICAL(&s_orientation_state_lock);
    status->mode = s_display_orientation_mode;
    status->orientation = s_display_orientation;
    taskEXIT_CRITICAL(&s_orientation_state_lock);

    status->mode_name = display_orientation_mode_name_for_value(status->mode);
    status->orientation_name = display_orientation_name_for_value(status->orientation);
    status->rotation_degrees = display_rotation_degrees_for_value(status->orientation);
    status->auto_supported = board_amoled_1_64_display_orientation_auto_supported();
}

bool board_amoled_1_64_parse_display_orientation_mode(
    const char *value,
    taby_display_orientation_mode_t *out_mode) {
    if (!value || !out_mode) {
        return false;
    }

    while (*value && isspace((unsigned char)*value)) {
        value++;
    }

    size_t value_len = strlen(value);
    while (value_len > 0 && isspace((unsigned char)value[value_len - 1])) {
        value_len--;
    }

    if ((value_len == 4 && strncasecmp(value, "left", value_len) == 0) ||
        (value_len == 1 && value[0] == '0')) {
        *out_mode = TABY_DISPLAY_ORIENTATION_MODE_LEFT;
        return true;
    }

    if ((value_len == 5 && strncasecmp(value, "right", value_len) == 0) ||
        (value_len == 3 && strncmp(value, "180", value_len) == 0)) {
        *out_mode = TABY_DISPLAY_ORIENTATION_MODE_RIGHT;
        return true;
    }

    if (value_len == 2 && strncmp(value, "90", value_len) == 0) {
        *out_mode = TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90;
        return true;
    }

    if (value_len == 3 && strncmp(value, "270", value_len) == 0) {
        *out_mode = TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270;
        return true;
    }

    if (value_len == 4 && strncasecmp(value, "auto", value_len) == 0) {
        *out_mode = TABY_DISPLAY_ORIENTATION_MODE_AUTO;
        return true;
    }

    return false;
}

esp_err_t board_amoled_1_64_set_display_orientation_mode(taby_display_orientation_mode_t mode) {
    if (!display_orientation_mode_is_valid(mode)) {
        return ESP_ERR_INVALID_ARG;
    }
    if (!display_orientation_mode_is_supported_for_target(mode)) {
        return ESP_ERR_NOT_SUPPORTED;
    }

    ESP_RETURN_ON_ERROR(load_display_orientation(), TAG, "load display orientation failed");
    taby_display_orientation_mode_t previous_mode;
    taby_display_orientation_t previous_orientation;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    previous_mode = s_display_orientation_mode;
    previous_orientation = s_display_orientation;
    taskEXIT_CRITICAL(&s_orientation_state_lock);

    taby_display_orientation_t desired_orientation = previous_orientation;
    desired_orientation = display_orientation_for_mode(mode, desired_orientation);

    if (mode == previous_mode && desired_orientation == previous_orientation) {
        return ESP_OK;
    }

    if (desired_orientation != previous_orientation) {
        ESP_RETURN_ON_ERROR(
            apply_display_orientation(desired_orientation),
            TAG,
            "apply display orientation failed");
    }

    if (mode != previous_mode) {
        esp_err_t persist_err = persist_display_orientation_mode(mode);
        if (persist_err != ESP_OK) {
            ESP_LOGW(
                TAG,
                "persist display orientation mode failed; restoring previous state: %s",
                esp_err_to_name(persist_err));
            restore_display_orientation_after_persistence_failure(
                previous_mode,
                previous_orientation);
            return persist_err;
        }
    }

    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_display_orientation_mode = mode;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
#if !TABY_HARDWARE_ROUND_1_32
    orientation_detector_reset();
#endif

    ESP_LOGI(
        TAG,
        "display orientation mode=%s effective=%s rotation=%u",
        display_orientation_mode_name_for_value(mode),
        display_orientation_name_for_value(desired_orientation),
        display_rotation_degrees_for_value(desired_orientation));
    return ESP_OK;
}

esp_err_t board_amoled_1_64_reset_display_orientation(void) {
    taby_display_orientation_mode_t previous_mode;
    taby_display_orientation_t previous_orientation;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    previous_mode = s_display_orientation_mode;
    previous_orientation = s_display_orientation;
    taskEXIT_CRITICAL(&s_orientation_state_lock);

#if TABY_HARDWARE_ROUND_1_32
    const taby_display_orientation_t default_orientation = display_orientation_for_mode(
        TABY_DISPLAY_ORIENTATION_DEFAULT_MODE,
        TABY_DISPLAY_ORIENTATION_LEFT);
    if (previous_orientation != default_orientation) {
        ESP_RETURN_ON_ERROR(
            apply_display_orientation(default_orientation),
            TAG,
            "apply default display orientation failed");
    }
#endif

    esp_err_t erase_err = erase_persisted_display_orientation();
    if (erase_err != ESP_OK) {
        ESP_LOGW(
            TAG,
            "clear persisted display orientation failed; restoring previous state: %s",
            esp_err_to_name(erase_err));
        restore_display_orientation_after_persistence_failure(previous_mode, previous_orientation);
        return erase_err;
    }

    taskENTER_CRITICAL(&s_orientation_state_lock);
    s_display_orientation_mode = TABY_DISPLAY_ORIENTATION_DEFAULT_MODE;
#if TABY_HARDWARE_ROUND_1_32
    s_display_orientation = default_orientation;
#endif
    s_display_orientation_loaded = true;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
#if !TABY_HARDWARE_ROUND_1_32
    orientation_detector_reset();
#endif
    ESP_LOGI(
        TAG,
        "display orientation reset mode=%s effective=%s rotation=%u",
        board_amoled_1_64_display_orientation_mode_name(),
        board_amoled_1_64_display_orientation_name(),
        (unsigned int)board_amoled_1_64_display_rotation_degrees());
    return ESP_OK;
}

void board_amoled_1_64_orientation_imu_diagnostics(
    taby_orientation_imu_diagnostics_t *diagnostics) {
    if (!diagnostics) {
        return;
    }

    int64_t last_sample_us = 0;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    *diagnostics = s_orientation_imu;
#if !TABY_HARDWARE_ROUND_1_32
    last_sample_us = s_orientation_imu_last_sample_us;
#endif
    taskEXIT_CRITICAL(&s_orientation_state_lock);

    if (last_sample_us > 0) {
        int64_t age_ms = (esp_timer_get_time() - last_sample_us) / 1000LL;
        diagnostics->sample_age_ms = age_ms > UINT32_MAX
            ? UINT32_MAX
            : (uint32_t)age_ms;
    } else {
        diagnostics->sample_age_ms = UINT32_MAX;
    }
}

const char *board_amoled_1_64_orientation_imu_state_name(
    taby_orientation_imu_state_t state) {
    switch (state) {
        case TABY_ORIENTATION_IMU_READ_ERROR:
            return "read_error";
        case TABY_ORIENTATION_IMU_MOVING:
            return "moving";
        case TABY_ORIENTATION_IMU_FLAT:
            return "flat";
        case TABY_ORIENTATION_IMU_AMBIGUOUS:
            return "ambiguous";
        case TABY_ORIENTATION_IMU_STABILIZING:
            return "stabilizing";
        case TABY_ORIENTATION_IMU_STABLE:
            return "stable";
        case TABY_ORIENTATION_IMU_UNAVAILABLE:
        default:
            return "unavailable";
    }
}

esp_err_t board_amoled_1_64_init(void) {
    if (s_display) {
        return ESP_OK;
    }

    static lv_color_t *buf1 = NULL;
    static lv_color_t *buf2 = NULL;
    ESP_RETURN_ON_ERROR(load_display_orientation(), TAG, "load display orientation failed");
    s_touch_press_active = false;
    s_touch_press_start_us = 0;
    s_touch_last_tap_us = 0;
    taskENTER_CRITICAL(&s_touch_signal_lock);
    s_touch_signal = 0;
    taskEXIT_CRITICAL(&s_touch_signal_lock);

#if TABY_HARDWARE_ROUND_1_32
    const gpio_config_t system_power_config = {
        .pin_bit_mask = 1ULL << PIN_NUM_SYSTEM_POWER,
        .mode = GPIO_MODE_OUTPUT,
        .pull_up_en = GPIO_PULLUP_DISABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    ESP_RETURN_ON_ERROR(gpio_config(&system_power_config), TAG, "system power gpio config failed");
    gpio_set_level(PIN_NUM_SYSTEM_POWER, 1);
#endif

    ESP_RETURN_ON_ERROR(board_i2c_init(), TAG, "board_i2c_init failed");
#if !TABY_HARDWARE_ROUND_1_32
    esp_err_t imu_err = board_orientation_imu_init();
    if (imu_err != ESP_OK) {
        taskENTER_CRITICAL(&s_orientation_state_lock);
        s_orientation_imu.available = false;
        s_orientation_imu.state = TABY_ORIENTATION_IMU_UNAVAILABLE;
        taskEXIT_CRITICAL(&s_orientation_state_lock);
        ESP_LOGW(
            TAG,
            "QMI8658 unavailable; auto orientation will keep the safe left fallback: %s",
            esp_err_to_name(imu_err));
    } else {
        board_orientation_sample_before_panel();
    }
#endif

    const spi_bus_config_t bus_cfg = SH8601_PANEL_BUS_QSPI_CONFIG(
        PIN_NUM_LCD_PCLK,
        PIN_NUM_LCD_DATA0,
        PIN_NUM_LCD_DATA1,
        PIN_NUM_LCD_DATA2,
        PIN_NUM_LCD_DATA3,
        DISP_W * DISP_H * LCD_BIT_PER_PIXEL / 8);
    ESP_RETURN_ON_ERROR(spi_bus_initialize(LCD_HOST, &bus_cfg, SPI_DMA_CH_AUTO), TAG, "spi_bus_initialize failed");

    esp_lcd_panel_io_handle_t io_handle = NULL;
    const esp_lcd_panel_io_spi_config_t io_config = SH8601_PANEL_IO_QSPI_CONFIG(
        PIN_NUM_LCD_CS,
        lvgl_flush_ready,
        &s_disp_drv);

    sh8601_vendor_config_t vendor_config = {
        .init_cmds = s_lcd_init_cmds,
        .init_cmds_size = sizeof(s_lcd_init_cmds) / sizeof(s_lcd_init_cmds[0]),
        .flags = {
            .use_qspi_interface = 1,
        },
    };

    ESP_RETURN_ON_ERROR(
        esp_lcd_new_panel_io_spi((esp_lcd_spi_bus_handle_t)LCD_HOST, &io_config, &io_handle),
        TAG,
        "esp_lcd_new_panel_io_spi failed");
    s_panel_io_handle = io_handle;

    const esp_lcd_panel_dev_config_t panel_config = {
        .reset_gpio_num = PIN_NUM_LCD_RST,
        .rgb_ele_order = LCD_RGB_ELEMENT_ORDER_RGB,
        .bits_per_pixel = LCD_BIT_PER_PIXEL,
        .vendor_config = &vendor_config,
    };

    ESP_RETURN_ON_ERROR(esp_lcd_new_panel_sh8601(io_handle, &panel_config, &s_panel_handle), TAG, "new panel failed");
    ESP_RETURN_ON_ERROR(esp_lcd_panel_reset(s_panel_handle), TAG, "panel reset failed");
    ESP_RETURN_ON_ERROR(esp_lcd_panel_init(s_panel_handle), TAG, "panel init failed");
    taby_display_orientation_t startup_orientation = board_amoled_1_64_display_orientation();
    ESP_RETURN_ON_ERROR(
        apply_display_orientation(startup_orientation),
        TAG,
        "restore display orientation failed");
    ESP_RETURN_ON_ERROR(
        board_amoled_1_64_set_brightness_percent(LCD_DEFAULT_BRIGHTNESS_PERCENT),
        TAG,
        "set default brightness failed");

    ESP_RETURN_ON_ERROR(board_touch_init(), TAG, "board_touch_init failed");

    lv_init();

    buf1 = heap_caps_malloc(DISP_W * DISP_DRAW_BUF_LINES * sizeof(lv_color_t), MALLOC_CAP_DMA);
    buf2 = heap_caps_malloc(DISP_W * DISP_DRAW_BUF_LINES * sizeof(lv_color_t), MALLOC_CAP_DMA);
#if TABY_HARDWARE_ROUND_1_32
    s_rotation_buf = heap_caps_malloc(
        DISP_W * DISP_DRAW_BUF_LINES * sizeof(lv_color_t),
        MALLOC_CAP_DMA);
#endif
    if (!buf1 || !buf2
#if TABY_HARDWARE_ROUND_1_32
        || !s_rotation_buf
#endif
    ) {
        return ESP_ERR_NO_MEM;
    }

    lv_disp_draw_buf_init(&s_draw_buf, buf1, buf2, DISP_W * DISP_DRAW_BUF_LINES);

    lv_disp_drv_init(&s_disp_drv);
    s_disp_drv.hor_res = DISP_W;
    s_disp_drv.ver_res = DISP_H;
    s_disp_drv.flush_cb = lvgl_flush_cb;
    s_disp_drv.rounder_cb = lvgl_rounder_cb;
    s_disp_drv.draw_buf = &s_draw_buf;
    s_disp_drv.user_data = s_panel_handle;
    s_display = lv_disp_drv_register(&s_disp_drv);

    lv_indev_drv_init(&s_indev_drv);
    s_indev_drv.type = LV_INDEV_TYPE_POINTER;
    s_indev_drv.disp = s_display;
    s_indev_drv.read_cb = lvgl_touch_read_cb;
    s_input_device = lv_indev_drv_register(&s_indev_drv);
    if (!s_input_device) {
        return ESP_FAIL;
    }

    const esp_timer_create_args_t tick_args = {
        .callback = &lvgl_tick_cb,
        .name = "taby_lvgl_tick",
    };
    ESP_RETURN_ON_ERROR(esp_timer_create(&tick_args, &s_tick_timer), TAG, "tick timer create failed");
    ESP_RETURN_ON_ERROR(esp_timer_start_periodic(s_tick_timer, 2 * 1000), TAG, "tick timer start failed");

    s_lvgl_mutex = xSemaphoreCreateMutex();
    if (!s_lvgl_mutex) {
        return ESP_ERR_NO_MEM;
    }

    BaseType_t task_ok = xTaskCreate(lvgl_task, "taby_lvgl", 12 * 1024, NULL, 2, NULL);
    if (task_ok != pdPASS) {
        return ESP_FAIL;
    }

#if !TABY_HARDWARE_ROUND_1_32
    bool imu_available;
    taskENTER_CRITICAL(&s_orientation_state_lock);
    imu_available = s_orientation_imu.available;
    taskEXIT_CRITICAL(&s_orientation_state_lock);
    if (imu_available) {
        task_ok = xTaskCreate(
            board_orientation_monitor_task,
            "taby_orientation",
            3 * 1024,
            NULL,
            2,
            NULL);
        if (task_ok != pdPASS) {
            ESP_LOGW(TAG, "orientation monitor task unavailable; keeping current orientation");
        }
    }
#endif

    ESP_LOGI(TAG, "%s board bring-up complete", BOARD_MODEL_LOG);
    return ESP_OK;
}
