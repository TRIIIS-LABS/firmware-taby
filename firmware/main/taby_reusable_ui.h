#pragma once

#include <stdbool.h>
#include <stdint.h>

typedef enum {
    TABY_REUSABLE_CARD_HEADLINE = 0,
    TABY_REUSABLE_CARD_TEXT,
    TABY_REUSABLE_CARD_ICON_ONLY,
    TABY_REUSABLE_CARD_ICON_TEXT,
    TABY_REUSABLE_CARD_ICON_TEXT_ROW,
    TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE,
    TABY_REUSABLE_CARD_ACTION,
    TABY_REUSABLE_CARD_CHOICE_2,
    TABY_REUSABLE_CARD_COUNTDOWN,
    TABY_REUSABLE_CARD_PROGRESS,
} taby_reusable_card_kind_t;

typedef enum {
    TABY_REUSABLE_TEXT_EFFECT_NONE = 0,
    TABY_REUSABLE_TEXT_EFFECT_BLINK,
    TABY_REUSABLE_TEXT_EFFECT_LOADING_DOTS,
} taby_reusable_text_effect_t;

typedef enum {
    TABY_REUSABLE_DECOR_EFFECT_NONE = 0,
    TABY_REUSABLE_DECOR_EFFECT_SHOOTING_STARS,
    TABY_REUSABLE_DECOR_EFFECT_FIREWORK_DOTS,
    TABY_REUSABLE_DECOR_EFFECT_HEART_BURST,
    TABY_REUSABLE_DECOR_EFFECT_GOLD_RINGS,
    TABY_REUSABLE_DECOR_EFFECT_SQUARE_CONFETTI,
    TABY_REUSABLE_DECOR_EFFECT_DIAMOND_BURST,
    TABY_REUSABLE_DECOR_EFFECT_COMET_BURST,
    TABY_REUSABLE_DECOR_EFFECT_RIBBON_SWEEP,
    TABY_REUSABLE_DECOR_EFFECT_EMBER_DRIFT,
    TABY_REUSABLE_DECOR_EFFECT_STAR_TWINKLE,
    TABY_REUSABLE_DECOR_EFFECT_BUBBLE_POP,
    TABY_REUSABLE_DECOR_EFFECT_PIXEL_BURST,
    TABY_REUSABLE_DECOR_EFFECT_GLOW_WAVE,
    TABY_REUSABLE_DECOR_EFFECT_SUNBEAM_LINES,
    TABY_REUSABLE_DECOR_EFFECT_PRISM_SHARDS,
    TABY_REUSABLE_DECOR_EFFECT_HEART_RAIN,
    TABY_REUSABLE_DECOR_EFFECT_CONFETTI_RAIN,
    TABY_REUSABLE_DECOR_EFFECT_ORBIT_DOTS,
    TABY_REUSABLE_DECOR_EFFECT_FLARE_FAN,
    TABY_REUSABLE_DECOR_EFFECT_PETAL_SWIRL,
    TABY_REUSABLE_DECOR_EFFECT_NEON_ARC,
    TABY_REUSABLE_DECOR_EFFECT_SPIRAL_SPARKS,
    TABY_REUSABLE_DECOR_EFFECT_CHECKER_BURST,
    TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP,
} taby_reusable_decor_effect_t;

typedef enum {
    TABY_REUSABLE_CHOICE_NONE = 0,
    TABY_REUSABLE_CHOICE_1 = 1,
    TABY_REUSABLE_CHOICE_2 = 2,
    TABY_REUSABLE_CHOICE_ACTION = 3,
} taby_reusable_choice_selection_t;

typedef struct {
    uint32_t signal;
    taby_reusable_choice_selection_t selection;
} taby_reusable_choice_signal_t;

typedef struct {
    taby_reusable_text_effect_t text_effect;
    uint32_t text_effect_seconds;
    const char *animation_id;
    uint32_t animation_replay_seconds;
    bool animation_play_on_show;
    taby_reusable_decor_effect_t decor_effect;
    uint32_t decor_effect_seconds;
    bool countdown_running;
    uint32_t countdown_visible_seconds;
} taby_reusable_behavior_t;

typedef struct {
    uint32_t background_hex;
    uint32_t card_hex;
    uint32_t panel_border_hex;
    uint32_t accent_hex;
    uint32_t headline_hex;
    uint32_t title_hex;
    uint32_t body_hex;
    uint32_t button_fill_hex;
    uint32_t button_text_hex;
    uint32_t button_border_hex;
    uint32_t secondary_button_fill_hex;
    uint32_t secondary_button_text_hex;
    uint32_t secondary_button_border_hex;
    uint32_t progress_track_hex;
    uint32_t progress_fill_hex;
} taby_reusable_style_t;

typedef struct {
    int16_t title_offset_x;
    int16_t title_offset_y;
    uint16_t title_scale_percent;
    int16_t subtitle_offset_x;
    int16_t subtitle_offset_y;
    uint16_t subtitle_scale_percent;
    int16_t icon_offset_x;
    int16_t icon_offset_y;
    uint16_t icon_size;
    int16_t action_button_offset_y;
    int16_t action_button_width_delta;
    int16_t action_button_height_delta;
    int16_t choice_title_offset_x;
    int16_t choice_title_offset_y;
    uint16_t choice_title_scale_percent;
    int16_t choice_button_offset_y;
    int16_t choice_button_height_delta;
    int16_t value_offset_x;
    int16_t value_offset_y;
    uint16_t value_scale_percent;
    int16_t bar_offset_y;
} taby_reusable_layout_t;

typedef struct {
    taby_reusable_card_kind_t kind;
    const char *headline;
    const char *title;
    const char *subtitle;
    const char *icon_id;
    const char *primary_action_label;
    const char *secondary_action_label;
    uint32_t countdown_total_seconds;
    uint32_t countdown_remaining_seconds;
    uint8_t progress_percent;
    taby_reusable_behavior_t behavior;
    taby_reusable_style_t style;
    taby_reusable_layout_t layout;
} taby_reusable_card_t;

void taby_reusable_ui_start(void);
taby_reusable_style_t taby_reusable_ui_default_style(void);
void taby_reusable_ui_reset(void);
void taby_reusable_ui_deactivate_choice_input(void);
bool taby_reusable_ui_render_card(const taby_reusable_card_t *card);
void taby_reusable_ui_read_choice_signal(taby_reusable_choice_signal_t *signal);
const char *taby_reusable_ui_choice_selection_name(taby_reusable_choice_selection_t selection);
