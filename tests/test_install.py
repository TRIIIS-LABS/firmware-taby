"""Installation safety checks; no test connects to physical hardware."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from common import BOARDS, allowed_images, load_bundle
from install import flash_command, verify_info


class BundleTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.board = "round-1.32"
        self.manifest = {"schema": "taby-install-v1", "board": self.board,
                         "revision": "original", "chip": "esp32s3", "flash_size_mb": 8,
                         "firmware_version": "test", "assets_version": "test", "images": []}
        for kind, (offset, _) in allowed_images(self.board).items():
            content = (kind * 2).encode()
            (self.root / f"{kind}.bin").write_bytes(content)
            self.manifest["images"].append({"kind": kind, "file": f"{kind}.bin", "offset": offset,
                                           "size": len(content), "sha256": hashlib.sha256(content).hexdigest()})
        self.save()

    def save(self):
        (self.root / "manifest.json").write_text(json.dumps(self.manifest))

    def test_correct_bundle_never_writes_settings_or_factory_identity(self):
        _, images = load_bundle(self.root, self.board)
        self.assertEqual([offset for offset, _ in images], [0, 0x8000, 0x19000, 0x40000, 0x340000])
        command = flash_command("COM4", self.board, images)
        self.assertNotIn("erase_flash", command)
        self.assertNotIn("--force", command)
        self.assertIn("keep", command)

    def test_other_board_is_rejected(self):
        with self.assertRaises(ValueError):
            load_bundle(self.root, "amoled-1.64")

    def test_wrong_revision_is_rejected(self):
        self.manifest["revision"] = "V2"
        self.save()
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_corrupt_binary_is_rejected(self):
        (self.root / "firmware.bin").write_bytes(b"corrupt")
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_protected_partition_offset_is_rejected(self):
        self.manifest["images"][0]["offset"] = 0x1c000
        self.save()
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_missing_or_duplicated_component_is_rejected(self):
        self.manifest["images"][-1] = self.manifest["images"][0]
        self.save()
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_path_escape_is_rejected(self):
        self.manifest["images"][0]["file"] = "../bootloader.bin"
        self.save()
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_partition_overflow_is_rejected(self):
        item = self.manifest["images"][0]
        data = bytes(0x8001)
        (self.root / item["file"]).write_bytes(data)
        item.update(size=len(data), sha256=hashlib.sha256(data).hexdigest())
        self.save()
        with self.assertRaises(ValueError):
            load_bundle(self.root, self.board)

    def test_success_requires_running_firmware_readback(self):
        actual = {"hardware_target": self.board, "firmware_version": "test", "assets_version": "test"}
        self.assertEqual(verify_info(actual, self.manifest), actual)
        for field in actual:
            with self.subTest(field=field), self.assertRaises(ValueError):
                verify_info({**actual, field: "wrong"}, self.manifest)


if __name__ == "__main__":
    unittest.main()
