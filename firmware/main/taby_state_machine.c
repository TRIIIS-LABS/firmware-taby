#include "taby_state_machine.h"

#include <stddef.h>
#include <string.h>

typedef struct {
    const char *text;
    taby_command_t command;
} taby_command_binding_t;

static const taby_command_binding_t k_command_bindings[] = {
    {"stop", TABY_COMMAND_STOP},
    {"ambient_startup", TABY_COMMAND_AMBIENT_STARTUP},
    {"ambient_idle", TABY_COMMAND_AMBIENT_IDLE},
    {"ambient_waiting", TABY_COMMAND_AMBIENT_WAITING},
    {"voice_listening", TABY_COMMAND_VOICE_LISTENING},
    {"voice_talking", TABY_COMMAND_VOICE_TALKING},
    {"tool_use", TABY_COMMAND_TOOL_USE},
    {"task_delete", TABY_COMMAND_TASK_DELETE},
    {"ambient_busy", TABY_COMMAND_AMBIENT_BUSY},
    {"focus_timer", TABY_COMMAND_FOCUS_TIMER},
    {"break_start", TABY_COMMAND_BREAK_START},
    {"animation", TABY_COMMAND_CUSTOM_ANIMATION},
    {"missing_feature", TABY_COMMAND_MISSING_FEATURE},
};

static taby_state_t state_for_command(taby_command_t command) {
    switch (command) {
        case TABY_COMMAND_AMBIENT_STARTUP:
            return TABY_STATE_AMBIENT_STARTUP;
        case TABY_COMMAND_AMBIENT_IDLE:
        case TABY_COMMAND_STOP:
            return TABY_STATE_AMBIENT_IDLE;
        case TABY_COMMAND_AMBIENT_WAITING:
            return TABY_STATE_AMBIENT_WAITING;
        case TABY_COMMAND_VOICE_LISTENING:
            return TABY_STATE_VOICE_LISTENING;
        case TABY_COMMAND_VOICE_TALKING:
            return TABY_STATE_VOICE_TALKING;
        case TABY_COMMAND_TOOL_USE:
            return TABY_STATE_TOOL_USE;
        case TABY_COMMAND_TASK_DELETE:
            return TABY_STATE_TASK_DELETE;
        case TABY_COMMAND_AMBIENT_BUSY:
            return TABY_STATE_AMBIENT_BUSY_ANIMATION;
        case TABY_COMMAND_FOCUS_TIMER:
            return TABY_STATE_FOCUS_TIMER;
        case TABY_COMMAND_BREAK_START:
            return TABY_STATE_BREAK_START;
        case TABY_COMMAND_CUSTOM_ANIMATION:
            return TABY_STATE_CUSTOM_ANIMATION;
        case TABY_COMMAND_MISSING_FEATURE:
            return TABY_STATE_MISSING_FEATURE;
        case TABY_COMMAND_NONE:
        default:
            return TABY_STATE_AMBIENT_IDLE;
    }
}

void taby_state_machine_init(taby_state_machine_t *machine) {
    if (!machine) {
        return;
    }
    machine->current_state = TABY_STATE_AMBIENT_STARTUP;
}

taby_state_t taby_state_machine_on_animation_complete(taby_state_machine_t *machine) {
    if (!machine) {
        return TABY_STATE_AMBIENT_IDLE;
    }

    switch (machine->current_state) {
        case TABY_STATE_AMBIENT_STARTUP:
            machine->current_state = TABY_STATE_AMBIENT_IDLE;
            break;
        case TABY_STATE_AMBIENT_IDLE:
        case TABY_STATE_AMBIENT_WAITING:
        case TABY_STATE_VOICE_LISTENING:
        case TABY_STATE_VOICE_TALKING:
        case TABY_STATE_TOOL_USE:
        case TABY_STATE_TASK_DELETE:
        case TABY_STATE_CUSTOM_ANIMATION:
            machine->current_state = TABY_STATE_AMBIENT_IDLE;
            break;
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
            machine->current_state = TABY_STATE_AMBIENT_BUSY_TEXT;
            break;
        case TABY_STATE_AMBIENT_BUSY_TEXT:
            machine->current_state = TABY_STATE_AMBIENT_BUSY_ANIMATION;
            break;
        case TABY_STATE_FOCUS_TIMER:
        case TABY_STATE_BREAK_START:
        case TABY_STATE_MISSING_FEATURE:
        default:
            break;
    }

    return machine->current_state;
}

