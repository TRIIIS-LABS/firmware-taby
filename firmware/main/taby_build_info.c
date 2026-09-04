#include "taby_build_info.h"

#include "taby_asset_store.h"

static const char *TABY_PRODUCT_NAME = "taby";
static const char *TABY_FIRMWARE_VERSION = "1.0.8";
static const char *TABY_ASSETS_VERSION_FALLBACK = "0.3.3";

const char *taby_firmware_version(void) {
    return TABY_FIRMWARE_VERSION;
}

const char *taby_assets_version(void) {
    const char *asset_pack_version = taby_asset_store_pack_version();
    if (asset_pack_version && asset_pack_version[0] != '\0') {
        return asset_pack_version;
    }
    return TABY_ASSETS_VERSION_FALLBACK;
}

const char *taby_product_name(void) {
    return TABY_PRODUCT_NAME;
}

const char *taby_hardware_target(void) {
#if defined(TABY_HARDWARE_ROUND_1_32) && TABY_HARDWARE_ROUND_1_32
    return "round-1.32";
#else
    return "amoled-1.64";
#endif
}

const char *taby_display_shape(void) {
#if defined(TABY_HARDWARE_ROUND_1_32) && TABY_HARDWARE_ROUND_1_32
    return "round";
#else
    return "rectangle";
#endif
}

unsigned int taby_display_width(void) {
#if defined(TABY_HARDWARE_ROUND_1_32) && TABY_HARDWARE_ROUND_1_32
    return 466U;
#else
    return 280U;
#endif
}

unsigned int taby_display_height(void) {
#if defined(TABY_HARDWARE_ROUND_1_32) && TABY_HARDWARE_ROUND_1_32
    return 466U;
#else
    return 456U;
#endif
}
