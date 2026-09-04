"""Install the ESP32 flashing and serial dependencies in a local environment."""
import subprocess
import sys
from pathlib import Path


def main():
    if sys.version_info < (3, 11):
        raise SystemExit("Install Python 3.11 or newer from https://www.python.org/downloads/")
    root = Path(__file__).resolve().parents[1]
    env = root / ".venv"
    python = env / ("Scripts/python.exe" if sys.platform == "win32" else "bin/python")
    if not python.exists():
        subprocess.run([sys.executable, "-m", "venv", str(env)], check=True)
    subprocess.run([str(python), "-m", "pip", "install", "-r",
                    str(root / "tools/requirements.txt")], check=True)
    subprocess.run([str(python), "-m", "esptool", "version"], check=True)
    print(f"Ready. Use this Python for the remaining commands: {python}")
    print("Next: run tools/device.py ports. USB driver troubleshooting is in INSTALL.md.")


if __name__ == "__main__":
    main()
