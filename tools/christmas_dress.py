"""Makes firmware/main/christmas_dress.bin: the Christmas dress the 1.64 board's live resting face wears
(taby_dress.h). The hat and the two strings of lights are the app's own drawing (app-taby
`ChristmasDress.tsx`, `christmas.ts`, `christmas.css` on claude/christmas-idle-2), placed as on the board's
resting frame (the app's idle at 0.67, the hat 0.88x about its brim's foot so its top stays on the screen,
the lights steady at 0.8 as the app draws them with less motion, the plate's sides on the screen's sides),
turned into the panel's portrait layout as premultiplied ARGB.

    python tools/christmas_dress.py firmware/main/christmas_dress.bin

Needs rsvg-convert, Pillow and numpy. Run it by hand when the drawing changes; CI uses the committed file.
"""
import io, math, os, struct, subprocess, sys
import numpy as np
from PIL import Image

W, H = 456, 280   # the board's resting frame, landscape
TRACK = {"fps": 24, "anchor": [344.25, 292.0], "frames": [[0.0, 0.0, 0.0, 0.2]]}   # the app's pose at rest
STEADY = 0.8
# ---- the hat, exactly ChristmasDress.tsx's, in the clip's 680x418 units
RED, RED_FOLD, WHITE = "#E2352D", "#A9221D", "#FBFBFB"
BRIM = [(220.2,66.2,7.7),(220.4,93.5,8.1),(234.6,67,8.7),(237.7,94.3,7.2),(251.6,66.2,7.8),(252.5,92.3,9.6),(268.8,67.4,9.2),(267.5,93,8.8),(286.7,67,8.7),(286.2,93.2,8.5),(299.8,67.1,8.8),(301.9,92.8,9.1),(316,66.3,7.9),(317.7,92.5,9.3),(335.7,67.2,9),(335.8,92.8,8.9),(351.7,66.5,8.1),(352.2,93.4,8.3),(365.2,67.5,9.4),(365.6,94,7.5),(382.8,67.7,9.6),(382.3,93,8.7),(398.9,66.7,8.4),(399.7,93.6,8),(417.3,66.9,8.6),(417.4,92.9,8.9),(434,67.4,9.3),(430.7,92.9,8.8)]
BOBBLE = [(530,74,22.5),(547.3,73.3,7.7),(543.7,84.7,7.6),(535.1,90.2,8),(526.5,90.4,8.3),(517.5,85.4,8.2),(512.7,75.8,7.6),(516.7,64.7,8.7),(523.2,58.2,7.8),(535.4,58.9,8.9),(543.9,64.3,8.1)]
circ = lambda l: "".join(f'<circle cx="{x}" cy="{y}" r="{r}"/>' for x, y, r in l)
def pose(t):  # christmas.ts hatPose
    F = TRACK["frames"]; n = len(F); at = ((t * TRACK["fps"]) % n + n) % n; i = int(at); p = at - i
    a, b = F[i], F[(i + 1) % n]; return [a[k] + (b[k] - a[k]) * p for k in range(4)]
def hat_svg(t):
    x, y, turn, tip = pose(t); ax, ay = TRACK["anchor"]
    head = f"translate({ax + x:.2f} {ay + y:.2f}) rotate({turn:.2f}) translate({-ax} {-ay})"
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W*2}" height="{H*2}" viewBox="0 0 680 418" preserveAspectRatio="none">'
            f'<g transform="{head}"><g transform="translate(326 100) scale(0.88) translate(-326 -100)"><path fill="{RED}" d="M 222 76 C 212 42 236 6 290 0 C 334 -5 396 -2 448 20 L 462 70 L 430 76 Z"/>'
            f'<g transform="rotate({tip:.2f} 440 20)"><path fill="{RED}" d="M 420 10 C 466 18 500 38 524 66 L 512 76 C 494 62 470 56 444 62 L 424 44 Z"/>'
            f'<path fill="{RED_FOLD}" d="M 462 44 C 486 50 506 60 522 70 L 512 76 C 494 62 470 56 444 62 L 448 50 Z"/>'
            f'<g fill="{WHITE}">{circ(BOBBLE)}</g></g>'
            f'<g fill="{WHITE}"><rect x="202" y="60" width="248" height="40" rx="19"/>{circ(BRIM)}</g></g></g></svg>')
# ---- the lights, exactly ChristmasDress.tsx + christmas.css, in the plate's units; the plate's body
# (x 10..310) is the device's screen width, its height (0..184) the screen's height.
LIGHTS = ["#E0534B", "#3DB36E", "#E6B044", "#4C8FD9"]; N_SIDE = 5
HOOKS = [8 + ((i + 0.5) / N_SIDE) * (184 - 30 - 8) + (8 if i == N_SIDE - 1 else 0) for i in range(N_SIDE)]
def chase(phase):  # keyframes 0%,40%,100% 0.55; 20% 0.95; linear
    p = phase % 1.0
    if p <= 0.2: return 0.55 + (0.95 - 0.55) * p / 0.2
    if p <= 0.4: return 0.95 - (0.95 - 0.55) * (p - 0.2) / 0.2
    return 0.55
