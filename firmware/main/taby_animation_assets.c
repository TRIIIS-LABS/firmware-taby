#include "taby_animation_assets.h"

#include <inttypes.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    const char *alias;
    const char *canonical_id;
} taby_animation_alias_t;

#define TABY_DYNAMIC_ASSET_PATH_SLOTS 4
#define TABY_DYNAMIC_ASSET_PATH_SIZE 32
#define TABY_FNV1A_32_OFFSET_BASIS 0x811C9DC5U
#define TABY_FNV1A_32_PRIME 0x01000193U

static char s_dynamic_asset_paths[TABY_DYNAMIC_ASSET_PATH_SLOTS][TABY_DYNAMIC_ASSET_PATH_SIZE];
static size_t s_dynamic_asset_path_index = 0;

static const taby_animation_asset_t k_animation_assets[] = {
    {"angry_01_loop", "/assets/animations/angry_01_loop.gif", NULL, 0, 2542U, true},
    {"angry_02_loop", "/assets/animations/angry_02_loop.gif", NULL, 0, 2500U, true},
    {"basketball_dunk", "/assets/animations/basketball_dunk.gif", NULL, 0, 4208U, false},
    {"basketball_throw", "/assets/animations/basketball_throw.gif", NULL, 0, 4167U, false},
    {"blush", "/assets/animations/blush.gif", NULL, 0, 4875U, false},
    {"boxing", "/assets/animations/boxing.gif", NULL, 0, 5042U, false},
    {"break_start", "/assets/animations/break_start.gif", NULL, 0, 6708U, false},
    {"busy_loop", "/assets/animations/busy_loop.gif", NULL, 0, 3500U, true},
    {"calendar_in", "/assets/animations/calendar_in.gif", NULL, 0, 2083U, false},
    {"calendar_loop", "/assets/animations/calendar_loop.gif", NULL, 0, 2042U, true},
    {"circle", "/assets/animations/circle.gif", NULL, 0, 2875U, false},
    {"claude_in", "/assets/animations/claude_in.gif", NULL, 0, 3708U, false},
    {"claude_loop", "/assets/animations/claude_loop.gif", NULL, 0, 1667U, true},
    {"codex_in", "/assets/animations/codex_in.gif", NULL, 0, 2042U, false},
    {"codex_loop", "/assets/animations/codex_loop.gif", NULL, 0, 1667U, true},
    {"confirmation", "/assets/animations/confirmation.gif", NULL, 0, 1958U, false},
    {"copy_paste", "/assets/animations/copy_paste.gif", NULL, 0, 3125U, false},
    {"creating_task_loop", "/assets/animations/creating_task_loop.gif", NULL, 0, 1708U, true},
    {"day_planned", "/assets/animations/day_planned.gif", NULL, 0, 6250U, false},
    {"delete_01", "/assets/animations/delete_01.gif", NULL, 0, 3542U, false},
    {"disappointed", "/assets/animations/disappointed.gif", NULL, 0, 2792U, false},
    {"drink_water", "/assets/animations/drink_water.gif", NULL, 0, 6875U, false},
    {"f1_car", "/assets/animations/f1_car.gif", NULL, 0, 8417U, false},
    {"fishing_long", "/assets/animations/fishing_long.gif", NULL, 0, 7875U, false},
    {"fishing_short", "/assets/animations/fishing_short.gif", NULL, 0, 5750U, false},
    {"flower_grow", "/assets/animations/flower_grow.gif", NULL, 0, 8583U, false},
    {"hello_annoyed", "/assets/animations/hello_annoyed.gif", NULL, 0, 8833U, false},
    {"hello_disappointed", "/assets/animations/hello_disappointed.gif", NULL, 0, 4250U, false},
    {"idle_01_loop", "/assets/animations/idle_01_loop.gif", NULL, 0, 9042U, true},
    {"calm_idle_01_f000", "/assets/animations/calm_idle_01_f000.gif", NULL, 0, 1000U, true},
    {"calm_idle_01_to_f137", "/assets/animations/calm_idle_01_to_f137.gif", NULL, 0, 5708U, false},
    {"calm_idle_01_f137", "/assets/animations/calm_idle_01_f137.gif", NULL, 0, 1000U, true},
    {"calm_idle_01_f137_to_f177", "/assets/animations/calm_idle_01_f137_to_f177.gif", NULL, 0, 1667U, false},
    {"calm_idle_01_f177", "/assets/animations/calm_idle_01_f177.gif", NULL, 0, 1000U, true},
    {"calm_idle_01_f177_to_f216", "/assets/animations/calm_idle_01_f177_to_f216.gif", NULL, 0, 1625U, false},
    {"calm_idle_01_f216", "/assets/animations/calm_idle_01_f216.gif", NULL, 0, 1000U, true},
    {"calm_work_low_f000", "/assets/animations/calm_work_low_f000.gif", NULL, 0, 1000U, true},
    {"calm_work_medium_f000", "/assets/animations/calm_work_medium_f000.gif", NULL, 0, 1000U, true},
    {"calm_work_high_f000", "/assets/animations/calm_work_high_f000.gif", NULL, 0, 1000U, true},
    {"idle_02_loop", "/assets/animations/idle_02_loop.gif", NULL, 0, 7875U, true},
    {"idle_variation_loop", "/assets/animations/idle_variation_loop.gif", NULL, 0, 1667U, true},
    {"listening_in", "/assets/animations/listening_in.gif", NULL, 0, 2000U, false},
    {"listening_loop", "/assets/animations/listening_loop.gif", NULL, 0, 2667U, true},
    {"listening_music_loop", "/assets/animations/listening_music_loop.gif", NULL, 0, 5333U, true},
    {"lockin", "/assets/animations/lockin.gif", NULL, 0, 3958U, false},
    {"love_01", "/assets/animations/love_01.gif", NULL, 0, 6333U, false},
    {"no", "/assets/animations/no.gif", NULL, 0, 4333U, false},
    {"perfect_day_01", "/assets/animations/perfect_day_01.gif", NULL, 0, 7125U, false},
    {"perfect_day_01_simple", "/assets/animations/perfect_day_01_simple.gif", NULL, 0, 7167U, false},
    {"perfect_day_02", "/assets/animations/perfect_day_02.gif", NULL, 0, 5500U, false},
    {"perfect_day_03", "/assets/animations/perfect_day_03.gif", NULL, 0, 6375U, false},
    {"posture_check", "/assets/animations/posture_check.gif", NULL, 0, 6125U, false},
    {"relaxing_01_loop", "/assets/animations/relaxing_01_loop.gif", NULL, 0, 3458U, true},
    {"relaxing_couch_in", "/assets/animations/relaxing_couch_in.gif", NULL, 0, 1333U, false},
    {"relaxing_couch_loop", "/assets/animations/relaxing_couch_loop.gif", NULL, 0, 2000U, true},
    {"review", "/assets/animations/review.gif", NULL, 0, 2000U, false},
    {"searching_loop", "/assets/animations/searching_loop.gif", NULL, 0, 1000U, true},
    {"sleeping_loop", "/assets/animations/sleeping_loop.gif", NULL, 0, 3250U, true},
    {"square", "/assets/animations/square.gif", NULL, 0, 3458U, false},
    {"startup", "/assets/animations/startup.gif", NULL, 0, 7667U, false},
    {"stretching", "/assets/animations/stretching.gif", NULL, 0, 6250U, false},
    {"talking_default_loop", "/assets/animations/talking_default_loop.gif", NULL, 0, 5333U, true},
    {"taby_response_ready_loop", "/assets/animations/taby_response_ready_loop.gif", NULL, 0, 1250U, true},
    {"task_completed", "/assets/animations/task_completed.gif", NULL, 0, 3125U, false},
    {"task_created", "/assets/animations/task_created.gif", NULL, 0, 5208U, false},
    {"task_page", "/assets/animations/task_page.gif", NULL, 0, 3583U, false},
    {"thumbs_up", "/assets/animations/thumbs_up.gif", NULL, 0, 3167U, false},
    {"trophy", "/assets/animations/trophy.gif", NULL, 0, 7208U, false},
    {"turn_off_reddit", "/assets/animations/turn_off_reddit.gif", NULL, 0, 6583U, false},
    {"turn_off_scroll", "/assets/animations/turn_off_scroll.gif", NULL, 0, 6500U, false},
    {"turn_off_tv", "/assets/animations/turn_off_tv.gif", NULL, 0, 6583U, false},
    {"waiting_01", "/assets/animations/waiting_01.gif", NULL, 0, 12917U, false},
    {"working_in", "/assets/animations/working_in.gif", NULL, 0, 2000U, false},
    {"working_loop", "/assets/animations/working_loop.gif", NULL, 0, 1333U, true},
    {"working_laptop_in", "/assets/animations/working_laptop_in.gif", NULL, 0, 1625U, false},
    {"working_laptop_loop", "/assets/animations/working_laptop_loop.gif", NULL, 0, 2667U, true},
    {"working_laptop_bored_loop", "/assets/animations/working_laptop_bored_loop.gif", NULL, 0, 1667U, true},
    {"working_laptop_excited_loop", "/assets/animations/working_laptop_excited_loop.gif", NULL, 0, 1667U, true},
    {"working_laptop_normal_loop", "/assets/animations/working_laptop_normal_loop.gif", NULL, 0, 1667U, true},
    {"workspaces_in", "/assets/animations/workspaces_in.gif", NULL, 0, 2250U, false},
    {"workspaces_loop", "/assets/animations/workspaces_loop.gif", NULL, 0, 4375U, true},
    {"wow", "/assets/animations/wow.gif", NULL, 0, 2583U, false},
    {"yeah", "/assets/animations/yeah.gif", NULL, 0, 2333U, false},
};

