# Taby's live character: the desktop notch's Rive character driven as the
# notch drives it (taby_character), drawn by PlutoVG (rive_plutovg), and the
# app's VOICE_MOTION lines played on the board's clock (taby_voice). From
# experiments/rive-proof on the claude/rive-on-device branch.
idf_component_register(
    SRCS "rive_plutovg.cpp" "taby_character.cpp" "taby_voice.cpp"
    INCLUDE_DIRS "."
    REQUIRES rive plutovg)
target_compile_options(${COMPONENT_LIB} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++17>)
