# Taby 1.64 V2 firmware target

Waveshare ESP32-S3-Touch-AMOLED-1.64 **V2** (version silkscreen on the right
side of the PCB, near the pin headers). Same panel, touch, IMU, flash, and
artwork as V1; the difference that matters to firmware:

| Signal | V1 | V2 |
| --- | --- | --- |
| LCD_CS | GPIO9 | GPIO46 |
| IMU_INT1 | GPIO46 | GPIO9 |

This target reuses V1's `sdkconfig.defaults`, `partitions.csv`, and
`assets/amoled-1.64`. V2-only pins (LCD_TE GPIO45, TP_INT GPIO18,
IMU_INT2 GPIO17) are not used yet.

```bash
python tools/build.py amoled-1.64-v2
python tools/package_release.py amoled-1.64-v2
```

A V1 image on a V2 board, or the reverse, leaves the screen black.

For manual download mode, keep BOOT held about two seconds after releasing
RESET, or hold BOOT while plugging in USB (see [INSTALL.md](../../../INSTALL.md)).
Source: [Waveshare 1.64 documentation](https://docs.waveshare.com/ESP32-S3-Touch-AMOLED-1.64).
