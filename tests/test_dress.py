"""The Christmas dress on the live resting face, off-device: the embedded
pictures as the firmware reads them, the hat following the face, and the
blend and clipping that put them on the panel.

tests/host/dress_driver.c links firmware/main/taby_dress.c, built with
AddressSanitizer and UndefinedBehaviorSanitizer where the compiler has them.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

try:
    from PIL import Image
except ImportError:
    Image = None

ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "firmware/main"
BLOB = MAIN / "christmas_dress.bin"
SOURCES = [ROOT / "tests/host/dress_driver.c", MAIN / "taby_dress.c"]
FLAGS = ["-std=gnu11", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer", f"-I{MAIN}"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]
PANEL_W, PANEL_H = 280, 456


class DressTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CC") or shutil.which("cc") or shutil.which("clang") or shutil.which("gcc")
        if not compiler:
            raise unittest.SkipTest("A C compiler is needed to test the Christmas dress off-device")
        cls.build = Path(tempfile.mkdtemp(prefix="taby-dress-"))
        cls.driver = cls.build / "dress_driver"
        base = [compiler, *FLAGS, "-o", str(cls.driver), *map(str, SOURCES)]
        built = subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True, text=True)
        if built.returncode != 0:
            built = subprocess.run(base, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(f"host build of the Christmas dress failed:\n{built.stderr}")

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.build, ignore_errors=True)

    def run_driver(self, args, stdin=b""):
        result = subprocess.run([str(self.driver), *args], input=stdin, capture_output=True, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return [json.loads(line) for line in result.stdout.decode().splitlines()]

    def test_the_firmware_reads_a_hat_and_two_strings_of_lights_on_the_panel(self):
        blob = self.run_driver(["blob", str(BLOB)])[0]
        self.assertTrue(blob["parsed"])
        kinds = [s["kind"] for s in blob["sprites"]]
        self.assertEqual(kinds, [0, 1, 1])
        for sprite in blob["sprites"]:
            self.assertGreaterEqual(sprite["x"], 0)
            self.assertGreaterEqual(sprite["y"], 0)
            self.assertLessEqual(sprite["x"] + sprite["w"], PANEL_W)
            self.assertLessEqual(sprite["y"] + sprite["h"], PANEL_H)

    def test_a_damaged_blob_is_refused(self):
        with tempfile.NamedTemporaryFile(suffix=".bin") as bad:
            bad.write(BLOB.read_bytes()[:5000])
            bad.flush()
            self.assertFalse(self.run_driver(["blob", bad.name])[0]["parsed"])

    def offsets(self, boxes):
        stdin = "".join(" ".join(map(str, b)) + "\n" for b in boxes).encode()
        result = subprocess.run([str(self.driver), "offsets", str(BLOB)], input=stdin, capture_output=True, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return [json.loads(line) for line in result.stdout.decode().splitlines()]

    def test_the_hat_moves_with_the_face(self):
        blob = self.run_driver(["blob", str(BLOB)])[0]
        rx, ry = blob["ref"]
        at_rest, looked, lower = self.offsets([[rx, ry - 150, rx + 130, ry + 150],
                                                [rx, ry - 230, rx + 130, ry + 70],
                                                [rx - 7, ry - 150, rx + 123, ry + 150]])
        self.assertEqual([looked[0], looked[1] + 80], [at_rest[0], at_rest[1]], "a look to the side carries the hat")
        self.assertEqual(lower[0], at_rest[0] - 7, "a face that drops takes the hat down with it")
        self.assertEqual(self.offsets([[0, 0, 0, 0]])[0], at_rest, "no face drawn: the hat stays put")

    def test_a_sprite_is_blended_over_the_panel_and_clipped_to_it(self):
        dark = 0xFF202020
        cases = self.run_driver(["blit"])[0]
        placed = cases[0]
        self.assertEqual(placed["box"], [1, 1, 3, 3])
        panel = placed["panel"]
        self.assertEqual(panel[1 * 4 + 1], 0xFFFF0000, "an opaque pixel replaces")
        half = panel[1 * 4 + 2]
        self.assertEqual(half >> 24, 0xFF)
        self.assertTrue(0x80 < (half & 0xFF) < 0xB0, "a half pixel blends over what is there")
        self.assertEqual(panel[2 * 4 + 1], dark, "a clear pixel leaves the panel")
        self.assertEqual(cases[1]["box"], [3, 2, 4, 3], "clipped at the right and bottom")
        self.assertEqual(cases[2]["box"], [0, 1, 1, 3], "clipped at the left")
        self.assertEqual(cases[3]["box"], [0, 0, 0, 0], "wholly off the panel: nothing")
        self.assertEqual(cases[3]["panel"], [dark] * 12)

    @unittest.skipIf(Image is None, "Pillow reads the idle's frames")
    def test_over_the_whole_resting_face_the_hat_stays_on_the_screen(self):
        manifest = json.loads((ROOT / "assets/amoled-1.64/manifest.json").read_text())
        rel = next(a["relative_path"] for a in manifest["animations"] if a["id"] == "idle_01_loop")
        gif = Image.open(ROOT / "assets/amoled-1.64" / rel)
        boxes = []
        try:
            while True:
                bbox = gif.convert("L").point(lambda v: 255 if v > 60 else 0).getbbox()
                boxes.append(list(bbox))
                gif.seek(gif.tell() + 1)
        except EOFError:
            pass
        self.assertGreater(len(boxes), 100)
        for box in self.offsets(boxes):
            self.assertGreaterEqual(box[0], 0)
            self.assertGreaterEqual(box[1], 0)
            self.assertLessEqual(box[2], PANEL_W)
            self.assertLessEqual(box[3], PANEL_H)


if __name__ == "__main__":
    unittest.main()
