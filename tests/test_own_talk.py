"""The 1.64 board's live face talking with no motion from the app: over
Bluetooth, which carries no VOICE_MOTION, or from an app that sends none. The
face must not talk with its mouth shut where the GIF pack's talking clip moved
it; once the app's motion comes, the face wears that instead.

firmware/components/taby_character/taby_voice.cpp is built against the
stand-in character in tests/host/live_face/, as tests/test_live_face.py does.
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
# One run of 30 frames, the mouth open on "aa" for all of them.
OPEN_RUN = "KzB" * 30


class OwnTalkTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CXX") or shutil.which("c++") or shutil.which("clang++") or shutil.which("g++")
        if not compiler:
            raise unittest.SkipTest("A C++ compiler is needed to test the voice motion off-device")
        cls.temp = tempfile.TemporaryDirectory()
        build = Path(cls.temp.name)
        for name in ("taby_voice.hpp", "taby_voice.cpp"):
            shutil.copy(FACE / name, build / name)
        shutil.copy(HOST / "live_face/taby_character.hpp", build / "taby_character.hpp")
        cls.driver = build / "voice_driver"
        sources = [str(HOST / "voice_driver.cpp"), str(build / "taby_voice.cpp")]
        base = [compiler, *FLAGS, f"-I{build}", "-o", str(cls.driver), *sources]
        if subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True).returncode != 0:
            subprocess.run(base, check=True, capture_output=True)

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def play(self, *commands):
        result = subprocess.run([str(self.driver)], input="\n".join(commands) + "\n",
                                capture_output=True, text=True, check=True)
        return [json.loads(line) for line in result.stdout.splitlines() if '"event"' not in line]

    def test_with_no_motion_from_the_app_the_mouth_talks_by_itself(self):
        mouth = self.play("mouth 10000 20000 10000")
        waiting = [m for m in mouth if m["t"] < 10500]
        talking = [m for m in mouth if m["t"] >= 10500]
        # A moment's wait for the app's first run, the mouth shut.
        self.assertTrue(all(m["viseme"] == "sil" and m["jaw"] == 0 for m in waiting))
        # Then it talks: open and shut, many shapes, the talking face's look.
        self.assertGreater(max(m["jaw"] for m in talking), 40)
        self.assertGreater(len({m["viseme"] for m in talking}), 8)
        self.assertGreater(sum(1 for a, b in zip(talking, talking[1:]) if a["viseme"] != b["viseme"]), 60)
        self.assertTrue(any(m["jaw"] == 0 for m in talking), "it pauses between words")
        self.assertEqual({m["expression"] for m in talking}, {"happy"})

    def test_the_apps_motion_wins_when_it_comes_with_the_talk(self):
        # The first run lands just before the face turns to talking.
        mouth = self.play(f"line 9950 1 0 0 {OPEN_RUN}", "mouth 10000 12000 10000")
        during = [m for m in mouth if m["t"] < 10950]
        after = [m for m in mouth if m["t"] >= 11000]
        self.assertEqual({m["viseme"] for m in during}, {"aa"})
        # Past the app's frames its mouth is shut, a pause between pieces,
        # not Taby talking by itself.
        self.assertTrue(all(m["viseme"] == "sil" and m["jaw"] == 0 for m in after))

    def test_a_late_first_run_takes_over_from_the_own_talk(self):
        mouth = self.play("mouth 10000 11000 10000", f"line 11000 1 0 0 {OPEN_RUN}", "mouth 11000 11900 10000")
        own = [m for m in mouth if 10500 <= m["t"] < 11000]
        self.assertGreater(len({m["viseme"] for m in own}), 1)
        self.assertEqual({m["viseme"] for m in mouth if m["t"] >= 11000}, {"aa"})

    def test_a_talk_long_after_the_last_run_talks_by_itself(self):
        mouth = self.play(f"line 1000 1 0 0 {OPEN_RUN}", "mouth 60000 62000 60000")
        self.assertGreater(len({m["viseme"] for m in mouth if m["t"] >= 60500}), 3)


if __name__ == "__main__":
    unittest.main()
