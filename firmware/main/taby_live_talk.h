#pragma once

/* Taby talking live (draft ADR device-live-talk in app-taby): while the face
   shows talking, the board draws the desktop notch's own Rive character and
   wears the app's mouth motion, sent as VOICE_MOTION lines; every other state
   stays a GIF. */

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

/* The face draws this animation live (talking, once the character is
   loaded) rather than playing its GIF. */
bool taby_live_talk_takes(const char *animation_id);

/* Under the LVGL lock: the live scene on `parent`, drawing from now on, or
   NULL. The object is the screen's; the scene ends with taby_live_talk_hide. */
lv_obj_t *taby_live_talk_show(lv_obj_t *parent);

/* Under the LVGL lock: the live scene stops drawing, before its object is
   deleted. Harmless when nothing is shown. */
void taby_live_talk_hide(void);

/* What follows "VOICE_MOTION ": a run of frames or a stop. False if the line
   is not valid or the board cannot talk live. */
bool taby_live_talk_voice_motion(const char *args);

#ifdef __cplusplus
}
#endif
