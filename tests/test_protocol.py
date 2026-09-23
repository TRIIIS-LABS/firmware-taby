"""Feed the firmware's own command parsing unknown IDs and malformed input, off-device.

tests/host/protocol_driver.c links the real parser and asset table with
stand-ins for the runtime and the asset pack. It is built with AddressSanitizer
and UndefinedBehaviorSanitizer where the compiler has them, so an out-of-bounds
read or write aborts the driver and fails the test.
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
SOURCES = [ROOT / "tests/host/protocol_driver.c"] + [MAIN / name for name in (
    "taby_transport_protocol.c", "taby_animation_assets.c", "taby_state_machine.c",
    "taby_line_reader.c", "taby_reusable_preview.c")]
FLAGS = ["-std=gnu11", "-Wall", "-Wextra", "-Werror", "-g", "-O1", "-fno-omit-frame-pointer",
         f"-I{ROOT / 'tests/host/stubs'}", f"-I{MAIN}"]
SANITIZERS = ["-fsanitize=address,undefined", "-fno-sanitize-recover=all"]
# IDs the desktop has sent that no firmware has a clip for.
DESKTOP_IDS_WITHOUT_CLIPS = ("dizzy_loop", "talking_man_loop")


def board_catalog(board):
    manifest = json.loads((ROOT / "assets" / board / "manifest.json").read_text())
    return json.loads((ROOT / "assets" / board / manifest["catalog"]["relative_path"]).read_text())


class DriverTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = os.environ.get("CC") or shutil.which("cc") or shutil.which("clang") or shutil.which("gcc")
        if not compiler:
            raise unittest.SkipTest("A C compiler is needed to test the firmware parser off-device")
        cls.build = Path(tempfile.mkdtemp(prefix="taby-protocol-"))
        cls.driver = cls.build / "protocol_driver"
        base = [compiler, *FLAGS, "-o", str(cls.driver), *map(str, SOURCES)]
        built = subprocess.run(base[:1] + SANITIZERS + base[1:], capture_output=True, text=True)
        cls.sanitized = built.returncode == 0
        if not cls.sanitized:
            built = subprocess.run(base, capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(f"host build of the firmware parser failed:\n{built.stderr}")
        cls.boards = {}
        for board in ("amoled-1.64", "round-1.32"):
            path = cls.build / f"{board}.txt"
            path.write_text("".join(item["id"] + "\n" for item in board_catalog(board)["animations"]))
            cls.boards[board] = path

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.build, ignore_errors=True)

    def run_driver(self, args, stdin):
        result = subprocess.run([str(self.driver), *args], input=stdin, capture_output=True, timeout=120)
        self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
        return [json.loads(line) for line in result.stdout.decode().splitlines()]

    @staticmethod
    def hex_lines(commands):
        return b"".join((command if isinstance(command, bytes) else command.encode()).hex().encode() + b"\n"
                        for command in commands)

    def handle(self, commands, board="amoled-1.64", prefix="TABY:", echo=True, apply_fails=False):
        args = ["handle", str(self.boards[board]), prefix, "echo" if echo else "quiet"]
        if apply_fails:
            args.append("apply_fails")
        return self.run_driver(args, self.hex_lines(commands))


class DisplayCommandTests(DriverTestCase):
    def assert_ignored(self, reply, animation_id, state=None):
        self.assertEqual(reply["result"], "unsupported_animation")
        self.assertFalse(reply["applied"])
        self.assertTrue(reply["reply"].startswith("TABY:OK "), reply["reply"])
        self.assertTrue(reply["reply"].endswith(f" unsupported_animation {animation_id}"), reply["reply"])
        if state:
            self.assertEqual(reply["reply"], f"TABY:OK {state} unsupported_animation {animation_id}")

    def test_the_id_that_dropped_the_desktop_now_plays_on_both_boards(self):
        for board in self.boards:
            with self.subTest(board=board):
                single, chained = self.handle(
                    ["taby_response_ready_in", "taby_response_ready_in>taby_response_ready_loop"], board)
                self.assertEqual((single["result"], single["reply"]), ("applied", "TABY:OK ANIMATION"))
                self.assertEqual(chained["animation_id"], "taby_response_ready_in")
                self.assertEqual(chained["next_animation_id"], "taby_response_ready_loop")

    def test_every_clip_on_each_board_plays(self):
        for board in self.boards:
            ids = [item["id"] for item in board_catalog(board)["animations"]]
            with self.subTest(board=board):
                for reply in self.handle(ids, board):
                    self.assertEqual(reply["result"], "applied", reply)
                    self.assertEqual(reply["animation_id"], reply["input"])

    def test_an_id_with_no_clip_is_answered_ok_and_changes_nothing(self):
        idle, played, ignored, *rest = self.handle(["S", "confirmation", *DESKTOP_IDS_WITHOUT_CLIPS])
        self.assertEqual(idle["reply"], "TABY:OK IDLE")
        self.assertEqual(played["state"], "ANIMATION")
        self.assert_ignored(ignored, "dizzy_loop", "ANIMATION")
        for reply in rest:
            self.assert_ignored(reply, reply["input"], "ANIMATION")

        still_idle = self.handle(["S", "dizzy_loop"])[1]
        self.assert_ignored(still_idle, "dizzy_loop", "IDLE")
        self.assertEqual(still_idle["state"], "IDLE")

    def test_a_clip_the_table_knows_but_this_boards_pack_lacks_is_ignored(self):
        # thumbs_up ships on the 1.64 only; on the round the renderer used to
        # refuse it and USB answered "ERR runtime_unavailable".
        self.assertEqual(self.handle(["thumbs_up"], "amoled-1.64")[0]["result"], "applied")
        self.assert_ignored(self.handle(["thumbs_up"], "round-1.32")[0], "thumbs_up")
        self.assert_ignored(self.handle(["confirmation>thumbs_up"], "round-1.32")[0], "thumbs_up")

    def test_a_state_whose_clip_the_board_lacks_leaves_the_state_alone(self):
        # The round pack has neither delete_01 nor waiting_01; the state
        # machine used to switch anyway and the face never followed.
        for command, clip in (("D", "delete_01"), ("task_delete", "delete_01"), ("ambient_waiting", "waiting_01")):
            with self.subTest(command=command):
                idle, ignored = self.handle(["S", command], "round-1.32")
                self.assert_ignored(ignored, clip, "IDLE")
                self.assertEqual(ignored["state"], "IDLE")
                self.assertEqual(self.handle([command], "amoled-1.64")[0]["result"], "applied")

    def test_sequences_name_the_missing_side(self):
        first, second, both = self.handle(["dizzy_loop>idle_01_loop", "idle_01_loop>dizzy_loop",
                                           "DIZZY_LOOP>TALKING_MAN_LOOP"])
        self.assert_ignored(first, "dizzy_loop")
        self.assert_ignored(second, "dizzy_loop")
        self.assert_ignored(both, "dizzy_loop")

    def test_id_shaped_text_up_to_the_desktops_limit_is_an_animation(self):
        longest = "x" * 80
        ignored, too_long = self.handle([longest, longest + "x"])
        self.assert_ignored(ignored, longest)
        self.assertEqual(too_long["result"], "unsupported_command")
        self.assert_ignored(self.handle(["animation"])[0], "animation")
        self.assert_ignored(self.handle(["0_starts_with_a_digit"])[0], "0_starts_with_a_digit")

    def test_malformed_commands_are_errors_that_touch_nothing(self):
        malformed = ["", " ", "HELLO", "Confirmation", "confirmation ", "a>b>c", ">idle_01_loop",
                     "idle_01_loop>", "a>", "TBY#zzzzzz", "TBY@", "TBY!", "UI", "\x7f\x01\x02",
                     b"caf\xc3\xa9", "x" * 4000,
                     "\"quoted\\\"", "%s%s%s%n"]
        for reply in self.handle(malformed):
            with self.subTest(command=reply["input"][:40]):
                self.assertEqual(reply["result"], "unsupported_command")
                self.assertFalse(reply["applied"])
                self.assertTrue(reply["reply"].startswith("TABY:ERR unsupported_command"), reply["reply"])
                self.assertLessEqual(len(reply["reply"]), len("TABY:ERR unsupported_command ") + 64)

    def test_bluetooth_replies_carry_no_prefix_and_no_echo(self):
        ignored, error, played = self.handle(["dizzy_loop", "HELLO", "confirmation"], prefix="", echo=False)
        self.assertEqual(ignored["reply"], "OK IDLE unsupported_animation dizzy_loop")
        self.assertEqual(error["reply"], "ERR unsupported_command")
        self.assertEqual(played["reply"], "OK ANIMATION")

    def test_only_a_runtime_that_cannot_apply_a_playable_clip_is_an_error(self):
        playable, ignored = self.handle(["confirmation", "dizzy_loop"], apply_fails=True)
        self.assertEqual(playable["reply"], "TABY:ERR runtime_unavailable")
        self.assert_ignored(ignored, "dizzy_loop")

    def test_clear_is_a_command(self):
        cleared = self.handle(["CLEAR"])[0]
        self.assertEqual((cleared["result"], cleared["reply"], cleared["cleared"]), ("applied", "TABY:OK IDLE", True))
        self.assertEqual(self.handle(["CLEAR"], apply_fails=True)[0]["reply"], "TABY:ERR runtime_unavailable")
        self.assertEqual(self.handle(["clear"])[0]["result"], "unsupported_animation")


class AssetLookupTests(DriverTestCase):
    def test_every_catalog_clip_resolves_where_the_pack_stores_it(self):
        for board in self.boards:
            items = board_catalog(board)["animations"]
            with self.subTest(board=board):
                replies = self.run_driver(["lookup"], self.hex_lines([item["id"] for item in items]))
                for item, reply in zip(items, replies):
                    self.assertTrue(reply["found"], item["id"])
                    self.assertEqual(reply["path"], "/assets/" + item["relative_path"])
                    self.assertEqual(reply["duration_ms"], item["duration_ms"])
                    self.assertEqual(reply["loop"], item["loop_policy"] != "play_once")

    def test_aliases_and_unknown_ids(self):
        alias, unknown, empty, long_id, control = self.run_driver(["lookup"], self.hex_lines(
            ["taby_response_ready__loop", "dizzy_loop", "", "a" * 3000, b"confirmation\x01"]))
        self.assertEqual(alias["animation_id"], "taby_response_ready_loop")
        for reply in (unknown, empty, long_id, control):
            self.assertFalse(reply["found"])


class UiCommandTests(DriverTestCase):
    def ui(self, *commands):
        return self.run_driver(["ui"], self.hex_lines(commands))

    def test_the_desktops_own_cards_parse(self):
        title, choice, timer = self.ui(
            "UI/title_subtitle?taby_error:SOMETHING WENT WRONG|TRY AGAIN",
            "UI/choice_2?taby_approval:RUN THIS?|YES|NO|FROM CLAUDE",
            "UI/timer?focus:FOCUS|1500|1500||run|0")
        for reply in (title, choice, timer):
            self.assertTrue(reply["ok"], reply)
        self.assertEqual(title["state_name"], "UI_TABY_ERROR")
        self.assertEqual((timer["countdown_remaining_seconds"], timer["countdown_total_seconds"]), (1500, 1500))

    def test_durations_saturate_and_clamp_instead_of_wrapping(self):
        # 536870912 s * 1000 is exactly 2^32 * 125: a 0 ms LVGL timer before.
        decor, text, replay, timer = self.ui(
            "UI/title&shooting_stars/536870912:HI",
            "UI/title~blink/99999999999999:HI",
            "UI/title!confirmation@4294967296:HI",
            "UI/timer?focus:FOCUS|99999999999999999999|4294967296||run|99999999999")
        self.assertEqual(decor["decor_effect_seconds"], 86400)
        self.assertEqual(text["text_effect_seconds"], 86400)
        self.assertEqual(replay["animation_replay_seconds"], 86400)
        self.assertEqual(timer["countdown_total_seconds"], 359999)
        self.assertEqual(timer["countdown_remaining_seconds"], 359999)
        self.assertEqual(timer["countdown_visible_seconds"], 86400)
        progress = self.ui("UI/progress:SYNC|4294967297")[0]
        self.assertEqual(progress["progress_percent"], 100)

    def test_a_card_naming_an_unknown_animation_still_shows(self):
        card = self.ui("UI/title!dizzy_loop*:HELLO")[0]
        self.assertTrue(card["ok"])
        self.assertEqual((card["title"], card["animation_id"]), ("HELLO", "dizzy_loop"))

    def test_malformed_cards_are_refused_with_a_reason(self):
        malformed = ["UI/", "UI/nope:x", "UI/title", "UI/title#zzzzzz:x", "UI/title#12:x",
                     "UI/title?" + "a" * 100 + ":x", "UI/" + "k" * 100 + ":x", "UI/title!" + "a" * 200 + ":x",
                     "UI/title@:x", "UI/title&nope:x", "UI/title~nope:x", "UI/timer:x|nan",
                     "UI/timer:x|1|2||sometimes", "UI/progress:x|-5", "UI/title=:x"]
        for reply in self.ui(*malformed):
            with self.subTest(command=reply["input"][:40]):
                self.assertFalse(reply["ok"])
                self.assertFalse(reply["rendered"])
                self.assertTrue(reply["error"])

    def test_oversized_text_is_cut_to_the_card_not_past_it(self):
        card = self.ui("UI/choice_2?c:" + "|".join(["T" * 500] * 6))[0]
        self.assertTrue(card["ok"])
        self.assertLess(len(card["title"]), 96)


class LineReaderTests(DriverTestCase):
    def lines(self, data, size=2048):
        return self.run_driver(["lines", str(size)], data)

    def test_lines_and_line_endings(self):
        events = self.lines(b"PING\r\nINFO\n\n\r\nCLEAR\r")
        self.assertEqual([event["text"] for event in events], ["PING", "INFO", "CLEAR"])

    def test_non_printable_bytes_are_dropped(self):
        self.assertEqual(self.lines(b"con\x00fir\x1bmation\xff\n")[0]["text"], "confirmation")

    def test_an_overlong_line_is_reported_once_and_its_tail_is_not_a_command(self):
        # The old loop restarted mid-line and ran the rest as a second command.
        events = self.lines(b"x" * 2100 + b"confirmation\nPING\n")
        self.assertEqual(events, [{"event": "too_long"}, {"event": "line", "text": "PING"}])

    def test_the_longest_line_that_fits(self):
        self.assertEqual(self.lines(b"a" * 2047 + b"\n")[0]["text"], "a" * 2047)
        self.assertEqual(self.lines(b"a" * 2048 + b"\n"), [{"event": "too_long"}])


class FuzzTests(DriverTestCase):
    def test_generated_input_never_crashes_any_parser(self):
        if not self.sanitized:
            self.skipTest("Sanitizers unavailable; generated input proves little without them")
        for seed in (1, 2, 3):
            with self.subTest(seed=seed):
                self.assertEqual(self.run_driver(["fuzz", str(seed), "20000"], b""), [{"fuzzed": 20000}])


if __name__ == "__main__":
    unittest.main()