def lights_svg(t, period):
    parts = []
    for left in (True, False):
        inward = 1 if left else -1; edge = 16.5 if left else 303.5; step = HOOKS[1] - HOOKS[0]
        pts = []; y = HOOKS[0] - 14
        while y <= HOOKS[-1] + 6:
            pts.append(f"{edge + inward * 0.8 * math.sin(((y - HOOKS[0]) / step) * math.pi * 2):.2f} {y:.2f}"); y += 1
        parts.append(f'<path d="M {" L ".join(pts)}" fill="none" stroke="#2C3C2E" stroke-width="1"/>')
        for i, hy in enumerate(HOOKS):
            out = 1 if i % 2 == 0 else -1; ang = math.radians(24) * out * -inward
            bx, by = edge + math.sin(ang) * 4.4, hy + math.cos(ang) * 4.4
            hx, hy2 = edge + math.sin(ang) * 0.9, hy + math.cos(ang) * 0.9
            col = LIGHTS[(i + (0 if left else 2)) % 4]
            op = STEADY   # animation-delay (i/5 - 1) * period
            parts.append(f'<g fill="{col}" opacity="{op:.3f}"><circle cx="{bx:.2f}" cy="{by:.2f}" r="4.5" opacity="0.32" filter="url(#g)"/>'
                         f'<ellipse cx="{bx:.2f}" cy="{by:.2f}" rx="2.8" ry="4" transform="rotate({-math.degrees(ang):.1f} {bx:.2f} {by:.2f})"/>'
                         f'<circle cx="{hx:.2f}" cy="{hy2:.2f}" r="1.6" fill="#28342A"/></g>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W*2}" height="{H*2}" viewBox="10 0 300 184" preserveAspectRatio="none">'
            f'<defs><filter id="g" x="-1" y="-1" width="3" height="3"><feGaussianBlur stdDeviation="3"/></filter></defs>{"".join(parts)}</svg>')
def raster(svg):
    png = subprocess.run(["rsvg-convert"], input=svg.encode(), capture_output=True, check=True).stdout
    return Image.open(io.BytesIO(png)).convert("RGBA").resize((W, H), Image.LANCZOS)

OUTBIN = sys.argv[1]
def layer(svg):
    png = subprocess.run(["rsvg-convert"], input=svg.encode(), capture_output=True, check=True).stdout
    return Image.open(io.BytesIO(png)).convert("RGBA").resize((W, H), Image.LANCZOS)
hat = layer(hat_svg(0.0))                      # pose at the idle's first frame
lights = layer(lights_svg(0.0, 1.0))
# The face box of frame 0 (landscape): x 75..385, bottom 204 -> panel: low x = 279 - 204 = 75, centre y = 230
REF_PX, REF_PY = 279 - 204, (75 + 385) // 2
def sprites_of(img, kind, split=False):
    a = np.asarray(img)
    parts = []
    if split:  # the two strings, each its own sprite
        for xs in ((0, W // 2), (W // 2, W)):
            sub = np.zeros_like(a); sub[:, xs[0]:xs[1]] = a[:, xs[0]:xs[1]]; parts.append(sub)
    else:
        parts.append(a)
    out = []
    for p in parts:
        ys, xs = np.where(p[:, :, 3] > 2)
        X0, X1, Y0, Y1 = xs.min(), xs.max() + 1, ys.min(), ys.max() + 1
        crop = Image.fromarray(p[Y0:Y1, X0:X1])
        panel = crop.transpose(Image.ROTATE_270)          # landscape -> panel (clockwise)
        px0, py0 = 279 - (Y1 - 1), X0                     # panel x = 279 - Y, panel y = X
        out.append((kind, px0, py0, panel))
    return out
items = sprites_of(hat, 0) + sprites_of(lights, 1, split=True)
blob = bytearray(b"TXD1") + struct.pack("<HHHH", len(items), REF_PX, REF_PY, 0)
for kind, px0, py0, im in items:
    a = np.asarray(im).astype(np.uint32); w, h = im.size
    al = a[:, :, 3]
    r = a[:, :, 0] * al // 255; g = a[:, :, 1] * al // 255; b = a[:, :, 2] * al // 255
    argb = (al << 24) | (r << 16) | (g << 8) | b
    blob += struct.pack("<BBhhHHH", kind, 0, px0, py0, w, h, 0) + argb.astype("<u4").tobytes()
    print("sprite kind", kind, "panel at", (px0, py0), "size", (w, h))
open(OUTBIN, "wb").write(blob); print("blob", len(blob), "bytes")
open(OUTBIN, "wb").write(blob); print("blob", len(blob), "bytes")