static const taby_animation_alias_t k_animation_aliases[] = {
    {"ambient_startup", "startup"},
    {"ambient_idle", "idle_01_loop"},
    {"ambient_waiting", "waiting_01"},
    {"ambient_busy", "busy_loop"},
    {"voice_listening", "listening_loop"},
    {"voice_talking", "talking_default_loop"},
    {"tool_use", "working_loop"},
    {"task_delete", "delete_01"},
    {"task_complete_finished", "task_completed"},
    {"task_complete_love", "love_01"},
    {"day_planning", "day_planned"},
    {"hello_dissapointed", "hello_disappointed"},
    {"angry_01__loop", "angry_01_loop"},
    {"angry_02__loop", "angry_02_loop"},
    {"busy__loop", "busy_loop"},
    {"calendar_page", "calendar_in"},
    {"calendar_page_in", "calendar_in"},
    {"calendar_page__loop", "calendar_loop"},
    {"creating_task__loop", "creating_task_loop"},
    {"idle_01__loop", "idle_01_loop"},
    {"idle_02__loop", "idle_02_loop"},
    {"idle_variation__loop", "idle_variation_loop"},
    {"listening__in", "listening_in"},
    {"listening__loop", "listening_loop"},
    {"listening_music__loop", "listening_music_loop"},
    {"relaxing_01__loop", "relaxing_01_loop"},
    {"relaxing_couch__in", "relaxing_couch_in"},
    {"relaxing_couch__loop", "relaxing_couch_loop"},
    {"searching__loop", "searching_loop"},
    {"sleeping__loop", "sleeping_loop"},
    {"talking_default__loop", "talking_default_loop"},
    {"taby_response_ready__loop", "taby_response_ready_loop"},
    {"working__in", "working_in"},
    {"working__loop", "working_loop"},
    {"working_laptop__in", "working_laptop_in"},
    {"working_laptop__loop", "working_laptop_loop"},
    {"working_laptop_bored__loop", "working_laptop_bored_loop"},
    {"working_laptop_excited__loop", "working_laptop_excited_loop"},
    {"working_laptop_normal__loop", "working_laptop_normal_loop"},
    {"workspaces__in", "workspaces_in"},
    {"workspaces__loop", "workspaces_loop"},
};

