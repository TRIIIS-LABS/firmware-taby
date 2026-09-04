#include "taby_transport_protocol.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "taby_animation_assets.h"
#include "taby_state_machine.h"

static void copy_text(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0) {
        return;
    }

    if (!source) {
        destination[0] = '\0';
        return;
    }

    size_t copy_len = 0;
    while (copy_len + 1 < destination_size && source[copy_len] != '\0') {
        destination[copy_len] = source[copy_len];
        copy_len++;
    }
    destination[copy_len] = '\0';
}

static void copy_humanized_upper(char *destination, size_t destination_size, const char *source) {
    if (!destination || destination_size == 0) {
        return;
    }

    size_t write_index = 0;
    bool last_was_space = true;
    for (size_t i = 0; source && source[i] != '\0' && write_index + 1 < destination_size; ++i) {
        unsigned char ch = (unsigned char)source[i];
        if (isalnum(ch)) {
            destination[write_index++] = (char)toupper(ch);
            last_was_space = false;
        } else if (!last_was_space) {
            destination[write_index++] = ' ';
            last_was_space = true;
        }
    }

    while (write_index > 0 && destination[write_index - 1] == ' ') {
        write_index--;
    }
    destination[write_index] = '\0';
}

static void set_resolution(
    taby_transport_resolution_t *resolution,
    taby_command_t command,
    const char *title,
    const char *subtitle) {
    resolution->command = command;
    copy_text(resolution->title, sizeof(resolution->title), title);
    copy_text(resolution->subtitle, sizeof(resolution->subtitle), subtitle);
    resolution->animation_id[0] = '\0';
    resolution->next_animation_id[0] = '\0';
}

static void set_animation_resolution(
    taby_transport_resolution_t *resolution,
    const char *animation_id,
    const char *title,
    const char *subtitle) {
    resolution->command = TABY_COMMAND_CUSTOM_ANIMATION;
    copy_text(resolution->animation_id, sizeof(resolution->animation_id), animation_id);
    copy_text(resolution->title, sizeof(resolution->title), title);
    copy_text(resolution->subtitle, sizeof(resolution->subtitle), subtitle);
    resolution->next_animation_id[0] = '\0';
}

static bool set_resolution_from_animation_id(
    taby_transport_resolution_t *resolution,
    const char *animation_id,
    const char *fallback_title) {
    taby_animation_asset_t asset = {0};
    if (!taby_animation_asset_for_id(animation_id, &asset)) {
        return false;
    }

    char title[TABY_TRANSPORT_LABEL_SIZE] = {0};
    copy_humanized_upper(title, sizeof(title), fallback_title && fallback_title[0] ? fallback_title : asset.animation_id);
    set_animation_resolution(
        resolution,
        asset.animation_id,
        title[0] ? title : "ANIMATION",
        asset.loop ? "Animation loop" : "Animation");
    return true;
}

static bool parse_animation_sequence(
    const char *text,
    char *animation_id,
    size_t animation_id_size,
    char *next_animation_id,
    size_t next_animation_id_size) {
    if (!text || !animation_id || !next_animation_id || animation_id_size == 0 || next_animation_id_size == 0) {
        return false;
    }

    const char *separator = strchr(text, '>');
    if (!separator || separator == text || separator[1] == '\0' || strchr(separator + 1, '>') != NULL) {
        return false;
    }

    size_t left_len = (size_t)(separator - text);
    size_t right_len = strlen(separator + 1);
    if (left_len + 1 > animation_id_size || right_len + 1 > next_animation_id_size) {
        return false;
    }

    for (size_t i = 0; i < left_len; ++i) {
        unsigned char ch = (unsigned char)text[i];
        if (!isalnum(ch) && ch != '_') {
            return false;
        }
        animation_id[i] = (char)tolower(ch);
    }
    animation_id[left_len] = '\0';

    for (size_t i = 0; i < right_len; ++i) {
        unsigned char ch = (unsigned char)separator[1 + i];
        if (!isalnum(ch) && ch != '_') {
            return false;
        }
        next_animation_id[i] = (char)tolower(ch);
    }
    next_animation_id[right_len] = '\0';

    return true;
}

