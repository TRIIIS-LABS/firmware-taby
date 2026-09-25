#include "taby_idle_eyes.h"

#include <string.h>

#include "esp_log.h"
#include "esp_random.h"
#include "nvs.h"

static const char *TAG = "taby_idle_eyes";
/* Kept beside the display orientation, the other thing the device remembers
   about how its face looks. */
#define PREFS_NAMESPACE "taby_display"
#define EYE_MOTION_KEY "eye_motion"
/* The clip idle shows. taby_eye_motion.h's frame plan was cut from it. */
#define REST_FACE_ID "idle_01_loop"

static bool s_loaded = false;
static taby_eye_motion_t s_mode = TABY_EYE_MOTION_DEFAULT;
/* The rest face on screen, driven or not. */
static lv_obj_t *s_face = NULL;
/* Set while this module, not LVGL, advances the face's frames. */
static lv_timer_t *s_timer = NULL;
static taby_rest_face_t s_plan;

static void load_mode(void) {
    if (s_loaded) {
        return;
    }
    s_loaded = true;

    nvs_handle_t handle;
    if (nvs_open(PREFS_NAMESPACE, NVS_READONLY, &handle) != ESP_OK) {
        return;
    }
    uint8_t stored = 0;
    esp_err_t err = nvs_get_u8(handle, EYE_MOTION_KEY, &stored);
    nvs_close(handle);
    if (err == ESP_OK && !taby_eye_motion_from_stored(stored, &s_mode)) {
        ESP_LOGW(TAG, "unknown stored eye motion=%u; using normal", (unsigned int)stored);
        s_mode = TABY_EYE_MOTION_DEFAULT;
    }
    ESP_LOGI(TAG, "eye motion loaded mode=%s", taby_eye_motion_name(s_mode));
}

taby_eye_motion_t taby_idle_eyes_mode(void) {
    load_mode();
    return s_mode;
}

esp_err_t taby_idle_eyes_store(taby_eye_motion_t mode) {
    nvs_handle_t handle;
    esp_err_t err = nvs_open(PREFS_NAMESPACE, NVS_READWRITE, &handle);
    if (err != ESP_OK) {
        return err;
    }
    err = nvs_set_u8(handle, EYE_MOTION_KEY, (uint8_t)mode);
    if (err == ESP_OK) {
        err = nvs_commit(handle);
    }
    nvs_close(handle);
    if (err == ESP_OK) {
        s_mode = mode;
        s_loaded = true;
    }
    return err;
}

esp_err_t taby_idle_eyes_erase(void) {
    nvs_handle_t handle;
    esp_err_t err = nvs_open(PREFS_NAMESPACE, NVS_READWRITE, &handle);
    if (err != ESP_OK) {
        return err;
    }
    err = nvs_erase_key(handle, EYE_MOTION_KEY);
    if (err == ESP_ERR_NVS_NOT_FOUND) {
        err = ESP_OK;
    }
    if (err == ESP_OK) {
        err = nvs_commit(handle);
    }
    nvs_close(handle);
    if (err == ESP_OK) {
        s_mode = TABY_EYE_MOTION_DEFAULT;
        s_loaded = true;
    }
    return err;
}

static void show_next_frame(lv_timer_t *timer);

static lv_gif_t *gif_of(lv_obj_t *face) {
    return (lv_gif_t *)face;
}

static void stop_driving(void) {
    if (s_timer) {
        lv_timer_del(s_timer);
        s_timer = NULL;
    }
}

/* LVGL plays the clip as drawn again, from the frame it is on. */
static void hand_back(void) {
    stop_driving();
    if (s_face && gif_of(s_face)->gif) {
        lv_timer_resume(gif_of(s_face)->timer);
    }
}

/* What lv_gif does for each frame, for the frame the decoder has just read. */
static void show_decoded_frame(lv_gif_t *gif) {
    gd_render_frame(gif->gif, (uint8_t *)gif->imgdsc.data);
    lv_img_cache_invalidate_src(lv_img_get_src(s_face));
    lv_obj_invalidate(s_face);
}

static void hold_frame(lv_gif_t *gif) {
    uint32_t hold_ms = taby_rest_face_hold_ms(&s_plan, (uint32_t)gif->gif->gce.delay * 10U, esp_random());
    if (!s_timer) {
        s_timer = lv_timer_create(show_next_frame, hold_ms, NULL);
        return;
    }
    lv_timer_set_period(s_timer, hold_ms);
    lv_timer_reset(s_timer);
}

/* The decoder only reads forward, so a pass that ends goes back to frame 0,
   which covers the whole canvas and redraws the face exactly. */
static bool read_frame(lv_gif_t *gif, bool rewind) {
    if (rewind) {
        gd_rewind(gif->gif);
    }
    if (gd_get_frame(gif->gif) != 1) {
        ESP_LOGW(TAG, "rest face frame %u unreadable; playing it as drawn", (unsigned int)s_plan.frame);
        hand_back();
        return false;
    }
    show_decoded_frame(gif);
    return true;
}

static void show_next_frame(lv_timer_t *timer) {
    (void)timer;
    if (!s_face || !gif_of(s_face)->gif) {
        stop_driving();
        return;
    }
    lv_gif_t *gif = gif_of(s_face);
    if (read_frame(gif, taby_rest_face_advance(&s_plan, esp_random()))) {
        hold_frame(gif);
    }
}

static void start_driving(void) {
    lv_gif_t *gif = gif_of(s_face);
    if (!gif->gif || !taby_rest_face_start(&s_plan, s_mode, esp_random())) {
        return;
    }
    lv_timer_pause(gif->timer);
    if (read_frame(gif, true)) {
        hold_frame(gif);
        ESP_LOGI(TAG, "rest face driven mode=%s", taby_eye_motion_name(s_mode));
    }
}

static void handle_face_deleted(lv_event_t *event) {
    if (lv_event_get_target(event) == s_face) {
        stop_driving();
        s_face = NULL;
    }
}

static void let_go(void) {
    stop_driving();
    if (s_face) {
        lv_obj_remove_event_cb(s_face, handle_face_deleted);
        s_face = NULL;
    }
}

void taby_idle_eyes_follow(lv_obj_t *face, const char *animation_id) {
    /* A new source restarts lv_gif's own timer, so there is nothing to hand back. */
    let_go();
    if (!face || !animation_id || strcmp(animation_id, REST_FACE_ID) != 0) {
        return;
    }
    s_face = face;
    lv_obj_add_event_cb(face, handle_face_deleted, LV_EVENT_DELETE, NULL);
    load_mode();
    start_driving();
}

void taby_idle_eyes_forget(void) {
    let_go();
}

void taby_idle_eyes_apply(void) {
    if (!s_face) {
        return;
    }
    load_mode();
    if (s_mode == TABY_EYE_MOTION_NORMAL) {
        hand_back();
        return;
    }
    stop_driving();
    start_driving();
}
