#!/usr/bin/env python
"""Nine simple hats for the Taby 1.64, all built on the same clip (taby_hat_clip.py).

    pip install numpy manifold3d
    python simple_hats.py              # rebuilds every hat's STL files next to this script
    python simple_hats.py beanie       # only the named hats

Every hat follows the same three rules, which is what makes them easy to print:
  1. It stands on the clip and only gets narrower (or leans a little) on the way up,
     so nothing outside needs support. Only the roof inside the clip does.
  2. Its colours are level bands stacked by height. A layer is never two colours, so a whole
     plate needs one filament swap per band, however many hats are on it. A band never starts
     exactly on a flat face of the shape (it starts 0.1 mm above), or a film of the next colour
     would be left lying on that face.
  3. Its base is wider than the clip from the bed up past the clip's top, so the clip is hidden.

To add a hat: write a function that returns (solid, [band heights], [colour names]) and add it
to HATS. Coordinates are those of taby_hat_clip.py: X across, Y depth (0 = glass), Z up (0 = bed).
"""
import os
import sys

import numpy as np
from manifold3d import CrossSection, Manifold, OpType

import taby_hat_clip as K

HERE = os.path.dirname(os.path.abspath(__file__))
CY = (K.Y_FRONT + K.Y_BACK) / 2          # middle of the clip, front to back
EPS = 0.002

COLOURS = {"white": "#FBFAF6", "blue": "#3B82F6", "yellow": "#F4B731", "pink": "#EF4F8B", "black": "#33363F",
           "red": "#D7263D", "orange": "#F2711C", "gold": "#F4B731", "ginger": "#E8873A", "green": "#8FB38A",
           "teal": "#35C7A0"}


# ------------------------------------------------------------------ building blocks
def oval(a, b):
    """Ellipse seen from above, half width a, half depth b, centred over the clip."""
    return CrossSection.circle(1.0, 128).scale((a, b)).translate((0, CY))


def rounded_rect(a, b, r):
    """Rounded rectangle seen from above, half width a, half depth b, centred over the clip."""
    return CrossSection.square((2 * a, 2 * b)).translate((-a, CY - b)).offset(-r).offset(r)


def loft(sections):
    """Smooth solid through a stack of (height, outline) pairs. Every outline must be convex."""
    parts = []
    for (z0, c0), (z1, c1) in zip(sections[:-1], sections[1:]):
        lo = Manifold.extrude(c0, EPS).translate((0, 0, z0))
        hi = Manifold.extrude(c1, EPS).translate((0, 0, z1 - EPS))
        parts.append(Manifold.batch_hull([lo, hi]))
    return Manifold.batch_boolean(parts, OpType.Add)


def rounded_top(outline, z_flat, z_top, steps=8):
    """Sections that round an outline's top edge over the height from z_flat to z_top."""
    r = z_top - z_flat
    out = []
    for t in np.linspace(0, np.pi / 2, steps + 1)[1:]:
        out.append((z_flat + r * np.sin(t), outline.offset(-r * (1 - np.cos(t)))))
    return out


def band(grow, height, r=1.8, foot=0.6):
    """A ring around the clip: its outline grown by `grow`, from the bed to `height`, rounded on top."""
    full = K.plan(grow)
    return loft([(0.0, K.plan(grow - foot)), (foot, full), (height - r, full)] + rounded_top(full, height - r, height))


def drop(r, x, y, z):
    """A ball with a 45 degree cone under it, so it prints on top of anything without support."""
    k = r / np.sqrt(2)
    cone = Manifold.cylinder(k, 0.0, k, 96).translate((0, 0, -2 * k))
    return (Manifold.sphere(r, 96) + cone).translate((x, y, z))


def slab(points_xz, y0, y1):
    """A flat shape drawn in the front view (x, z), made y1 - y0 thick."""
    pts = np.asarray(points_xz, float)
    area = 0.5 * np.sum(pts[:, 0] * np.roll(pts[:, 1], -1) - np.roll(pts[:, 0], -1) * pts[:, 1])
    if area < 0:
        pts = pts[::-1]
    return Manifold.extrude(CrossSection([pts]), y1 - y0).rotate((90, 0, 0)).translate((0, y1, 0))


def bezier(p0, p1, p2, p3, n):
    t = np.linspace(0, 1, n)[:, None]
    p0, p1, p2, p3 = map(np.asarray, (p0, p1, p2, p3))
    return (1 - t) ** 3 * p0 + 3 * (1 - t) ** 2 * t * p1 + 3 * (1 - t) * t ** 2 * p2 + t ** 3 * p3


