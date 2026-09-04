# Taby Round 1.32 firmware target

This target is isolated from the working `amoled-1.64` firmware build.

It uses:

- Waveshare ESP32-S3-Touch-AMOLED-1.32
- 466x466 round AMOLED panel using the board's CO5300-compatible QSPI command set
- CST820 touch at I2C address `0x15`
- 8MB flash and 8MB octal PSRAM
- the isolated `assets/round-1.32` pack at the repository root

Build from `firmware/` with a dedicated build directory and sdkconfig:

```bash
idf.py -B build-round-1.32 \
  -D SDKCONFIG=sdkconfig.round-1.32 \
  -D SDKCONFIG_DEFAULTS=targets/round-1.32/sdkconfig.defaults \
  -D TABY_HARDWARE_TARGET=round-1.32 \
  build
```

For the recommended isolated build commands for both targets, see
[the firmware guide](../../README.md). The public wrapper uses a separate
build directory and sdkconfig for each board.
