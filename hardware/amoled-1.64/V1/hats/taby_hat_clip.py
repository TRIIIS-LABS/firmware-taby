#!/usr/bin/env python
"""Taby 1.64 hat clip: the part that holds any hat on a Taby. Needs only numpy and manifold3d.

    pip install numpy manifold3d
    python taby_hat_clip.py            # writes clip/taby-hat-clip-base.stl

The clip is a low saddle that drops over the Taby's top edge (case body plus back plate). A rigid lip
sits in front of the glass, two leaf springs press on the back plate, and the flat top is where a hat
goes. Build your own hat with attach(): it joins your shape to the clip and keeps the working space clear.

Coordinates (mm), already in print orientation:
  X  across the Taby, 0 = centre, + toward the USB-C side
  Y  depth, 0 = the glass plane (front of the Taby), + toward the back
  Z  up, 0 = the print bed. On the Taby, Z = CH is level with the top of the back plate.

These numbers are the grip Peter picked from five printed test clips on 2026-11-20 ("number 3").
Change GRIP first if a clip is too loose or too tight on your print; leave the rest alone.
"""
import os
import struct

import numpy as np
import manifold3d as m3
from manifold3d import CrossSection, Manifold, OpType

m3.set_min_circular_angle(5.0)
m3.set_min_circular_edge_length(0.2)

# ---- measured on the printable case (base.stl + back.stl of the amoled-1.64 V1 desktop case)
STACK = 9.03 + 5.00      # case body depth + back plate thickness
PLATE_ROUND = 2.0        # the back plate's top rear edge is rounded with this radius: nothing can grip there
PLATE_PROUD = 0.3        # the back plate's top stands this far above the body's top (0.26 to 0.31 by plate position)

# ---- the clip
CH = 4.0                 # channel depth: the clip covers this much of the Taby's top, front and back
SEAT, SEAT_Y = 0.2, 8.8  # the roof is SEAT lower over the body (Y < SEAT_Y), so the clip rests on body and plate
LIP_GAP = 0.15           # free space between the front lip and the glass
FRONT_T = 2.15           # front lip thickness
BEAM_GAP = 0.45          # free space between the back plate and the spring beams
BEAM_T = 1.4             # spring beam thickness
GRIP = 0.7               # how far the spring bumps bite into the Taby (tested: 0.3 loose ... 1.1 very tight)
FLEX_GAP = max(1.0, GRIP + 0.3)   # room behind the beams for them to bend into
WALL_T = 1.4             # rear wall thickness
BUMP_FOOT = 0.4          # 45 degree lead-in at the bottom of each bump
ROOF_GAP = 0.6           # free space between the spring tops and the roof
ROOF_T = 1.4             # roof thickness over the channel
HALF_W, CORNER_R = 15.3, 6.0      # half width of the clip and its corner radius seen from above

Y_FRONT = -LIP_GAP - FRONT_T
Y_BEAM0 = STACK + BEAM_GAP
Y_BEAM1 = Y_BEAM0 + BEAM_T
Y_WALL0 = Y_BEAM1 + FLEX_GAP
Y_BACK = Y_WALL0 + WALL_T
BUMP = Y_BEAM0 - (STACK - LIP_GAP - GRIP)     # how far each bump sticks out of its beam
TOP_Z = CH + ROOF_T                           # the clip's flat top: hats start here


def box(x0, y0, z0, x1, y1, z1):
    return Manifold.cube((x1 - x0, y1 - y0, z1 - z0)).translate((x0, y0, z0))


def _prism_along_x(poly_yz, x0, x1):
    poly = np.asarray(poly_yz, float)
    area = 0.5 * np.sum(poly[:, 0] * np.roll(poly[:, 1], -1) - np.roll(poly[:, 0], -1) * poly[:, 1])
    if area < 0:
        poly = poly[::-1]
    solid = Manifold.extrude(CrossSection([poly]), x1 - x0)
    return solid.transform(np.array([[0, 0, 1, x0], [1, 0, 0, 0], [0, 1, 0, 0]], float))


def _pillow(cs, z_top, r, foot):
    """cs extruded from the bed to z_top, with a rounded top edge and a small 45 degree foot."""
    parts = []
    for k in range(int(round(foot / 0.2))):
        lo, hi = k * 0.2, (k + 1) * 0.2
        parts.append(Manifold.extrude(cs.offset(-(foot - 0.5 * (lo + hi))), hi - lo).translate((0, 0, lo)))
    z_flat = z_top - r
    parts.append(Manifold.extrude(cs, z_flat - foot).translate((0, 0, foot)))
    step = 0.1
    for k in range(int(round(r / step))):
        lo, hi = z_flat + k * step, z_flat + (k + 1) * step
        t = (0.5 * (lo + hi) - z_flat) / r
        c = cs.offset(-r * (1 - np.sqrt(max(0.0, 1 - t * t))))
        if c.is_empty():
            break
        parts.append(Manifold.extrude(c, hi - lo).translate((0, 0, lo)))
    return Manifold.batch_boolean(parts, OpType.Add)


