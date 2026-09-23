/* Host-test stand-in for ESP-IDF logging: arguments are still evaluated, so a
   bad format argument is still caught by the compiler and the sanitizers. */
#pragma once

#include <stdio.h>

#define TABY_HOST_LOG(tag, format, ...) \
    do { \
        if (0) { \
            fprintf(stderr, "%s " format "\n", tag, ##__VA_ARGS__); \
        } \
    } while (0)
#define ESP_LOGE(tag, format, ...) TABY_HOST_LOG(tag, format, ##__VA_ARGS__)
#define ESP_LOGW(tag, format, ...) TABY_HOST_LOG(tag, format, ##__VA_ARGS__)
#define ESP_LOGI(tag, format, ...) TABY_HOST_LOG(tag, format, ##__VA_ARGS__)
#define ESP_LOGD(tag, format, ...) TABY_HOST_LOG(tag, format, ##__VA_ARGS__)
