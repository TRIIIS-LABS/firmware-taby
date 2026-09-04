# Firmware and device commands

This is the working ESP-IDF firmware extracted from Hey Taby for public
development. Start at [INSTALL.md](../INSTALL.md) to install a prebuilt release.

## Build from source

Install **ESP-IDF v5.4.2** using
[Espressif's setup guide](https://docs.espressif.com/projects/esp-idf/en/v5.4.2/esp32s3/get-started/index.html).
Use the installer on Windows or Espressif's install/export scripts on macOS/Linux.
Open the configured ESP-IDF terminal. Its Python/toolchain environment is
separate from the small `.venv` used for prebuilt installation.

From the repository root:

```sh
python tools/check.py
python -m unittest discover -s tests -v
python tools/build.py amoled-1.64
python tools/build.py round-1.32
```

Each board gets its own `firmware/build-BOARD` and `firmware/sdkconfig.BOARD`.
No Node, app repository, private service, factory registry, or editing software
is required. The asset packs are already present; ESP-IDF makes their SPIFFS images.
Dependencies are pinned in `main/idf_component.yml` and `dependencies.lock`.
The SDK fetches managed components during configuration; they are not vendored.

After a successful build, make a complete install bundle:

```sh
python tools/package_release.py amoled-1.64
python tools/package_release.py round-1.32
```

This writes `dist/taby-BOARD.zip`, its checksum, and an extracted bundle directory.
Packaging refuses to overwrite an existing bundle directory; choose a fresh
`--output` directory for another run. Use [INSTALL.md](../INSTALL.md) to inspect,
flash, and verify it. Source builds are development builds until tested and
released; do not call them an official downloaded release.

The GitHub build workflow builds both boards and attaches installation bundles
to successful runs. Maintainers publish tested bundles together in a GitHub
Release, with release notes stating the exact boards/revisions tested. CI never
publishes automatically and never connects to a physical device.

## Talk to Taby

USB uses newline-terminated UTF-8 commands at 115200 baud. Open only the chosen
port, keep DTR/RTS deasserted for normal control, and close it afterward. Do not
run another client while the Taby app owns the device. Responses can arrive in
chunks alongside logs: assemble complete lines and match the expected `TABY:`
prefix, with a bounded timeout. `tools/device.py` shows a working Python example.

| Send (followed by newline) | Response / behavior |
| --- | --- |
| `PING` | `TABY:PONG` |
| `INFO` | `TABY:INFO { ... }`, including `hardware_target`, `firmware_version`, `assets_version` |
| `confirmation` | Play that animation; `TABY:OK ...` on acceptance |
| `UI/title_subtitle?demo:HELLO\|FROM MY PROJECT` | Show a text card |
| `UI/choice_2?demo:TAKE A BREAK?\|YES\|LATER` | Show a two-choice prompt |
| `CHOICE_SIGNAL` | `TABY:CHOICE_SIGNAL {"signal":N,"selection":"..."}` |
| `UI/timer?demo:FOCUS\|60\|60\|\|run\|0` | Show a running timer |
| `CLEAR` | Clear the active presentation |

The backslashes before table pipes are Markdown escaping only; commands contain
literal `|` separators, never `\|`. For example:

```text
UI/title_subtitle?demo:HELLO|FROM MY PROJECT
```

Animation IDs are listed in `assets/BOARD/manifest.json`. Round and rectangle
packs differ; inspect the selected pack before choosing an ID. `TABY:OK` means
the protocol accepted the command, not that a person verified the image.
Unsupported commands return `TABY:ERR ...`. Keep control strings in English;
display text can differ, subject to the fonts' supported glyphs. Avoid protocol
delimiters/newlines in user-provided text and keep labels short.

Read the initial choice signal before displaying a new prompt, then handle a
changed signal once. The wire protocol has no application-level session or
prompt identifier in its choice result: the controlling client owns correlation,
supersession, timeouts, and deduplication. Device input is not blanket approval
to perform unrelated actions in a host application.

`INFO` in this inherited firmware also contains network/setup fields. The public
helper prints only an allowlisted version/hardware summary; do not publish raw
INFO/DIAG output, Wi-Fi credentials, or personal device logs in issues.

### Bluetooth and local Wi-Fi

Select Bluetooth on the device to use its BLE GATT service:
`54414259-0000-4000-a000-000000000001`. Write a short UTF-8 animation or `UI/...`
command as one characteristic value (without the USB newline) to the
characteristic ending in `0002`; subscribe to events on `0003` before writing.
`0004` is readable state, and `0005` is readable power information. The firmware
supports one controller at a time and does not use BLE bonding. BLE event payloads
use their own `READY`/`OK`/`ERR` messages rather than USB's `TABY:` prefix.
For payload details and limits, see `main/taby_ble_transport.c`.

After explicitly setting up Wi-Fi on the device, local HTTP supports `GET /ping`,
`GET /state`, `GET /touch`, `GET /v1/reusable/choice-signal`, and
`GET /cmd?c=confirmation` on the device's local IP. URL-encode the command value
when using a `UI/...` command. These inherited local endpoints have no request
authentication; use them only on a trusted local network, never by exposing the
device to the Internet. See `main/taby_http_server.c` for the implementation.
USB remains the firmware-install route for both boards.

Custom integrations, including MCP servers, are maintained by their authors.
The supported first-party integration is in the Taby app.

## Add a board

1. Add a board entry to `boards.json`, with an explicit model/revision and flash size.
2. Add isolated defaults and partitions under `targets/BOARD/` and wire the target
   into `CMakeLists.txt`. Add hardware initialization through the board adapter;
   do not change existing boards' pins to accommodate a new one.
3. Add an `assets/BOARD/` pack suited to its resolution and flash capacity, and
   select it in `main/CMakeLists.txt`. Keep semantic animation IDs compatible.
4. Extend the build matrix in `.github/workflows/build.yml` and installation
   validation if the new chip/layout differs from the current ESP32-S3 contract.
5. Verify a fresh build, USB install/recovery, display, touch, and app commands on
   real hardware. Record results in the PR before adding it to supported displays.

Do not infer board support from screen size or the ESP32 chip alone. Waveshare
1.64 V2 needs its own reviewed pin mapping and hardware tests.

## Assets and contributions

`assets/BOARD/a/` contains the runtime GIF artwork; `icons/` contains Lucide-derived
4-bit alpha icons. These checked-in packs are build inputs, not disposable build
outputs. They are sufficient to reproduce the current firmware; private editing
projects and app-only media are not needed.

When replacing an animation, update its catalog byte length and SHA-256, then
the catalog's byte length/SHA-256 in the runtime manifest. Keep JSON line endings
LF: the hashes cover exact bytes. A new semantic animation may also require
metadata in `main/taby_animation_assets.c`. Keep the runtime manifest below 16 KiB
and verify the actual SPIFFS build fits the board's partition.

## Extraction record

- Source: Hey Taby commit `6104c35aaf43f95021af9de14325e24221b5b965`.
- Firmware reports `1.0.8`; the rectangle pack is `0.3.3`, and round is
  `0.1.0-prototype`. These inherited identifiers do not imply a new public release.
- Maintainer reports both hardware implementations working. Public extraction
  validation is recorded below; no hardware flashing is part of automated checks.
- Firmware runtime C/H files are preserved. Build paths now point to the public
  packs, and component constraints match the inherited dependency lock.
- Excluded: factory data/registries/binaries, credentials, old app/runtime code,
  MQTT provisioning tools, private release tooling, and editing-project archives.
- Existing large C modules remain during extraction. New code should stay small
  by responsibility; refactor runtime modules separately with hardware evidence.
- USB is the install path. The active layout has one application slot; the unused
  recovery-layout proposal is not included and rollback-safe Wi-Fi OTA is not claimed.

### Validation checkpoint

2026-09-04, Windows, Python 3.12, ESP-IDF v5.4.2:

- Both targets built successfully from this extracted source, including their
  SPIFFS asset images. Application metadata and device-reported firmware are 1.0.8.
- Both complete installation bundles were generated and passed the installer's
  offline board/offset/size/checksum validation.
- All 84 rectangle and 27 round animations passed catalog/hash checks; all
  referenced reusable icons and both partition layouts passed validation.
- Eleven installer/serial tests passed. The serial tests use fake ports and
  cover partial replies and filtering of private INFO fields.
- A separate read-only USB INFO check succeeded against the connected device,
  which reported existing firmware 1.0.6 and assets 0.3.2. It was not reset or flashed.
- All 47 imported runtime C/H files remain byte-for-byte identical to the source.
  Existing unused-function compiler warnings remain; the build has no errors.
- These new 1.0.8 bundles have not been flashed during extraction. Visual/touch
  verification and publication of the first public release remain maintainer steps.
