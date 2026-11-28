#include "taby_season.h"

#include <ctype.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

static const char k_command[] = "SEASON";

/* The next word of `text` into `word` (at most `size` - 1 letters); NULL at the end. */
static const char *next_word(const char *text, char *word, size_t size) {
    while (*text == ' ') {
        ++text;
    }
    if (*text == '\0') {
        return NULL;
    }
    size_t used = 0;
    while (*text != '\0' && *text != ' ') {
        if (used + 1 < size) {
            word[used++] = *text;
        } else {
            word[0] = '\0';
            return NULL;
        }
        ++text;
    }
    word[used] = '\0';
    return text;
}

static bool parse_seconds(const char *word, uint32_t *out_seconds) {
    if (word[0] == '\0') {
        return false;
    }
    uint32_t value = 0;
    for (const char *cursor = word; *cursor != '\0'; ++cursor) {
        if (!isdigit((unsigned char)*cursor)) {
            return false;
        }
        value = value * 10U + (uint32_t)(*cursor - '0');
        if (value > TABY_SEASON_MAX_SECONDS) {
            return false;
        }
    }
    if (value == 0) {
        return false;
    }
    *out_seconds = value;
    return true;
}

taby_season_command_t taby_season_parse_command(
    const char *text,
    taby_season_look_t *out_look,
    uint32_t *out_seconds) {
    if (!text || strncmp(text, k_command, sizeof(k_command) - 1) != 0) {
        return TABY_SEASON_COMMAND_NONE;
    }
    const char *rest = text + sizeof(k_command) - 1;
    if (*rest == '\0' || strcmp(rest, "?") == 0) {
        return TABY_SEASON_COMMAND_QUERY;
    }
    if (*rest != ' ') {
        return TABY_SEASON_COMMAND_NONE;
    }

    char words[4][16] = {{0}};
    size_t count = 0;
    const char *cursor = rest;
    while (count < 4 && cursor && (cursor = next_word(cursor, words[count], sizeof(words[count]))) != NULL) {
        ++count;
    }
    if (cursor && next_word(cursor, (char[16]){0}, 16) != NULL) {
        return TABY_SEASON_COMMAND_INVALID;
    }

    if (count == 1 && strcmp(words[0], "off") == 0) {
        return TABY_SEASON_COMMAND_OFF;
    }
    if (count == 3 && strcmp(words[0], "christmas") == 0) {
        taby_season_look_t look;
        if (strcmp(words[1], "hat") == 0) {
            look = TABY_SEASON_CHRISTMAS_HAT;
        } else if (strcmp(words[1], "lights") == 0) {
            look = TABY_SEASON_CHRISTMAS_LIGHTS;
        } else {
            return TABY_SEASON_COMMAND_INVALID;
        }
        uint32_t seconds = 0;
        if (!parse_seconds(words[2], &seconds)) {
            return TABY_SEASON_COMMAND_INVALID;
        }
        if (out_look) {
            *out_look = look;
        }
        if (out_seconds) {
            *out_seconds = seconds;
        }
        return TABY_SEASON_COMMAND_SET;
    }
    return TABY_SEASON_COMMAND_INVALID;
}

/* The byte kept for each told look. 0 is never written, so a unit that was
   never told reads as such even if the key held 0. */
enum {
    STORED_OFF = 1,
    STORED_HAT = 2,
    STORED_LIGHTS = 3,
};

uint8_t taby_season_stored_value(taby_season_look_t look) {
    switch (look) {
        case TABY_SEASON_CHRISTMAS_HAT:
            return STORED_HAT;
        case TABY_SEASON_CHRISTMAS_LIGHTS:
            return STORED_LIGHTS;
        case TABY_SEASON_OFF:
        default:
            return STORED_OFF;
    }
}

taby_season_look_t taby_season_look_from_stored(bool stored, uint8_t value) {
    if (!stored) {
        return TABY_SEASON_DEFAULT_LOOK;
    }
    switch (value) {
        case STORED_OFF:
            return TABY_SEASON_OFF;
        case STORED_HAT:
            return TABY_SEASON_CHRISTMAS_HAT;
        case STORED_LIGHTS:
            return TABY_SEASON_CHRISTMAS_LIGHTS;
        default:
            return TABY_SEASON_DEFAULT_LOOK;
    }
}

bool taby_season_needs_store(bool stored, uint8_t value, taby_season_look_t look) {
    return !stored || value != taby_season_stored_value(look);
}

uint32_t taby_season_seconds_left(taby_season_look_t look) {
    return look == TABY_SEASON_OFF ? 0 : TABY_SEASON_MAX_SECONDS;
}

const char *taby_season_look_name(taby_season_look_t look) {
    switch (look) {
        case TABY_SEASON_CHRISTMAS_HAT:
            return "hat";
        case TABY_SEASON_CHRISTMAS_LIGHTS:
            return "lights";
        case TABY_SEASON_OFF:
        default:
            return "off";
    }
}

const char *taby_season_rest_clip(taby_season_look_t look) {
    switch (look) {
        case TABY_SEASON_CHRISTMAS_HAT:
            return "christmas_idle_hat_loop";
        case TABY_SEASON_CHRISTMAS_LIGHTS:
            return "christmas_idle_lights_loop";
        case TABY_SEASON_OFF:
        default:
            return NULL;
    }
}
