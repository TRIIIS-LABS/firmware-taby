/* Runs the firmware's touch start off-device, for tests/test_touch_start.py.

   The one argument is how the chip answers each try, in order: '1' answers,
   '0' is silent. The start makes its tries, then later tries are made until
   one is answered or the answers run out, then three more that must not ask
   the chip again. One JSON object comes out. Built with sanitizers. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "taby_touch_start.h"

typedef struct {
    const char *answers;
    size_t asked;
    uint32_t paused_ms;
    uint32_t pauses;
} chip_t;

static bool chip_answers(void *context) {
    chip_t *chip = context;
    const char answer = chip->answers[chip->asked];
    if (answer != '\0') {
        chip->asked += 1;
    }
    return answer == '1';
}

static void chip_pause(uint32_t ms, void *context) {
    chip_t *chip = context;
    chip->paused_ms += ms;
    chip->pauses += 1;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: touch_start_driver ANSWERS\n");
        return 2;
    }
    chip_t chip = {.answers = argv[1]};
    taby_touch_t touch;
    const bool first = taby_touch_first_tries(&touch, chip_answers, chip_pause, &chip);
    const bool readable_after_start = taby_touch_taken_up(&touch);
    const size_t asked_at_start = chip.asked;

    printf("{\"first\":%s,\"first_tries\":%u,\"asked_at_start\":%zu,\"pauses\":%u,\"paused_ms\":%u,"
           "\"readable_after_start\":%s,\"later\":[",
           first ? "true" : "false", (unsigned)touch.first_tries, asked_at_start,
           (unsigned)chip.pauses, (unsigned)chip.paused_ms, readable_after_start ? "true" : "false");
    bool later = first;
    for (int index = 0; !later && chip.answers[chip.asked] != '\0'; ++index) {
        later = taby_touch_try_again(&touch, chip_answers, &chip);
        printf("%s%s", index ? "," : "", later ? "true" : "false");
    }
    const size_t asked_before_extra = chip.asked;
    bool extra = true;
    for (int index = 0; index < 3; ++index) {
        extra = taby_touch_try_again(&touch, chip_answers, &chip) && extra;
    }
    printf("],\"later_tries\":%u,\"readable\":%s,\"extra_all_true\":%s,\"asked_by_extra\":%zu}\n",
           (unsigned)touch.later_tries, taby_touch_taken_up(&touch) ? "true" : "false",
           extra ? "true" : "false", chip.asked - asked_before_extra);
    return 0;
}