taby_state_t taby_state_machine_apply_command(taby_state_machine_t *machine, taby_command_t command) {
    if (!machine || command == TABY_COMMAND_NONE) {
        return machine ? machine->current_state : TABY_STATE_AMBIENT_IDLE;
    }

    machine->current_state = state_for_command(command);
    return machine->current_state;
}

bool taby_state_has_animation(taby_state_t state) {
    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
        case TABY_STATE_AMBIENT_IDLE:
        case TABY_STATE_AMBIENT_WAITING:
        case TABY_STATE_VOICE_LISTENING:
        case TABY_STATE_VOICE_TALKING:
        case TABY_STATE_TOOL_USE:
        case TABY_STATE_TASK_DELETE:
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
        case TABY_STATE_AMBIENT_BUSY_TEXT:
        case TABY_STATE_CUSTOM_ANIMATION:
            return true;
        case TABY_STATE_FOCUS_TIMER:
        case TABY_STATE_BREAK_START:
        case TABY_STATE_MISSING_FEATURE:
        default:
            return false;
    }
}

const char *taby_state_name(taby_state_t state) {
    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
            return "ambient_startup";
        case TABY_STATE_AMBIENT_IDLE:
            return "ambient_idle";
        case TABY_STATE_AMBIENT_WAITING:
            return "ambient_waiting";
        case TABY_STATE_VOICE_LISTENING:
            return "voice_listening";
        case TABY_STATE_VOICE_TALKING:
            return "voice_talking";
        case TABY_STATE_TOOL_USE:
            return "tool_use";
        case TABY_STATE_TASK_DELETE:
            return "task_delete";
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
        case TABY_STATE_AMBIENT_BUSY_TEXT:
            return "ambient_busy";
        case TABY_STATE_FOCUS_TIMER:
            return "focus_timer";
        case TABY_STATE_BREAK_START:
            return "break_start";
        case TABY_STATE_CUSTOM_ANIMATION:
            return "custom_animation";
        case TABY_STATE_MISSING_FEATURE:
            return "missing_feature";
        default:
            return "unknown";
    }
}

const char *taby_state_label(taby_state_t state) {
    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
            return "STARTUP";
        case TABY_STATE_AMBIENT_IDLE:
            return "IDLE";
        case TABY_STATE_AMBIENT_WAITING:
            return "WAITING";
        case TABY_STATE_VOICE_LISTENING:
            return "LISTENING";
        case TABY_STATE_VOICE_TALKING:
            return "TALKING";
        case TABY_STATE_TOOL_USE:
            return "WORKING";
        case TABY_STATE_TASK_DELETE:
            return "DELETE";
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
        case TABY_STATE_AMBIENT_BUSY_TEXT:
            return "BUSY";
        case TABY_STATE_FOCUS_TIMER:
            return "FOCUS";
        case TABY_STATE_BREAK_START:
            return "BREAK";
        case TABY_STATE_CUSTOM_ANIMATION:
            return "ANIMATION";
        case TABY_STATE_MISSING_FEATURE:
            return "COMING SOON";
        default:
            return "TABY";
    }
}

bool taby_command_from_string(const char *text, taby_command_t *out_command) {
    if (!text || !out_command) {
        return false;
    }

    for (size_t i = 0; i < sizeof(k_command_bindings) / sizeof(k_command_bindings[0]); ++i) {
        if (strcmp(text, k_command_bindings[i].text) == 0) {
            *out_command = k_command_bindings[i].command;
            return true;
        }
    }

    return false;
}