def channel():
    """The space the Taby's top edge goes into."""
    return (box(-60, -LIP_GAP, -1, 60, SEAT_Y, CH - SEAT)
            + box(-60, SEAT_Y - 0.01, -1, 60, Y_WALL0, CH))


def keep_out():
    """Everything a hat must stay out of: the channel, the springs' space, and all of it below the bed."""
    return channel() + box(-200, -200, -200, 200, 200, 0)


def _spring(root_x0, root_x1, beam_x0, beam_x1, bump_x0, bump_x1):
    top = CH - ROOF_GAP
    root = box(root_x0, Y_BEAM0, 0, root_x1, Y_WALL0 + 0.3, CH + 0.3)
    beam = box(beam_x0, Y_BEAM0, 0, beam_x1, Y_BEAM1, top)
    # square almost down to the bed, so the bump presses on the flat part of the plate's back face
    bump = _prism_along_x([(Y_BEAM0 + 0.05, 0), (Y_BEAM0 - BUMP + BUMP_FOOT, 0), (Y_BEAM0 - BUMP, BUMP_FOOT),
                           (Y_BEAM0 - BUMP, top), (Y_BEAM0 + 0.05, top)], bump_x0, bump_x1)
    return root + beam + bump


def springs():
    return (_spring(-HALF_W + 0.2, -HALF_W + 2.2, -HALF_W + 2.1, -0.7, -3.5, -0.7)
            + _spring(HALF_W - 2.2, HALF_W - 0.2, 0.5, HALF_W - 2.1, 0.5, 3.3))


def _clean(solid):
    return Manifold.compose([p for p in solid.decompose() if abs(p.volume()) > 1e-3])


def plan(grow=0.0):
    """The clip's outline seen from above (a rounded rectangle), grown outward by `grow` mm.
    A hat whose base is plan(1.0) or wider, from the bed up past TOP_Z, hides the whole clip."""
    base = (CrossSection.square((2 * HALF_W, Y_BACK - Y_FRONT)).translate((-HALF_W, Y_FRONT))
            .offset(-CORNER_R).offset(CORNER_R))
    return base.offset(grow) if grow else base


def clip():
    """The bare clip: 30.6 mm wide, about 20.6 mm deep, TOP_Z tall, flat on top."""
    return _clean(_pillow(plan(), TOP_Z, 1.0, 0.4) - channel() + springs())


def attach(hat):
    """Join your hat (a Manifold in the coordinates above) to the clip.

    Your shape may sit on the top (start it a little below TOP_Z so the two fuse) and may wrap around
    the clip down to the bed. Whatever reaches into the channel or below the bed is cut away, so the
    clip always still fits and the springs stay free."""
    return _clean(clip() + (hat - keep_out()))


def write_stl(path, solid):
    mesh = solid.to_mesh()
    v = np.asarray(mesh.vert_properties, np.float32)[:, :3]
    f = np.asarray(mesh.tri_verts, np.uint32)
    tri = v[f]
    n = np.cross(tri[:, 1] - tri[:, 0], tri[:, 2] - tri[:, 0])
    ln = np.linalg.norm(n, axis=1)
    n[ln > 0] /= ln[ln > 0][:, None]
    rec = np.zeros(len(f), dtype=[("n", "<f4", 3), ("v", "<f4", (3, 3)), ("a", "<u2")])
    rec["n"], rec["v"] = n, tri
    with open(path, "wb") as fh:
        fh.write(b"Taby hat clip".ljust(80, b" "))
        fh.write(struct.pack("<I", len(f)))
        fh.write(rec.tobytes())


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    base = clip()
    b = base.bounding_box()
    print(f"clip: {b[3] - b[0]:.1f} x {b[4] - b[1]:.1f} x {b[5] - b[2]:.1f} mm, one piece: {len(base.decompose()) == 1}, "
          f"slot for a {STACK:.2f} mm Taby is {STACK - GRIP:.2f} mm at the bumps, top at Z {TOP_Z:.1f}")
    os.makedirs(os.path.join(here, "clip"), exist_ok=True)
    write_stl(os.path.join(here, "clip", "taby-hat-clip-base.stl"), base)
    print("wrote taby-hat-clip-base.stl (simple_hats.py shows how nine hats are built on it)")
