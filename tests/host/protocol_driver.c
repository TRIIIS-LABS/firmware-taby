/* Runs the firmware's own command parsing off-device, for tests/test_protocol.py.

   Each mode reads stdin and prints one JSON object per result:
     handle AVAILABLE_FILE   hex-encoded commands through the USB/BLE display handler
     lookup                  hex-encoded ids through the asset table
     ui                      hex-encoded UI/ commands through the card parser
     lines SIZE              raw bytes through the USB line reader
     fuzz SEED COUNT         generated input through all of the above

   AVAILABLE_FILE lists, one per line, the clips a board's asset pack holds,
   standing in for the SPIFFS check on the device. Built with sanitizers, so an
   out-of-bounds access fails the test rather than passing silently. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "taby_animation_assets.h"
#include "taby_line_reader.h"
#include "taby_reusable_preview.h"
#include "taby_reusable_ui.h"
#include "taby_state_machine.h"
#include "taby_transport_protocol.h"

#define MAX_INPUT 4096
#define MAX_AVAILABLE 256

static char s_available[MAX_AVAILABLE][TABY_TRANSPORT_ANIMATION_ID_SIZE];
static size_t s_available_count = 0;
static bool s_all_available = false;
static taby_state_t s_state = TABY_STATE_AMBIENT_IDLE;
static bool s_card_active = false;
static int s_apply_calls = 0;
static int s_clear_calls = 0;
static taby_transport_resolution_t s_applied;

/* ---- JSON output --------------------------------------------------------- */

