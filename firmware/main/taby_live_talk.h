#pragma once

/* Taby's live face on the 1.64 board: resting, listening and talking are the
   desktop notch's own Rive character, moving between them by its own
   transitions, and talking wears the app's mouth motion (VOICE_MOTION lines;
   draft ADRs device-live-talk and device-live-face in app-taby). Every other
   clip stays a GIF: the face rests on its neutral face before one takes
   over, and starts there again after it, which is where the pack's clips
   start and end. The round board keeps its GIFs. */

#include <stdbool.h>

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Loads the built-in character in the background; once, at boot. */
void taby_live_talk_start(void);

/* The board can talk live: built in, and the character has not failed to
   load. INFO lists voice_motion from this. */
bool taby_live_talk_offered(void);

/* The character is loaded and takes VOICE_MOTION. */
bool taby_live_talk_ready(void);

/* The face draws this animation live (idle_01_loop, listening_loop and
   talking_default_loop, once the character is loaded) rather than playing
   its GIF. */
bool taby_live_talk_takes(const char *animation_id);

/* What was on screen before the live face shows. */
typedef enum {
    TABY_LIVE_AFTER_LIVE = 0,  /* the live face itself: it carries on */
    TABY_LIVE_AFTER_CLIP,      /* a GIF, its last frame taken (taby_live_talk_take_frame) */
    TABY_LIVE_AFTER_OTHER,     /* nothing, a card or text: it starts on black */
} taby_live_after_t;

/* Under the LVGL lock, before a GIF on screen is deleted for the live face:
   its frame is what the live canvas shows until the face's first frame. */
void taby_live_talk_take_frame(lv_obj_t *gif);

/* Under the LVGL lock: the live face on `parent`, showing `animation_id`
   (one taby_live_talk_takes accepts), or NULL. The object is the screen's;
   it ends with taby_live_talk_hide. */
lv_obj_t *taby_live_talk_show(lv_obj_t *parent, const char *animation_id, taby_live_after_t after);

/* Under the LVGL lock: the face on screen moves to `animation_id` by its
   own transitions, and stays if it was about to hand over to a clip. */
void taby_live_talk_change(const char *animation_id);

/* Under the LVGL lock: a clip is to take over. The face goes to its neutral
   rest, and `left` is called through lv_async_call once it is there (or
   after a short limit). False when there is no face on screen to rest, or
   the screen is dark: the clip can show at once. */
bool taby_live_talk_leave(lv_async_cb_t left);

/* Under the LVGL lock: the live face stops drawing, before its object is
   deleted. Harmless when nothing is shown. */
void taby_live_talk_hide(void);

/* The Eyes setting changed (taby_idle_eyes): the live resting face follows. */
void taby_live_talk_set_eye_motion(int mode);

/* What follows "VOICE_MOTION ": a run of frames or a stop. False if the line
   is not valid or the board cannot talk live. */
bool taby_live_talk_voice_motion(const char *args);

#ifdef __cplusplus
}
#endif
