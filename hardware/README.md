# Print your Taby

| Taby | Print files | Compatibility |
| --- | --- | --- |
| **1.64-inch rectangle** | [Download everything](https://github.com/TRIIIS-LABS/firmware-taby/releases/download/prints-1.64-1.0.0/taby-1.64-print-pack-1.0.0.zip) · [Browse files](amoled-1.64/V1/desktop-case) | Supplied for Taby 1.64; filed under the current V1 target. V2 fit has not been established. |
| **Round 1.32-inch** | Coming soon | Requires its own case. |

![The three supplied case parts](amoled-1.64/V1/desktop-case/preview.png)

## Choose your files

- **STL:** [base](amoled-1.64/V1/desktop-case/base.stl),
  [back](amoled-1.64/V1/desktop-case/back.stl), and
  [handle](amoled-1.64/V1/desktop-case/handle.stl). Import these into your slicer
  in millimetres and select your printer, material, orientation, and supports.
- **3MF:** [complete project](amoled-1.64/V1/desktop-case/case.3mf), including
  part placement and a subtractive cylinder modifier. The saved profile is
  **Bambu Lab A1 mini, 0.4 mm nozzle, PLA, 25% infill**. Nominal layer height is
  0.2 mm and manual tree supports are enabled. Check the sliced preview; STL
  files do not carry the project's modifiers or support settings.
- **G-code:** [all parts](amoled-1.64/V1/desktop-case/gcode/bambu-p1s-0.4/all-parts.gcode)
  or [individual parts](amoled-1.64/V1/desktop-case/gcode/bambu-p1s-0.4).
  These are sliced for **Bambu Lab P1S, 0.4 mm nozzle, PLA, 15% infill**, with
  variable layer heights and manual tree supports enabled. The combined file
  estimates about 59 minutes. Use these only with the matching printer setup;
  for an A1 mini or another printer, slice the 3MF/STLs with that printer's profile.

The G-code and 3MF have different saved profiles. These settings describe the
supplied files, not a newly validated print recommendation. No print job is
started by installing the firmware or downloading this pack.

The original eight print files are preserved byte-for-byte, with clearer file
names. macOS `__MACOSX` metadata is omitted. The preview is extracted from the
3MF. [Print metadata](amoled-1.64/V1/desktop-case/print.json) records the original
names, checksums, and printer profiles. Native parametric CAD/STEP and assembly
instructions were not supplied. A physical fit-test record, including exact PCB
revision and any additional hardware needed, is still to be added.

## For agents and contributors

Read [`catalog.json`](catalog.json) to select the matching board/revision, then
the model's `print.json` for its files and printer profiles. `availability`
describes whether files exist; `status` describes validation. The 1.64 model is
available with `prototype` status; the round model is coming soon. Do not infer
physical fit from the installed firmware target, a render, or screen size alone.

Future cases, stands, mounts, and other parts go under
`hardware/BOARD/REVISION/PART/`. Include editable design files when available,
printable meshes, a preview, print settings, assembly notes, required hardware,
and physical fit evidence. Mark a design `verified` only after recording its
physical fit test. Use another entry for a different PCB revision instead of
silently sharing a design whose fit has not been established.

Original mechanical designs use the root [Apache-2.0 license](../LICENSE).
Taby artwork and identity keep their separate terms. Include the source and
license for third-party designs and retain their notices.
