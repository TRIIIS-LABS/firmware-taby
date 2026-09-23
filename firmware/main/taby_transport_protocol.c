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

bool taby_transport_is_animation_id(const char *text) {
    if (!text || text[0] == '\0') {
        return false;
    }

    size_t length = 0;
    for (; text[length] != '\0'; ++length) {
        unsigned char ch = (unsigned char)text[length];
        if (length >= TABY_TRANSPORT_ANIMATION_ID_MAX_LEN ||
            !((ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '_')) {
            return false;
        }
    }
    return true;
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

static taby_transport_resolve_status_t unknown_animation(
    const char *animation_id,
    char *out_animation_id,
    size_t out_animation_id_size) {
    copy_text(out_animation_id, out_animation_id_size, animation_id);
    return TABY_TRANSPORT_UNKNOWN_ANIMATION;
}

static taby_transport_resolve_status_t resolve_animation_id(
    taby_transport_resolution_t *resolution,
    const char *animation_id,
    const char *fallback_title,
    char *out_animation_id,
    size_t out_animation_id_size) {
    if (set_resolution_from_animation_id(resolution, animation_id, fallback_title)) {
        return TABY_TRANSPORT_RESOLVED;
    }
    return unknown_animation(animation_id, out_animation_id, out_animation_id_size);
}

bool taby_transport_resolve_text(const char *text, taby_transport_resolution_t *out_resolution) {
    return taby_transport_resolve_text_status(text, out_resolution, NULL, 0) == TABY_TRANSPORT_RESOLVED;
}

taby_transport_resolve_status_t taby_transport_resolve_text_status(
    const char *text,
    taby_transport_resolution_t *out_resolution,
    char *out_animation_id,
    size_t out_animation_id_size) {
    copy_text(out_animation_id, out_animation_id_size, NULL);
    if (!text || !out_resolution) {
        return TABY_TRANSPORT_UNKNOWN_COMMAND;
    }

    memset(out_resolution, 0, sizeof(*out_resolution));

    if (strcmp(text, "S") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_STOP, "IDLE", "Ambient loop");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "VL") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_VOICE_LISTENING, "LISTENING", "Voice animation");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "VT") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_VOICE_TALKING, "TALKING", "Voice animation");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "U") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_TOOL_USE, "WORKING", "Tool animation");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "D") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_TASK_DELETE, "DELETE", "Delete animation");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "TBY") == 0) {
        set_busy_resolution(out_resolution, NULL, NULL);
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strncmp(text, "TBY#", 4) == 0 || strncmp(text, "TBY@", 4) == 0 || strncmp(text, "TBY!", 4) == 0) {
        char metadata[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
        const char *busy_text = NULL;
        if (!parse_busy_metadata(text + 3, metadata, sizeof(metadata), &busy_text)) {
            return TABY_TRANSPORT_UNKNOWN_COMMAND;
        }
        set_busy_resolution(out_resolution, busy_text, metadata);
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strncmp(text, "TBY:", 4) == 0 || strncmp(text, "TBY/", 4) == 0 || strncmp(text, "TBY ", 4) == 0) {
        set_busy_resolution(out_resolution, text + 4, NULL);
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "F") == 0 || strcmp(text, "0") == 0 || strcmp(text, "1") == 0) {
        const char *title = strcmp(text, "0") == 0 ? "POMODORO 0" : strcmp(text, "1") == 0 ? "POMODORO 1" : "FOCUS";
        set_resolution(out_resolution, TABY_COMMAND_FOCUS_TIMER, title, "Timer text");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "P2") == 0) {
        const char *title = "POMODORO DONE";
        set_resolution(out_resolution, TABY_COMMAND_BREAK_START, title, "Break text");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strcmp(text, "updating") == 0 || strcmp(text, "UPDATING") == 0 || strcmp(text, "UPDATE") == 0) {
        set_resolution(out_resolution, TABY_COMMAND_MISSING_FEATURE, "UPDATING", "Do not unplug");
        return TABY_TRANSPORT_RESOLVED;
    }
    if (strncmp(text, "NAV:", 4) == 0) {
        set_resolution(out_resolution, TABY_COMMAND_AMBIENT_IDLE, "AMBIENT", "Idle animation");
        return TABY_TRANSPORT_RESOLVED;
    }

    char animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
    char next_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE] = {0};
    if (parse_animation_sequence(
            text,
            animation_id,
            sizeof(animation_id),
            next_animation_id,
            sizeof(next_animation_id))) {
        if (set_resolution_from_animation_sequence(out_resolution, animation_id, next_animation_id, NULL)) {
            return TABY_TRANSPORT_RESOLVED;
        }
        taby_animation_asset_t asset = {0};
        return unknown_animation(
            taby_animation_asset_for_id(animation_id, &asset) ? next_animation_id : animation_id,
            out_animation_id,
            out_animation_id_size);
    }

    if (strcmp(text, "L") == 0) {
        return resolve_animation_id(out_resolution, "love_01", "LOVE", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "B") == 0) {
        return resolve_animation_id(out_resolution, "blush", "BLUSH", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "K") == 0) {
        return resolve_animation_id(out_resolution, "task_completed", "FINISHED", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "A") == 0) {
        return resolve_animation_id(out_resolution, "trophy", "ACHIEVEMENT", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "R") == 0) {
        return resolve_animation_id(out_resolution, "relaxing_01_loop", "RELAXING", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "V") == 0 || strncmp(text, "V", 1) == 0) {
        return resolve_animation_id(out_resolution, "listening_loop", "VOICE", out_animation_id, out_animation_id_size);
    }
    if (strcmp(text, "W") == 0) {
        return resolve_animation_id(out_resolution, "drink_water", "DRINK WATER", out_animation_id, out_animation_id_size);
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
        return resolve_animation_id(out_resolution, animation_id, title, out_animation_id, out_animation_id_size);
    }

    taby_command_t command = TABY_COMMAND_NONE;
    if (taby_command_from_string(text, &command)) {
        if (command == TABY_COMMAND_BREAK_START) {
            return resolve_animation_id(out_resolution, "break_start", "BREAK", out_animation_id, out_animation_id_size);
        }

        if (command == TABY_COMMAND_CUSTOM_ANIMATION) {
            /* "animation" on its own names no clip. */
            return unknown_animation(text, out_animation_id, out_animation_id_size);
        }

        set_resolution_from_command_text(out_resolution, command, text);
        return TABY_TRANSPORT_RESOLVED;
    }

    if (set_resolution_from_animation_id(out_resolution, text, NULL)) {
        return TABY_TRANSPORT_RESOLVED;
    }
    memset(out_resolution, 0, sizeof(*out_resolution));
    if (taby_transport_is_animation_id(text)) {
        return unknown_animation(text, out_animation_id, out_animation_id_size);
    }
    return TABY_TRANSPORT_UNKNOWN_COMMAND;
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

