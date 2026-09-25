"""Calmer eyes: the EYE_MOTION command and the rest-face frame plan, off-device.

tests/host/eye_motion_driver.c links firmware/main/taby_eye_motion.c, built
with AddressSanitizer and UndefinedBehaviorSanitizer where the compiler has
them. The plan names frames of idle_01_loop, so the art it was cut from is
checked here too: its structure always, and what the frames show when Pillow
is installed.
"""
import json
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile
import unittest

try:
    from PIL import Image
except ImportError:
    Image = None

ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "firmware/main"
HEADER = MAIN / "taby_eye_motion.h"
SOURCES = [ROOT / "tests/host/eye_motion_driver.c", MAIN / "taby_eye_motion.c"]
FLAGS = ["-std=gnu11", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer", f"-I{MAIN}"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]
BOARDS = ("amoled-1.64", "round-1.32")
# The rest-face plan was cut by looking at these files. Other art needs its
# frames read again and the numbers in taby_eye_motion.h changed to match.
REST_FACE_ART = {
    "amoled-1.64": "b11cae58a6973f7f3ef9c373d5d894fa7f5c981785e0311db2a117155ec28f18",
    "round-1.32": "7cb39158376c6e56811683d165140f997833f6967d0d42d1cfbe03f98696ee3d",
}
DRAWN_MS = 50


def header_number(name):
    match = re.search(rf"#define {name} (\d+)U", HEADER.read_text())
    if not match:
        raise AssertionError(f"{name} is not in {HEADER.name}")
    return int(match.group(1))


BLINK_LAST = header_number("TABY_REST_FACE_BLINK_LAST")
GLANCE_LAST = header_number("TABY_REST_FACE_GLANCE_LAST")


def rest_face_entry(board):
    manifest = json.loads((ROOT / "assets" / board / "manifest.json").read_text())
    catalog = json.loads((ROOT / "assets" / board / manifest["catalog"]["relative_path"]).read_text())
    return next(item for item in catalog["animations"] if item["id"] == "idle_01_loop")


def gif_blocks(data):
    """The frames of a GIF89a (rectangle and transparency) and whether a
    NETSCAPE loop block comes before the first one. No pixels are decoded."""
    if data[:6] != b"GIF89a":
        raise AssertionError("not a GIF89a")
    width, height, flags = struct.unpack("<HHB", data[6:11])
    at = 13 + (3 * (1 << ((flags & 7) + 1)) if flags & 0x80 else 0)
    frames, transparent, loops_before_first = [], False, False

    def skip_sub_blocks(position):
        while data[position]:
            position += data[position] + 1
        return position + 1

    while data[at] != 0x3B:
        kind, at = data[at], at + 1
        if kind == 0x21:
            label, at = data[at], at + 1
            if label == 0xF9:
                transparent = bool(data[at + 1] & 1)
            if label == 0xFF and data[at + 1:at + 9] == b"NETSCAPE" and not frames:
                loops_before_first = True
            at = skip_sub_blocks(at)
        elif kind == 0x2C:
            x, y, w, h, local = struct.unpack("<HHHHB", data[at:at + 9])
            at += 9 + (3 * (1 << ((local & 7) + 1)) if local & 0x80 else 0) + 1
            at = skip_sub_blocks(at)
            frames.append({"rect": (x, y, w, h), "transparent": transparent})
        else:
            raise AssertionError(f"unexpected GIF block {kind:#x}")
    return {"size": (width, height), "frames": frames, "loops": loops_before_first}


class DriverTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CC") or shutil.which("cc") or shutil.which("clang") or shutil.which("gcc")
        if not compiler:
            raise unittest.SkipTest("A C compiler is needed to test the eye-motion plan off-device")
        cls.build = Path(tempfile.mkdtemp(prefix="taby-eye-motion-"))
        cls.driver = cls.build / "eye_motion_driver"
        base = [compiler, *FLAGS, "-o", str(cls.driver), *map(str, SOURCES)]
        built = subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True, text=True)
        if built.returncode != 0:
            built = subprocess.run(base, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(f"host build of the eye-motion plan failed:\n{built.stderr}")

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.build, ignore_errors=True)

    def run_driver(self, args, stdin=b""):
        result = subprocess.run([str(self.driver), *args], input=stdin, capture_output=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return [json.loads(line) for line in result.stdout.decode().splitlines()]

    def commands(self, *lines):
        stdin = b"".join((line if isinstance(line, bytes) else line.encode()).hex().encode() + b"\n"
                         for line in lines)
        return self.run_driver(["commands"], stdin)

    def passes(self, mode, seed, steps=4000):
        """The plan as passes: each a list of (frame, hold_ms), starting at a rewind."""
        started, *shown = self.run_driver(["plan", mode, str(seed), str(steps)])
        self.assertTrue(started["started"])
        passes = []
        for step in shown:
            if step["rewound"]:
                passes.append([])
            passes[-1].append((step["frame"], step["hold_ms"]))
        return passes[:-1]  # the last pass is cut off by the step count


class CommandTests(DriverTestCase):
    def test_each_mode_is_set_by_name_and_read_back_by_query(self):
        replies = self.commands("EYE_MOTION normal", "EYE_MOTION calm", "EYE_MOTION still",
                                "EYE_MOTION   calm  ", "EYE_MOTION", "EYE_MOTION?")
        self.assertEqual([(r["kind"], r["mode"]) for r in replies],
                         [("set", "normal"), ("set", "calm"), ("set", "still"), ("set", "calm"),
                          ("query", None), ("query", None)])

    def test_a_mode_this_firmware_does_not_know_is_refused(self):
        for reply in self.commands("EYE_MOTION loud", "EYE_MOTION CALM", "EYE_MOTION calm still",
                                   "EYE_MOTION ", "EYE_MOTION ?", "EYE_MOTION calmer",
                                   "EYE_MOTION " + "x" * 3000, b"EYE_MOTION caf\xc3\xa9"):
            with self.subTest(command=reply["input"][:40]):
                self.assertEqual((reply["kind"], reply["mode"]), ("invalid", None))

    def test_other_commands_are_left_to_their_own_handlers(self):
        for reply in self.commands("EYE_MOTIONS calm", "eye_motion calm", "EYE_MOTION?x", "EYE",
                                   "BRIGHTNESS 50", "idle_01_loop", ""):
            with self.subTest(command=reply["input"]):
                self.assertEqual(reply["kind"], "none")

    def test_only_known_values_come_back_from_storage(self):
        stored = {row["stored"]: row["mode"] for row in self.run_driver(["stored"]) if row["known"]}
        self.assertEqual(stored, {0: "normal", 1: "calm", 2: "still"})


class RestFacePlanTests(DriverTestCase):
    SEEDS = (1, 7, 2026, 90210)

    def test_normal_is_not_driven(self):
        self.assertEqual(self.run_driver(["plan", "normal", "1", "10"]), [{"started": False}])

    def assert_pass_plays_in_order_from_the_rest_frame(self, frames, last):
        self.assertEqual(frames, list(range(last + 1)))

    def test_still_only_blinks(self):
        for seed in self.SEEDS:
            with self.subTest(seed=seed):
                passes = self.passes("still", seed)
                self.assertGreater(len(passes), 100)
                for shown in passes:
                    self.assert_pass_plays_in_order_from_the_rest_frame([f for f, _ in shown], BLINK_LAST)
                    rest, *drawn = [hold for _, hold in shown]
                    self.assertTrue(4000 <= rest <= 9000, rest)
                    self.assertEqual(set(drawn), {DRAWN_MS})

    def test_calm_blinks_and_sometimes_tilts_but_never_looks_away(self):
        for seed in self.SEEDS:
            with self.subTest(seed=seed):
                passes = self.passes("calm", seed)
                glances = [i for i, shown in enumerate(passes) if len(shown) > BLINK_LAST + 1]
                self.assertGreater(len(glances), 10)
                for shown in passes:
                    frames = [f for f, _ in shown]
                    self.assertIn(frames[-1], (BLINK_LAST, GLANCE_LAST))
                    self.assert_pass_plays_in_order_from_the_rest_frame(frames, frames[-1])
                    self.assertTrue(3000 <= shown[0][1] <= 7000, shown[0][1])
                between = [later - earlier - 1 for earlier, later in zip(glances, glances[1:])]
                self.assertTrue(all(5 <= count <= 8 for count in between), between)
                self.assertLessEqual(glances[0], 8)


class RestFaceArtTests(unittest.TestCase):
    def test_the_plan_was_cut_from_this_art(self):
        for board, sha256 in REST_FACE_ART.items():
            with self.subTest(board=board):
                self.assertEqual(rest_face_entry(board)["sha256"], sha256,
                                 "idle_01_loop changed: read its frames again and update taby_eye_motion.h")

    def test_the_rest_frame_redraws_the_whole_face_and_the_clip_keeps_looping(self):
        # Calm and still go back to frame 0 by rewinding the decoder. That only
        # redraws the face exactly when frame 0 is whole and opaque, and a face
        # handed back to LVGL keeps looping only if the loop block is re-read.
        for board in BOARDS:
            with self.subTest(board=board):
                gif = gif_blocks((ROOT / "assets" / board / rest_face_entry(board)["relative_path"]).read_bytes())
                self.assertEqual(len(gif["frames"]), header_number("TABY_REST_FACE_FRAME_COUNT"))
                first = gif["frames"][0]
                self.assertEqual(first["rect"], (0, 0, *gif["size"]))
                self.assertFalse(first["transparent"])
                self.assertTrue(gif["loops"])


@unittest.skipIf(Image is None, "Install Pillow to check what the rest face's frames show")
class RestFaceFrameTests(unittest.TestCase):
    """What the plan says about the frames, read from the pixels."""

    @staticmethod
    def eyes(board):
        """Per frame: how many lit pixels, and how far their centre is from frame 0's."""
        image = Image.open(ROOT / "assets" / board / rest_face_entry(board)["relative_path"])
        found = []
        for index in range(image.n_frames):
            image.seek(index)
            frame = image.convert("L")
            width, height = frame.size
            pixels = frame.load()
            xs = ys = count = 0
            for y in range(0, height, 2):
                for x in range(0, width, 2):
                    if pixels[x, y] > 128:
                        xs, ys, count = xs + x, ys + y, count + 1
            found.append((count, xs / count, ys / count))
        base_count, base_x, base_y = found[0]
        return [(count / base_count, ((x - base_x) ** 2 + (y - base_y) ** 2) ** 0.5) for count, x, y in found]

    def test_calm_and_still_stay_near_the_centre_and_the_long_looks_do_not(self):
        for board in BOARDS:
            with self.subTest(board=board):
                eyes = self.eyes(board)
                # Eyes open: about as much lit as frame 0. A blink leaves the
                # mouth, which moves the centre without the eyes moving.
                open_eyes = [i for i, (lit, _) in enumerate(eyes) if 0.95 <= lit <= 1.05]
                self.assertEqual(eyes[0][1], 0)
                self.assertLess(max(eyes[i][1] for i in open_eyes if i <= BLINK_LAST), 1)
                # The tilt moves the eyes about 7 px; an eye still reopening
                # from a blink shifts the centre up to 10.
                self.assertLess(max(eyes[i][1] for i in open_eyes if i <= GLANCE_LAST), 12)
                self.assertGreater(max(eyes[i][1] for i in open_eyes if i > GLANCE_LAST), 60)
                for last in (BLINK_LAST, GLANCE_LAST):
                    self.assertIn(last, open_eyes)
                    self.assertLess(eyes[last][1], 1, "a pass must end where frame 0 starts")


if __name__ == "__main__":
    unittest.main()
