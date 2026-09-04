"""Build one board with an already installed ESP-IDF v5.4.2 environment."""
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

from common import BOARDS, ROOT, source_digest, build_fingerprint


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("board", choices=BOARDS)
    args = parser.parse_args()
    idf = Path(os.environ.get("IDF_PATH", "")) / "tools/idf.py"
    if not idf.is_file():
        raise SystemExit("Open an ESP-IDF v5.4.2 terminal first; see firmware/README.md.")
    version = subprocess.check_output([sys.executable, str(idf), "--version"], text=True)
    if "v5.4.2" not in version:
        raise SystemExit(f"Expected ESP-IDF v5.4.2; got {version.strip()}")
    subprocess.run([sys.executable, str(ROOT / "tools/check.py")], check=True)
    before = source_digest()
    subprocess.run([sys.executable, str(idf), "-B", f"build-{args.board}",
                    "-D", f"SDKCONFIG=sdkconfig.{args.board}",
                    "-D", f"SDKCONFIG_DEFAULTS={BOARDS[args.board]['sdkconfig']}",
                    "-D", f"TABY_HARDWARE_TARGET={args.board}", "build"],
                   cwd=ROOT / "firmware", check=True)
    if source_digest() != before:
        raise SystemExit("Source/assets changed during the build. Rebuild before packaging.")
    build = ROOT / "firmware" / f"build-{args.board}"
    (build / "taby-build.json").write_text(json.dumps(build_fingerprint(args.board, build)) + "\n")


if __name__ == "__main__":
    main()
