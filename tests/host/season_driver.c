/* Runs the firmware's Christmas rest off-device, for tests/test_season.py.

   Modes, one JSON object per line out:
     commands            hex-encoded lines through taby_season_parse_command
     stored              the look a unit starts in for each stored byte, what
                         SEASON reports as left, and when a told look is written
     rest LOOK           what the rest (idle_01_loop and the idle state) plays
                         with the season's look, through the real clip table
   Built with sanitizers. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "taby_animation_assets.h"
#include "taby_season.h"

static int hex_value(int ch) {
    if (ch >= '0' && ch <= '9') return ch - '0';
    if (ch >= 'a' && ch <= 'f') return ch - 'a' + 10;
    return -1;
}

static bool read_hex_line(char *out, size_t out_size) {
    static char line[512];
    if (!fgets(line, sizeof(line), stdin)) return false;
    size_t used = 0;
    for (size_t i = 0; line[i] && line[i + 1] && line[i] != '\n'; i += 2) {
        int high = hex_value((unsigned char)line[i]);
        int low = hex_value((unsigned char)line[i + 1]);
        if (high < 0 || low < 0 || used + 1 >= out_size) break;
        out[used++] = (char)(high * 16 + low);
    }
    out[used] = '\0';
    return true;
}

static const char *command_name(taby_season_command_t command) {
    switch (command) {
        case TABY_SEASON_COMMAND_QUERY: return "query";
        case TABY_SEASON_COMMAND_SET: return "set";
        case TABY_SEASON_COMMAND_OFF: return "off";
        case TABY_SEASON_COMMAND_INVALID: return "invalid";
        case TABY_SEASON_COMMAND_NONE:
        default: return "none";
    }
}

static taby_season_look_t look_from(const char *name) {
    if (strcmp(name, "hat") == 0) return TABY_SEASON_CHRISTMAS_HAT;
    if (strcmp(name, "lights") == 0) return TABY_SEASON_CHRISTMAS_LIGHTS;
    return TABY_SEASON_OFF;
}

static taby_season_look_t s_rest_look = TABY_SEASON_OFF;
static const char *rest_override(void) { return taby_season_rest_clip(s_rest_look); }

int main(int argc, char **argv) {
    if (argc >= 2 && strcmp(argv[1], "commands") == 0) {
        char line[256];
        while (read_hex_line(line, sizeof(line))) {
            taby_season_look_t look = TABY_SEASON_OFF;
            uint32_t seconds = 0;
            taby_season_command_t command = taby_season_parse_command(line, &look, &seconds);
            printf("{\"command\":\"%s\",\"look\":\"%s\",\"seconds\":%u}\n", command_name(command),
                   taby_season_look_name(look), (unsigned)seconds);
        }
        return 0;
    }
    if (argc == 2 && strcmp(argv[1], "stored") == 0) {
        const taby_season_look_t looks[] = {TABY_SEASON_OFF, TABY_SEASON_CHRISTMAS_HAT, TABY_SEASON_CHRISTMAS_LIGHTS};
        printf("{\"never_told\":\"%s\",\"after_power\":{", taby_season_look_name(taby_season_look_from_stored(false, 0)));
        for (size_t i = 0; i < 3; ++i) {
            uint8_t value = taby_season_stored_value(looks[i]);
            printf("%s\"%s\":[%u,\"%s\"]", i ? "," : "", taby_season_look_name(looks[i]), (unsigned)value,
                   taby_season_look_name(taby_season_look_from_stored(true, value)));
        }
        printf("},\"unknown_bytes\":[");
        const uint8_t unknown[] = {0, 4, 255};
        for (size_t i = 0; i < 3; ++i) {
            printf("%s\"%s\"", i ? "," : "", taby_season_look_name(taby_season_look_from_stored(true, unknown[i])));
        }
        printf("],\"seconds_left\":{");
        for (size_t i = 0; i < 3; ++i) {
            printf("%s\"%s\":%u", i ? "," : "", taby_season_look_name(looks[i]), (unsigned)taby_season_seconds_left(looks[i]));
        }
        uint8_t hat = taby_season_stored_value(TABY_SEASON_CHRISTMAS_HAT);
        printf("},\"writes\":{\"first_told\":%s,\"same_again\":%s,\"another\":%s}}\n",
               taby_season_needs_store(false, 0, TABY_SEASON_CHRISTMAS_HAT) ? "true" : "false",
               taby_season_needs_store(true, hat, TABY_SEASON_CHRISTMAS_HAT) ? "true" : "false",
               taby_season_needs_store(true, hat, TABY_SEASON_OFF) ? "true" : "false");
        return 0;
    }
    if (argc == 3 && strcmp(argv[1], "rest") == 0) {
        taby_animation_asset_t by_id, by_state, other;
        bool before = taby_animation_asset_for_id("idle_01_loop", &by_id);
        const char *before_id = before ? by_id.animation_id : "";
        s_rest_look = look_from(argv[2]);
        taby_animation_assets_set_rest_override(rest_override);
        bool found_id = taby_animation_asset_for_id("idle_01_loop", &by_id);
        bool found_alias = taby_animation_asset_for_id("idle_01__loop", &other);
        const char *alias_id = found_alias ? other.animation_id : "";
        bool found_state = taby_animation_asset_for_state(TABY_STATE_AMBIENT_IDLE, &by_state);
        bool found_other = taby_animation_asset_for_id("idle_02_loop", &other);
        printf("{\"without_season\":\"%s\",\"id\":\"%s\",\"path\":\"%s\",\"loop\":%s,\"alias\":\"%s\","
               "\"idle_state\":\"%s\",\"other_clip\":\"%s\",\"rests\":%s}\n",
               before_id, found_id ? by_id.animation_id : "", found_id && by_id.asset_pack_path ? by_id.asset_pack_path : "",
               found_id && by_id.loop ? "true" : "false", alias_id,
               found_state ? by_state.animation_id : "", found_other ? other.animation_id : "",
               taby_animation_id_rests("idle_01__loop") ? "true" : "false");
        taby_animation_assets_set_rest_override(NULL);
        return 0;
    }
    fprintf(stderr, "usage: season_driver commands | stored | rest LOOK\n");
    return 2;
}
