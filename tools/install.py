"""Validate, flash, and verify a locally downloaded official Taby release."""
import argparse
import json
import re
import subprocess
import sys
import time

from common import BOARDS, load_bundle


def flash_command(port, board, files):
    args = [sys.executable, "-m", "esptool", "--chip", "esp32s3", "--port", port,
            "--baud", "460800", "--before", "default_reset", "--after", "hard_reset",
            "write_flash", "--flash_mode", "keep", "--flash_freq", "keep",
            "--flash_size", "keep"]
    for offset, path in files:
        args.extend([hex(offset), str(path)])
    return args


def verify_info(actual, expected):
    for key, value in (("hardware_target", expected["board"]),
                       ("firmware_version", expected["firmware_version"]),
                       ("assets_version", expected["assets_version"])):
        if actual.get(key) != value:
            raise ValueError(f"Device {key} does not match the release; installation is not verified")
    return actual


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("inspect", "flash", "verify"))
    parser.add_argument("--bundle", required=True)
    parser.add_argument("--board", required=True, choices=BOARDS)
    parser.add_argument("--port")
    parser.add_argument("--confirmed-board", action="store_true",
                        help="The user has identified this exact board/revision and requested installation")
    args = parser.parse_args()
    manifest, files = load_bundle(args.bundle, args.board)
    print(json.dumps({"board": manifest["board"], "revision": manifest["revision"],
                      "firmware": manifest["firmware_version"], "assets": manifest["assets_version"],
                      "images": [{"offset": hex(o), "file": p.name} for o, p in files],
                      "settings": "NVS and factory identity partitions are not written"}, indent=2))
    if args.action == "inspect":
        return
    if not args.port:
        parser.error("--port is required; use tools/device.py ports to identify it")
    from device import info
    if args.action == "flash":
        if not args.confirmed_board:
            parser.error("Identify the board and revision with the user, then pass --confirmed-board")
        # esptool's ROM read resets the device but does not write flash. A generic
        # ESP32-S3 chip ID cannot distinguish a round board or the 1.64 V1/V2.
        probe = subprocess.run([sys.executable, "-m", "esptool", "--chip", "esp32s3",
                                "--port", args.port, "flash_id"], capture_output=True, text=True)
        if probe.returncode:
            raise ValueError("ESP32-S3 connection failed. Check USB drivers/permissions and BOOT instructions in INSTALL.md.")
        capacity = re.search(r"Detected flash size:\s*(\d+)MB", probe.stdout)
        if not capacity or int(capacity[1]) != BOARDS[args.board]["flash_size_mb"]:
            raise ValueError("Flash capacity does not match the selected board. Nothing was written.")
        subprocess.run(flash_command(args.port, args.board, files), check=True)
        print("Flash write completed; checking the running firmware...")
        time.sleep(2)
    failure = None
    for _ in range(3):
        try:
            actual = verify_info(info(args.port), manifest)
            print(json.dumps({"verified": True, "device": actual}, indent=2))
            return
        except (ValueError, OSError, TimeoutError) as error:
            failure = error
            time.sleep(1)
    raise ValueError(f"Not verified: {failure}. Reset if needed, list ports again, and run verify with the current port. Do not reflash just because the port changed.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, KeyError, subprocess.CalledProcessError) as error:
        raise SystemExit(str(error))
