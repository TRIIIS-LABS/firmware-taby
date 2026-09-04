# Physical Taby

Put Taby on your desk. This repository contains the ESP32 firmware and animations
for Physical Taby. Use it with the **Taby app**, or control it from your own
personal projects using the [device commands](firmware/README.md#talk-to-taby).
We maintain the Taby app integration; community integrations are maintained by
their authors.

## Supported displays

| Display | Supported hardware | Screen | Get the board |
| --- | --- | --- | --- |
| **Taby 1.64** | Waveshare ESP32-S3-Touch-AMOLED-1.64 **V1** | Rectangle, 280 × 456 | [Waveshare](https://www.waveshare.com/product/esp32-s3-touch-amoled-1.64.htm) |
| **Taby Round 1.32** | Waveshare ESP32-S3-Touch-AMOLED-1.32 | Round, 466 × 466 | [Waveshare](https://www.waveshare.com/product/esp32-s3-touch-amoled-1.32.htm) |

Both implementations have been tested on physical boards by the maintainer.
The firmware source here is **1.0.8**.
The round board has 8 MB flash and a smaller, 27-animation pack; the 1.64 has
16 MB flash and an 84-animation pack. They require different firmware bundles.

**Check the 1.64 revision before buying.** Waveshare's V2 has different pins and
is not supported by this release. V1's revision marking is at the top of the PCB;
V2's is beside the right-hand headers. A product link alone does not guarantee
which revision a seller ships. See [Waveshare's revision guide](https://docs.waveshare.com/ESP32-S3-Touch-AMOLED-1.64).
<!-- When affiliate URLs are available, replace these product links and add
a short commission disclosure beside them. Do not invent affiliate URLs. -->

## Install with your AI agent

Connect the board with a **USB data cable**, then copy this prompt into an agent
that can run commands on your computer:

```text
Install Physical Taby on my connected device by following:
https://github.com/TRIIIS-LABS/firmware-taby/blob/main/INSTALL.md

Read the guide first. Identify my operating system and exact supported board
and hardware revision; ask me if those cannot be determined reliably. Install
the ESP32 flashing and serial dependencies and resolve any missing USB driver
or serial permission. Get the matching official firmware and animation bundle,
validate it, install it, and verify the running device. Guide me through any
physical button presses. Then help me use it with the Taby app. Do not change
firmware source just to perform an installation.
```

Humans can follow the same [installation guide](INSTALL.md). The guide also
covers missing COM ports, USB drivers, bootloader mode, and recovery.

Prebuilt bundles belong in [GitHub Releases](https://github.com/TRIIIS-LABS/firmware-taby/releases).
The current binaries are in the [v1.0.8 release](https://github.com/TRIIIS-LABS/firmware-taby/releases/tag/v1.0.8).
Use the documented [source-build path](firmware/README.md#build-from-source)
when developing firmware; do not substitute an unrelated ESP32 image or an old
factory dump.

## Print a case

Cases and other printable parts live under [hardware](hardware/README.md). A
model is compatible only with the exact board and hardware revision named in
its catalog entry. Screen shape and opening, PCB outline, USB connector,
buttons, antenna clearance, and mounting points are all part of that target.

No printable model has been published yet. The hardware catalog says this
explicitly so a person or agent will not silently use a case for the wrong
display. Future contributions should include editable CAD, ready-to-print
files, print settings, and physical fit-test evidence.

## Contribute

People and AI agents use the same workflow: fork, create a branch, make a focused
change, and open a pull request. Read [firmware/README.md](firmware/README.md)
before editing. Run `python tools/check.py` and
`python -m unittest discover -s tests -v`, then build both supported boards.
State which physical board you tested; a successful build is not a hardware test.

Keep the existing USB/Bluetooth/Wi-Fi command grammar compatible with Taby.
New boards need their own configuration, asset pack, and hardware test evidence;
shared device behavior stays shared. See [adding a board](firmware/README.md#add-a-board).
Never contribute factory records, device secrets, private keys, or personal logs.
Contributions use the license applicable to the files being changed; disclose
third-party sources and retain their notices.

## What's in the repository?

- `firmware/`: ESP-IDF source and the two hardware targets.
- `assets/`: the complete runtime animation/icon packs needed to reproduce builds.
- `hardware/`: board-specific cases and other printable physical parts.
- `tools/`: serial setup, installation, builds, integrity checks, and release packaging.
- `tests/`: installation checks that do not touch hardware.

Code is Apache-2.0, with existing third-party licenses preserved. Taby character
artwork has separate terms in [LICENSE](LICENSE): use it in your personal
projects and keep its identity as Taby; do not rebrand the face or animations as
your own different character or product. Third-party credits are in
[firmware/NOTICE](firmware/NOTICE).
