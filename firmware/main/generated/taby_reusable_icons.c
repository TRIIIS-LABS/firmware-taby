#include "generated/taby_reusable_icons.h"

#include <ctype.h>
#include <stddef.h>

typedef struct {
    const char *id;
    taby_reusable_icon_asset_t asset;
} taby_reusable_icon_entry_t;

static const taby_reusable_icon_entry_t k_taby_reusable_icon_entries[] = {
    {"water", {"/assets/icons/droplets.a4", 96, 96}},
    {"drink-water", {"/assets/icons/droplets.a4", 96, 96}},
    {"coffee", {"/assets/icons/coffee.a4", 96, 96}},
    {"tea", {"/assets/icons/cup-soda.a4", 96, 96}},
    {"apple", {"/assets/icons/apple.a4", 96, 96}},
    {"snack", {"/assets/icons/croissant.a4", 96, 96}},
    {"pause", {"/assets/icons/pause-circle.a4", 96, 96}},
    {"break", {"/assets/icons/pause-circle.a4", 96, 96}},
    {"phone", {"/assets/icons/phone.a4", 96, 96}},
    {"call", {"/assets/icons/phone.a4", 96, 96}},
    {"phone-talk", {"/assets/icons/phone-call.a4", 96, 96}},
    {"microphone", {"/assets/icons/mic.a4", 96, 96}},
    {"mic", {"/assets/icons/mic.a4", 96, 96}},
    {"record", {"/assets/icons/circle-dot.a4", 96, 96}},
    {"target", {"/assets/icons/target.a4", 96, 96}},
    {"focus", {"/assets/icons/focus.a4", 96, 96}},
    {"dnd", {"/assets/icons/minus-circle.a4", 96, 96}},
    {"stretch", {"/assets/icons/biceps-flexed.a4", 96, 96}},
    {"walk", {"/assets/icons/footprints.a4", 96, 96}},
    {"run", {"/assets/icons/activity.a4", 96, 96}},
    {"posture", {"/assets/icons/accessibility.a4", 96, 96}},
    {"check", {"/assets/icons/circle-check.a4", 96, 96}},
    {"warning", {"/assets/icons/triangle-alert.a4", 96, 96}},
    {"upload", {"/assets/icons/upload.a4", 96, 96}},
    {"download", {"/assets/icons/download.a4", 96, 96}},
    {"render", {"/assets/icons/monitor-cog.a4", 96, 96}},
    {"ship", {"/assets/icons/package-check.a4", 96, 96}},
    {"timer", {"/assets/icons/timer.a4", 96, 96}},
    {"progress-upload", {"/assets/icons/upload-cloud.a4", 96, 96}},
    {"progress-download", {"/assets/icons/download-cloud.a4", 96, 96}},
    {"play", {"/assets/icons/play-circle.a4", 96, 96}},
    {"stop", {"/assets/icons/stop-circle.a4", 96, 96}},
    {"refresh", {"/assets/icons/refresh-cw.a4", 96, 96}},
    {"sync", {"/assets/icons/cloud-sync.a4", 96, 96}},
    {"wifi", {"/assets/icons/wifi.a4", 96, 96}},
    {"usb", {"/assets/icons/usb.a4", 96, 96}},
    {"bluetooth", {"/assets/icons/bluetooth.a4", 96, 96}},
    {"battery", {"/assets/icons/battery.a4", 96, 96}},
    {"charging", {"/assets/icons/battery-charging.a4", 96, 96}},
    {"moon", {"/assets/icons/moon.a4", 96, 96}},
    {"sun", {"/assets/icons/sun.a4", 96, 96}},
    {"sleep", {"/assets/icons/moon-star.a4", 96, 96}},
    {"energy", {"/assets/icons/zap.a4", 96, 96}},
    {"heart", {"/assets/icons/heart.a4", 96, 96}},
    {"pulse", {"/assets/icons/heart-pulse.a4", 96, 96}},
    {"brain", {"/assets/icons/brain.a4", 96, 96}},
    {"eye", {"/assets/icons/eye.a4", 96, 96}},
    {"eye-off", {"/assets/icons/eye-off.a4", 96, 96}},
    {"listen", {"/assets/icons/ear.a4", 96, 96}},
    {"talk", {"/assets/icons/message-circle.a4", 96, 96}},
    {"video", {"/assets/icons/video.a4", 96, 96}},
    {"camera", {"/assets/icons/camera.a4", 96, 96}},
    {"note", {"/assets/icons/notepad-text.a4", 96, 96}},
    {"task", {"/assets/icons/check-square.a4", 96, 96}},
    {"calendar", {"/assets/icons/calendar.a4", 96, 96}},
    {"calendar-check", {"/assets/icons/calendar-check.a4", 96, 96}},
    {"calendar-clock", {"/assets/icons/calendar-clock.a4", 96, 96}},
    {"alarm", {"/assets/icons/alarm-clock.a4", 96, 96}},
    {"bell", {"/assets/icons/bell.a4", 96, 96}},
    {"bell-off", {"/assets/icons/bell-off.a4", 96, 96}},
    {"email", {"/assets/icons/mail.a4", 96, 96}},
    {"message", {"/assets/icons/message-circle.a4", 96, 96}},
    {"chat", {"/assets/icons/message-square.a4", 96, 96}},
    {"work", {"/assets/icons/briefcase.a4", 96, 96}},
    {"home", {"/assets/icons/house.a4", 96, 96}},
    {"car", {"/assets/icons/car-front.a4", 96, 96}},
    {"train", {"/assets/icons/train.a4", 96, 96}},
    {"flight", {"/assets/icons/plane.a4", 96, 96}},
    {"airplane", {"/assets/icons/plane.a4", 96, 96}},
    {"plane", {"/assets/icons/plane.a4", 96, 96}},
    {"cloud", {"/assets/icons/cloud.a4", 96, 96}},
    {"cloud-upload", {"/assets/icons/cloud-upload.a4", 96, 96}},
    {"cloud-download", {"/assets/icons/cloud-download.a4", 96, 96}},
    {"server", {"/assets/icons/server.a4", 96, 96}},
    {"database", {"/assets/icons/database.a4", 96, 96}},
    {"settings", {"/assets/icons/settings.a4", 96, 96}},
    {"tool", {"/assets/icons/wrench.a4", 96, 96}},
    {"bug", {"/assets/icons/bug.a4", 96, 96}},
    {"lock", {"/assets/icons/lock.a4", 96, 96}},
    {"unlock", {"/assets/icons/lock-open.a4", 96, 96}},
    {"shield", {"/assets/icons/shield-check.a4", 96, 96}},
    {"qr", {"/assets/icons/qr-code.a4", 96, 96}},
    {"link", {"/assets/icons/link.a4", 96, 96}},
    {"web", {"/assets/icons/globe.a4", 96, 96}},
    {"file", {"/assets/icons/file-text.a4", 96, 96}},
    {"folder", {"/assets/icons/folder.a4", 96, 96}},
    {"folder-open", {"/assets/icons/folder-open.a4", 96, 96}},
    {"printer", {"/assets/icons/printer.a4", 96, 96}},
    {"package", {"/assets/icons/package.a4", 96, 96}},
    {"star", {"/assets/icons/star.a4", 96, 96}},
    {"trophy", {"/assets/icons/award.a4", 96, 96}},
    {"fire", {"/assets/icons/flame.a4", 96, 96}},
    {"sparkles", {"/assets/icons/sparkles.a4", 96, 96}},
    {"flag", {"/assets/icons/flag.a4", 96, 96}},
    {"bookmark", {"/assets/icons/bookmark.a4", 96, 96}},
    {"clock", {"/assets/icons/clock.a4", 96, 96}},
    {"close", {"/assets/icons/circle-x.a4", 96, 96}},
    {"info", {"/assets/icons/info.a4", 96, 96}},
    {"help", {"/assets/icons/help-circle.a4", 96, 96}},
    {"account", {"/assets/icons/circle-user-round.a4", 96, 96}},
    {"team", {"/assets/icons/users-round.a4", 96, 96}},
    {"voice", {"/assets/icons/mic-vocal.a4", 96, 96}},
    {"laptop", {"/assets/icons/laptop.a4", 96, 96}},
    {"monitor", {"/assets/icons/monitor.a4", 96, 96}},
    {"tablet", {"/assets/icons/tablet.a4", 96, 96}},
    {"cellphone", {"/assets/icons/smartphone.a4", 96, 96}},
    {"keyboard", {"/assets/icons/keyboard.a4", 96, 96}},
    {"mouse", {"/assets/icons/mouse.a4", 96, 96}},
    {"headphones", {"/assets/icons/headphones.a4", 96, 96}},
    {"speaker", {"/assets/icons/speaker.a4", 96, 96}},
    {"network", {"/assets/icons/network.a4", 96, 96}},
    {"bicycle", {"/assets/icons/bike.a4", 96, 96}},
    {"dumbbell", {"/assets/icons/dumbbell.a4", 96, 96}},
    {"calendar-days", {"/assets/icons/calendar-days.a4", 96, 96}},
    {"calendar-heart", {"/assets/icons/calendar-heart.a4", 96, 96}},
    {"calendar-plus", {"/assets/icons/calendar-plus.a4", 96, 96}},
    {"calendar-range", {"/assets/icons/calendar-range.a4", 96, 96}},
    {"bell-ring", {"/assets/icons/bell-ring.a4", 96, 96}},
    {"book-open", {"/assets/icons/book-open.a4", 96, 96}},
    {"notebook-pen", {"/assets/icons/notebook-pen.a4", 96, 96}},
    {"clipboard-list", {"/assets/icons/clipboard-list.a4", 96, 96}},
    {"clipboard-check", {"/assets/icons/clipboard-check.a4", 96, 96}},
    {"briefcase-business", {"/assets/icons/briefcase-business.a4", 96, 96}},
    {"pill", {"/assets/icons/pill.a4", 96, 96}},
    {"stethoscope", {"/assets/icons/stethoscope.a4", 96, 96}},
    {"bath", {"/assets/icons/bath.a4", 96, 96}},
    {"shower-head", {"/assets/icons/shower-head.a4", 96, 96}},
    {"bed", {"/assets/icons/bed.a4", 96, 96}},
    {"sunrise", {"/assets/icons/sunrise.a4", 96, 96}},
    {"sunset", {"/assets/icons/sunset.a4", 96, 96}},
    {"cloud-rain", {"/assets/icons/cloud-rain.a4", 96, 96}},
    {"umbrella", {"/assets/icons/umbrella.a4", 96, 96}},
    {"leaf", {"/assets/icons/leaf.a4", 96, 96}},
    {"flower-2", {"/assets/icons/flower-2.a4", 96, 96}},
    {"message-circle-more", {"/assets/icons/message-circle-more.a4", 96, 96}},
    {"check-check", {"/assets/icons/check-check.a4", 96, 96}},
    {"map-pinned", {"/assets/icons/map-pinned.a4", 96, 96}},
    {"bus-front", {"/assets/icons/bus-front.a4", 96, 96}},
    {"train-front", {"/assets/icons/train-front.a4", 96, 96}},
    {"car-taxi-front", {"/assets/icons/car-taxi-front.a4", 96, 96}},
    {"plane-takeoff", {"/assets/icons/plane-takeoff.a4", 96, 96}},
    {"plane-landing", {"/assets/icons/plane-landing.a4", 96, 96}},
    {"ticket", {"/assets/icons/ticket.a4", 96, 96}},
    {"gift", {"/assets/icons/gift.a4", 96, 96}},
    {"cake", {"/assets/icons/cake.a4", 96, 96}},
    {"party-popper", {"/assets/icons/party-popper.a4", 96, 96}},
    {"person-standing", {"/assets/icons/person-standing.a4", 96, 96}},
    {"watch", {"/assets/icons/watch.a4", 96, 96}},
    {"timer-reset", {"/assets/icons/timer-reset.a4", 96, 96}},
    {"scan-eye", {"/assets/icons/scan-eye.a4", 96, 96}},
    {"shopping-bag", {"/assets/icons/shopping-bag.a4", 96, 96}},
    {"utensils", {"/assets/icons/utensils.a4", 96, 96}},
    {"cooking-pot", {"/assets/icons/cooking-pot.a4", 96, 96}},
};

static bool normalized_equals(const char *left, const char *right) {
    if (!left || !right) {
        return false;
    }

    size_t left_index = 0;
    size_t right_index = 0;
    while (left[left_index] != '\0' && right[right_index] != '\0') {
        char left_char = (char)tolower((unsigned char)left[left_index]);
        char right_char = (char)tolower((unsigned char)right[right_index]);
        if (left_char == '_') {
            left_char = '-';
        }
        if (right_char == '_') {
            right_char = '-';
        }
        if (left_char != right_char) {
            return false;
        }
        left_index++;
        right_index++;
    }

    return left[left_index] == '\0' && right[right_index] == '\0';
}

bool taby_reusable_icon_lookup(const char *icon_id, taby_reusable_icon_asset_t *out_asset) {
    if (!icon_id || !out_asset) {
        return false;
    }

    for (size_t index = 0; index < sizeof(k_taby_reusable_icon_entries) / sizeof(k_taby_reusable_icon_entries[0]); ++index) {
        if (normalized_equals(icon_id, k_taby_reusable_icon_entries[index].id)) {
            *out_asset = k_taby_reusable_icon_entries[index].asset;
            return true;
        }
    }

    return false;
}
