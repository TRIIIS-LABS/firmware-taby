# The Rive C++ runtime (MIT), for Taby talking live. tools/fetch-rive.sh puts
# the pinned source in firmware/third_party. No scripting: the talking face
# needs none (the working sparkle is a GIF here).
set(RIVE "${CMAKE_CURRENT_LIST_DIR}/../../third_party/rive-runtime")
if(NOT EXISTS "${RIVE}/include/rive/file.hpp")
    message(FATAL_ERROR "The Rive runtime is missing: run firmware/tools/fetch-rive.sh")
endif()
file(GLOB_RECURSE RIVE_SOURCES "${RIVE}/src/*.cpp")
idf_component_register(SRCS ${RIVE_SOURCES}
    INCLUDE_DIRS "${RIVE}/include"
    REQUIRES esp_hw_support freertos)
target_compile_definitions(${COMPONENT_LIB} PUBLIC _RIVE_INTERNAL_ YOGA_EXPORT=)
target_compile_options(${COMPONENT_LIB} PRIVATE -w $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++17>)