static const char *busy_replay_animation_id(const char *metadata, char *buffer, size_t buffer_size) {
    const char *marker = metadata ? strchr(metadata, '!') : NULL;
    if (!marker) {
        return NULL;
    }

    size_t length = 0;
    while (length + 1 < buffer_size &&
           (isalnum((unsigned char)marker[length + 1]) || marker[length + 1] == '_')) {
        buffer[length] = marker[length + 1];
        length++;
    }
    buffer[length] = '\0';
    return length > 0 ? buffer : NULL;
}

size_t taby_transport_required_animations(
    const taby_transport_resolution_t *resolution,
    const char *out_ids[2]) {
    if (!resolution || !out_ids) {
        return 0;
    }

    out_ids[0] = NULL;
    out_ids[1] = NULL;

    if (resolution->command == TABY_COMMAND_CUSTOM_ANIMATION) {
        size_t count = 0;
        if (resolution->animation_id[0] != '\0') {
            out_ids[count++] = resolution->animation_id;
        }
        if (resolution->next_animation_id[0] != '\0') {
            out_ids[count++] = resolution->next_animation_id;
        }
        return count;
    }

    taby_state_t state = taby_state_for_command(resolution->command);
    taby_animation_asset_t asset = {0};
    if (state == TABY_STATE_AMBIENT_BUSY_ANIMATION) {
        /* The renderer prefers a replay clip named in the busy metadata when
           the asset table knows it, as the display does. */
        char replay_id[TABY_TRANSPORT_SUBTITLE_SIZE] = {0};
        const char *replay = busy_replay_animation_id(resolution->subtitle, replay_id, sizeof(replay_id));
        if (replay && taby_animation_asset_for_id(replay, &asset)) {
            out_ids[0] = asset.animation_id;
            return 1;
        }
    }

    if (!taby_state_has_animation(state) ||
        !taby_animation_asset_for_state(state, &asset) ||
        !asset.asset_pack_path) {
        return 0;
    }
    out_ids[0] = asset.animation_id;
    return 1;
}

