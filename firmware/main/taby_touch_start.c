#include "taby_touch_start.h"

#include <stddef.h>

bool taby_touch_first_tries(
    taby_touch_t *touch,
    taby_touch_answers_fn answers,
    taby_touch_pause_fn pause,
    void *context) {
    atomic_store(&touch->taken_up, false);
    touch->first_tries = 0;
    touch->later_tries = 0;
    for (uint32_t attempt = 1; attempt <= TABY_TOUCH_FIRST_TRIES; ++attempt) {
        touch->first_tries = attempt;
        if (answers(context)) {
            atomic_store(&touch->taken_up, true);
            return true;
        }
        if (attempt < TABY_TOUCH_FIRST_TRIES && pause != NULL) {
            pause(TABY_TOUCH_FIRST_PAUSE_MS, context);
        }
    }
    return false;
}

bool taby_touch_try_again(taby_touch_t *touch, taby_touch_answers_fn answers, void *context) {
    if (atomic_load(&touch->taken_up)) {
        return true;
    }
    touch->later_tries += 1U;
    if (!answers(context)) {
        return false;
    }
    atomic_store(&touch->taken_up, true);
    return true;
}

bool taby_touch_taken_up(taby_touch_t *touch) {
    return atomic_load(&touch->taken_up);
}
