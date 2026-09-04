# Cases and printable parts

Physical parts are selected by **board and hardware revision**, just like the
firmware. Do not scale a model made for another display: the screen opening,
PCB outline, USB connector, buttons, antenna clearance, mounting points, and
available battery space may differ.

[`catalog.json`](catalog.json) is the source an installer or coding agent should
read first. It currently records both supported firmware targets as `planned`
because no case has completed a physical fit test yet.

When a model is published, its catalog entry will point to a folder like:

```text
hardware/
  amoled-1.64/
    V1/
      desktop-case/
        source.step
        body.stl
        print.3mf
        print.json
```

- `source.step` is the editable neutral CAD source.
- STL files contain individual ready-to-slice parts.
- `print.3mf` may contain the tested orientation and slicer setup.
- `print.json` records material, nozzle, layer height, supports, hardware,
  model version, and the exact board/revision used for the fit test.

Other parts such as stands, wall mounts, battery backs, and cable guides use a
separate folder and catalog model entry under the same board/revision.

## Contribute a model

Add a model only under the board and revision it physically fits. Include the
editable CAD source, exported mesh files, print metadata, a rendered preview,
and photos or a pull-request note confirming a real fit test. List any screws,
inserts, magnets, battery, cable, adhesive, or other non-printed parts.

Do not mark a model `verified` from dimensions or a render alone. If a design is
adapted from another project, include its source link and license. Unless a
model folder says otherwise, original CAD and mesh contributions use the
repository's Apache-2.0 terms; Taby artwork and identity keep the separate terms
in the root [LICENSE](../LICENSE).
