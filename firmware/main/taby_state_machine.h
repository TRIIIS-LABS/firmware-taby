#pragma once

#include <stdbool.h>

typedef enum {
    TABY_STATE_AMBIENT_STARTUP = 0,
    TABY_STATE_AMBIENT_IDLE,
    TABY_STATE_AMBIENT_WAITING,
    TABY_STATE_VOICE_LISTENING,
    TABY_STATE_VOICE_TALKING,
    TABY_STATE_TOOL_USE,
    TABY_STATE_TASK_DELETE,
    TABY_STATE_AMBIENT_BUSY_ANIMATION,
    TABY_STATE_AMBIENT_BUSY_TEXT,
    TABY_STATE_FOCUS_TIMER,
    TABY_STATE_BREAK_START,
    TABY_STATE_CUSTOM_ANIMATION,
    TABY_STATE_MISSING_FEATURE,
} taby_state_t;

typedef enum {
    TABY_COMMAND_NONE = 0,
    TABY_COMMAND_STOP,
    TABY_COMMAND_AMBIENT_STARTUP,
    TABY_COMMAND_AMBIENT_IDLE,
    TABY_COMMAND_AMBIENT_WAITING,
    TABY_COMMAND_VOICE_LISTENING,
    TABY_COMMAND_VOICE_TALKING,
    TABY_COMMAND_TOOL_USE,
    TABY_COMMAND_TASK_DELETE,
    TABY_COMMAND_AMBIENT_BUSY,
    TABY_COMMAND_FOCUS_TIMER,
    TABY_COMMAND_BREAK_START,
    TABY_COMMAND_CUSTOM_ANIMATION,
    TABY_COMMAND_MISSING_FEATURE,
} taby_command_t;

typedef struct {
    taby_state_t current_state;
} taby_state_machine_t;

void taby_state_machine_init(taby_state_machine_t *machine);
taby_state_t taby_state_machine_on_animation_complete(taby_state_machine_t *machine);
taby_state_t taby_state_machine_apply_command(taby_state_machine_t *machine, taby_command_t command);
bool taby_state_has_animation(taby_state_t state);
const char *taby_state_name(taby_state_t state);
const char *taby_state_label(taby_state_t state);
bool taby_command_from_string(const char *text, taby_command_t *out_command);