# ------------------------------------------------------------------ the hats
def beanie():
    base = band(1.1, 7.3, r=2.2)
    outline = np.asarray(K.plan(1.1).to_polygons()[0])
    step = np.linalg.norm(np.roll(outline, -1, 0) - outline, axis=1)
    along, ribs, next_at = np.cumsum(step), [], 0.0
    pitch = along[-1] / round(along[-1] / 3.3)
    for p, s in zip(outline, along):                       # knitted ribs standing around the band
        if s >= next_at:
            ribs.append((Manifold.cylinder(5.6, 0.6, 0.6, 24) + Manifold.sphere(0.6, 24).translate((0, 0, 5.6)))
                        .translate((p[0], p[1], 0)))
            next_at += pitch
    dome = Manifold.sphere(1.0, 128).scale((15.4, 11.0, 15.0)).translate((0, CY, 5.7)).trim_by_plane((0, 0, 1), 5.7)
    pom = drop(4.2, 0, CY, 23.1)
    return base + Manifold.batch_boolean(ribs, OpType.Add) + dome + pom, [7.4, 20.2], ["white", "blue", "white"]


def party_cone():
    cone = loft([(6.0, oval(12.6, 9.8)), (28.0, oval(1.5, 1.17))])
    pom = drop(3.2, 0, CY, 30.7)
    return (band(1.0, 6.3) + cone + pom, [6.4, 10.2, 14.1, 18.0, 21.9, 25.8, 27.7],
            ["yellow", "pink", "yellow", "pink", "yellow", "pink", "yellow", "pink"])


def top_hat():
    brim = band(2.9, 6.3, r=2.4, foot=0.8)
    top = oval(11.15, 9.2)
    crown = loft([(6.0, oval(10.2, 8.4)), (22.7, top)] + rounded_top(top, 22.7, 24.1))
    return brim + crown, [6.4, 11.1], ["black", "red", "black"]


def santa():
    fur = band(1.3, 7.5, r=3.0, foot=1.0)
    profile = bezier((13.4, 6.1), (11.0, 15.1), (5.6, 23.3), (0.0, 28.3), 28)
    cone = loft([(z, oval(r, 0.74 * r)) for r, z in profile if r > 0.5])
    pom = drop(3.8, 0, CY, 29.3)
    return fur + cone + pom, [7.6, 26.0], ["white", "red", "white"]


def traffic_cone():
    foot = rounded_rect(16.4, 11.4, 2.0)
    base = loft([(0.0, foot.offset(-0.6)), (0.6, foot), (5.7, foot), (6.3, foot.offset(-0.6))])
    cone = loft([(6.0, oval(10.6, 10.6)), (28.1, oval(3.2, 3.2))])
    cap = Manifold.sphere(1.0, 64).scale((3.2, 3.2, 1.6)).translate((0, CY, 28.1))
    return base + cone + cap, [10.5, 14.7, 18.9, 23.1], ["orange", "white", "orange", "white", "orange"]


def crown():
    base = band(0.7, 6.6, r=0.6) + band(1.3, 3.2, r=0.6)
    mid = np.asarray(K.plan(-0.3).to_polygons()[0])        # centre line of the wall, 2 mm thick
    nxt = np.roll(mid, -1, 0)
    seg = np.linalg.norm(nxt - mid, axis=1)
    s = np.concatenate([[0.0], np.cumsum(seg)])
    points, low, high = 10, 8.6, 15.8
    front = s[np.argmin(np.hypot(mid[:, 0], mid[:, 1] - K.Y_FRONT))]      # put one point at the front centre

    def height(at):
        u = ((at - front) / s[-1] * points) % 1.0
        return min(high - 0.4, low + (high - low) * abs(1 - 2 * u))

    edge = nxt - mid
    normal = np.column_stack([edge[:, 1], -edge[:, 0]]) / np.maximum(seg, 1e-9)[:, None]
    normal = (normal + np.roll(normal, 1, 0))
    normal /= np.linalg.norm(normal, axis=1)[:, None]
    walls = []
    for i in range(len(mid)):
        j = (i + 1) % len(mid)
        # split long edges so the zigzag keeps its shape
        n = max(int(np.ceil(seg[i] / 0.45)), 1)
        for k in range(n):
            ta, tb = k / n, (k + 1) / n
            pa, pb = mid[i] + edge[i] * ta, mid[i] + edge[i] * tb
            na, nb = normal[i] * (1 - ta) + normal[j] * ta, normal[i] * (1 - tb) + normal[j] * tb
            ha, hb = height(s[i] + seg[i] * ta), height(s[i] + seg[i] * tb)
            pts = []
            for p, nrm, h in ((pa, na, ha), (pb, nb, hb)):
                for side in (1.0, -1.0):
                    q = p + nrm * side
                    pts += [(q[0], q[1], 6.0), (q[0], q[1], h)]
            walls.append(Manifold.hull_points(np.array(pts, np.float64)))
    return base + Manifold.batch_boolean(walls, OpType.Add), [], ["gold"]


def cat_ears():
    foot = (CrossSection.square((11.8, 8.8)).translate((-15.2, 3.6)).offset(-2.0).offset(2.0))
    ear = Manifold.batch_hull([Manifold.extrude(foot, 0.1).translate((0, 0, 5.5)),
                               Manifold.sphere(1.2, 48).translate((-12.6, CY + 0.6, 18.3))])
    skin = ear - ear.translate((0, 1.0, 0))                # the front 1 mm of the ear
    inner = (ear.translate((10.5, -CY, -5.5)).scale((0.58, 3.0, 0.62)).translate((-10.5, CY, 7.5)))
    ear -= inner ^ skin                                    # the inner ear is a shallow dent, not a colour
    return band(0.9, 6.5, r=2.0) + ear + ear.mirror((1, 0, 0)), [], ["ginger"]


