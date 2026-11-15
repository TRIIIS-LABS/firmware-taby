# Taby Round 1.75C firmware target

This target is isolated from the working `amoled-1.64` and `round-1.32`
firmware builds.

It uses:

- Waveshare ESP32-S3-Touch-AMOLED-1.75C (hardware V1.0)
- 466x466 round AMOLED panel with the CO5300 QSPI command set
- CST9217 touch at I2C address `0x5A` (16-bit register addressing)
- 32MB flash and 8MB octal PSRAM

Pins and hardware follow Waveshare's official BSP,
`waveshare/esp32_s3_touch_amoled_1_75c` (component registry), and the
`waveshare_boards` device description:

| Signal | GPIO |
| --- | --- |
| LCD CS | 12 |
| LCD PCLK | 38 |
| LCD DATA0..3 | 4, 5, 6, 7 |
| LCD RST | 1 |
| Touch RST | 2 |
| Touch INT | 11 |
| I2C SCL / SDA | 14 / 15 |

Build from `firmware/` with a dedicated build directory and sdkconfig:

```bash
idf.py -B build-round-1.75c \
  -D SDKCONFIG=sdkconfig.round-1.75c \
  -D SDKCONFIG_DEFAULTS=targets/round-1.75c/sdkconfig.defaults \
  -D TABY_HARDWARE_TARGET=round-1.75c \
  build
```

For the recommended isolated build commands for all targets, see
[the firmware guide](../../README.md). The public wrapper uses a separate
build directory and sdkconfig for each board.

## Verification status

Source builds and the offline checks cover this target, and it has been
flashed and measured on a physical board (2026-09-28):

- firmware boots and reports `round-1.75c`, round, 466x466, USB bridge ready
- the CO5300 panel initializes, applies the display orientation, and renders
  animations correctly
- the CST9217 answers its identity read as `resolution=466x466`, and touch
  coordinates and tap/hold gestures respond correctly
- USB `INFO`, `install.py verify`, animation commands, and the Windows Taby
  app connection all work
- the asset pack mounts (about 4.3 MB used of the 7.7 MB partition)
- no panic or boot loop; `main_task` returns normally

There is no printed case to contribute: the 1.75C ships in a CNC-machined
aluminium enclosure. The target is therefore feature-complete for hardware
support; publishing a release bundle is the remaining maintainer step.