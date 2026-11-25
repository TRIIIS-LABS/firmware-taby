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

# PCB revision of the 1.64 board. V1.1 is the current production board; V1 only
# moves LCD_CS from GPIO46 to GPIO9.
set(TABY_AMOLED_1_64_REVISION "V1.1" CACHE STRING "Waveshare 1.64 PCB revision (V1.1 or V1)")
set_property(CACHE TABY_AMOLED_1_64_REVISION PROPERTY STRINGS "V1.1" "V1")
if(NOT TABY_AMOLED_1_64_REVISION STREQUAL "V1.1" AND NOT TABY_AMOLED_1_64_REVISION STREQUAL "V1")
    message(FATAL_ERROR "Unsupported TABY_AMOLED_1_64_REVISION=${TABY_AMOLED_1_64_REVISION}")
endif()
if(TABY_HARDWARE_TARGET STREQUAL "amoled-1.64")
    message(STATUS "Taby 1.64 PCB revision: ${TABY_AMOLED_1_64_REVISION}")
endif()

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(taby_firmware)
