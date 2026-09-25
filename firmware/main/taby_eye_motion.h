#pragma once

/* How much the resting face's eyes move, and the frame plan that calms them.

   Nothing here touches LVGL, NVS or a clock, so it builds on the host and is
   tested by tests/test_eye_motion.py. taby_idle_eyes.c drives the display
   with it and keeps the choice across restarts. */

#include <stdbool.h>
#include <stdint.h>

typedef enum {
    /* The rest face plays as drawn: blinks, a tilt, and long looks to each side. */
    TABY_EYE_MOTION_NORMAL = 0,
    /* Mostly still, with a blink every few seconds and a small tilt now and then. */
    TABY_EYE_MOTION_CALM = 1,
    /* Centred, with gentle blinks only. */
    TABY_EYE_MOTION_STILL = 2,
} taby_eye_motion_t;

#define TABY_EYE_MOTION_DEFAULT TABY_EYE_MOTION_NORMAL

const char *taby_eye_motion_name(taby_eye_motion_t mode);
bool taby_eye_motion_from_name(const char *name, taby_eye_motion_t *out_mode);
/* A value read back from storage, which may predate or postdate this build. */
bool taby_eye_motion_from_stored(uint8_t stored, taby_eye_motion_t *out_mode);

typedef enum {
    TABY_EYE_MOTION_COMMAND_NONE = 0, /* not an EYE_MOTION command */
    TABY_EYE_MOTION_COMMAND_QUERY,    /* EYE_MOTION or EYE_MOTION? */
    TABY_EYE_MOTION_COMMAND_SET,      /* EYE_MOTION <normal|calm|still> */
    TABY_EYE_MOTION_COMMAND_INVALID,  /* EYE_MOTION with a mode this firmware does not know */
} taby_eye_motion_command_t;

taby_eye_motion_command_t taby_eye_motion_parse_command(const char *text, taby_eye_motion_t *out_mode);

/* The rest face is idle_01_loop, 174 frames on both boards. Its frames, cut
   from the art (tests/test_eye_motion.py pins the files this was cut from):

     0-2      centred, eyes open. Frame 0 covers the whole canvas and is opaque,
              so going back to it redraws the face exactly.
     3-6      one blink
     7-9      centred
     10-37    a small tilt, about 7 px, with two blinks in it
     38-45    centred
     46-55    a double blink
     56-63    centred
     64-150   a long look to one side and then the other, 67-78 px
     151-173  centred, with a 5 px twitch at 156-163

   Calm and still play the start of the clip and go back to frame 0, holding
   it between passes; neither ever reaches the long looks. */
#define TABY_REST_FACE_FRAME_COUNT 174U
#define TABY_REST_FACE_BLINK_LAST 9U
#define TABY_REST_FACE_GLANCE_LAST 63U

/* How long frame 0 holds between passes. */
#define TABY_REST_FACE_CALM_HOLD_MIN_MS 3000U
#define TABY_REST_FACE_CALM_HOLD_MAX_MS 7000U
#define TABY_REST_FACE_STILL_HOLD_MIN_MS 4000U
#define TABY_REST_FACE_STILL_HOLD_MAX_MS 9000U
/* Calm: blink-only passes between two passes that also tilt. */
#define TABY_REST_FACE_CALM_BLINKS_MIN 5U
#define TABY_REST_FACE_CALM_BLINKS_MAX 8U

typedef struct {
    taby_eye_motion_t mode;
    /* The frame on screen. */
    uint16_t frame;
    /* Calm: blink-only passes left before one that tilts. */
    uint8_t blinks_before_glance;
    /* Calm: this pass goes on past the blink into the tilt. */
    bool glancing;
} taby_rest_face_t;

/* Starts a plan at frame 0, the frame a freshly loaded clip shows. Returns
   false for normal, which is not driven: the clip plays as drawn. `random`
   is any 32-bit random value. */
bool taby_rest_face_start(taby_rest_face_t *face, taby_eye_motion_t mode, uint32_t random);

/* The frame on screen has had its time: moves the plan to the frame to show
   next. Returns true when that is frame 0 again, which the caller reaches by
   rewinding the clip; otherwise the next frame is the one after this. */
bool taby_rest_face_advance(taby_rest_face_t *face, uint32_t random);

/* How long the frame on screen stays: frame 0 holds between passes, and every
   other frame keeps the delay it was drawn with. */
uint32_t taby_rest_face_hold_ms(const taby_rest_face_t *face, uint32_t drawn_ms, uint32_t random);
