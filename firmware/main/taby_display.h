#pragma once

#include "taby_state_machine.h"

typedef void (*taby_display_animation_complete_cb_t)(taby_state_t state, void *ctx);

void taby_display_init(void);
void taby_display_clear(void);
bool taby_display_animation_available(const char *animation_id);
bool taby_display_render_state(
    taby_state_t state,
    taby_display_animation_complete_cb_t animation_complete_cb,
    void *animation_complete_ctx,
    const char *fallback_title,
    const char *fallback_subtitle,
    const char *animation_id);
bool taby_display_swap_custom_animation(const char *animation_id);
