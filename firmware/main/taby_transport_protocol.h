#pragma once

#include <stdbool.h>

#include "taby_state_machine.h"

#define TABY_TRANSPORT_LABEL_SIZE 64
#define TABY_TRANSPORT_SUBTITLE_SIZE 48
#define TABY_TRANSPORT_ANIMATION_ID_SIZE 64

typedef struct {
    taby_command_t command;
    char title[TABY_TRANSPORT_LABEL_SIZE];
    char subtitle[TABY_TRANSPORT_SUBTITLE_SIZE];
    char animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE];
    char next_animation_id[TABY_TRANSPORT_ANIMATION_ID_SIZE];
} taby_transport_resolution_t;

bool taby_transport_command_from_text(const char *text, taby_command_t *out_command);
bool taby_transport_resolve_text(const char *text, taby_transport_resolution_t *out_resolution);
const char *taby_transport_state_name(taby_state_t state);
