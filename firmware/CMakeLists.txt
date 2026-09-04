cmake_minimum_required(VERSION 3.16)

# Keep ESP-IDF's application metadata aligned with the version reported by INFO.
file(STRINGS "${CMAKE_CURRENT_LIST_DIR}/main/taby_build_info.c" TABY_VERSION_LINE
     REGEX "TABY_FIRMWARE_VERSION =")
string(REGEX MATCH "\"([0-9]+\\.[0-9]+\\.[0-9]+)\"" TABY_VERSION_MATCH "${TABY_VERSION_LINE}")
if(NOT TABY_VERSION_MATCH)
    message(FATAL_ERROR "Could not read firmware version from taby_build_info.c")
endif()
set(PROJECT_VER "${CMAKE_MATCH_1}")

set(TABY_HARDWARE_TARGET "amoled-1.64" CACHE STRING "Taby physical hardware target")
set_property(CACHE TABY_HARDWARE_TARGET PROPERTY STRINGS "amoled-1.64" "round-1.32")
if(NOT TABY_HARDWARE_TARGET STREQUAL "amoled-1.64" AND NOT TABY_HARDWARE_TARGET STREQUAL "round-1.32")
    message(FATAL_ERROR "Unsupported TABY_HARDWARE_TARGET=${TABY_HARDWARE_TARGET}")
endif()
message(STATUS "Taby hardware target: ${TABY_HARDWARE_TARGET}")

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(taby_firmware)
