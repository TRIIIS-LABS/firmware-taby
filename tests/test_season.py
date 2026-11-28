"""The Christmas rest, off-device: the SEASON command, the told look kept across
power (the hat when never told), and the rest playing the Christmas clip only
while the season is on.

tests/host/season_driver.c links firmware/main/taby_season.c with the real
clip table (taby_animation_assets.c), built with AddressSanitizer and
UndefinedBehaviorSanitizer where the compiler has them.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "firmware/main"
SOURCES = [ROOT / "tests/host/season_driver.c"] + [MAIN / name for name in (
    "taby_season.c", "taby_animation_assets.c", "taby_state_machine.c")]
FLAGS = ["-std=gnu11", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer",
         f"-I{ROOT / 'tests/host/stubs'}", f"-I{MAIN}"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]
PACK = ROOT / "assets/amoled-1.64"


class SeasonTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CC") or shutil.which("cc") or shutil.which("clang") or shutil.which("gcc")
        if not compiler:
            raise unittest.SkipTest("A C compiler is needed to test the Christmas rest off-device")
        cls.build = Path(tempfile.mkdtemp(prefix="taby-season-"))
        cls.driver = cls.build / "season_driver"
        base = [compiler, *FLAGS, "-o", str(cls.driver), *map(str, SOURCES)]
        built = subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True, text=True)
        if built.returncode != 0:
            built = subprocess.run(base, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(f"host build of the Christmas rest failed:\n{built.stderr}")

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.build, ignore_errors=True)

    def run_driver(self, args, stdin=b""):
        result = subprocess.run([str(self.driver), *args], input=stdin, capture_output=True, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return [json.loads(line) for line in result.stdout.decode().splitlines()]

    def commands(self, *lines):
        return self.run_driver(["commands"], b"".join(line.encode().hex().encode() + b"\n" for line in lines))

    def test_the_season_is_set_read_and_ended_by_command(self):
        got = self.commands("SEASON?", "SEASON", "SEASON christmas hat 7200", "SEASON christmas lights 60", "SEASON off")
        self.assertEqual([g["command"] for g in got], ["query", "query", "set", "set", "off"])
        self.assertEqual((got[2]["look"], got[2]["seconds"]), ("hat", 7200))
        self.assertEqual((got[3]["look"], got[3]["seconds"]), ("lights", 60))

    def test_a_season_with_no_end_or_an_unknown_look_is_refused(self):
        bad = ["SEASON christmas hat", "SEASON christmas hat 0", "SEASON christmas hat 43201",
               "SEASON christmas hat -5", "SEASON christmas hat 10s", "SEASON christmas santa 60",
               "SEASON easter hat 60", "SEASON on", "SEASON christmas hat 60 now"]
        self.assertEqual([g["command"] for g in self.commands(*bad)], ["invalid"] * len(bad))

    def test_other_commands_are_left_to_their_own_handlers(self):
        self.assertEqual([g["command"] for g in self.commands("SEASONS", "EYE_MOTION calm", "idle_01_loop")],
                         ["none"] * 3)

    def test_a_unit_never_told_rests_in_the_hat_and_a_told_look_survives_power(self):
        got = self.run_driver(["stored"])[0]
        self.assertEqual(got["never_told"], "hat")
        for look, (value, after) in got["after_power"].items():
            self.assertEqual(after, look, f"a told {look} must come back after a power-up")
            self.assertNotEqual(value, 0, "0 is never stored, so it cannot be told apart from never told")
        self.assertEqual(len({value for value, _ in got["after_power"].values()}), 3)
        self.assertEqual(got["unknown_bytes"], ["hat"] * 3)

    def test_a_told_look_has_no_end(self):
        got = self.run_driver(["stored"])[0]
        self.assertEqual(got["seconds_left"], {"off": 0, "hat": 43200, "lights": 43200})

    def test_the_same_look_told_every_30_minutes_writes_nothing(self):
        self.assertEqual(self.run_driver(["stored"])[0]["writes"],
                         {"first_told": True, "same_again": False, "another": True})

    def test_the_rest_plays_the_christmas_clip_only_while_the_season_is_on(self):
        hat = self.run_driver(["rest", "hat"])[0]
        self.assertEqual(hat["without_season"], "idle_01_loop")
        self.assertEqual((hat["id"], hat["alias"], hat["idle_state"]), ("christmas_idle_hat_loop",) * 3)
        self.assertTrue(hat["loop"])
        self.assertEqual(hat["other_clip"], "idle_02_loop", "only the rest is dressed")
        self.assertTrue(hat["rests"])
        lights = self.run_driver(["rest", "lights"])[0]
        self.assertEqual(lights["id"], "christmas_idle_lights_loop")
        self.assertEqual(self.run_driver(["rest", "off"])[0]["id"], "idle_01_loop")

    def test_the_christmas_clips_are_in_the_1_64_pack_where_the_firmware_looks(self):
        catalog = json.loads((PACK / "catalog.json").read_text())
        entries = {a["id"]: a for a in catalog["animations"]}
        for look in ("hat", "lights"):
            clip = self.run_driver(["rest", look])[0]
            entry = entries[clip["id"]]
            self.assertEqual(f"/assets/{entry['relative_path']}", clip["path"])
            self.assertEqual(entry["loop_policy"], "loop")
            self.assertEqual((PACK / entry["relative_path"]).stat().st_size, entry["byte_length"])


if __name__ == "__main__":
    unittest.main()