static bool set_resolution_from_animation_sequence(
    taby_transport_resolution_t *resolution,
    const char *animation_id,
    const char *next_animation_id,
    const char *fallback_title) {
    taby_animation_asset_t asset = {0};
    taby_animation_asset_t next_asset = {0};
    if (!taby_animation_asset_for_id(animation_id, &asset) ||
        !taby_animation_asset_for_id(next_animation_id, &next_asset)) {
        return false;
    }

    char title[TABY_TRANSPORT_LABEL_SIZE] = {0};
    copy_humanized_upper(title, sizeof(title), fallback_title && fallback_title[0] ? fallback_title : asset.animation_id);
    set_animation_resolution(
        resolution,
        asset.animation_id,
        title[0] ? title : "ANIMATION",
        next_asset.loop ? "Animation intro" : "Animation");
    copy_text(resolution->next_animation_id, sizeof(resolution->next_animation_id), next_asset.animation_id);
    return true;
}

static void set_busy_resolution(
    taby_transport_resolution_t *resolution,
    const char *text,
    const char *metadata) {
    char title[TABY_TRANSPORT_LABEL_SIZE] = {0};
    copy_humanized_upper(title, sizeof(title), text);
    if (title[0] == '\0') {
        copy_text(title, sizeof(title), "BUSY");
    }

    set_resolution(resolution, TABY_COMMAND_AMBIENT_BUSY, title, metadata && metadata[0] ? metadata : "Busy loop");
}

static bool parse_busy_metadata(
    const char *source,
    char *out_metadata,
    size_t out_metadata_size,
    const char **out_text) {
    if (!source || !out_metadata || out_metadata_size == 0) {
        return false;
    }

    out_metadata[0] = '\0';
    if (out_text) {
        *out_text = NULL;
    }

    const char *cursor = source;
    size_t write_index = 0;

    if (cursor[0] == '#') {
        if (out_metadata_size < 8) {
            return false;
        }

        out_metadata[write_index++] = '#';
        for (size_t i = 0; i < 6; ++i) {
            unsigned char ch = (unsigned char)cursor[i + 1];
            if (!isxdigit(ch)) {
                return false;
            }
            out_metadata[write_index++] = (char)toupper(ch);
        }

        cursor += 7;
    }

    if (cursor[0] == '@') {
        size_t digit_count = 0;
        while (isdigit((unsigned char)cursor[digit_count + 1])) {
            digit_count++;
        }

        if (digit_count == 0 || write_index + 1 + digit_count >= out_metadata_size) {
            return false;
        }

        out_metadata[write_index++] = '@';
        for (size_t i = 0; i < digit_count; ++i) {
            out_metadata[write_index++] = cursor[i + 1];
        }

        cursor += 1 + digit_count;
    }

    if (cursor[0] == '!') {
        size_t id_count = 0;
        while (isalnum((unsigned char)cursor[id_count + 1]) || cursor[id_count + 1] == '_') {
            id_count++;
        }

        if (id_count == 0 || write_index + 1 + id_count >= out_metadata_size) {
            return false;
        }

        out_metadata[write_index++] = '!';
        for (size_t i = 0; i < id_count; ++i) {
            out_metadata[write_index++] = (char)tolower((unsigned char)cursor[i + 1]);
        }

        cursor += 1 + id_count;
    }

    out_metadata[write_index] = '\0';

    if (cursor[0] == '\0') {
        return true;
    }

    if (cursor[0] == ':' || cursor[0] == '/' || cursor[0] == ' ') {
        if (out_text) {
            *out_text = cursor + 1;
        }
        return true;
    }

    return false;
}

