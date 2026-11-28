#pragma once

/* The Christmas dress on the live resting face (1.64 board): the app's Santa
   hat and its two strings of lights as pictures (`christmas_dress.bin`, made
   by tools/christmas_dress.py from the app's drawing), put on the panel
   before the face is drawn each frame, so the face is always drawn over
   them and the eyes are never covered. The hat goes where the face is: the
   face box's low panel edge (the landscape bottom, the mouth) and its middle;
   the lights stay at the screen's two sides.

   Nothing here touches LVGL, Rive or a clock, so it builds on the host and is
   tested by tests/test_dress.py. taby_live_talk.cpp draws it. */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define TABY_DRESS_MAX_SPRITES 4

typedef enum {
    TABY_DRESS_HAT = 0,
    TABY_DRESS_LIGHTS = 1,
} taby_dress_kind_t;

typedef struct {
    taby_dress_kind_t kind;
    int16_t panel_x;
    int16_t panel_y;
    uint16_t width;
    uint16_t height;
    /* Premultiplied ARGB, row by row; 4-byte aligned in the blob. */
    const uint32_t *argb;
} taby_dress_sprite_t;

typedef struct {
    /* Where the face box was when the hat's place was drawn: its low panel x
       and its middle panel y. */
    int16_t ref_x;
    int16_t ref_y;
    size_t count;
    taby_dress_sprite_t sprites[TABY_DRESS_MAX_SPRITES];
} taby_dress_t;

/* A box on the panel, x0 <= x < x1, y0 <= y < y1; empty when x0 >= x1. */
typedef struct {
    int x0, y0, x1, y1;
} taby_dress_box_t;

/* Reads the blob; false if it is not one (nothing is kept from it then). */
bool taby_dress_parse(const uint8_t *blob, size_t length, taby_dress_t *out);

/* How far the hat moves for a face drawn in `face` (an empty box: not at all). */
void taby_dress_offset(const taby_dress_t *dress, taby_dress_box_t face, int *out_dx, int *out_dy);

/* Puts one sprite on a premultiplied ARGB panel, moved by (dx, dy), clipped to
   the panel; the box it touched comes back (empty if none). */
taby_dress_box_t taby_dress_blit(
    uint32_t *panel, int panel_width, int panel_height,
    const taby_dress_sprite_t *sprite, int dx, int dy);
