#pragma once

/* The told Christmas look, kept in NVS beside the Eyes setting (taby_season.h). */

#include "esp_err.h"
#include "taby_season.h"

/* The look this power-up starts in: the stored one, or the hat if none is. */
taby_season_look_t taby_season_store_load(void);
/* Stores a told look; telling the stored look again writes nothing. */
esp_err_t taby_season_store_save(taby_season_look_t look);
