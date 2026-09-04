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
    def __init__(self, chunks):
        self.chunks = list(chunks)
        self.in_waiting = 4
        self.opened = False
        self.closed = False
        self.sent = b""

    def open(self):
        assert self.dtr is False and self.rts is False
        self.opened = True

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


if __name__ == "__main__":
    unittest.main()
