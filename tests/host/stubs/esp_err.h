/* Host-test stand-in for ESP-IDF's esp_err.h: only what firmware headers name. */
#pragma once

typedef int esp_err_t;
#define ESP_OK 0
#define ESP_FAIL -1
