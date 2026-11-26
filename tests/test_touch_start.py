"""The 1.64 board's touch start, off-device: a silent touch chip no longer ends
the start, and touch is taken up once a later try is answered.

tests/host/touch_start_driver.c links firmware/main/taby_touch_start.c, built
with AddressSanitizer and UndefinedBehaviorSanitizer where the compiler has
them. Each run says how the chip answers each try, in order.
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
SOURCES = [ROOT / "tests/host/touch_start_driver.c", MAIN / "taby_touch_start.c"]
FLAGS = ["-std=gnu11", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer", f"-I{MAIN}"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]
FIRST_TRIES = 8


class TouchStartTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CC") or shutil.which("cc") or shutil.which("clang") or shutil.which("gcc")
        if not compiler:
            raise unittest.SkipTest("A C compiler is needed to test the touch start off-device")
        cls.build = Path(tempfile.mkdtemp(prefix="taby-touch-start-"))
        cls.driver = cls.build / "touch_start_driver"
        base = [compiler, *FLAGS, "-o", str(cls.driver), *map(str, SOURCES)]
        built = subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True, text=True)
        if built.returncode != 0:
            built = subprocess.run(base, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(f"host build of the touch start failed:\n{built.stderr}")

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.build, ignore_errors=True)

    def start(self, answers):
        result = subprocess.run([str(self.driver), answers], capture_output=True, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return json.loads(result.stdout)

    def test_a_chip_that_answers_at_once_is_taken_up_with_no_wait(self):
        run = self.start("1")
        self.assertTrue(run["first"])
        self.assertEqual((run["first_tries"], run["pauses"]), (1, 0))
        self.assertTrue(run["readable_after_start"])
        self.assertEqual((run["later"], run["later_tries"]), ([], 0))

    def test_a_slow_chip_is_taken_up_during_the_start(self):
        run = self.start("001")
        self.assertTrue(run["first"])
        self.assertEqual((run["first_tries"], run["pauses"], run["paused_ms"]), (3, 2, 50))
        self.assertTrue(run["readable_after_start"])

    def test_a_silent_chip_lets_the_start_go_on_after_its_tries_without_touch(self):
        run = self.start("0" * FIRST_TRIES)
        self.assertFalse(run["first"])
        self.assertEqual(run["asked_at_start"], FIRST_TRIES)
        # Eight tries, 25 ms apart: the start waits no longer than it did
        # when a silent chip ended it.
        self.assertEqual((run["pauses"], run["paused_ms"]), (FIRST_TRIES - 1, 25 * (FIRST_TRIES - 1)))
        self.assertFalse(run["readable_after_start"], "taps must not read a chip that never answered")

    def test_a_later_answer_takes_touch_up_without_a_restart(self):
        run = self.start("0" * FIRST_TRIES + "0" * 40 + "1")
        self.assertFalse(run["first"])
        self.assertEqual(run["later"], [False] * 40 + [True])
        self.assertEqual(run["later_tries"], 41)
        self.assertTrue(run["readable"])

    def test_once_taken_up_the_chip_is_not_asked_again(self):
        for answers in ("1", "0" * FIRST_TRIES + "01"):
            with self.subTest(answers=answers):
                run = self.start(answers)
                self.assertTrue(run["extra_all_true"])
                self.assertEqual(run["asked_by_extra"], 0)

    def test_a_chip_that_never_answers_stays_untouched_and_keeps_being_tried(self):
        run = self.start("0" * (FIRST_TRIES + 5))
        self.assertEqual(run["later"], [False] * 5)
        self.assertFalse(run["readable"])
        self.assertFalse(run["extra_all_true"])


if __name__ == "__main__":
    unittest.main()
