<a id="start-here"></a>

<p align="center">
  <a href="https://www.heytaby.com"><img src=".github/taby.svg" width="88" alt="Taby's smiling face"></a>
</p>

<h1 align="center">Physical Taby</h1>
<p align="center"><strong>A tiny companion for your desk. Made by you.</strong></p>
<p align="center">
  <a href="https://www.heytaby.com">Meet Taby</a> &nbsp;·&nbsp;
  <a href="https://www.heytaby.com/setup">Get the desktop app</a> &nbsp;·&nbsp;
  <a href="#bring-taby-to-life">Install firmware</a> &nbsp;·&nbsp;
  <a href="https://github.com/TRIIIS-LABS/firmware-taby/releases/download/prints-1.64-1.0.0/taby-1.64-print-pack-1.0.0.zip">Download 3D print files</a>
</p>

<br>

**Hello, little desk buddy.** Taby brings a friendly face to your setup. The
[Taby desktop app](https://www.heytaby.com/setup) is where chat, tasks, habits,
and focus timers live; the little screen gives your companion a place on your desk.

This is the DIY home for Physical Taby: **firmware, animations, and printable
cases**. Bring a supported Waveshare screen and a USB data cable. Add a case
if you'd like, then make it your own.

<a id="supported-displays"></a>

## Pick your little screen

<table>
<tr>
<td width="50%" valign="top">
<h3>Taby 1.64</h3>
<p>The rectangular one.<br>280 × 456 AMOLED · 84 animations</p>
<p><strong>Waveshare ESP32-S3-Touch-AMOLED-1.64, V1</strong></p>
<p><a href="https://www.waveshare.com/product/esp32-s3-touch-amoled-1.64.htm">Get the board ↗</a> &nbsp;·&nbsp; <a href="#a-home-for-your-taby">Print its case</a></p>
</td>
<td width="50%" valign="top">
<h3>Taby Round 1.32</h3>
<p>The round little one.<br>466 × 466 AMOLED · 27 animations</p>
<p><strong>Waveshare ESP32-S3-Touch-AMOLED-1.32</strong></p>
<p><a href="https://www.waveshare.com/product/esp32-s3-touch-amoled-1.32.htm">Get the board ↗</a> &nbsp;·&nbsp; Case coming soon</p>
</td>
</tr>
</table>

**Buying the 1.64? Choose V1.** The newer V2 needs different firmware and isn't
supported yet. [How to tell them apart](https://docs.waveshare.com/ESP32-S3-Touch-AMOLED-1.64).
Already have a board? The install guide reads it first and helps identify it.
<!-- Replace store links with affiliate URLs and disclose the commission when available. -->

<a id="print-a-case"></a>
<a id="3d-print-your-case"></a>

## A home for your Taby

<img align="right" src="hardware/amoled-1.64/V1/desktop-case/preview.png" width="190" alt="The printable base, back, and handle for Taby 1.64">

A little case, printed in your favorite color. The **1.64-inch print pack**
includes the base, back, and handle, ready to open in your slicer.

**[↓ Download the complete print pack](https://github.com/TRIIIS-LABS/firmware-taby/releases/download/prints-1.64-1.0.0/taby-1.64-print-pack-1.0.0.zip)**

STL parts · 3MF project · individual and all-parts G-code

[Printing guide](hardware/README.md) · [Browse individual files](hardware/amoled-1.64/V1/desktop-case)

**Round 1.32 case: coming soon.**

The G-code is for a **Bambu P1S, 0.4 mm nozzle**. The 3MF selects an A1 mini
profile; choose your actual printer before slicing. V2 case fit isn't established.

<br clear="right">

<a id="install-with-your-ai-agent"></a>

## Bring Taby to life

Connect your screen with a **USB data cable**. Copy this into an AI agent that
can run commands on your computer:

```text
Help me install Physical Taby on my connected device.
Read and follow this guide:
https://github.com/TRIIIS-LABS/firmware-taby/blob/main/INSTALL.md

Install any missing USB/ESP32 tools, read the device to identify its board,
ask me only if its revision remains uncertain, and install the matching
release. Verify it and play an animation so I can check the screen.
Then help me connect it to the Taby desktop app.
```

Prefer doing it yourself? **[Follow the installation guide →](INSTALL.md)**

The guide covers setup, USB drivers, board selection, flashing, and recovery.
Current firmware: **[1.0.8](https://github.com/TRIIIS-LABS/firmware-taby/releases/tag/v1.0.8)**.
Both supported boards have been tested by the maintainer; each has its own bundle.

## Better together

Use Physical Taby with the **[Taby desktop app](https://www.heytaby.com/setup)**
for the maintained companion integration. Visit **[heytaby.com](https://www.heytaby.com)**
to meet Taby, explore the software, and see it on people's desks.

Building your own project? You're welcome to control the device yourself.
The [device commands](firmware/README.md#talk-to-taby) explain animations,
text cards, choices, and connections. Community integrations are maintained
by their authors. App connection details and current MCP availability are in
[the install guide](INSTALL.md#5-use-it-with-taby).

## Make something lovely

New animations, cases, supported boards, and thoughtful fixes are welcome.
Humans and AI agents contribute through the same pull-request workflow.

[Work on firmware](firmware/README.md) · [Contribute a print](hardware/README.md#for-agents-and-contributors) · [Add a board](firmware/README.md#add-a-board)

<details>
<summary><strong>Contributor notes & repository map</strong></summary>

Fork, create a branch, make a focused change, and open a pull request. Read the
firmware guide before editing. For firmware or tooling changes, run
`python tools/check.py` and `python -m unittest discover -s tests -v`, then build
both supported boards. State which physical board you tested; a build alone
is not a hardware test.

Keep existing USB/Bluetooth/Wi-Fi commands compatible. New boards need their
own configuration, asset pack, and physical test evidence. Keep shared behavior
shared, preserve third-party credits, and never contribute device secrets,
factory records, private keys, or personal logs.

- `firmware/` — ESP-IDF source and board configurations.
- `assets/` — animation and icon packs used by the firmware.
- `hardware/` — printable cases and other physical parts.
- `tools/` — USB setup, installation, builds, and integrity checks.
- `tests/` — checks that don't touch physical hardware.

</details>

<br>

Code and original mechanical designs are **Apache-2.0**. Taby artwork has its
own [license terms](LICENSE): use it in your personal projects and keep it Taby;
don't rebrand the face or animations as your own different character or product.
[Third-party credits](firmware/NOTICE).

<p align="center">A little more personality on your desk. <a href="https://www.heytaby.com">Hey Taby ↗</a></p>