def bucket_hat():
    def ring(a):
        b = 0.74 * a
        return rounded_rect(a, b, 0.72 * b)
    profile = [(0.0, 19.5), (0.6, 20.0), (1.4, 20.0), (8.6, 13.2), (19.0, 10.6), (19.9, 10.25), (20.4, 9.6), (20.6, 8.8)]
    return loft([(z, ring(a)) for z, a in profile]), [], ["green"]


def spiky_hair():
    mid = np.array([(-14.6, 5.5), (-16.2, 14.3), (-11.4, 11.1), (-10.4, 20.1), (-6.0, 14.1), (-3.4, 24.7), (0.0, 16.1),
                    (3.4, 23.1), (6.0, 14.1), (10.4, 19.1), (11.4, 11.1), (16.2, 14.3), (14.6, 5.5)])

    def row(flip, tall):
        return np.column_stack([flip * mid[:, 0], 5.5 + tall * (mid[:, 1] - 5.5)])
    rows = slab(row(-1, 0.72), 1.6, 5.2) + slab(mid, 5.2, 10.8) + slab(row(-1, 0.86), 10.8, 14.4)
    return band(0.9, 6.5, r=2.0) + rows, [], ["teal"]


HATS = {"beanie": beanie, "party-cone": party_cone, "top-hat": top_hat, "santa-simple": santa,
        "traffic-cone": traffic_cone, "crown": crown, "cat-ears": cat_ears, "bucket-hat": bucket_hat,
        "spiky-hair": spiky_hair}


# ------------------------------------------------------------------ finishing and checks
def build(name):
    """The finished hat on its clip, and the same hat cut into one solid per colour."""
    shape, bounds, colours = HATS[name]()
    whole = K.attach(shape)
    top = whole.bounding_box()[5] + 1.0
    edges = [-1.0] + list(bounds) + [top]
    by_colour = {}
    for z0, z1, colour in zip(edges[:-1], edges[1:], colours):
        piece = K._clean(whole.trim_by_plane((0, 0, 1), z0).trim_by_plane((0, 0, -1), -z1))
        by_colour[colour] = by_colour[colour] + piece if colour in by_colour else piece
    return whole, by_colour, len(bounds)


def overhang(solid, limit_deg=50.0):
    """Area (mm2) of outside faces that lean out more than limit_deg from vertical. Should be near zero."""
    mesh = solid.to_mesh()
    v = np.asarray(mesh.vert_properties, float)[:, :3]
    t = v[np.asarray(mesh.tri_verts)]
    n = np.cross(t[:, 1] - t[:, 0], t[:, 2] - t[:, 0])
    area = np.linalg.norm(n, axis=1) / 2
    ok = area > 1e-9
    nz = np.zeros(len(t)); nz[ok] = n[ok, 2] / (2 * area[ok])
    cen = t.mean(1)
    inside = (cen[:, 1] > -K.LIP_GAP - 0.01) & (cen[:, 1] < K.Y_WALL0 + 0.31) & (cen[:, 2] < K.CH + 0.31)   # the clip's own roof and springs
    bad = ok & (nz < -np.sin(np.radians(limit_deg))) & (cen[:, 2] > 0.15) & ~inside
    return float(area[bad].sum())


def clip_hidden(solid_shape):
    """True if the hat's own shape covers the clip's outline at the clip's shoulder and near its top."""
    for z, grow in ((K.TOP_Z - 1.0, 0.0), (K.TOP_Z - 0.2, -0.6)):
        if (K.plan(grow) - solid_shape.slice(z)).area() > 0.05:
            return False
    return True


if __name__ == "__main__":
    names = sys.argv[1:] or list(HATS)
    os.makedirs(os.path.join(HERE, "clip"), exist_ok=True)
    K.write_stl(os.path.join(HERE, "clip", "taby-hat-clip-base.stl"), K.clip())
    for name in names:
        whole, by_colour, swaps = build(name)
        folder = os.path.join(HERE, name)
        os.makedirs(folder, exist_ok=True)
        K.write_stl(os.path.join(folder, f"{name}.stl"), whole)
        if len(by_colour) > 1:
            for colour, piece in by_colour.items():
                K.write_stl(os.path.join(folder, f"{name}-{colour}.stl"), piece)
        b = whole.bounding_box()
        print(f"{name:13s} {b[3] - b[0]:5.1f} x {b[4] - b[1]:5.1f} x {b[5] - b[2]:5.1f} mm  {whole.volume() / 1000:5.2f} cm3  "
              f"one piece: {len(whole.decompose()) == 1}  colours: {'+'.join(by_colour)}  swaps: {swaps}  "
              f"overhang: {overhang(whole):.1f} mm2  clip hidden: {clip_hidden(HATS[name]()[0])}")
