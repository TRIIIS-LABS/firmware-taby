"""Exercise chunked serial replies with a fake port; never opens real hardware."""
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
try:
    import device
except SystemExit:
    device = None


class FakePort:
    """Models the control lines as a POSIX kernel and pyserial drive them.

    Opening asserts DTR and RTS; pyserial then applies any lines set before
    opening, DTR first. `lines` records every (dtr, rts) state while open.
    """
    def __init__(self, chunks):
        self.chunks = list(chunks)
        self.in_waiting = 4
        self.opened = False
        self.closed = False
        self.sent = b""
        self.preset = {}
        self.lines = []
        self._dtr = self._rts = None

    @property
    def dtr(self):
        return self._dtr

    @dtr.setter
    def dtr(self, value):
        self._set_line("dtr", value)

    @property
    def rts(self):
        return self._rts

    @rts.setter
    def rts(self, value):
        self._set_line("rts", value)

    def _set_line(self, name, value):
        setattr(self, "_" + name, value)
        if self.opened:
            self.lines.append((self._dtr, self._rts))
        else:
            self.preset[name] = value

    def open(self):
        self.opened = True
        self._dtr = self._rts = True
        self.lines.append((True, True))
        for name in ("dtr", "rts"):
            if name in self.preset:
                setattr(self, name, self.preset[name])

    def reset_input_buffer(self):
        pass

    def write(self, data):
        self.sent += data

    def flush(self):
        pass

    def read(self, size):
        return self.chunks.pop(0) if self.chunks else b""

    def close(self):
        self.closed = True


@unittest.skipIf(device is None, "Install tools/requirements.txt to test the serial helper")
class DeviceTests(unittest.TestCase):
    def test_supported_firmware_metadata_selects_target_without_claiming_physical_detection(self):
        result = device.identify({"hardware_target": "amoled-1.64",
                                  "display_width": 280, "display_height": 456,
                                  "setup_ap_password": "private"})
        self.assertEqual(result["board"], "amoled-1.64")
        self.assertEqual(result["revision"], "V1")
        self.assertFalse(result["physical_revision_verified"])
        self.assertNotIn("setup_ap_password", result["device"])

    def test_legacy_firmware_does_not_guess_from_asset_version(self):
        result = device.identify({"firmware_version": "1.0.6", "assets_version": "0.3.2"})
        self.assertEqual(result["status"], "unknown")
        self.assertIsNone(result["board"])

    def test_unknown_target_and_conflicting_geometry_do_not_select_a_bundle(self):
        for actual in ({"hardware_target": "amoled-1.64-v2"},
                       {"hardware_target": "amoled-1.64", "display_width": 466}):
            with self.subTest(actual=actual):
                self.assertIsNone(device.identify(actual)["board"])

    def test_opening_the_port_never_signals_a_reset(self):
        # ESP32-S3 USB-Serial-JTAG resets the chip while RTS is asserted and DTR is not.
        port = FakePort([b"TABY:PONG\n"])
        with patch.object(device.os, "name", "posix"), \
                patch.object(device.serial, "Serial", return_value=port):
            device.exchange("test-port", "PING", "TABY:")
        self.assertNotIn((False, True), port.lines)
        self.assertEqual(port.lines[-1], (False, False))

    def test_windows_deasserts_the_lines_before_opening(self):
        port = FakePort([b"TABY:PONG\n"])
        with patch.object(device.os, "name", "nt"), \
                patch.object(device.serial, "Serial", return_value=port):
            device.exchange("test-port", "PING", "TABY:")
        self.assertEqual(port.preset, {"dtr": False, "rts": False})
        self.assertEqual(port.lines[-1], (False, False))

    def test_chunked_info_filters_private_fields_and_closes_port(self):
        port = FakePort([b"boot log\nTABY:IN", b'FO {"firmware_version":"test",',
                         b'"setup_ap_password":"test-secret"}', b"\r\n"])
        with patch.object(device.serial, "Serial", return_value=port):
            self.assertEqual(device.info("test-port"), {"firmware_version": "test"})
        self.assertEqual(port.sent, b"INFO\n")
        self.assertTrue(port.closed)

    def test_error_closes_port_without_echoing_raw_response(self):
        port = FakePort([b"TABY:ERR arbitrary-private-detail\n"])
        with patch.object(device.serial, "Serial", return_value=port):
            with self.assertRaisesRegex(ValueError, "^Device rejected the command$"):
                device.info("test-port")
        self.assertTrue(port.closed)

    def test_animation_the_board_lacks_is_reported_not_claimed(self):
        port = FakePort([b"TABY:OK IDLE unsupported_animation dizzy_loop\n"])
        with patch.object(device.serial, "Serial", return_value=port):
            with self.assertRaisesRegex(ValueError, "does not have that animation"):
                device.play_animation("test-port", "dizzy_loop")
        self.assertEqual(port.sent, b"dizzy_loop\n")
        self.assertTrue(port.closed)

    def test_animation_played(self):
        port = FakePort([b"TABY:OK ANIMATION\n"])
        with patch.object(device.serial, "Serial", return_value=port):
            self.assertTrue(device.play_animation("test-port", "confirmation")["accepted"])

    def test_eye_motion_is_set_and_read_back(self):
        port = FakePort([b'TABY:EYE_MOTION {"mode":"calm","modes":["normal","calm","still"]}\n'])
        with patch.object(device.serial, "Serial", return_value=port):
            self.assertEqual(device.eye_motion("test-port", "calm"), {"eye_motion": "calm"})
        self.assertEqual(port.sent, b"EYE_MOTION calm\n")

    def test_eye_motion_on_older_firmware_says_what_to_install(self):
        port = FakePort([b"TABY:ERR unsupported_command EYE_MOTION?\n"])
        with patch.object(device.serial, "Serial", return_value=port):
            with self.assertRaisesRegex(ValueError, "install 1.2.0"):
                device.eye_motion("test-port")
        self.assertEqual(port.sent, b"EYE_MOTION?\n")
        with self.assertRaisesRegex(ValueError, "normal, calm or still"):
            device.eye_motion("test-port", "sleepy")


if __name__ == "__main__":
    unittest.main()