taby_display_command_result_t taby_transport_handle_display_command(
    const char *text,
    const taby_transport_display_hooks_t *hooks,
    const char *reply_prefix,
    bool echo_unsupported_command,
    char *reply,
    size_t reply_size) {
    char scratch[8];
    if (!reply || reply_size == 0) {
        reply = scratch;
        reply_size = sizeof(scratch);
    }
    const char *prefix = reply_prefix ? reply_prefix : "";
    const char *state = hooks && hooks->state_name ? hooks->state_name() : NULL;
    state = state && state[0] ? state : "UNKNOWN";

    if (text && strcmp(text, "CLEAR") == 0) {
        if (!hooks || !hooks->clear || !hooks->clear()) {
            snprintf(reply, reply_size, "%sERR runtime_unavailable", prefix);
            return TABY_DISPLAY_COMMAND_RUNTIME_UNAVAILABLE;
        }
        state = hooks->state_name ? hooks->state_name() : NULL;
        snprintf(reply, reply_size, "%sOK %s", prefix, state && state[0] ? state : "UNKNOWN");
        return TABY_DISPLAY_COMMAND_APPLIED;
    }

    taby_transport_resolution_t resolution = {0};
    char unsupported_id[TABY_TRANSPORT_ANIMATION_ID_MAX_LEN + 1] = {0};
    taby_transport_resolve_status_t status = taby_transport_resolve_text_status(
        text,
        &resolution,
        unsupported_id,
        sizeof(unsupported_id));

    if (status == TABY_TRANSPORT_UNKNOWN_COMMAND) {
        if (echo_unsupported_command && text) {
            snprintf(reply, reply_size, "%sERR unsupported_command %.64s", prefix, text);
        } else {
            snprintf(reply, reply_size, "%sERR unsupported_command", prefix);
        }
        return TABY_DISPLAY_COMMAND_UNSUPPORTED_COMMAND;
    }

    if (status == TABY_TRANSPORT_RESOLVED) {
        const char *required[2] = {0};
        size_t required_count = taby_transport_required_animations(&resolution, required);
        for (size_t i = 0; i < required_count; ++i) {
            if (!hooks || !hooks->animation_available || !hooks->animation_available(required[i])) {
                copy_text(unsupported_id, sizeof(unsupported_id), required[i]);
                status = TABY_TRANSPORT_UNKNOWN_ANIMATION;
                break;
            }
        }
    }

    if (status == TABY_TRANSPORT_UNKNOWN_ANIMATION) {
        snprintf(reply, reply_size, "%sOK %s unsupported_animation %s", prefix, state, unsupported_id);
        return TABY_DISPLAY_COMMAND_UNSUPPORTED_ANIMATION;
    }

    if (!hooks || !hooks->apply || !hooks->apply(&resolution)) {
        snprintf(reply, reply_size, "%sERR runtime_unavailable", prefix);
        return TABY_DISPLAY_COMMAND_RUNTIME_UNAVAILABLE;
    }

    state = hooks->state_name ? hooks->state_name() : NULL;
    snprintf(reply, reply_size, "%sOK %s", prefix, state && state[0] ? state : "UNKNOWN");
    return TABY_DISPLAY_COMMAND_APPLIED;
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
