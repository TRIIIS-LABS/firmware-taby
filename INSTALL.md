# Install Physical Taby

For humans and AI agents. Follow these steps on the computer connected to the
board. An agent needs local terminal/USB access; a cloud-only session cannot
flash a board attached to another computer. Install released firmware without
editing source. Use USB-C for installation; Bluetooth and Wi-Fi are device
control options, not firmware-update paths here.

## 1. Connect the device; read it before asking about the board

Read the [supported displays](README.md#supported-displays). First install the
serial tools in step 2 and query the connected device. Do not require the user
to know the model/revision before this read-only discovery.

| Board argument | Exact hardware | Flash |
| --- | --- | --- |
| `amoled-1.64` | Waveshare ESP32-S3-Touch-AMOLED-1.64 **V1** | 16 MB |
| `round-1.32` | Waveshare ESP32-S3-Touch-AMOLED-1.32 | 8 MB |

**An ESP32-S3 chip ID or USB VID/PID cannot identify the display or PCB revision.**
The 1.64 V2 is unsupported. Do not use a 1.64 image on the round board or patch
pins during an ordinary installation. See the discovery rules below when a
device cannot report a supported target.

Connect a known **data-capable** USB cable directly to the computer. Close Taby,
serial monitors, and other applications using the port for the installation.
Do not close unrelated applications. An interrupted flash may require USB
bootloader recovery; avoid unplugging during writes.

## 2. Install the ESP32 communication tools

Get this repository from GitHub (clone it or download and extract its source ZIP).
Run all commands below from its root. Use Python **3.11 or newer**; Python 3.12
is the recommended version when also building firmware from source.

If Python is missing, install it from [python.org](https://www.python.org/downloads/)
or the operating system's trusted package manager. On Windows, reopen the
terminal after installation; use `py -3.12` when `python` opens the Store.
If another supported Python is already installed, use its executable instead
of installing a second copy just to match the example command.
On Linux, the distribution may also require its `python3-venv` package.

**Windows (PowerShell):**

```powershell
py -3.12 tools/bootstrap.py
.\.venv\Scripts\python.exe tools/device.py ports
```

**macOS / Linux:**

```sh
python3 tools/bootstrap.py
.venv/bin/python tools/device.py ports
```

`bootstrap.py` installs **esptool 4.11.0** (ESP32 flashing) and **pyserial 3.5**
(serial communication) into this repository's `.venv`, then checks esptool.
These are required even when an agent already has ordinary terminal access.
Do not use an unrelated Python environment for the remaining commands.
An Arduino IDE or complete ESP-IDF installation is not required for prebuilt bundles.

In subsequent commands, `PYTHON` means `.\.venv\Scripts\python.exe` on Windows
or `.venv/bin/python` on macOS/Linux. Replace that word with the actual executable;
it is a placeholder, not a command to install.

### Read the connected device and select its target

Select the connected port from `ports`, then run:

```text
PYTHON tools/device.py identify --port PORT
```

This sends the read-only `INFO` command without intentionally resetting the
device. It filters private fields and compares the reported target and display
dimensions with `firmware/boards.json`.

- **`firmware_target`:** use the returned `board` and `revision` for an update
  when the existing display works correctly. Do not ask the user to read a PCB
  marking again if this working target is already established. `amoled-1.64`
  currently maps to V1; `round-1.32` maps to the original round board.
- **`unknown` or no Taby reply:** older firmware (including the tested 1.0.6
  build), blank boards, and vendor demos may not report a target. Ask for the
  board marking, order details that specify the revision, or a clear PCB photo.
- **`unsupported` or `conflict`:** explain the reported mismatch. Do not select
  another bundle just because its screen size or flash capacity looks similar.

The target is compiled into the running firmware; it is **not** an independently
measured PCB revision. Wrong firmware can report the wrong target even with a
blank screen. Firmware versions, asset versions, flash capacity, and ESP32 chip
revision are not proof of the Waveshare PCB revision. A later update can reuse a
target whose display was already tested successfully.

For 1.64 V1/V2, Waveshare documents identification by PCB marking and different
LCD chip-select wiring, not a USB-readable revision ID. Use the
[manufacturer's illustrated revision guide](https://docs.waveshare.com/ESP32-S3-Touch-AMOLED-1.64)
when discovery is inconclusive. Do not trial-flash multiple board images as an
automatic detection method. If the owner explicitly authorizes a development
test with a provisional board selection, record that uncertainty and require
display validation afterward; do not describe it as automatic detection.

### If the board does not appear: USB drivers and permissions

Installing Python libraries does **not** install an operating-system USB driver.
These two boards use the ESP32-S3's **native USB Serial/JTAG** connection.

- **Windows:** check Device Manager under Ports and USB devices. Native USB
  normally appears as a USB Serial Device (`COM...`) using Windows' CDC driver.
  If it is missing or has a warning, inspect its hardware ID, check Windows
  Update for drivers, and follow [Espressif's serial setup instructions](https://docs.espressif.com/projects/esp-idf/en/v5.4.2/esp32s3/get-started/establish-serial-connection.html).
  Use Espressif's official driver/setup distribution if that identified
  interface requires it. Do not replace the serial interface with a WinUSB/Zadig
  driver: JTAG debugging and the serial COM interface are different functions.
- **macOS:** look for `/dev/cu.usbmodem...`; native USB uses the built-in CDC
  driver. Check accessory connection permission if macOS asks to allow the device.
- **Linux:** look for `/dev/ttyACM...`. Inspect the port's owner/group. If access
  is denied, add the user to the actual serial-access group (commonly `dialout`
  or `uucp`) using the distribution's instructions, then log out/in. Do not use
  world-writable device permissions or run the whole agent as root.
- **An actual external USB-UART bridge:** identify the chip first. Only then
  install the vendor's matching [CP210x](https://www.silabs.com/developer-tools/usb-to-uart-bridge-vcp-drivers),
  [FTDI](https://ftdichip.com/drivers/vcp-drivers/), or [WCH](https://www.wch-ic.com/downloads/category/30.html)
  driver. Those are not generic ESP32 drivers and are not the default for these boards.

First try a known data cable and another direct USB port; a lit display does not
prove the cable carries data. Compare the port list unplugged and plugged in.
Ask the user to approve an OS administrator prompt if driver/group installation
requires it. Continue only after the selected port is accessible.

See [Espressif's native USB explanation](https://docs.espressif.com/projects/esp-idf/en/v5.4.2/esp32s3/api-guides/usb-serial-jtag-console.html).

## 3. Download the matching release

Use a published release from
[TRIIIS-LABS/firmware-taby](https://github.com/TRIIIS-LABS/firmware-taby/releases).
Download `taby-amoled-1.64.zip` or `taby-round-1.32.zip` and its `.sha256` file
from the **same release**. Follow any release-specific compatibility notes.
Verify the ZIP's SHA-256 against that file, then extract it to a local directory.
Checksums detect corruption; obtain both files from the official release, not an
untrusted mirror. Do not execute scripts from inside a downloaded firmware ZIP.

For an unpublished repository with no release, explain that prebuilt installation
is not available yet. Build the selected board using
[the source instructions](firmware/README.md#build-from-source) if the user wants
to proceed. Do not invent download URLs, versions, offsets, or successful installs.

The extracted bundle contains `manifest.json`, firmware, bootloader, partition
table, OTA-selection data, and the animation filesystem image. There is no
factory identity or Wi-Fi configuration in a public bundle.

## 4. Inspect, install, and verify

Replace `BOARD`, `BUNDLE_DIRECTORY`, and `PORT` with the identified values:

```text
PYTHON tools/install.py inspect --board BOARD --bundle BUNDLE_DIRECTORY
PYTHON tools/device.py identify --port PORT
```

`inspect` opens no serial port. It checks the board, revision, every binary's
size/hash, and permitted flash offsets. `identify` reads a running Taby without
intentionally resetting it. A blank/vendor board may not answer `INFO`.
If it does answer, check that its hardware target agrees with the selected board.

Explain the selected board and version. The user's installation request and
established board target identify the intended target; do not repeatedly ask for the
same permission. Then run:

```text
PYTHON tools/install.py flash --board BOARD --bundle BUNDLE_DIRECTORY --port PORT --confirmed-board
```

The installer first checks the ESP32-S3 and flash capacity through esptool. It
writes only the five reviewed image regions, preserving the NVS settings and
factory identity regions. On a board previously running unrelated firmware,
existing partition layouts/data may be incompatible; do not promise those
applications or their data will be preserved. Do not erase the whole chip as a
routine workaround. No `--force`, eFuse change, or security-setting change is needed.

After flashing, the installer requires the running device's hardware target,
firmware version, and asset version to match the bundle. If USB changes port,
list ports again and use the new port for verification:

```text
PYTHON tools/device.py ports
PYTHON tools/install.py verify --board BOARD --bundle BUNDLE_DIRECTORY --port PORT
PYTHON tools/device.py animation --port PORT --id confirmation
```

Ask the user whether the animation looks correct. Protocol acceptance is not
proof that the screen, touch, and artwork are visually correct. Report any
unverified step clearly; do not report success from esptool's exit alone.
For additional animation tests, choose IDs actually listed in
`assets/BOARD/manifest.json` and repeat the `animation` command. This tests the
documented USB control path. It is not an MCP test: report MCP success only after
calling a tool on the Taby app's maintained MCP interface and checking its result.

### If esptool cannot connect or the device stays in download mode

- If the native USB serial port remains accessible but Taby does not answer,
  try `PYTHON tools/device.py reset --port PORT`. This requests a normal USB
  reset without writing flash. Wait a few seconds, list ports, and run `verify`.
  If software reset fails, use the board's buttons below.
- **1.64 V1:** hold BOOT, press/release RESET, then release BOOT.
- **Round 1.32:** hold BOOT while powering the board on again, then release BOOT.
  Follow [Waveshare's board guide](https://docs.waveshare.com/ESP32-S3-Touch-AMOLED-1.32).
- List ports again; bootloader and running firmware can enumerate differently.
- Retry using the identified bootloader port. If flashing succeeds but Taby does
  not start, release BOOT and reset/power-cycle normally, then run `verify`.
- If a port is busy, close only the application holding that port. If no port
  appears even in bootloader mode, return to cable/driver checks.

## 5. Use it with Taby

Complete the device's on-screen setup and select USB for the first connection.
Close the installation tools, reopen the Taby app, and enable physical output
in its companion settings. The app owns the USB connection while it is running.
Exact settings labels depend on the app version. This repository installs device
firmware, not the desktop application, and does not create an account or claim a device.

For a custom project, use the [documented device commands](firmware/README.md#talk-to-taby).
An MCP server is not needed to install firmware. We maintain the app integration;
authors maintain their own MCP servers and other clients.

### Verify the app's MCP integration separately

Use MCP tool discovery on the installed app connection first. App versions with
**Settings -> Integrations -> Local API & MCP** expose `taby_list_animations` and
`taby_play_animation` when the connection has the required permissions. Grant
**Use physical Taby** (`device.physical.write`) through the app, then invoke
`taby_play_animation` with an ID returned by its catalog, for example:

```json
{
  "animationId": "confirmation",
  "targets": ["physical"],
  "durationSeconds": 4,
  "requestId": "physical-install-confirmation"
}
```

Check the returned physical delivery result and the actual display. Keep tokens
private and use the app-generated connection settings. If these settings/tools
are absent, report the app handoff as unavailable; do not invent an endpoint or
create a replacement MCP server as part of firmware installation. As checked on
2026-09-05, the TRIIIS-LABS/app-taby V4 development app does not expose this MCP
server yet; the earlier Hey Taby app implements it. Firmware installation and
direct USB animation checks still work independently of that app feature.
