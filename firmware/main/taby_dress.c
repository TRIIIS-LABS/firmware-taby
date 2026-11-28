#include "taby_dress.h"

#include <string.h>

static uint16_t u16_at(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static int16_t i16_at(const uint8_t *p) { return (int16_t)u16_at(p); }

bool taby_dress_parse(const uint8_t *blob, size_t length, taby_dress_t *out) {
    if (!blob || !out || length < 12 || memcmp(blob, "TXD1", 4) != 0) {
        return false;
    }
    taby_dress_t dress = {0};
    size_t count = u16_at(blob + 4);
    dress.ref_x = (int16_t)u16_at(blob + 6);
    dress.ref_y = (int16_t)u16_at(blob + 8);
    if (count == 0 || count > TABY_DRESS_MAX_SPRITES) {
        return false;
    }
    size_t at = 12;
    for (size_t i = 0; i < count; ++i) {
        if (at + 12 > length) {
            return false;
        }
        const uint8_t *h = blob + at;
        taby_dress_sprite_t sprite = {
            .kind = h[0] == 0 ? TABY_DRESS_HAT : TABY_DRESS_LIGHTS,
            .panel_x = i16_at(h + 2),
            .panel_y = i16_at(h + 4),
            .width = u16_at(h + 6),
            .height = u16_at(h + 8),
        };
        size_t bytes = (size_t)sprite.width * sprite.height * 4U;
        at += 12;
        if (h[0] > 1 || sprite.width == 0 || sprite.height == 0 || at + bytes > length || (at % 4) != 0) {
            return false;
        }
        sprite.argb = (const uint32_t *)(const void *)(blob + at);
        dress.sprites[i] = sprite;
        at += bytes;
    }
    dress.count = count;
    *out = dress;
    return true;
}

void taby_dress_offset(const taby_dress_t *dress, taby_dress_box_t face, int *out_dx, int *out_dy) {
    if (face.x0 >= face.x1 || face.y0 >= face.y1) {
        *out_dx = 0;
        *out_dy = 0;
        return;
    }
    *out_dx = face.x0 - dress->ref_x;
    *out_dy = (face.y0 + face.y1) / 2 - dress->ref_y;
}

taby_dress_box_t taby_dress_blit(
    uint32_t *panel, int panel_width, int panel_height,
    const taby_dress_sprite_t *sprite, int dx, int dy) {
    taby_dress_box_t box = {0, 0, 0, 0};
    int x0 = sprite->panel_x + dx, y0 = sprite->panel_y + dy;
    int x1 = x0 + sprite->width, y1 = y0 + sprite->height;
    int cx0 = x0 < 0 ? 0 : x0, cy0 = y0 < 0 ? 0 : y0;
    int cx1 = x1 > panel_width ? panel_width : x1, cy1 = y1 > panel_height ? panel_height : y1;
    if (cx0 >= cx1 || cy0 >= cy1) {
        return box;
    }
    for (int y = cy0; y < cy1; ++y) {
        const uint32_t *from = sprite->argb + (size_t)(y - y0) * sprite->width + (cx0 - x0);
        uint32_t *to = panel + (size_t)y * panel_width + cx0;
        for (int x = cx0; x < cx1; ++x, ++from, ++to) {
            uint32_t s = *from;
            uint32_t a = s >> 24;
            if (a == 0) {
                continue;
            }
            if (a == 255) {
                *to = s;
                continue;
            }
            /* Premultiplied source over: d = s + d * (255 - a) / 255, per channel. */
            uint32_t d = *to, keep = 255U - a, out = 0;
            for (int shift = 0; shift < 32; shift += 8) {
                uint32_t c = ((s >> shift) & 0xffU) + (((d >> shift) & 0xffU) * keep + 127U) / 255U;
                out |= (c > 255U ? 255U : c) << shift;
            }
            *to = out;
        }
    }
    box.x0 = cx0;
    box.y0 = cy0;
    box.x1 = cx1;
    box.y1 = cy1;
    return box;
}
