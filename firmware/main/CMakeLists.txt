idf_component_register(
    SRCS
        "app_main.c"
        "board_amoled_1_64.c"
        "dns_server.c"
        "taby_ble_transport.c"
        "taby_asset_store.c"
        "taby_animation_assets.c"
        "taby_build_info.c"
        "taby_display.c"
        "generated/taby_reusable_icons.c"
        "taby_http_server.c"
        "taby_identity.c"
        "taby_mqtt.c"
        "taby_onboarding.c"
        "taby_power.c"
        "taby_power_button.c"
        "taby_reusable_preview.c"
        "taby_reusable_ui.c"
        "taby_runtime.c"
        "taby_state_machine.c"
        "taby_transport_prefs.c"
        "taby_transport_protocol.c"
        "taby_usb_serial.c"
        "taby_wifi.c"
    INCLUDE_DIRS "."
    REQUIRES bt driver esp_adc esp_event esp_http_server esp_lcd esp_netif esp_timer esp_wifi json lvgl mdns mqtt nvs_flash esp_lcd_sh8601 spiffs
)

if(TABY_HARDWARE_TARGET STREQUAL "round-1.32")
    target_compile_definitions(${COMPONENT_LIB} PRIVATE TABY_HARDWARE_ROUND_1_32=1)
    set(TABY_AMOLED_PACK_DIR "${CMAKE_CURRENT_LIST_DIR}/../../assets/round-1.32")
else()
    set(TABY_AMOLED_PACK_DIR "${CMAKE_CURRENT_LIST_DIR}/../../assets/amoled-1.64")
endif()

if(EXISTS "${TABY_AMOLED_PACK_DIR}/manifest.json")
    spiffs_create_partition_image(assets "${TABY_AMOLED_PACK_DIR}" FLASH_IN_PROJECT)
else()
    message(FATAL_ERROR "Asset pack missing at ${TABY_AMOLED_PACK_DIR}; restore the assets directory from this repository")
endif()
