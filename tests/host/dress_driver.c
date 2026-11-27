/* Runs the firmware's Christmas dress off-device, for tests/test_dress.py.

   Modes, JSON out:
     blob PATH                the blob as the firmware reads it
     offsets PATH             one face box a line on stdin (x0 y0 x1 y1): the hat's
                              box on the panel for each, after taby_dress_offset
     blit                     a 2x2 sprite on a 4x3 panel, moved and clipped
   Built with sanitizers. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "taby_dress.h"

static uint8_t *read_all(const char *path, size_t *length) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    /* Aligned as the firmware's copy is. */
    uint8_t *data = aligned_alloc(16, ((size_t)size + 15) & ~(size_t)15);
    if (data && fread(data, 1, (size_t)size, f) != (size_t)size) {
        free(data);
        data = NULL;
    }
    fclose(f);
    *length = (size_t)size;
    return data;
}

int main(int argc, char **argv) {
    if (argc == 3 && (strcmp(argv[1], "blob") == 0 || strcmp(argv[1], "offsets") == 0)) {
        size_t length = 0;
        uint8_t *data = read_all(argv[2], &length);
        taby_dress_t dress;
        if (!data || !taby_dress_parse(data, length, &dress)) {
            printf("{\"parsed\":false}\n");
            free(data);
            return 0;
        }
        if (strcmp(argv[1], "blob") == 0) {
            printf("{\"parsed\":true,\"ref\":[%d,%d],\"sprites\":[", dress.ref_x, dress.ref_y);
            for (size_t i = 0; i < dress.count; ++i) {
                const taby_dress_sprite_t *s = &dress.sprites[i];
                printf("%s{\"kind\":%d,\"x\":%d,\"y\":%d,\"w\":%u,\"h\":%u,\"opaque_corner\":%s}", i ? "," : "",
                       (int)s->kind, s->panel_x, s->panel_y, s->width, s->height,
                       (s->argb[0] >> 24) ? "true" : "false");
            }
            printf("]}\n");
        } else {
            int x0, y0, x1, y1;
            while (scanf("%d %d %d %d", &x0, &y0, &x1, &y1) == 4) {
                int dx = 0, dy = 0;
                taby_dress_offset(&dress, (taby_dress_box_t){x0, y0, x1, y1}, &dx, &dy);
                const taby_dress_sprite_t *hat = &dress.sprites[0];
                printf("[%d,%d,%d,%d]\n", hat->panel_x + dx, hat->panel_y + dy,
                       hat->panel_x + dx + hat->width, hat->panel_y + dy + hat->height);
            }
        }
        free(data);
        return 0;
    }
    if (argc == 2 && strcmp(argv[1], "blit") == 0) {
        /* Opaque red, half-white (premultiplied), transparent, opaque green. */
        static const uint32_t pixels[4] = {0xffff0000u, 0x80808080u, 0x00000000u, 0xff00ff00u};
        taby_dress_sprite_t sprite = {TABY_DRESS_HAT, 1, 1, 2, 2, pixels};
        const int cases[][2] = {{0, 0}, {2, 1}, {-2, 0}, {-5, -5}};
        printf("[");
        for (size_t c = 0; c < sizeof(cases) / sizeof(cases[0]); ++c) {
            uint32_t panel[12];
            for (int i = 0; i < 12; ++i) panel[i] = 0xff202020u;
            taby_dress_box_t box = taby_dress_blit(panel, 4, 3, &sprite, cases[c][0], cases[c][1]);
            printf("%s{\"box\":[%d,%d,%d,%d],\"panel\":[", c ? "," : "", box.x0, box.y0, box.x1, box.y1);
            for (int i = 0; i < 12; ++i) printf("%s%u", i ? "," : "", (unsigned)panel[i]);
            printf("]}");
        }
        printf("]\n");
        return 0;
    }
    fprintf(stderr, "usage: dress_driver blob PATH | offsets PATH | blit\n");
    return 2;
}
