/* Runs the firmware's eye-motion parsing and rest-face plan off-device, for
   tests/test_eye_motion.py.

   Each mode prints one JSON object per result:
     commands              hex-encoded lines through taby_eye_motion_parse_command
     stored                stored bytes 0-255 through taby_eye_motion_from_stored
     plan MODE SEED STEPS  the frames a rest face shows, each with its hold

   `plan` stands in for the display: every frame the plan asks for is drawn
   with a 50 ms delay, which is what idle_01_loop's frames mostly carry, so a
   hold that differs from 50 is one the plan chose. Built with sanitizers. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "taby_eye_motion.h"

#define DRAWN_MS 50U

static int hex_value(int ch) {
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    }
    if (ch >= 'a' && ch <= 'f') {
        return ch - 'a' + 10;
    }
    return -1;
}

static bool read_hex_line(char *out, size_t out_size) {
    static char line[8192];
    if (!fgets(line, sizeof(line), stdin)) {
        return false;
    }
    size_t used = 0;
    for (size_t i = 0; line[i] && line[i + 1] && line[i] != '\n'; i += 2) {
        int high = hex_value((unsigned char)line[i]);
        int low = hex_value((unsigned char)line[i + 1]);
        if (high < 0 || low < 0 || used + 1 >= out_size) {
            break;
        }
        out[used++] = (char)((high << 4) | low);
    }
    out[used] = '\0';
    return true;
}

static void json_string(const char *text) {
    putchar('"');
    for (const unsigned char *cursor = (const unsigned char *)text; *cursor; ++cursor) {
        if (*cursor == '"' || *cursor == '\\') {
            printf("\\%c", *cursor);
        } else if (*cursor < 0x20 || *cursor >= 0x7F) {
            printf("\\u%04x", *cursor);
        } else {
            putchar(*cursor);
        }
    }
    putchar('"');
}

static const char *command_kind(taby_eye_motion_command_t kind) {
    switch (kind) {
        case TABY_EYE_MOTION_COMMAND_QUERY:
            return "query";
        case TABY_EYE_MOTION_COMMAND_SET:
            return "set";
        case TABY_EYE_MOTION_COMMAND_INVALID:
            return "invalid";
        case TABY_EYE_MOTION_COMMAND_NONE:
        default:
            return "none";
    }
}

static int run_commands(void) {
    static char command[4096];
    while (read_hex_line(command, sizeof(command))) {
        taby_eye_motion_t mode = (taby_eye_motion_t)99;
        taby_eye_motion_command_t kind = taby_eye_motion_parse_command(command, &mode);
        fputs("{\"input\":", stdout);
        json_string(command);
        printf(",\"kind\":\"%s\",\"mode\":", command_kind(kind));
        if (kind == TABY_EYE_MOTION_COMMAND_SET) {
            json_string(taby_eye_motion_name(mode));
        } else {
            fputs("null", stdout);
        }
        puts("}");
    }
    return 0;
}

static int run_stored(void) {
    for (unsigned int stored = 0; stored <= 255U; ++stored) {
        taby_eye_motion_t mode = TABY_EYE_MOTION_DEFAULT;
        bool known = taby_eye_motion_from_stored((uint8_t)stored, &mode);
        printf("{\"stored\":%u,\"known\":%s,\"mode\":", stored, known ? "true" : "false");
        if (known) {
            json_string(taby_eye_motion_name(mode));
        } else {
            fputs("null", stdout);
        }
        puts("}");
    }
    return 0;
}

static uint32_t next_random(uint32_t *state) {
    uint32_t x = *state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    *state = x;
    return x;
}

static int run_plan(const char *mode_name, unsigned long seed, unsigned long steps) {
    taby_eye_motion_t mode = TABY_EYE_MOTION_DEFAULT;
    if (!taby_eye_motion_from_name(mode_name, &mode)) {
        fprintf(stderr, "unknown mode %s\n", mode_name);
        return 2;
    }
    uint32_t state = (uint32_t)seed ? (uint32_t)seed : 1U;
    taby_rest_face_t face;
    memset(&face, 0xA5, sizeof(face));
    bool started = taby_rest_face_start(&face, mode, next_random(&state));
    printf("{\"started\":%s}\n", started ? "true" : "false");
    if (!started) {
        return 0;
    }
    bool rewound = true;
    for (unsigned long i = 0; i < steps; ++i) {
        uint32_t hold = taby_rest_face_hold_ms(&face, DRAWN_MS, next_random(&state));
        printf("{\"frame\":%u,\"hold_ms\":%u,\"rewound\":%s}\n",
               (unsigned int)face.frame, (unsigned int)hold, rewound ? "true" : "false");
        rewound = taby_rest_face_advance(&face, next_random(&state));
    }
    return 0;
}

int main(int argc, char **argv) {
    if (argc >= 2 && strcmp(argv[1], "commands") == 0) {
        return run_commands();
    }
    if (argc >= 2 && strcmp(argv[1], "stored") == 0) {
        return run_stored();
    }
    if (argc == 5 && strcmp(argv[1], "plan") == 0) {
        return run_plan(argv[2], strtoul(argv[3], NULL, 10), strtoul(argv[4], NULL, 10));
    }
    fprintf(stderr, "usage: eye_motion_driver commands | stored | plan MODE SEED STEPS\n");
    return 2;
}
