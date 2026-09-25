#pragma once

/* Keeps the eye-motion choice across restarts, and drives the rest face's
   frames when that choice is calm or still (taby_eye_motion.h). */

#include "esp_err.h"
#include "lvgl.h"
#include "taby_eye_motion.h"

/* The stored choice; normal until one has been saved. */
taby_eye_motion_t taby_idle_eyes_mode(void);
/* Saves the choice in NVS. Does not touch the display. */
esp_err_t taby_idle_eyes_store(taby_eye_motion_t mode);
/* Forgets the saved choice, for a factory reset. */
esp_err_t taby_idle_eyes_erase(void);

/* The functions below need the LVGL lock. */

/* `face` has just been given the clip `animation_id`: drive it when it is the
   rest face and the choice is calm or still, and let go of anything else. */
void taby_idle_eyes_follow(lv_obj_t *face, const char *animation_id);
/* The scene is being cleared. */
void taby_idle_eyes_forget(void);
/* The choice changed: a rest face on screen restarts from its first frame
   under the new choice, or plays as drawn again for normal. */
void taby_idle_eyes_apply(void);
