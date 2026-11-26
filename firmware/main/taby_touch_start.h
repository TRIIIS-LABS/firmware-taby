#pragma once

/* Whether the 1.64 board's touch chip is taken up, and the tries that take it
   up later when it was silent at start.

   The 1.64 board has no reset line to its touch chip, so a chip reset (an
   update, a USB reconnect) does not restart it, and after one the chip can
   stay silent for seconds to minutes (2026-11-26). Until 1.4.1 a silent chip
   ended the whole start, and the board restarted every three seconds until it
   answered. Now the start goes on without touch, and taps and holds work from
   the moment a later try is answered.

   Nothing here touches I2C, FreeRTOS or a clock, so it builds on the host and
   is tested by tests/test_touch_start.py. board_amoled_1_64.c gives it the
   chip, the pause and the task the later tries run in. */

#include <stdatomic.h>
#include <stdbool.h>
#include <stdint.h>

/* At start: this many tries, this far apart, then the start goes on. */
#define TABY_TOUCH_FIRST_TRIES 8U
#define TABY_TOUCH_FIRST_PAUSE_MS 25U
/* Later: one try this often, from a low-priority task, until one is answered. */
#define TABY_TOUCH_LATER_PAUSE_MS 1000U

/* One try: true when the chip took the command that sets it working. */
typedef bool (*taby_touch_answers_fn)(void *context);
typedef void (*taby_touch_pause_fn)(uint32_t ms, void *context);

typedef struct {
    atomic_bool taken_up;
    /* Tries made at start, and later tries made since. */
    uint32_t first_tries;
    uint32_t later_tries;
} taby_touch_t;

/* The tries at start. Never fails the start: false means touch waits for a
   later try, and nothing reads the chip until one is answered. */
bool taby_touch_first_tries(
    taby_touch_t *touch,
    taby_touch_answers_fn answers,
    taby_touch_pause_fn pause,
    void *context);

/* One later try; true once touch is taken up, and from then on without
   asking the chip again. */
bool taby_touch_try_again(taby_touch_t *touch, taby_touch_answers_fn answers, void *context);

/* Whether the chip may be read: safe from any task. */
bool taby_touch_taken_up(taby_touch_t *touch);
