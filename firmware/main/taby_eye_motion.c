#include "taby_eye_motion.h"

#include <stddef.h>
#include <string.h>

static const char *const k_mode_names[] = {
    [TABY_EYE_MOTION_NORMAL] = "normal",
    [TABY_EYE_MOTION_CALM] = "calm",
    [TABY_EYE_MOTION_STILL] = "still",
};

#define MODE_COUNT (sizeof(k_mode_names) / sizeof(k_mode_names[0]))

const char *taby_eye_motion_name(taby_eye_motion_t mode) {
    return (size_t)mode < MODE_COUNT ? k_mode_names[mode] : k_mode_names[TABY_EYE_MOTION_DEFAULT];
}

bool taby_eye_motion_from_name(const char *name, taby_eye_motion_t *out_mode) {
    if (!name) {
        return false;
    }
    for (size_t i = 0; i < MODE_COUNT; ++i) {
        if (strcmp(name, k_mode_names[i]) == 0) {
            if (out_mode) {
                *out_mode = (taby_eye_motion_t)i;
            }
            return true;
        }
    }
    return false;
}

bool taby_eye_motion_from_stored(uint8_t stored, taby_eye_motion_t *out_mode) {
    if (stored >= MODE_COUNT) {
        return false;
    }
    if (out_mode) {
        *out_mode = (taby_eye_motion_t)stored;
    }
    return true;
}

static bool is_space(char ch) {
    return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n';
}

taby_eye_motion_command_t taby_eye_motion_parse_command(const char *text, taby_eye_motion_t *out_mode) {
    static const char k_command[] = "EYE_MOTION";
    const size_t command_len = sizeof(k_command) - 1;
    if (!text || strncmp(text, k_command, command_len) != 0) {
        return TABY_EYE_MOTION_COMMAND_NONE;
    }

    const char *rest = text + command_len;
    if (rest[0] == '\0' || strcmp(rest, "?") == 0) {
        return TABY_EYE_MOTION_COMMAND_QUERY;
    }
    if (!is_space(rest[0])) {
        return TABY_EYE_MOTION_COMMAND_NONE;
    }

    while (is_space(*rest)) {
        rest++;
    }
    size_t len = 0;
    while (rest[len] != '\0' && !is_space(rest[len])) {
        len++;
    }
    for (const char *tail = rest + len; *tail != '\0'; ++tail) {
        if (!is_space(*tail)) {
            return TABY_EYE_MOTION_COMMAND_INVALID;
        }
    }

    char name[8] = {0};
    if (len == 0 || len >= sizeof(name)) {
        return TABY_EYE_MOTION_COMMAND_INVALID;
    }
    memcpy(name, rest, len);
    return taby_eye_motion_from_name(name, out_mode) ? TABY_EYE_MOTION_COMMAND_SET
                                                     : TABY_EYE_MOTION_COMMAND_INVALID;
}

static uint32_t between(uint32_t low, uint32_t high, uint32_t random) {
    return low + random % (high - low + 1U);
}

static uint8_t blinks_before_glance(uint32_t random) {
    return (uint8_t)between(TABY_REST_FACE_CALM_BLINKS_MIN, TABY_REST_FACE_CALM_BLINKS_MAX, random);
}

bool taby_rest_face_start(taby_rest_face_t *face, taby_eye_motion_t mode, uint32_t random) {
    if (!face || (mode != TABY_EYE_MOTION_CALM && mode != TABY_EYE_MOTION_STILL)) {
        return false;
    }
    face->mode = mode;
    face->frame = 0;
    face->glancing = false;
    face->blinks_before_glance = blinks_before_glance(random);
    return true;
}

bool taby_rest_face_advance(taby_rest_face_t *face, uint32_t random) {
    if (!face) {
        return true;
    }
    uint16_t last = face->glancing ? TABY_REST_FACE_GLANCE_LAST : TABY_REST_FACE_BLINK_LAST;
    if (face->frame < last) {
        face->frame++;
        return false;
    }

    /* A pass has ended; the next one starts from the rest frame. */
    face->frame = 0;
    if (face->glancing) {
        face->glancing = false;
        face->blinks_before_glance = blinks_before_glance(random);
    } else if (face->mode == TABY_EYE_MOTION_CALM) {
        if (face->blinks_before_glance > 0) {
            face->blinks_before_glance--;
        }
        face->glancing = face->blinks_before_glance == 0;
    }
    return true;
}

uint32_t taby_rest_face_hold_ms(const taby_rest_face_t *face, uint32_t drawn_ms, uint32_t random) {
    if (!face || face->frame != 0) {
        return drawn_ms > 0 ? drawn_ms : 10U;
    }
    return face->mode == TABY_EYE_MOTION_STILL
        ? between(TABY_REST_FACE_STILL_HOLD_MIN_MS, TABY_REST_FACE_STILL_HOLD_MAX_MS, random)
        : between(TABY_REST_FACE_CALM_HOLD_MIN_MS, TABY_REST_FACE_CALM_HOLD_MAX_MS, random);
}
