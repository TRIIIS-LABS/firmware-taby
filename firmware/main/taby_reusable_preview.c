#include "taby_reusable_preview.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "esp_log.h"
#include "taby_reusable_ui.h"
#include "taby_runtime.h"

typedef struct {
    char headline[48];
    char title[96];
    char subtitle[128];
    char icon_id[24];
    char primary_action_label[48];
    char secondary_action_label[48];
    char animation_id[64];
} taby_reusable_preview_strings_t;

static const char *TAG = "taby_reusable_preview";

static const char *card_kind_name(taby_reusable_card_kind_t kind) {
    switch (kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            return "title";
        case TABY_REUSABLE_CARD_TEXT:
            return "title_subtitle";
        case TABY_REUSABLE_CARD_ICON_ONLY:
            return "icon";
        case TABY_REUSABLE_CARD_ICON_TEXT:
            return "title_icon";
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
            return "title_icon_row";
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            return "title_icon_subtitle";
        case TABY_REUSABLE_CARD_ACTION:
            return "title_action";
        case TABY_REUSABLE_CARD_CHOICE_2:
            return "choice_2";
        case TABY_REUSABLE_CARD_COUNTDOWN:
            return "timer";
        case TABY_REUSABLE_CARD_PROGRESS:
            return "progress";
        default:
            return "unknown";
    }
}

static void set_error(char *buffer, size_t buffer_size, const char *message) {
    if (!buffer || buffer_size == 0U) {
        return;
    }

    snprintf(buffer, buffer_size, "%s", message ? message : "unknown error");
}

static bool has_text(const char *text) {
    return text && text[0] != '\0';
}

static const char *optional_text(char *buffer) {
    return has_text(buffer) ? buffer : NULL;
}

static bool parse_hex_color_text(const char *text, uint32_t *out_hex) {
    if (!text || !out_hex) {
        return false;
    }

    while (*text == ' ' || *text == '\t') {
        text++;
    }

    if (*text == '#') {
        text++;
    } else if (text[0] == '0' && (text[1] == 'x' || text[1] == 'X')) {
        text += 2;
    }

    if (strlen(text) != 6U) {
        return false;
    }

    unsigned int parsed = 0U;
    if (sscanf(text, "%06x", &parsed) != 1) {
        return false;
    }

    *out_hex = (uint32_t)parsed;
    return true;
}

static taby_reusable_layout_t default_layout_for_card(
    taby_reusable_card_kind_t kind,
    bool has_subtitle,
    bool has_icon) {
    (void)has_subtitle;
    switch (kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            return (taby_reusable_layout_t){0};
        case TABY_REUSABLE_CARD_TEXT:
            return (taby_reusable_layout_t){
                .title_offset_x = 13,
                .title_offset_y = 29,
                .title_scale_percent = 101,
                .subtitle_offset_y = -18,
                .subtitle_scale_percent = 110,
            };
        case TABY_REUSABLE_CARD_ICON_ONLY:
            return (taby_reusable_layout_t){
                .icon_offset_y = 39,
                .icon_size = 158,
            };
        case TABY_REUSABLE_CARD_ICON_TEXT:
            return (taby_reusable_layout_t){
                .title_offset_x = -70,
                .title_offset_y = -44,
                .title_scale_percent = 96,
                .subtitle_offset_x = 34,
                .subtitle_offset_y = -16,
                .subtitle_scale_percent = 118,
                .icon_offset_x = 8,
                .icon_offset_y = 13,
                .icon_size = 132,
            };
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
            return (taby_reusable_layout_t){
                .title_offset_x = 0,
                .title_offset_y = 55,
                .title_scale_percent = 96,
                .icon_offset_x = -130,
                .icon_offset_y = 72,
                .icon_size = 132,
            };
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            return (taby_reusable_layout_t){
                .title_offset_x = -34,
                .title_offset_y = -44,
                .title_scale_percent = 100,
                .subtitle_scale_percent = 110,
                .icon_offset_y = 8,
                .icon_size = 115,
            };
        case TABY_REUSABLE_CARD_ACTION:
            return (taby_reusable_layout_t){
                .title_offset_x = 72,
                .title_offset_y = has_icon ? 91 : 39,
                .title_scale_percent = 83,
                .subtitle_scale_percent = 100,
                .icon_offset_x = has_icon ? 15 : 0,
                .icon_offset_y = has_icon ? -76 : 0,
                .icon_size = has_icon ? 110 : 0,
                .action_button_offset_y = has_icon ? -52 : -47,
                .action_button_width_delta = -122,
                .action_button_height_delta = 80,
            };
        case TABY_REUSABLE_CARD_CHOICE_2:
            return (taby_reusable_layout_t){
                .choice_title_offset_x = has_icon ? -52 : 97,
                .choice_title_offset_y = has_icon ? 118 : 97,
                .choice_title_scale_percent = 120,
                .icon_offset_y = has_icon ? -50 : 0,
                .icon_size = has_icon ? 74 : 0,
            };
        case TABY_REUSABLE_CARD_COUNTDOWN:
        case TABY_REUSABLE_CARD_PROGRESS:
            return (taby_reusable_layout_t){
                .title_scale_percent = 115,
                .subtitle_scale_percent = 100,
                .value_scale_percent = 100,
            };
        default:
            return (taby_reusable_layout_t){0};
    }
}