static void json_string(const char *text) {
    putchar('"');
    for (const unsigned char *cursor = (const unsigned char *)(text ? text : ""); *cursor; ++cursor) {
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

static void json_field(const char *key, const char *value, bool last) {
    json_string(key);
    putchar(':');
    if (value) {
        json_string(value);
    } else {
        fputs("null", stdout);
    }
    fputs(last ? "" : ",", stdout);
}

/* ---- Hooks standing in for the runtime and the asset pack ----------------- */

static bool fake_animation_available(const char *animation_id) {
    taby_animation_asset_t asset = {0};
    if (!taby_animation_asset_for_id(animation_id, &asset)) {
        return false;
    }
    if (s_all_available) {
        return true;
    }
    for (size_t i = 0; i < s_available_count; ++i) {
        if (strcmp(s_available[i], asset.animation_id) == 0) {
            return true;
        }
    }
    return false;
}

static bool s_apply_result = true;

static bool fake_apply(const taby_transport_resolution_t *resolution) {
    s_apply_calls++;
    if (!s_apply_result) {
        return false;
    }
    s_applied = *resolution;
    s_state = taby_state_for_command(resolution->command);
    s_card_active = false;
    return true;
}

static const char *fake_state_name(void) {
    return taby_transport_state_name(s_state);
}

static bool fake_clear(void) {
    s_clear_calls++;
    s_card_active = false;
    return s_apply_result;
}

static const taby_transport_display_hooks_t k_hooks = {
    .animation_available = fake_animation_available,
    .apply = fake_apply,
    .state_name = fake_state_name,
    .clear = fake_clear,
};

/* ---- Stubs for what the card parser renders through ----------------------- */

static struct {
    bool rendered;
    taby_reusable_card_t card;
    char state_name[64];
    char title[160];
    char subtitle[160];
    char icon_id[64];
    char animation_id[96];
} s_card;

taby_reusable_style_t taby_reusable_ui_default_style(void) {
    taby_reusable_style_t style = {0};
    return style;
}

bool taby_runtime_render_reusable_card(const taby_reusable_card_t *card, const char *transport_state_name) {
    s_card.rendered = true;
    s_card.card = *card;
    snprintf(s_card.state_name, sizeof(s_card.state_name), "%s", transport_state_name ? transport_state_name : "");
    snprintf(s_card.title, sizeof(s_card.title), "%s", card->title ? card->title : "");
    snprintf(s_card.subtitle, sizeof(s_card.subtitle), "%s", card->subtitle ? card->subtitle : "");
    snprintf(s_card.icon_id, sizeof(s_card.icon_id), "%s", card->icon_id ? card->icon_id : "");
    snprintf(
        s_card.animation_id,
        sizeof(s_card.animation_id),
        "%s",
        card->behavior.animation_id ? card->behavior.animation_id : "");
    return true;
}

/* ---- Input ---------------------------------------------------------------- */

static int hex_value(int ch) {
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    }
    if (ch >= 'a' && ch <= 'f') {
        return ch - 'a' + 10;
    }
    if (ch >= 'A' && ch <= 'F') {
        return ch - 'A' + 10;
    }
    return -1;
}

/* Reads one hex-encoded line into out (NUL-terminated). False at end of input. */
static bool read_hex_line(char *out, size_t out_size) {
    static char line[MAX_INPUT * 2 + 4];
    if (!fgets(line, sizeof(line), stdin)) {
        return false;
    }

    size_t length = 0;
    for (size_t i = 0; line[i] && line[i] != '\n' && line[i + 1]; i += 2) {
        int high = hex_value((unsigned char)line[i]);
        int low = hex_value((unsigned char)line[i + 1]);
        if (high < 0 || low < 0 || length + 1 >= out_size) {
            break;
        }
        out[length++] = (char)((high << 4) | low);
    }
    out[length] = '\0';
    return true;
}

static void load_available(const char *path) {
    if (strcmp(path, "all") == 0) {
        s_all_available = true;
        return;
    }

    FILE *file = fopen(path, "r");
    if (!file) {
        fprintf(stderr, "cannot open %s\n", path);
        exit(2);
    }
    char line[TABY_TRANSPORT_ANIMATION_ID_SIZE + 2];
    while (s_available_count < MAX_AVAILABLE && fgets(line, sizeof(line), file)) {
        line[strcspn(line, "\r\n")] = '\0';
        size_t length = strlen(line);
        if (length == 0) {
            continue;
        }
        if (length >= TABY_TRANSPORT_ANIMATION_ID_SIZE) {
            length = TABY_TRANSPORT_ANIMATION_ID_SIZE - 1;
        }
        memcpy(s_available[s_available_count], line, length);
        s_available[s_available_count++][length] = '\0';
    }
    fclose(file);
}

/* ---- Modes ---------------------------------------------------------------- */

static const char *result_name(taby_display_command_result_t result) {
    switch (result) {
        case TABY_DISPLAY_COMMAND_APPLIED:
            return "applied";
        case TABY_DISPLAY_COMMAND_UNSUPPORTED_ANIMATION:
            return "unsupported_animation";
        case TABY_DISPLAY_COMMAND_UNSUPPORTED_COMMAND:
            return "unsupported_command";
        case TABY_DISPLAY_COMMAND_RUNTIME_UNAVAILABLE:
            return "runtime_unavailable";
        default:
            return "invalid";
    }
}

static void run_handle_one(const char *text, const char *prefix, bool echo, bool print) {
    char reply[192];
    int apply_before = s_apply_calls;
    int clear_before = s_clear_calls;
    taby_display_command_result_t result =
        taby_transport_handle_display_command(text, &k_hooks, prefix, echo, reply, sizeof(reply));
    if (!print) {
        return;
    }

    putchar('{');
    json_field("input", text, false);
    json_field("result", result_name(result), false);
    json_field("reply", reply, false);
    json_field("state", fake_state_name(), false);
    printf("\"applied\":%s,\"cleared\":%s,", s_apply_calls > apply_before ? "true" : "false",
           s_clear_calls > clear_before ? "true" : "false");
    json_field("animation_id", s_apply_calls > apply_before ? s_applied.animation_id : NULL, false);
    json_field("next_animation_id", s_apply_calls > apply_before ? s_applied.next_animation_id : NULL, true);
    puts("}");
}

static int mode_handle(int argc, char **argv) {
    if (argc < 3) {
        return 2;
    }
    load_available(argv[2]);
    const char *prefix = argc > 3 ? argv[3] : "TABY:";
    bool echo = argc > 4 ? strcmp(argv[4], "echo") == 0 : true;
    s_apply_result = !(argc > 5 && strcmp(argv[5], "apply_fails") == 0);

    char text[MAX_INPUT];
    while (read_hex_line(text, sizeof(text))) {
        run_handle_one(text, prefix, echo, true);
    }
    return 0;
}

static int mode_lookup(void) {
    char text[MAX_INPUT];
    while (read_hex_line(text, sizeof(text))) {
        taby_animation_asset_t asset = {0};
        bool found = taby_animation_asset_for_id(text, &asset);
        putchar('{');
        json_field("input", text, false);
        printf("\"found\":%s,", found ? "true" : "false");
        json_field("animation_id", found ? asset.animation_id : NULL, false);
        json_field("path", found ? asset.asset_pack_path : NULL, false);
        printf("\"duration_ms\":%u,\"loop\":%s}\n", (unsigned int)asset.duration_ms, asset.loop ? "true" : "false");
    }
    return 0;
}

static void run_ui_one(const char *text, bool print) {
    char error[96] = {0};
    memset(&s_card, 0, sizeof(s_card));
    bool ok = taby_reusable_preview_render_ui_command(text, error, sizeof(error));
    if (!print) {
        return;
    }

    const taby_reusable_behavior_t *behavior = &s_card.card.behavior;
    putchar('{');
    json_field("input", text, false);
    printf("\"ok\":%s,", ok ? "true" : "false");
    json_field("error", ok ? NULL : error, false);
    printf("\"rendered\":%s,", s_card.rendered ? "true" : "false");
    json_field("state_name", s_card.state_name, false);
    json_field("title", s_card.title, false);
    json_field("subtitle", s_card.subtitle, false);
    json_field("icon_id", s_card.icon_id, false);
    json_field("animation_id", s_card.animation_id, false);
    printf(
        "\"kind\":%d,\"countdown_total_seconds\":%u,\"countdown_remaining_seconds\":%u,"
        "\"countdown_visible_seconds\":%u,\"progress_percent\":%u,\"text_effect_seconds\":%u,"
        "\"decor_effect_seconds\":%u,\"animation_replay_seconds\":%u}\n",
        (int)s_card.card.kind,
        (unsigned int)s_card.card.countdown_total_seconds,
        (unsigned int)s_card.card.countdown_remaining_seconds,
        (unsigned int)behavior->countdown_visible_seconds,
        (unsigned int)s_card.card.progress_percent,
        (unsigned int)behavior->text_effect_seconds,
        (unsigned int)behavior->decor_effect_seconds,
        (unsigned int)behavior->animation_replay_seconds);
}

static int mode_ui(void) {
    char text[MAX_INPUT];
    while (read_hex_line(text, sizeof(text))) {
        run_ui_one(text, true);
    }
    return 0;
}

static int mode_lines(int argc, char **argv) {
    size_t size = argc > 2 ? (size_t)strtoul(argv[2], NULL, 10) : 2048U;
    char *buffer = malloc(size ? size : 1);
    if (!buffer) {
        return 2;
    }
    taby_line_reader_t reader;
    taby_line_reader_init(&reader, buffer, size);

    int ch = 0;
    while ((ch = getchar()) != EOF) {
        switch (taby_line_reader_push(&reader, (uint8_t)ch)) {
            case TABY_LINE_READER_LINE:
                putchar('{');
                json_field("event", "line", false);
                json_field("text", reader.buffer, true);
                puts("}");
                break;
            case TABY_LINE_READER_TOO_LONG:
                puts("{\"event\":\"too_long\"}");
                break;
            case TABY_LINE_READER_NONE:
            default:
                break;
        }
    }
    free(buffer);
    return 0;
}

/* xorshift32: deterministic across compilers and platforms. */
static uint32_t s_rng = 1;
static uint32_t next_random(void) {
    s_rng ^= s_rng << 13;
    s_rng ^= s_rng >> 17;
    s_rng ^= s_rng << 5;
    return s_rng;
}

static const char *const k_fragments[] = {
    "UI/", "title", "title_subtitle", "choice_2", "timer", "progress", "icon", "title_action",
    "?", "#", "^", "+", "%", "(", ")", "[", "{", "}", "$", "!", "*", "@", "&", "~", ":", "|",
    ">", "/", " ", "TBY", "TBY!", "TBY#", "TBY@", "PD", "V", "CLEAR", "CMD ", "BRIGHTNESS ",
    "taby_response_ready_in", "taby_response_ready_loop", "dizzy_loop", "confirmation",
    "shooting_stars", "blink", "dots", "run", "pause", "4294967295", "99999999999999999999",
    "536870912", "0", "1", "ff00ff", "FFFFFF", "zz", "_", "__loop", "animation",
};

static size_t random_input(char *out, size_t out_size) {
    size_t length = 0;
    uint32_t pieces = next_random() % 40U;
    for (uint32_t piece = 0; piece < pieces && length + 1 < out_size; ++piece) {
        if (next_random() % 4U == 0) {
            /* Any byte but NUL, which ends a C string before the parser sees it. */
            out[length++] = (char)(1U + next_random() % 255U);
            continue;
        }
        const char *fragment = k_fragments[next_random() % (sizeof(k_fragments) / sizeof(k_fragments[0]))];
        uint32_t repeat = next_random() % 16U == 0 ? 1U + next_random() % 200U : 1U;
        for (uint32_t r = 0; r < repeat; ++r) {
            for (size_t i = 0; fragment[i] && length + 1 < out_size; ++i) {
                out[length++] = fragment[i];
            }
        }
    }
    out[length] = '\0';
    return length;
}

static int mode_fuzz(int argc, char **argv) {
    s_rng = argc > 2 ? (uint32_t)strtoul(argv[2], NULL, 10) : 1U;
    if (s_rng == 0) {
        s_rng = 1;
    }
    unsigned long count = argc > 3 ? strtoul(argv[3], NULL, 10) : 10000UL;
    s_all_available = false;
    s_available_count = 0;
    snprintf(s_available[s_available_count++], TABY_TRANSPORT_ANIMATION_ID_SIZE, "%s", "confirmation");
    snprintf(s_available[s_available_count++], TABY_TRANSPORT_ANIMATION_ID_SIZE, "%s", "idle_01_loop");

    char line_buffer[64];
    taby_line_reader_t reader;
    taby_line_reader_init(&reader, line_buffer, sizeof(line_buffer));

    char text[MAX_INPUT];
    for (unsigned long i = 0; i < count; ++i) {
        size_t length = random_input(text, sizeof(text));
        s_apply_result = (next_random() % 8U) != 0;
        run_handle_one(text, (i & 1U) ? "TABY:" : "", (i & 2U) != 0, false);
        run_ui_one(text, false);

        taby_transport_resolution_t resolution;
        char unknown[TABY_TRANSPORT_ANIMATION_ID_MAX_LEN + 1];
        taby_transport_resolve_text_status(text, &resolution, unknown, sizeof(unknown));
        const char *required[2];
        taby_transport_required_animations(&resolution, required);
        taby_animation_asset_t asset;
        taby_animation_asset_for_id(text, &asset);

        for (size_t b = 0; b < length; ++b) {
            taby_line_reader_push(&reader, (uint8_t)text[b]);
        }
        taby_line_reader_push(&reader, '\n');
    }
    printf("{\"fuzzed\":%lu}\n", count);
    return 0;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s handle|lookup|ui|lines|fuzz ...\n", argv[0]);
        return 2;
    }
    if (strcmp(argv[1], "handle") == 0) {
        return mode_handle(argc, argv);
    }
    if (strcmp(argv[1], "lookup") == 0) {
        return mode_lookup();
    }
    if (strcmp(argv[1], "ui") == 0) {
        return mode_ui();
    }
    if (strcmp(argv[1], "lines") == 0) {
        return mode_lines(argc, argv);
    }
    if (strcmp(argv[1], "fuzz") == 0) {
        return mode_fuzz(argc, argv);
    }
    fprintf(stderr, "unknown mode %s\n", argv[1]);
    return 2;
}
