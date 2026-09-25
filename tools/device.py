"""Bounded USB discovery and Taby INFO/animation commands; never flashes."""
import argparse
import json
import re
import time
from common import BOARDS

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    raise SystemExit("Run tools/bootstrap.py, then use the .venv Python from INSTALL.md.")

SAFE_INFO = (
    "firmware_version", "assets_version", "hardware_target", "display_shape",
    "display_width", "display_height", "preferred_transport",
    "transport_onboarding_complete", "usb_bridge_ready", "identity_source",
    "eye_motion",
)
EYE_MOTIONS = ("normal", "calm", "still")


def exchange(port, command, prefix, timeout=6):
    connection = serial.Serial(port=None, baudrate=115200, timeout=0.15,
                               write_timeout=2)
    connection.dtr = False
    connection.rts = False
    connection.port = port
    connection.open()
    try:
        connection.reset_input_buffer()
        connection.write((command + "\n").encode("utf-8"))
        connection.flush()
        deadline = time.monotonic() + timeout
        buffer = bytearray()
        while time.monotonic() < deadline:
            buffer.extend(connection.read(min(connection.in_waiting or 1, 4096)))
            if len(buffer) > 65536:
                raise ValueError("Device response exceeded the size limit")
            while b"\n" in buffer:
                line, _, rest = buffer.partition(b"\n")
                buffer = bytearray(rest)
                text = line.decode("utf-8", errors="replace").strip()
                if text.startswith("TABY:ERR"):
                    raise ValueError("Device rejected the command")
                if text.startswith(prefix):
                    return text[len(prefix):].strip()
        raise TimeoutError("No Taby response. Close other serial clients, check the port, and see INSTALL.md.")
    finally:
        connection.close()


def info(port):
    raw = json.loads(exchange(port, "INFO", "TABY:INFO "))
    return {key: raw[key] for key in SAFE_INFO if key in raw}


def play_animation(port, animation_id):
    """Ask for one animation; firmware 1.1.1 and later say when the board lacks it."""
    if not re.fullmatch(r"[a-z][a-z0-9_]{0,62}", animation_id):
        raise ValueError("Use an animation ID from this board's asset manifest")
    reply = exchange(port, animation_id, "TABY:OK ")
    if " unsupported_animation " in f" {reply} ":
        raise ValueError("This board does not have that animation. Use an ID from its asset manifest")
    return {"accepted": True, "animation": animation_id,
            "visual_verification": "Ask the user to confirm the screen"}


def eye_motion(port, mode=None):
    """Read, or set and read back, how much the resting face's eyes move (1.2.0+)."""
    if mode is not None and mode not in EYE_MOTIONS:
        raise ValueError("Use normal, calm or still")
    command = "EYE_MOTION?" if mode is None else f"EYE_MOTION {mode}"
    try:
        reply = json.loads(exchange(port, command, "TABY:EYE_MOTION "))
    except ValueError as error:
        if str(error) == "Device rejected the command":
            raise ValueError("This firmware has no eye-motion setting; install 1.2.0 or later") from None
        raise
    return {"eye_motion": reply.get("mode")}


def identify(actual):
    """Interpret firmware metadata without pretending it measures PCB wiring."""
    actual = {key: actual[key] for key in SAFE_INFO if key in actual}
    target = actual.get("hardware_target")
    profile = BOARDS.get(target) if isinstance(target, str) else None
    result = {"device": actual, "board": None, "revision": None,
              "physical_revision_verified": False}
    if not target:
        return {**result, "status": "unknown",
                "next_step": "No hardware target reported. Identify the PCB marking or purchase record; firmware/assets versions and USB IDs are not revision proof."}
    if profile is None:
        return {**result, "status": "unsupported",
                "next_step": "Reported target is not supported by this installer. Do not substitute another board's bundle."}
    for field, expected in (("display_width", profile["width"]),
                            ("display_height", profile["height"])):
        if field in actual and actual[field] != expected:
            return {**result, "status": "conflict",
                    "next_step": "Display dimensions conflict with the reported target. Resolve the mismatch before flashing."}
    return {**result, "status": "firmware_target", "board": target,
            "revision": profile["revision"], "evidence": "running_firmware_metadata",
            "next_step": "Use this target for an update if the existing display is working correctly. This identifies the installed build, not an independent PCB revision measurement."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="action", required=True)
    sub.add_parser("ports", help="List ports without opening or resetting them")
    for action in ("info", "identify", "animation", "eye-motion", "reset"):
        command = sub.add_parser(action)
        command.add_argument("--port", required=True)
        if action == "animation":
            command.add_argument("--id", required=True)
        if action == "eye-motion":
            command.add_argument("--mode", choices=EYE_MOTIONS,
                                 help="Omit to read the current setting")
    args = parser.parse_args()
    if args.action == "ports":
        print(json.dumps([{"port": p.device, "description": p.description,
                           "vid": p.vid, "pid": p.pid}
                          for p in list_ports.comports()], indent=2))
    elif args.action == "info":
        print(json.dumps(info(args.port), indent=2))
    elif args.action == "identify":
        print(json.dumps(identify(info(args.port)), indent=2))
    elif args.action == "eye-motion":
        print(json.dumps(eye_motion(args.port, args.mode)))
    elif args.action == "reset":
        from esptool.reset import HardReset
        connection = serial.Serial(port=None, baudrate=115200, timeout=0.2)
        connection.dtr = False
        connection.rts = False
        connection.port = args.port
        connection.open()
        try:
            HardReset(connection, uses_usb=True)()
        finally:
            connection.close()
        print(json.dumps({"reset_requested": True,
                          "next_step": "Wait for boot, list ports, then run install.py verify."}))
    else:
        print(json.dumps(play_animation(args.port, args.id)))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, TimeoutError, serial.SerialException, OSError) as error:
        raise SystemExit(str(error))
