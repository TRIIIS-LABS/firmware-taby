#pragma once

#include <stdbool.h>
#include <stddef.h>

#include "taby_state_machine.h"

#define TABY_TRANSPORT_LABEL_SIZE 64
#define TABY_TRANSPORT_SUBTITLE_SIZE 48
#define TABY_TRANSPORT_ANIMATION_ID_SIZE 64
/* The desktop's own limit for an animation id (`[a-z0-9_]{1,80}`). Longer text
   is not an animation request at all. */
#define TABY_TRANSPORT_ANIMATION_ID_MAX_LEN 80

typedef struct {
    taby_command_t command;
    char title[TABY_TRANSPORT_LABEL_SIZE];
    char subtitle[TABY_TRANSPORT_SUBTITLE_SIZE];
    char animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE];
    char next_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE];
} taby_transport_resolution_t;

typedef enum {
    TABY_TRANSPORT_RESOLVED = 0,
    /* `id` or `id>next_id` in animation-id form, naming a clip this firmware
       does not have. Not a malformed command: callers ignore it. */
    TABY_TRANSPORT_UNKNOWN_ANIMATION,
    TABY_TRANSPORT_UNKNOWN_COMMAND,
} taby_transport_resolve_status_t;

typedef enum {
    TABY_DISPLAY_COMMAND_APPLIED = 0,
    TABY_DISPLAY_COMMAND_UNSUPPORTED_ANIMATION,
    TABY_DISPLAY_COMMAND_UNSUPPORTED_COMMAND,
    TABY_DISPLAY_COMMAND_RUNTIME_UNAVAILABLE,
} taby_display_command_result_t;

/* What a display command needs from the device, so the decision and the reply
   can be exercised off-device. */
typedef struct {
    /* Whether this board's asset pack holds the clip. */
    bool (*animation_available)(const char *animation_id);
    /* Applies a resolution whose clips are all available. */
    bool (*apply)(const taby_transport_resolution_t *resolution);
    /* The state to report once the command is handled. */
    const char *(*state_name)(void);
    /* Dismisses the active presentation (a card), if any. */
    bool (*clear)(void);
} taby_transport_display_hooks_t;

bool taby_transport_command_from_text(const char *text, taby_command_t *out_command);
bool taby_transport_resolve_text(const char *text, taby_transport_resolution_t *out_resolution);
/* Like taby_transport_resolve_text, and says why text did not resolve. For
   TABY_TRANSPORT_UNKNOWN_ANIMATION the unknown id is copied to
   out_animation_id, which may be NULL. */
taby_transport_resolve_status_t taby_transport_resolve_text_status(
    const char *text,
    taby_transport_resolution_t *out_resolution,
    char *out_animation_id,
    size_t out_animation_id_size);
bool taby_transport_is_animation_id(const char *text);
/* The clips drawing this resolution needs, at most two, in the order they
   play. Text-only states need none. */
size_t taby_transport_required_animations(
    const taby_transport_resolution_t *resolution,
    const char *out_ids[2]);
/* Resolves and applies one display command, or CLEAR, and writes the single
   line that answers it:
     <prefix>OK <STATE>
     <prefix>OK <STATE> unsupported_animation <id>
     <prefix>ERR unsupported_command[ <text>]
     <prefix>ERR runtime_unavailable
   An animation the board cannot play changes nothing on the face and is
   answered OK: every desktop so far treats any ERR to a display command as a
   lost device, so an ERR here would cost the person their connection. */
taby_display_command_result_t taby_transport_handle_display_command(
    const char *text,
    const taby_transport_display_hooks_t *hooks,
    const char *reply_prefix,
    bool echo_unsupported_command,
    char *reply,
    size_t reply_size);
const char *taby_transport_state_name(taby_state_t state);
