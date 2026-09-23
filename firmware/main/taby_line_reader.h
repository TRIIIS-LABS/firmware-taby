#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Assembles newline-terminated commands from a byte stream. Only printable
   ASCII is kept. A line that does not fit is reported once and then dropped
   up to its newline, so its tail is never read as a command of its own. */
typedef struct {
    char *buffer;
    size_t size;
    size_t length;
    bool discarding;
} taby_line_reader_t;

typedef enum {
    TABY_LINE_READER_NONE = 0,
    /* The buffer holds one complete, NUL-terminated line until the next push. */
    TABY_LINE_READER_LINE,
    TABY_LINE_READER_TOO_LONG,
} taby_line_reader_event_t;

void taby_line_reader_init(taby_line_reader_t *reader, char *buffer, size_t size);
taby_line_reader_event_t taby_line_reader_push(taby_line_reader_t *reader, uint8_t byte);
