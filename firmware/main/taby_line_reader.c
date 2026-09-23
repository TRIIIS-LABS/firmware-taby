#include "taby_line_reader.h"

void taby_line_reader_init(taby_line_reader_t *reader, char *buffer, size_t size) {
    if (!reader) {
        return;
    }

    reader->buffer = buffer;
    reader->size = buffer ? size : 0;
    reader->length = 0;
    reader->discarding = false;
    if (reader->size > 0) {
        reader->buffer[0] = '\0';
    }
}

taby_line_reader_event_t taby_line_reader_push(taby_line_reader_t *reader, uint8_t byte) {
    if (!reader || reader->size == 0) {
        return TABY_LINE_READER_NONE;
    }

    if (byte == '\r' || byte == '\n') {
        size_t length = reader->length;
        bool discarded = reader->discarding;
        reader->length = 0;
        reader->discarding = false;
        if (discarded || length == 0) {
            reader->buffer[0] = '\0';
            return TABY_LINE_READER_NONE;
        }
        reader->buffer[length] = '\0';
        return TABY_LINE_READER_LINE;
    }

    if (reader->discarding || byte < 0x20 || byte > 0x7E) {
        return TABY_LINE_READER_NONE;
    }

    if (reader->length + 1 >= reader->size) {
        reader->length = 0;
        reader->buffer[0] = '\0';
        reader->discarding = true;
        return TABY_LINE_READER_TOO_LONG;
    }

    reader->buffer[reader->length++] = (char)byte;
    reader->buffer[reader->length] = '\0';
    return TABY_LINE_READER_NONE;
}
