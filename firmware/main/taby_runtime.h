#pragma once

#include <stdbool.h>
#include <stdint.h>

#include "board_amoled_1_64.h"
#include "taby_reusable_ui.h"
#include "taby_state_machine.h"
#include "taby_transport_protocol.h"

void taby_runtime_start(void);
bool taby_runtime_apply_command(taby_command_t command);
bool taby_runtime_apply_transport_resolution(const taby_transport_resolution_t *resolution);
bool taby_runtime_render_reusable_card(const taby_reusable_card_t *card, const char *transport_state_name);
// Must be called from the LVGL/display task while the board display lock is held.
void taby_runtime_dismiss_reusable_card_locked(void);
void taby_runtime_show_transport_banner(const char *title, const char *subtitle, uint32_t duration_ms);
bool taby_runtime_refresh_current_state(void);
void taby_runtime_invalidate_render_cache(void);
taby_state_t taby_runtime_current_state(void);
bool taby_runtime_set_display_awake(bool awake);
bool taby_runtime_toggle_display_awake(void);
bool taby_runtime_display_awake(void);
bool taby_runtime_set_brightness_percent(uint8_t percent);
taby_display_orientation_t taby_runtime_display_orientation(void);
taby_display_orientation_mode_t taby_runtime_display_orientation_mode(void);
bool taby_runtime_set_display_orientation_mode(taby_display_orientation_mode_t mode);
bool taby_runtime_reset_display_orientation(void);
