# PlutoVG (MIT; its rasterizer and stroker derive from FreeType), the CPU
# vector rasterizer Rive draws through. tools/fetch-rive.sh fetches it.
set(PLUTOVG "${CMAKE_CURRENT_LIST_DIR}/../../third_party/plutovg")
if(NOT EXISTS "${PLUTOVG}/include/plutovg.h")
    message(FATAL_ERROR "PlutoVG is missing: run firmware/tools/fetch-rive.sh")
endif()
file(GLOB PLUTOVG_SOURCES "${PLUTOVG}/source/*.c")
idf_component_register(SRCS ${PLUTOVG_SOURCES} INCLUDE_DIRS "${PLUTOVG}/include")
target_compile_definitions(${COMPONENT_LIB} PUBLIC PLUTOVG_BUILD_STATIC)
# No font files or PNG writing on the board. uint32_t and unsigned int are
# both 32-bit here; GCC 14 only refuses to mix the pointer types.
target_compile_definitions(${COMPONENT_LIB} PRIVATE
    PLUTOVG_DISABLE_FONT_FACE_CACHE_LOAD PLUTOVG_DISABLE_IMAGE_WRITE)
target_compile_options(${COMPONENT_LIB} PRIVATE -w -Wno-error=incompatible-pointer-types)
