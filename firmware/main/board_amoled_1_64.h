#pragma once

#include <stdbool.h>
#include <stdint.h>

#include "esp_err.h"
#include "lvgl.h"

typedef struct {
    uint16_t x;
    uint16_t y;
    bool pressed;
} board_amoled_1_64_touch_sample_t;

typedef enum {
    TABY_DISPLAY_ORIENTATION_LEFT = 0,
    TABY_DISPLAY_ORIENTATION_RIGHT,
    TABY_DISPLAY_ORIENTATION_ROTATE_90,
    TABY_DISPLAY_ORIENTATION_ROTATE_270,
} taby_display_orientation_t;

typedef enum {
    // Keep left/right at their legacy NVS values. Auto is additive so an
    // existing device keeps its explicit side after upgrading.
    TABY_DISPLAY_ORIENTATION_MODE_LEFT = 0,
    TABY_DISPLAY_ORIENTATION_MODE_RIGHT,
    TABY_DISPLAY_ORIENTATION_MODE_AUTO,
    TABY_DISPLAY_ORIENTATION_MODE_ROTATE_90,
    TABY_DISPLAY_ORIENTATION_MODE_ROTATE_270,
} taby_display_orientation_mode_t;

typedef enum {
    TABY_ORIENTATION_IMU_UNAVAILABLE = 0,
    TABY_ORIENTATION_IMU_READ_ERROR,
    TABY_ORIENTATION_IMU_MOVING,
    TABY_ORIENTATION_IMU_FLAT,
    TABY_ORIENTATION_IMU_AMBIGUOUS,
    TABY_ORIENTATION_IMU_STABILIZING,
    TABY_ORIENTATION_IMU_STABLE,
} taby_orientation_imu_state_t;

typedef struct {
    bool supported;
    bool available;
    uint8_t who_am_i;
    uint8_t revision_id;
    int16_t accel_x_raw;
    int16_t accel_y_raw;
    int16_t accel_z_raw;
    int32_t accel_x_mg;
    int32_t accel_y_mg;
    int32_t accel_z_mg;
    uint32_t sample_age_ms;
    uint32_t sample_count;
    uint32_t read_error_count;
    bool candidate_valid;
    taby_display_orientation_t candidate;
    uint16_t stable_ms;
    uint8_t confidence_percent;
    taby_orientation_imu_state_t state;
} taby_orientation_imu_diagnostics_t;

typedef struct {
    taby_display_orientation_mode_t mode;
    taby_display_orientation_t orientation;
    const char *mode_name;
    const char *orientation_name;
    uint16_t rotation_degrees;
    bool auto_supported;
} taby_display_orientation_status_t;

esp_err_t board_amoled_1_64_init(void);
bool board_amoled_1_64_lock(int timeout_ms);
void board_amoled_1_64_unlock(void);
lv_disp_t *board_amoled_1_64_display(void);
void board_amoled_1_64_last_touch(board_amoled_1_64_touch_sample_t *sample);
uint32_t board_amoled_1_64_touch_signal(void);
uint16_t board_amoled_1_64_width(void);
uint16_t board_amoled_1_64_height(void);
esp_err_t board_amoled_1_64_set_brightness_percent(uint8_t percent);
uint8_t board_amoled_1_64_brightness_percent(void);
uint8_t board_amoled_1_64_brightness_raw(void);
esp_err_t board_amoled_1_64_set_display_enabled(bool enabled);
bool board_amoled_1_64_display_enabled(void);
taby_display_orientation_t board_amoled_1_64_display_orientation(void);
const char *board_amoled_1_64_display_orientation_name(void);
uint16_t board_amoled_1_64_display_rotation_degrees(void);
taby_display_orientation_mode_t board_amoled_1_64_display_orientation_mode(void);
const char *board_amoled_1_64_display_orientation_mode_name(void);
bool board_amoled_1_64_display_orientation_auto_supported(void);
void board_amoled_1_64_display_orientation_status(
    taby_display_orientation_status_t *status);
bool board_amoled_1_64_parse_display_orientation_mode(
    const char *value,
    taby_display_orientation_mode_t *out_mode);
esp_err_t board_amoled_1_64_set_display_orientation_mode(taby_display_orientation_mode_t mode);
esp_err_t board_amoled_1_64_reset_display_orientation(void);
void board_amoled_1_64_orientation_imu_diagnostics(
    taby_orientation_imu_diagnostics_t *diagnostics);
const char *board_amoled_1_64_orientation_imu_state_name(
    taby_orientation_imu_state_t state);
