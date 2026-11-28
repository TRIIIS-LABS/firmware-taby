#pragma once

/* The Christmas rest: while the app says it is the season, the 1.64 board's
   resting face is a Christmas clip from the pack instead of the live face,
   Taby in a Santa hat with lights at the screen's sides, or the lights alone.

   The device has no clock and keeps nothing of this across a restart. From
   1.4.2 every power-up rests in the hat with no end, until an app says
   otherwise: the app sends `SEASON christmas hat|lights <seconds>` and sends
   it again before the seconds run out; when they do, or after `SEASON off`,
   the rest is the normal one until the next power-up.

   Nothing here touches LVGL, a clock or NVS, so it builds on the host and is
   tested by tests/test_season.py. taby_runtime.c holds the one season, reads
   the uptime clock and redraws the rest. */

#include <stdbool.h>
#include <stdint.h>

typedef enum {
    TABY_SEASON_OFF = 0,
    /* Taby in the Santa hat, lights down both sides. */
    TABY_SEASON_CHRISTMAS_HAT = 1,
    /* The lights only, for a Taby that wears a printed hat. */
    TABY_SEASON_CHRISTMAS_LIGHTS = 2,
} taby_season_look_t;

/* The longest a season lasts without being sent again: 12 hours. */
#define TABY_SEASON_MAX_SECONDS 43200U
/* The start-up season (1.4.2): far enough away never to come, small enough
   that the seconds-left sum cannot overflow; reported as the 12-hour most. */
#define TABY_SEASON_NO_END_US (INT64_MAX / 4)

typedef struct {
    taby_season_look_t look;
    /* Uptime in microseconds when the look ends. */
    int64_t until_us;
} taby_season_t;

typedef enum {
    TABY_SEASON_COMMAND_NONE = 0, /* not a SEASON command */
    TABY_SEASON_COMMAND_QUERY,    /* SEASON or SEASON? */
    TABY_SEASON_COMMAND_SET,      /* SEASON christmas <hat|lights> <seconds> */
    TABY_SEASON_COMMAND_OFF,      /* SEASON off */
    TABY_SEASON_COMMAND_INVALID,  /* SEASON with anything else */
} taby_season_command_t;

taby_season_command_t taby_season_parse_command(
    const char *text,
    taby_season_look_t *out_look,
    uint32_t *out_seconds);

void taby_season_set(taby_season_t *season, taby_season_look_t look, uint32_t seconds, int64_t now_us);
void taby_season_off(taby_season_t *season);

/* The look now: off once its seconds have run out. */
taby_season_look_t taby_season_look_at(const taby_season_t *season, int64_t now_us);
uint32_t taby_season_seconds_left(const taby_season_t *season, int64_t now_us);

/* "hat", "lights" or "off". */
const char *taby_season_look_name(taby_season_look_t look);
/* The pack's clip the rest plays for a look; NULL for off. */
const char *taby_season_rest_clip(taby_season_look_t look);
