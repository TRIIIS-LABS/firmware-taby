"""Bounded USB discovery and Taby INFO/animation commands; never flashes."""
import argparse
import json
import re
import time

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    raise SystemExit("Run tools/bootstrap.py, then use the .venv Python from INSTALL.md.")

SAFE_INFO = (
    "firmware_version", "assets_version", "hardware_target", "display_shape",
    "display_width", "display_height", "preferred_transport",
    "transport_onboarding_complete", "usb_bridge_ready", "identity_source",
)


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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="action", required=True)
    sub.add_parser("ports", help="List ports without opening or resetting them")
    for action in ("info", "animation"):
        command = sub.add_parser(action)
        command.add_argument("--port", required=True)
        if action == "animation":
            command.add_argument("--id", required=True)
    args = parser.parse_args()
    if args.action == "ports":
        print(json.dumps([{"port": p.device, "description": p.description,
                           "vid": p.vid, "pid": p.pid}
                          for p in list_ports.comports()], indent=2))
    elif args.action == "info":
        print(json.dumps(info(args.port), indent=2))
    else:
        if not re.fullmatch(r"[a-z][a-z0-9_]{0,62}", args.id):
            raise ValueError("Use an animation ID from this board's asset manifest")
        exchange(args.port, args.id, "TABY:OK ")
        print(json.dumps({"accepted": True, "animation": args.id,
                          "visual_verification": "Ask the user to confirm the screen"}))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, TimeoutError, serial.SerialException, OSError) as error:
        raise SystemExit(str(error))