static const char *default_label_for_command(taby_command_t command) {
    switch (command) {
        case TABY_COMMAND_STOP:
        case TABY_COMMAND_AMBIENT_IDLE:
            return "IDLE";
        case TABY_COMMAND_AMBIENT_STARTUP:
            return "STARTUP";
        case TABY_COMMAND_AMBIENT_WAITING:
            return "WAITING";
        case TABY_COMMAND_VOICE_LISTENING:
            return "LISTENING";
        case TABY_COMMAND_VOICE_TALKING:
            return "TALKING";
        case TABY_COMMAND_TOOL_USE:
            return "WORKING";
        case TABY_COMMAND_TASK_DELETE:
            return "DELETE";
        case TABY_COMMAND_AMBIENT_BUSY:
            return "BUSY";
        case TABY_COMMAND_FOCUS_TIMER:
            return "FOCUS";
        case TABY_COMMAND_BREAK_START:
            return "BREAK";
        case TABY_COMMAND_CUSTOM_ANIMATION:
            return "ANIMATION";
        case TABY_COMMAND_MISSING_FEATURE:
            return "COMING SOON";
        case TABY_COMMAND_NONE:
        default:
            return "TABY";
    }
}

static void set_resolution_from_command_text(
    taby_transport_resolution_t *resolution,
    taby_command_t command,
    const char *command_text) {
    char title[TABY_TRANSPORT_LABEL_SIZE] = {0};
    copy_humanized_upper(title, sizeof(title), command_text);
    if (title[0] == '\0') {
        copy_text(title, sizeof(title), default_label_for_command(command));
    }

    switch (command) {
        case TABY_COMMAND_FOCUS_TIMER:
            set_resolution(resolution, command, title[0] ? title : "FOCUS", "Text preview");
            return;
        case TABY_COMMAND_BREAK_START:
            set_resolution(resolution, command, title[0] ? title : "BREAK", "Text preview");
            return;
        case TABY_COMMAND_AMBIENT_BUSY:
            set_resolution(resolution, command, title[0] ? title : "BUSY", "Busy loop");
            return;
        case TABY_COMMAND_MISSING_FEATURE:
            set_resolution(resolution, command, title[0] ? title : "COMING SOON", "Text preview");
            return;
        default:
            set_resolution(resolution, command, title[0] ? title : default_label_for_command(command), command_text);
            return;
    }
}

