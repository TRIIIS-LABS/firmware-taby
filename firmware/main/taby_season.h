#pragma once

/* The Christmas rest: the 1.64 board's resting face wears a Santa hat with
   lights at the screen's sides, or the lights alone (taby_dress.h); while the
   live face is not there, the rest is the matching Christmas clip from the pack.

   From 1.4.3 the look is kept across power, as the Eyes setting is: the last
   look an app tells (`SEASON christmas hat|lights <seconds>` or `SEASON off`)
   is stored and holds until it tells another; a unit never told rests in the
   hat (1.4.2). The device has no clock, so nothing ends a look by itself: the
   seconds of the told form are still accepted, for the apps that send them,
   and end nothing. The app ends the season (1.0.14 tells `off` after 6 January).

   Nothing here touches LVGL, a clock or NVS, so it builds on the host and is
   tested by tests/test_season.py. taby_season_store.c keeps the look in NVS;
   taby_runtime.c holds the look now and redraws the rest. */

#include <stdbool.h>
#include <stdint.h>

typedef enum {
    TABY_SEASON_OFF = 0,
    /* Taby in the Santa hat, lights down both sides. */
    TABY_SEASON_CHRISTMAS_HAT = 1,
    /* The lights only, for a Taby that wears a printed hat. */
    TABY_SEASON_CHRISTMAS_LIGHTS = 2,
} taby_season_look_t;

/* The most seconds the told form takes, and what SEASON reports as left for
   any look but off: a told look has no end. */
#define TABY_SEASON_MAX_SECONDS 43200U
/* A unit never told a season rests in the hat (Peter, 2026-11-28). */
#define TABY_SEASON_DEFAULT_LOOK TABY_SEASON_CHRISTMAS_HAT

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

/* The byte stored for a told look (never 0). */
uint8_t taby_season_stored_value(taby_season_look_t look);
/* The look a unit starts in: the stored one; the hat when nothing (or a byte
   this firmware does not know) is stored. */
taby_season_look_t taby_season_look_from_stored(bool stored, uint8_t value);
/* Whether telling `look` changes what is stored, so the same look told again
   every 30 minutes writes nothing. */
bool taby_season_needs_store(bool stored, uint8_t value, taby_season_look_t look);
/* What SEASON reports as seconds_left: 0 for off, the most for a look. */
uint32_t taby_season_seconds_left(taby_season_look_t look);

/* "hat", "lights" or "off". */
const char *taby_season_look_name(taby_season_look_t look);
/* The pack's clip the rest plays for a look; NULL for off. */
const char *taby_season_rest_clip(taby_season_look_t look);