static bool parse_kind(const char *kind_text, taby_reusable_card_kind_t *out_kind) {
    if (!kind_text || !out_kind) {
        return false;
    }

    if (strcmp(kind_text, "title") == 0 ||
        strcmp(kind_text, "t") == 0 ||
        strcmp(kind_text, "headline") == 0 ||
        strcmp(kind_text, "headline_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_HEADLINE;
        return true;
    }
    if (strcmp(kind_text, "title_subtitle") == 0 ||
        strcmp(kind_text, "ts") == 0 ||
        strcmp(kind_text, "text") == 0 ||
        strcmp(kind_text, "text_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_TEXT;
        return true;
    }
    if (strcmp(kind_text, "icon") == 0 ||
        strcmp(kind_text, "i") == 0 ||
        strcmp(kind_text, "icon_only") == 0 ||
        strcmp(kind_text, "icon_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_ICON_ONLY;
        return true;
    }
    if (strcmp(kind_text, "title_icon") == 0 ||
        strcmp(kind_text, "ti") == 0 ||
        strcmp(kind_text, "icon_text") == 0 ||
        strcmp(kind_text, "icon_text_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_ICON_TEXT;
        return true;
    }
    if (strcmp(kind_text, "title_icon_row") == 0 ||
        strcmp(kind_text, "tir") == 0 ||
        strcmp(kind_text, "title_icon_inline") == 0 ||
        strcmp(kind_text, "title_icon_1_row") == 0 ||
        strcmp(kind_text, "icon_text_row") == 0) {
        *out_kind = TABY_REUSABLE_CARD_ICON_TEXT_ROW;
        return true;
    }
    if (strcmp(kind_text, "title_icon_subtitle") == 0 ||
        strcmp(kind_text, "tis") == 0 ||
        strcmp(kind_text, "icon_text_subtitle") == 0) {
        *out_kind = TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE;
        return true;
    }
    if (strcmp(kind_text, "title_action") == 0 ||
        strcmp(kind_text, "ta") == 0 ||
        strcmp(kind_text, "action") == 0 ||
        strcmp(kind_text, "action_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_ACTION;
        return true;
    }
    if (strcmp(kind_text, "choice_2") == 0 ||
        strcmp(kind_text, "c2") == 0 ||
        strcmp(kind_text, "choice_card_2") == 0) {
        *out_kind = TABY_REUSABLE_CARD_CHOICE_2;
        return true;
    }
    if (strcmp(kind_text, "timer") == 0 ||
        strcmp(kind_text, "tm") == 0 ||
        strcmp(kind_text, "countdown") == 0 ||
        strcmp(kind_text, "countdown_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_COUNTDOWN;
        return true;
    }
    if (strcmp(kind_text, "progress") == 0 ||
        strcmp(kind_text, "pg") == 0 ||
        strcmp(kind_text, "progress_card") == 0) {
        *out_kind = TABY_REUSABLE_CARD_PROGRESS;
        return true;
    }

    return false;
}

static bool parse_text_effect(const char *text, taby_reusable_text_effect_t *out_effect) {
    if (!text || !out_effect) {
        return false;
    }

    if (strcmp(text, "none") == 0) {
        *out_effect = TABY_REUSABLE_TEXT_EFFECT_NONE;
        return true;
    }

    if (strcmp(text, "blink") == 0) {
        *out_effect = TABY_REUSABLE_TEXT_EFFECT_BLINK;
        return true;
    }

    if (strcmp(text, "loading_dots") == 0 || strcmp(text, "dots") == 0) {
        *out_effect = TABY_REUSABLE_TEXT_EFFECT_LOADING_DOTS;
        return true;
    }

    return false;
}

static bool parse_decor_effect(const char *text, taby_reusable_decor_effect_t *out_effect) {
    if (!text || !out_effect) {
        return false;
    }

    if (strcmp(text, "none") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_NONE;
        return true;
    }
    if (strcmp(text, "shooting_stars") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_SHOOTING_STARS;
        return true;
    }
    if (strcmp(text, "firework_dots") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_FIREWORK_DOTS;
        return true;
    }
    if (strcmp(text, "heart_burst") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_HEART_BURST;
        return true;
    }
    if (strcmp(text, "gold_rings") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_GOLD_RINGS;
        return true;
    }
    if (strcmp(text, "square_confetti") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_SQUARE_CONFETTI;
        return true;
    }
    if (strcmp(text, "diamond_burst") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_DIAMOND_BURST;
        return true;
    }
    if (strcmp(text, "comet_burst") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_COMET_BURST;
        return true;
    }
    if (strcmp(text, "ribbon_sweep") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_RIBBON_SWEEP;
        return true;
    }
    if (strcmp(text, "ember_drift") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_EMBER_DRIFT;
        return true;
    }
    if (strcmp(text, "star_twinkle") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_STAR_TWINKLE;
        return true;
    }
    if (strcmp(text, "bubble_pop") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_BUBBLE_POP;
        return true;
    }
    if (strcmp(text, "pixel_burst") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_PIXEL_BURST;
        return true;
    }
    if (strcmp(text, "glow_wave") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_GLOW_WAVE;
        return true;
    }
    if (strcmp(text, "sunbeam_lines") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_SUNBEAM_LINES;
        return true;
    }
    if (strcmp(text, "prism_shards") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_PRISM_SHARDS;
        return true;
    }
    if (strcmp(text, "heart_rain") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_HEART_RAIN;
        return true;
    }
    if (strcmp(text, "confetti_rain") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_CONFETTI_RAIN;
        return true;
    }
    if (strcmp(text, "orbit_dots") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_ORBIT_DOTS;
        return true;
    }
    if (strcmp(text, "flare_fan") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_FLARE_FAN;
        return true;
    }
    if (strcmp(text, "petal_swirl") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_PETAL_SWIRL;
        return true;
    }
    if (strcmp(text, "neon_arc") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_NEON_ARC;
        return true;
    }
    if (strcmp(text, "spiral_sparks") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_SPIRAL_SPARKS;
        return true;
    }
    if (strcmp(text, "checker_burst") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_CHECKER_BURST;
        return true;
    }
    if (strcmp(text, "aurora_sweep") == 0) {
        *out_effect = TABY_REUSABLE_DECOR_EFFECT_AURORA_SWEEP;
        return true;
    }

    return false;
}

static void apply_card_defaults(
    taby_reusable_card_t *card,
    taby_reusable_preview_strings_t *strings) {
    if (!card || !strings) {
        return;
    }

    switch (card->kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            if (!has_text(strings->title)) {
                snprintf(strings->title, sizeof(strings->title), "BUSY");
            }
            break;
        case TABY_REUSABLE_CARD_TEXT:
            if (!has_text(strings->title) && !has_text(strings->subtitle)) {
                snprintf(strings->title, sizeof(strings->title), "OPEN TABY");
                snprintf(strings->subtitle, sizeof(strings->subtitle), "USB-C");
            } else if (!has_text(strings->title)) {
                snprintf(strings->title, sizeof(strings->title), "OPEN TABY");
            }
            break;
        case TABY_REUSABLE_CARD_ICON_ONLY:
            if (!has_text(strings->icon_id)) {
                snprintf(strings->icon_id, sizeof(strings->icon_id), "water");
            }
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT:
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            if (!has_text(strings->title)) {
                snprintf(strings->title, sizeof(strings->title), "DRINK WATER");
            }
            if (!has_text(strings->icon_id)) {
                snprintf(strings->icon_id, sizeof(strings->icon_id), "water");
            }
            break;
        case TABY_REUSABLE_CARD_ACTION:
            strings->subtitle[0] = '\0';
            if (!has_text(strings->title)) {
                snprintf(strings->title, sizeof(strings->title), "OPEN APP");
            }
            if (!has_text(strings->primary_action_label)) {
                snprintf(strings->primary_action_label, sizeof(strings->primary_action_label), "OPEN");
            }
            break;
        case TABY_REUSABLE_CARD_CHOICE_2:
            strings->icon_id[0] = '\0';
            if (!has_text(strings->title)) {
                snprintf(strings->title, sizeof(strings->title), "SET UP TABY");
            }
            if (!has_text(strings->primary_action_label)) {
                snprintf(strings->primary_action_label, sizeof(strings->primary_action_label), "WIRELESS");
            }
            if (!has_text(strings->secondary_action_label)) {
                snprintf(strings->secondary_action_label, sizeof(strings->secondary_action_label), "USB-C");
            }
            break;
        case TABY_REUSABLE_CARD_COUNTDOWN:
            if (card->countdown_total_seconds == 0U) {
                card->countdown_total_seconds = 300U;
            }
            if (card->countdown_remaining_seconds == 0U ||
                card->countdown_remaining_seconds > card->countdown_total_seconds) {
                card->countdown_remaining_seconds = card->countdown_total_seconds;
            }
            break;
        case TABY_REUSABLE_CARD_PROGRESS:
            if (card->progress_percent > 100U) {
                card->progress_percent = 100U;
            }
            break;
        default:
            break;
    }

    if (card->behavior.decor_effect != TABY_REUSABLE_DECOR_EFFECT_NONE &&
        card->behavior.decor_effect_seconds == 0U) {
        card->behavior.decor_effect_seconds = 4U;
    }

    card->layout = default_layout_for_card(card->kind, has_text(strings->subtitle), has_text(strings->icon_id));

    card->headline = optional_text(strings->headline);
    card->title = optional_text(strings->title);
    card->subtitle = optional_text(strings->subtitle);
    card->icon_id = optional_text(strings->icon_id);
    card->primary_action_label = optional_text(strings->primary_action_label);
    card->secondary_action_label = optional_text(strings->secondary_action_label);
}

static bool is_ui_modifier_char(char ch) {
    switch (ch) {
        case '?':
        case '#':
        case '^':
        case '+':
        case '%':
        case '(':
        case ')':
        case '[':
        case '{':
        case '}':
        case '$':
        case '!':
        case '*':
        case '@':
        case '&':
        case '~':
        case ':':
            return true;
        default:
            return false;
    }
}

static bool parse_compact_hex(const char *text, uint32_t *out_hex) {
    char buffer[8] = {0};
    if (!text || !out_hex) {
        return false;
    }

    for (size_t i = 0; i < 6; ++i) {
        if (!isxdigit((unsigned char)text[i])) {
            return false;
        }
        buffer[i] = text[i];
    }
    buffer[6] = '\0';
    return parse_hex_color_text(buffer, out_hex);
}

static bool parse_uint32_text(const char *text, uint32_t *out_value) {
    if (!text || !out_value || text[0] == '\0') {
        return false;
    }

    uint32_t value = 0U;
    for (size_t i = 0; text[i] != '\0'; ++i) {
        if (!isdigit((unsigned char)text[i])) {
            return false;
        }
        value = value * 10U + (uint32_t)(text[i] - '0');
    }

    *out_value = value;
    return true;
}

static bool parse_timer_running_text(const char *text, bool *out_running) {
    if (!text || !out_running || text[0] == '\0') {
        return false;
    }

    if (strcmp(text, "run") == 0 ||
        strcmp(text, "running") == 0 ||
        strcmp(text, "true") == 0 ||
        strcmp(text, "1") == 0) {
        *out_running = true;
        return true;
    }

    if (strcmp(text, "pause") == 0 ||
        strcmp(text, "paused") == 0 ||
        strcmp(text, "static") == 0 ||
        strcmp(text, "false") == 0 ||
        strcmp(text, "0") == 0) {
        *out_running = false;
        return true;
    }

    return false;
}

static void copy_display_segment(const char *source, char *buffer, size_t buffer_size) {
    if (!buffer || buffer_size == 0U) {
        return;
    }

    buffer[0] = '\0';
    if (!source) {
        return;
    }

    const char *end = strchr(source, '>');
    size_t copy_len = end ? (size_t)(end - source) : strlen(source);
    if (copy_len >= buffer_size) {
        copy_len = buffer_size - 1U;
    }
    memcpy(buffer, source, copy_len);
    buffer[copy_len] = '\0';
}

static size_t split_payload_fields(char *payload, char **fields, size_t max_fields) {
    if (!payload || !fields || max_fields == 0U) {
        return 0U;
    }

    size_t count = 0U;
    char *cursor = payload;
    fields[count++] = cursor;

    while (*cursor != '\0' && count < max_fields) {
        if (*cursor == '|') {
            *cursor = '\0';
            fields[count++] = cursor + 1;
        }
        cursor++;
    }

    return count;
}

static void build_ui_state_name(
    const char *screen_id,
    taby_reusable_card_kind_t kind,
    char *buffer,
    size_t buffer_size) {
    if (!buffer || buffer_size == 0U) {
        return;
    }

    const char *fallback = "UI_ACTIVE";
    switch (kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            fallback = "UI_TITLE";
            break;
        case TABY_REUSABLE_CARD_TEXT:
            fallback = "UI_TITLE_SUBTITLE";
            break;
        case TABY_REUSABLE_CARD_ICON_ONLY:
            fallback = "UI_ICON";
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT:
            fallback = "UI_TITLE_ICON";
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
            fallback = "UI_TITLE_ICON_ROW";
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            fallback = "UI_TITLE_ICON_SUBTITLE";
            break;
        case TABY_REUSABLE_CARD_ACTION:
            fallback = "UI_TITLE_ACTION";
            break;
        case TABY_REUSABLE_CARD_CHOICE_2:
            fallback = "UI_CHOICE_2";
            break;
        case TABY_REUSABLE_CARD_COUNTDOWN:
            fallback = "UI_TIMER";
            break;
        case TABY_REUSABLE_CARD_PROGRESS:
            fallback = "UI_PROGRESS";
            break;
        default:
            break;
    }

    if (!has_text(screen_id)) {
        snprintf(buffer, buffer_size, "%s", fallback);
        return;
    }

    snprintf(buffer, buffer_size, "UI_");
    size_t write_index = strlen(buffer);
    for (size_t i = 0; screen_id[i] != '\0' && write_index + 1 < buffer_size; ++i) {
        unsigned char ch = (unsigned char)screen_id[i];
        buffer[write_index++] = isalnum(ch) ? (char)toupper(ch) : '_';
    }
    buffer[write_index] = '\0';
}

static bool parse_ui_payload_into_card(
    const char *payload,
    taby_reusable_card_t *card,
    taby_reusable_preview_strings_t *strings,
    char *error_buffer,
    size_t error_buffer_size) {
    if (!payload || !card || !strings) {
        set_error(error_buffer, error_buffer_size, "ui payload required");
        return false;
    }

    char payload_copy[320] = {0};
    snprintf(payload_copy, sizeof(payload_copy), "%s", payload);
    char *fields[6] = {0};
    size_t field_count = split_payload_fields(payload_copy, fields, 6);

    switch (card->kind) {
        case TABY_REUSABLE_CARD_HEADLINE:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            break;
        case TABY_REUSABLE_CARD_TEXT:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            copy_display_segment(field_count > 1 ? fields[1] : NULL, strings->subtitle, sizeof(strings->subtitle));
            break;
        case TABY_REUSABLE_CARD_ICON_ONLY:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->icon_id, sizeof(strings->icon_id));
            break;
        case TABY_REUSABLE_CARD_ICON_TEXT:
        case TABY_REUSABLE_CARD_ICON_TEXT_ROW:
        case TABY_REUSABLE_CARD_ICON_TEXT_SUBTITLE:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            copy_display_segment(field_count > 1 ? fields[1] : NULL, strings->icon_id, sizeof(strings->icon_id));
            copy_display_segment(field_count > 2 ? fields[2] : NULL, strings->subtitle, sizeof(strings->subtitle));
            break;
        case TABY_REUSABLE_CARD_ACTION:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            copy_display_segment(field_count > 1 ? fields[1] : NULL, strings->primary_action_label, sizeof(strings->primary_action_label));
            copy_display_segment(field_count > 2 ? fields[2] : NULL, strings->icon_id, sizeof(strings->icon_id));
            break;
        case TABY_REUSABLE_CARD_CHOICE_2:
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            copy_display_segment(field_count > 1 ? fields[1] : NULL, strings->primary_action_label, sizeof(strings->primary_action_label));
            copy_display_segment(field_count > 2 ? fields[2] : NULL, strings->secondary_action_label, sizeof(strings->secondary_action_label));
            copy_display_segment(field_count > 3 ? fields[3] : NULL, strings->subtitle, sizeof(strings->subtitle));
            break;
        case TABY_REUSABLE_CARD_COUNTDOWN: {
            uint32_t remaining = 0U;
            uint32_t total = 0U;
            uint32_t visible_seconds = 0U;
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            if (field_count > 1 && !parse_uint32_text(fields[1], &remaining)) {
                set_error(error_buffer, error_buffer_size, "invalid timer remaining");
                return false;
            }
            if (field_count > 2 && !parse_uint32_text(fields[2], &total)) {
                set_error(error_buffer, error_buffer_size, "invalid timer total");
                return false;
            }
            card->countdown_remaining_seconds = remaining;
            card->countdown_total_seconds = total;
            copy_display_segment(field_count > 3 ? fields[3] : NULL, strings->subtitle, sizeof(strings->subtitle));
            if (field_count > 4 && fields[4][0] != '\0' &&
                !parse_timer_running_text(fields[4], &card->behavior.countdown_running)) {
                set_error(error_buffer, error_buffer_size, "invalid timer running state");
                return false;
            }
            if (field_count > 5 && fields[5][0] != '\0') {
                if (!parse_uint32_text(fields[5], &visible_seconds)) {
                    set_error(error_buffer, error_buffer_size, "invalid timer visible seconds");
                    return false;
                }
                card->behavior.countdown_visible_seconds = visible_seconds;
            }
            break;
        }
        case TABY_REUSABLE_CARD_PROGRESS: {
            uint32_t progress = 0U;
            copy_display_segment(field_count > 0 ? fields[0] : NULL, strings->title, sizeof(strings->title));
            if (field_count > 1 && !parse_uint32_text(fields[1], &progress)) {
                set_error(error_buffer, error_buffer_size, "invalid progress percent");
                return false;
            }
            card->progress_percent = (uint8_t)(progress > 100U ? 100U : progress);
            copy_display_segment(field_count > 2 ? fields[2] : NULL, strings->subtitle, sizeof(strings->subtitle));
            break;
        }
        default:
            break;
    }

    return true;
}

bool taby_reusable_preview_render_ui_command(const char *command, char *error_buffer, size_t error_buffer_size) {
    if (!command || strncmp(command, "UI/", 3) != 0) {
        set_error(error_buffer, error_buffer_size, "ui command required");
        return false;
    }

    const char *cursor = command + 3;
    char kind_text[24] = {0};
    size_t kind_len = 0U;
    while (cursor[kind_len] != '\0' &&
           cursor[kind_len] != ':' &&
           !is_ui_modifier_char(cursor[kind_len])) {
        if (kind_len + 1 >= sizeof(kind_text)) {
            set_error(error_buffer, error_buffer_size, "ui kind too long");
            return false;
        }
        kind_text[kind_len] = cursor[kind_len];
        kind_len++;
    }
    kind_text[kind_len] = '\0';
    cursor += kind_len;

    taby_reusable_card_t card = {
        .style = taby_reusable_ui_default_style(),
    };
    if (!parse_kind(kind_text, &card.kind)) {
        set_error(error_buffer, error_buffer_size, "unsupported ui kind");
        return false;
    }

    taby_reusable_preview_strings_t strings = {0};
    char screen_id[48] = {0};

    while (*cursor != '\0' && *cursor != ':') {
        if (*cursor == '?') {
            cursor++;
            size_t write_index = 0U;
            while (*cursor != '\0' && *cursor != ':' && !is_ui_modifier_char(*cursor)) {
                if (write_index + 1 >= sizeof(screen_id)) {
                    set_error(error_buffer, error_buffer_size, "screen id too long");
                    return false;
                }
                screen_id[write_index++] = *cursor++;
            }
            screen_id[write_index] = '\0';
            continue;
        }

        if (*cursor == '#') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.title_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid title color");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '^') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.body_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid body color");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '+') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.accent_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid accent color");
                return false;
            }
            card.style.headline_hex = card.style.accent_hex;
            card.style.button_border_hex = card.style.accent_hex;
            card.style.secondary_button_border_hex = card.style.accent_hex;
            card.style.progress_fill_hex = card.style.accent_hex;
            cursor += 6;
            continue;
        }

        if (*cursor == '%') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.background_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid background color");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '(') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.button_fill_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid primary button fill");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == ')') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.button_text_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid primary button text");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '[') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.button_border_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid primary button border");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '{') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.secondary_button_fill_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid secondary button fill");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '}') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.secondary_button_text_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid secondary button text");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '$') {
            cursor++;
            if (!parse_compact_hex(cursor, &card.style.secondary_button_border_hex)) {
                set_error(error_buffer, error_buffer_size, "invalid secondary button border");
                return false;
            }
            cursor += 6;
            continue;
        }

        if (*cursor == '!') {
            cursor++;
            size_t write_index = 0U;
            while (*cursor != '\0' && *cursor != ':' && !is_ui_modifier_char(*cursor)) {
                if (write_index + 1 >= sizeof(strings.animation_id)) {
                    set_error(error_buffer, error_buffer_size, "animation id too long");
                    return false;
                }
                strings.animation_id[write_index++] = *cursor++;
            }
            strings.animation_id[write_index] = '\0';
            card.behavior.animation_id = optional_text(strings.animation_id);
            continue;
        }

        if (*cursor == '*') {
            card.behavior.animation_play_on_show = true;
            cursor++;
            continue;
        }

        if (*cursor == '@') {
            cursor++;
            char seconds_text[16] = {0};
            size_t write_index = 0U;
            while (isdigit((unsigned char)*cursor) && write_index + 1 < sizeof(seconds_text)) {
                seconds_text[write_index++] = *cursor++;
            }
            seconds_text[write_index] = '\0';
            if (!parse_uint32_text(seconds_text, &card.behavior.animation_replay_seconds)) {
                set_error(error_buffer, error_buffer_size, "invalid animation replay");
                return false;
            }
            continue;
        }

        if (*cursor == '&') {
            cursor++;
            char effect_text[32] = {0};
            size_t write_index = 0U;
            while (*cursor != '\0' &&
                   *cursor != ':' &&
                   *cursor != '/' &&
                   !is_ui_modifier_char(*cursor) &&
                   write_index + 1 < sizeof(effect_text)) {
                effect_text[write_index++] = *cursor++;
            }
            effect_text[write_index] = '\0';
            if (!parse_decor_effect(effect_text, &card.behavior.decor_effect)) {
                set_error(error_buffer, error_buffer_size, "invalid decor effect");
                return false;
            }
            if (*cursor == '/') {
                cursor++;
                char seconds_text[16] = {0};
                size_t seconds_index = 0U;
                while (isdigit((unsigned char)*cursor) && seconds_index + 1 < sizeof(seconds_text)) {
                    seconds_text[seconds_index++] = *cursor++;
                }
                seconds_text[seconds_index] = '\0';
                if (!parse_uint32_text(seconds_text, &card.behavior.decor_effect_seconds)) {
                    set_error(error_buffer, error_buffer_size, "invalid decor seconds");
                    return false;
                }
            }
            continue;
        }

        if (*cursor == '~') {
            cursor++;
            char effect_text[16] = {0};
            size_t write_index = 0U;
            while (*cursor != '\0' &&
                   *cursor != ':' &&
                   *cursor != '/' &&
                   !is_ui_modifier_char(*cursor) &&
                   write_index + 1 < sizeof(effect_text)) {
                effect_text[write_index++] = *cursor++;
            }
            effect_text[write_index] = '\0';
            if (!parse_text_effect(effect_text, &card.behavior.text_effect)) {
                set_error(error_buffer, error_buffer_size, "invalid text effect");
                return false;
            }
            if (*cursor == '/') {
                cursor++;
                char seconds_text[16] = {0};
                size_t seconds_index = 0U;
                while (isdigit((unsigned char)*cursor) && seconds_index + 1 < sizeof(seconds_text)) {
                    seconds_text[seconds_index++] = *cursor++;
                }
                seconds_text[seconds_index] = '\0';
                if (!parse_uint32_text(seconds_text, &card.behavior.text_effect_seconds)) {
                    set_error(error_buffer, error_buffer_size, "invalid effect seconds");
                    return false;
                }
            }
            continue;
        }

        set_error(error_buffer, error_buffer_size, "invalid ui modifier");
        return false;
    }

    if (*cursor != ':') {
        set_error(error_buffer, error_buffer_size, "ui payload required");
        return false;
    }
    cursor++;

    if (!parse_ui_payload_into_card(cursor, &card, &strings, error_buffer, error_buffer_size)) {
        return false;
    }

    apply_card_defaults(&card, &strings);

    char state_name[48] = {0};
    build_ui_state_name(screen_id, card.kind, state_name, sizeof(state_name));
    ESP_LOGI(
        TAG,
        "parsed ui card state=%s kind=%s title='%s' subtitle='%s' icon='%s' primary='%s' secondary='%s'",
        state_name,
        card_kind_name(card.kind),
        strings.title,
        strings.subtitle,
        strings.icon_id,
        strings.primary_action_label,
        strings.secondary_action_label);
    if (!taby_runtime_render_reusable_card(&card, state_name)) {
        ESP_LOGW(TAG, "reusable render failed state=%s kind=%s", state_name, card_kind_name(card.kind));
        set_error(error_buffer, error_buffer_size, "ui render failed");
        return false;
    }

    return true;
}