bool taby_transport_resolve_text(const char *text, taby_transport_resolution_t *out_resolution) {
    if (!text || !out_resolution) {
        return false;
    }

    memset(out_resolution, 0, sizeof(*out_resolution));

    if (strcmp(text, "S") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_STOP, "IDLE", "Ambient loop");
        return true;
    }
    if (strcmp(text, "VL") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_VOICE_LISTENING, "LISTENING", "Voice animation");
        return true;
    }
    if (strcmp(text, "VT") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_VOICE_TALKING, "TALKING", "Voice animation");
        return true;
    }
    if (strcmp(text, "U") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_TOOL_USE, "WORKING", "Tool animation");
        return true;
    }
    if (strcmp(text, "D") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_TASK_DELETE, "DELETE", "Delete animation");
        return true;
    }
    if (strcmp(text, "TBY") == 0) {
        set_busy_resolution(out_resolution, NULL, NULL);
        return true;
    }
    if (strncmp(text, "TBY#", 4) == 0 || strncmp(text, "TBY@", 4) == 0 || strncmp(text, "TBY!", 4) == 0) {
        char metadata[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
        const char *busy_text = NULL;
        if (!parse_busy_metadata(text + 3, metadata, sizeof(metadata), &busy_text)) {
            return false;
        }
        set_busy_resolution(out_resolution, busy_text, metadata);
        return true;
    }
    if (strncmp(text, "TBY:", 4) == 0 || strncmp(text, "TBY/", 4) == 0 || strncmp(text, "TBY ", 4) == 0) {
        set_busy_resolution(out_resolution, text + 4, NULL);
        return true;
    }
    if (strcmp(text, "F") == 0 || strcmp(text, "0") == 0 || strcmp(text, "1") == 0) {
        const char *title = strcmp(text, "0") == 0 ? "POMODORO 0" : strcmp(text, "1") == 0 ? "POMODORO 1" : "FOCUS";
        set_resolution(out_resolution, TABY_COMMAND_FOCUS_TIMER, title, "Timer text");
        return true;
    }
    if (strcmp(text, "P2") == 0) {
        const char *title = "POMODORO DONE";
        set_resolution(out_resolution, TABY_COMMAND_BREAK_START, title, "Break text");
        return true;
    }
    if (strcmp(text, "updating") == 0 || strcmp(text, "UPDATING") == 0 || strcmp(text, "UPDATE") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_MISSING_FEATURE, "UPDATING", "Do not unplug");
        return true;
    }
    if (strncmp(text, "NAV:", 4) == 0) {
        set_resolution(out_resolution, TABY_COMMAND_AMBIENT_IDLE, "AMBIENT", "Idle animation");
        return true;
    }

    char animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
    char next_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
    if (parse_animation_sequence(
            text,
            animation_id,
            sizeof(animation_id),
            next_animation_id,
            sizeof(next_animation_id))) {
        return set_resolution_from_animation_sequence(out_resolution, animation_id, next_animation_id, NULL);
    }

    if (strcmp(text, "L") == 0) {
        return set_resolution_from_animation_id(out_resolution, "love_01", "LOVE");
    }
    if (strcmp(text, "B") == 0) {
        return set_resolution_from_animation_id(out_resolution, "blush", "BLUSH");
    }
    if (strcmp(text, "K") == 0) {
        return set_resolution_from_animation_id(out_resolution, "task_completed", "FINISHED");
    }
    if (strcmp(text, "A") == 0) {
        return set_resolution_from_animation_id(out_resolution, "trophy", "ACHIEVEMENT");
    }
    if (strcmp(text, "R") == 0) {
        return set_resolution_from_animation_id(out_resolution, "relaxing_01_loop", "RELAXING");
    }
    if (strcmp(text, "V") == 0 || strncmp(text, "V", 1) == 0) {
        return set_resolution_from_animation_id(out_resolution, "listening_loop", "VOICE");
    }
    if (strcmp(text, "W") == 0) {
        return set_resolution_from_animation_id(out_resolution, "drink_water", "DRINK WATER");
    }
    if (strncmp(text, "PD", 2) == 0) {
        char animation_id[32] = "perfect_day_01";
        if (text[2] == '2') {
            copy_text(animation_id, sizeof(animation_id), "perfect_day_02");
        } else if (text[2] == '3') {
            copy_text(animation_id, sizeof(animation_id), "perfect_day_03");
        }
        char title[TABY_TRANSPORT_LABEL_SIZE];
        snprintf(title, sizeof(title), "PERFECT DAY %c", text[2] ? text[2] : '1');
        return set_resolution_from_animation_id(out_resolution, animation_id, title);
    }

    taby_command_t command = TABY_COMMAND_NONE;
    if (taby_command_from_string(text, &command)) {
        if (command == TABY_COMMAND_BREAK_START) {
            return set_resolution_from_animation_id(out_resolution, "break_start", "BREAK");
        }

        set_resolution_from_command_text(out_resolution, command, text);
        return true;
    }

    return set_resolution_from_animation_id(out_resolution, text, NULL);
}

bool taby_transport_command_from_text(const char *text, taby_command_t *out_command) {
    if (!out_command) {
        return false;
    }

    taby_transport_resolution_t resolution = {0};
    if (!taby_transport_resolve_text(text, &resolution)) {
        return false;
    }

    *out_command = resolution.command;
    return true;
}

const char *taby_transport_state_name(taby_state_t state) {
    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
            return "STARTUP";
        case TABY_STATE_AMBIENT_IDLE:
            return "IDLE";
        case TABY_STATE_AMBIENT_WAITING:
            return "WAITING";
        case TABY_STATE_VOICE_LISTENING:
            return "VOICE_LISTENING";
        case TABY_STATE_VOICE_TALKING:
            return "VOICE_TALKING";
        case TABY_STATE_TOOL_USE:
            return "TOOL_USE";
        case TABY_STATE_TASK_DELETE:
            return "TASK_DELETE";
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
        case TABY_STATE_AMBIENT_BUSY_TEXT:
            return "AMBIENT_BUSY";
        case TABY_STATE_FOCUS_TIMER:
            return "FOCUS_TIMER";
        case TABY_STATE_BREAK_START:
            return "BREAK_START";
        case TABY_STATE_CUSTOM_ANIMATION:
            return "ANIMATION";
        case TABY_STATE_MISSING_FEATURE:
            return "COMING_SOON";
        default:
            return "UNKNOWN";
    }
}
