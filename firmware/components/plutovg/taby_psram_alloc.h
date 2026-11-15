/*
 * Forced into every PlutoVG source (see CMakeLists.txt): its paths, spans and
 * strokes go in PSRAM, so the live character leaves internal RAM to Wi-Fi and
 * Bluetooth. Internal RAM is still used when PSRAM is out.
 */
#pragma once

#include <stdlib.h>

#include "esp_heap_caps.h"

static inline void *taby_vg_malloc(size_t size)
{
    void *p = heap_caps_malloc(size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    return p != NULL ? p : malloc(size);
}

static inline void *taby_vg_calloc(size_t count, size_t size)
{
    void *p = heap_caps_calloc(count, size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    return p != NULL ? p : calloc(count, size);
}

static inline void *taby_vg_realloc(void *ptr, size_t size)
{
    void *p = heap_caps_realloc(ptr, size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    return (p != NULL || size == 0) ? p : realloc(ptr, size);
}

#define malloc(size) taby_vg_malloc(size)
#define calloc(count, size) taby_vg_calloc(count, size)
#define realloc(ptr, size) taby_vg_realloc(ptr, size)