static void reset_animation_asset(taby_animation_asset_t *out_asset) {
    if (!out_asset) {
        return;
    }

    out_asset->animation_id = NULL;
    out_asset->asset_pack_path = NULL;
    out_asset->compiled_data = NULL;
    out_asset->compiled_size = 0;
    out_asset->duration_ms = 0;
    out_asset->loop = false;
}

static uint32_t hash_animation_id(const char *animation_id) {
    uint32_t digest = TABY_FNV1A_32_OFFSET_BASIS;

    if (!animation_id) {
        return digest;
    }

    for (const unsigned char *cursor = (const unsigned char *)animation_id; *cursor != '\0'; ++cursor) {
        digest ^= (uint32_t)(*cursor);
        digest *= TABY_FNV1A_32_PRIME;
    }

    return digest;
}

static const char *asset_pack_path_for_animation_id(const char *animation_id) {
    if (!animation_id || animation_id[0] == '\0') {
        return NULL;
    }

    char *slot = s_dynamic_asset_paths[s_dynamic_asset_path_index];
    s_dynamic_asset_path_index = (s_dynamic_asset_path_index + 1U) % TABY_DYNAMIC_ASSET_PATH_SLOTS;

    int written = snprintf(
        slot,
        TABY_DYNAMIC_ASSET_PATH_SIZE,
        "/assets/a/%08" PRIx32 ".gif",
        hash_animation_id(animation_id));
    if (written <= 0 || written >= TABY_DYNAMIC_ASSET_PATH_SIZE) {
        slot[0] = '\0';
        return NULL;
    }

    return slot;
}

