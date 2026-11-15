"""The 1.64 board's live face, off-device: which of the character's modes it
asks for, when a clip may cut in, and how the Eyes setting moves the resting
face.

firmware/components/taby_character/taby_face.cpp is built against the
stand-in character in tests/host/live_face/ (no Rive), with
AddressSanitizer and UndefinedBehaviorSanitizer where the compiler has them.
The face's own source sits next to the stand-in in a scratch directory, since
its include of taby_character.hpp would otherwise find the real one.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
FACE = ROOT / "firmware/components/taby_character"
HOST = ROOT / "tests/host"
FLAGS = ["-std=c++17", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]


class LiveFaceTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CXX") or shutil.which("c++") or shutil.which("clang++") or shutil.which("g++")
        if not compiler:
            raise unittest.SkipTest("A C++ compiler is needed to test the live face off-device")
        cls.temp = tempfile.TemporaryDirectory()
        build = Path(cls.temp.name)
        for name in ("taby_face.hpp", "taby_face.cpp"):
            shutil.copy(FACE / name, build / name)
        shutil.copy(HOST / "live_face/taby_character.hpp", build / "taby_character.hpp")
        cls.driver = build / "live_face_driver"
        sources = [str(HOST / "live_face_driver.cpp"), str(build / "taby_face.cpp")]
        base = [compiler, *FLAGS, f"-I{build}", "-o", str(cls.driver), *sources]
        if subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True).returncode != 0:
            subprocess.run(base, check=True, capture_output=True)

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def play(self, *commands, seed=7):
        result = subprocess.run(
            [str(self.driver), str(seed)], input="\n".join(commands) + "\n",
            capture_output=True, text=True, check=True)
        return [json.loads(line) for line in result.stdout.splitlines()]

    @staticmethod
    def modes(lines):
        return [(line["mode"], line["t"]) for line in lines if line.get("event") == "mode"]

    @staticmethod
    def blinks(lines):
        return [line["t"] for line in lines if line.get("event") == "blink"]

    @staticmethod
    def frames(lines):
        return [line for line in lines if "frame" in line]

    def test_listening_working_and_talking_go_straight_from_one_to_the_next(self):
        lines = self.play("show listening", "run 0 1000", "show working", "run 1000 2000",
                          "show talking", "gesture hi", "run 2000 3000")
        # No rest between them: the character's own transitions carry it.
        self.assertEqual([mode for mode, _ in self.modes(lines)], ["listening", "working", "speaking"])
        speech = [line for line in lines if line.get("event") == "speech"]
        self.assertTrue(speech, "talking applies the app's mouth motion")
        # The body takes a gesture only once the action before it has let go.
        # (The stand-in counts from the frame before, so one frame either way.)
        early = [s["gesture"] for s in speech if s["t"] < 2000 + 300]
        late = [s["gesture"] for s in speech if s["t"] > 2000 + 300 + 1000 / 30]
        self.assertEqual(set(early), {"idle"})
        self.assertEqual(set(late), {"hi"})
        live = [f for f in self.frames(lines) if f["frame"] >= 1000]
        self.assertTrue(all(abs(f["frameMs"] - 1000 / 30) < 0.1 for f in live))

    def test_a_clip_cuts_in_only_once_the_face_rests_and_the_face_comes_back(self):
        lines = self.play("show listening", "run 0 1000", "handover", "run 1000 2000", "takeback", "run 2000 2500")
        self.assertEqual([mode for mode, _ in self.modes(lines)], ["listening", "rest", "listening"])
        rest_at = dict((mode, t) for mode, t in self.modes(lines))["rest"]
        resting = [f["frame"] for f in self.frames(lines) if f["atRest"]]
        self.assertTrue(resting, "the face reaches its rest")
        # Its neutral face reached, and past the blend there.
        self.assertGreaterEqual(resting[0] - rest_at, 400)
        self.assertLess(resting[0] - rest_at, 500)
        self.assertFalse(any(f["atRest"] for f in self.frames(lines) if f["frame"] > 2001))

    def test_a_face_back_from_a_clip_starts_on_its_rest_at_once(self):
        lines = self.play("show talking", "run 0 600", "fromrest 600", "run 600 700")
        start = next(line for line in lines if line.get("event") == "fromrest")
        self.assertTrue(start["atRest"], "settled before its first frame, its clock run ahead")
        self.assertIn(("rest", 600.0), self.modes(lines))
        self.assertEqual(self.modes(lines)[-1][0], "speaking")

    def test_normal_eyes_play_the_characters_own_idle_loop_at_the_idle_gifs_pace(self):
        lines = self.play("eyes normal", "show idle", "run 0 30000")
        self.assertEqual(self.modes(lines), [])
        self.assertEqual(self.blinks(lines), [])
        self.assertTrue(all(f["mode"] == "idle" and f["frameMs"] == 50 for f in self.frames(lines)))

    def test_still_eyes_hold_the_neutral_face_and_blink_gently(self):
        for seed in (1, 7, 42):
            lines = self.play("eyes still", "show idle", "run 0 60000", seed=seed)
            self.assertEqual([mode for mode, _ in self.modes(lines)], ["rest"])
            blinks = self.blinks(lines)
            gaps = [b - a for a, b in zip([0.0] + blinks, blinks)]
            self.assertGreaterEqual(len(blinks), 5)
            self.assertTrue(all(4000 - 100 <= gap <= 9000 + 1000 for gap in gaps), gaps)
            # Between blinks nothing moves: no frame drawn, a slow check.
            quiet = [f for f in self.frames(lines) if not f["moved"]]
            self.assertGreater(len(quiet), len(self.frames(lines)) / 2)
            self.assertTrue(all(f["frameMs"] == 100 for f in quiet))

    def test_calm_eyes_blink_more_and_tilt_now_and_then(self):
        lines = self.play("eyes calm", "show idle", "run 0 120000", seed=3)
        modes = self.modes(lines)
        tilts = [t for mode, t in modes if mode == "idle"]
        self.assertTrue(tilts, "a small tilt comes")
        blinks = self.blinks(lines)
        self.assertGreaterEqual(len([b for b in blinks if b < tilts[0]]), 5)
        self.assertLessEqual(len([b for b in blinks if b < tilts[0]]), 8)
        # The tilt is the idle loop's opening, let go after it.
        back = next(t for mode, t in modes if mode == "rest" and t > tilts[0])
        self.assertAlmostEqual(back - tilts[0], 1300, delta=100)
        gaps = [b - a for a, b in zip(blinks, blinks[1:]) if not any(a < t < b for t in tilts)]
        self.assertTrue(all(3000 - 100 <= gap <= 7000 + 1000 for gap in gaps), gaps)

    def test_a_clip_waiting_while_the_eyes_are_still_still_reaches_rest(self):
        lines = self.play("eyes still", "show idle", "run 0 10000", "handover", "run 10000 11000")
        self.assertTrue(any(f["atRest"] for f in self.frames(lines) if f["frame"] >= 10000))


if __name__ == "__main__":
    unittest.main()