static const char *canonical_animation_id(const char *animation_id) {
    if (!animation_id) {
        return NULL;
    }

    for (size_t i = 0; i < sizeof(k_animation_aliases) / sizeof(k_animation_aliases[0]); ++i) {
        if (strcmp(animation_id, k_animation_aliases[i].alias) == 0) {
            return k_animation_aliases[i].canonical_id;
        }
    }

    return animation_id;
}

bool taby_animation_asset_for_id(const char *animation_id, taby_animation_asset_t *out_asset) {
    if (!animation_id || !out_asset) {
        return false;
    }

    reset_animation_asset(out_asset);

    const char *canonical_id = canonical_animation_id(animation_id);
    for (size_t i = 0; i < sizeof(k_animation_assets) / sizeof(k_animation_assets[0]); ++i) {
        if (strcmp(canonical_id, k_animation_assets[i].animation_id) == 0) {
            *out_asset = k_animation_assets[i];
            out_asset->asset_pack_path = asset_pack_path_for_animation_id(out_asset->animation_id);
            return true;
        }
    }

    return false;
}

bool taby_animation_asset_for_state(taby_state_t state, taby_animation_asset_t *out_asset) {
    if (!out_asset) {
        return false;
    }

    reset_animation_asset(out_asset);

    switch (state) {
        case TABY_STATE_AMBIENT_STARTUP:
            return taby_animation_asset_for_id("startup", out_asset);
        case TABY_STATE_AMBIENT_IDLE:
            return taby_animation_asset_for_id("idle_01_loop", out_asset);
        case TABY_STATE_AMBIENT_WAITING:
            return taby_animation_asset_for_id("waiting_01", out_asset);
        case TABY_STATE_VOICE_LISTENING:
            return taby_animation_asset_for_id("listening_loop", out_asset);
        case TABY_STATE_VOICE_TALKING:
            return taby_animation_asset_for_id("talking_default_loop", out_asset);
        case TABY_STATE_TOOL_USE:
            return taby_animation_asset_for_id("working_loop", out_asset);
        case TABY_STATE_TASK_DELETE:
            return taby_animation_asset_for_id("delete_01", out_asset);
        case TABY_STATE_AMBIENT_BUSY_ANIMATION:
            return taby_animation_asset_for_id("busy_loop", out_asset);
        case TABY_STATE_AMBIENT_BUSY_TEXT:
            out_asset->animation_id = taby_state_name(state);
            out_asset->duration_ms = 0;
            return true;
        case TABY_STATE_FOCUS_TIMER:
        case TABY_STATE_BREAK_START:
        case TABY_STATE_CUSTOM_ANIMATION:
        case TABY_STATE_MISSING_FEATURE:
            out_asset->animation_id = taby_state_name(state);
            out_asset->duration_ms = 0;
            return true;
        default:
            break;
    }

    return false;
}
