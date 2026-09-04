"""Package ESP-IDF's actual flash outputs; never infer offsets from filenames."""
import argparse
import json
import os
import re
import shutil
import subprocess
import zipfile
from pathlib import Path

from common import BOARDS, ROOT, allowed_images, inside, load_bundle, sha256, build_fingerprint


def copy_dependency_notices(destination, description):
    """Ship upstream license files alongside statically linked binary images."""
    paths = description.get("build_component_paths", [])
    for directory in paths:
        component = Path(directory)
        for current, _, names in os.walk(component):
            for name in sorted(names):
                upper = name.upper()
                if not upper.startswith(("LICENSE", "LICENCE", "COPYING", "NOTICE")):
                    continue
                source = Path(current) / name
                # Preserve text license documents, not executable names or pictures.
                if source.suffix.lower() not in ("", ".txt", ".md", ".rst"):
                    continue
                target = destination / "licenses" / component.name / source.relative_to(component)
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(source, target)
    idf_license = Path(os.environ.get("IDF_PATH", "")) / "LICENSE"
    if idf_license.is_file():
        target = destination / "licenses/esp-idf/LICENSE"
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(idf_license, target)


def package(board, build, output):
    profile = BOARDS[board]
    stamp = json.loads((build / "taby-build.json").read_text())
    if stamp != build_fingerprint(board, build):
        raise ValueError("Source, configuration, dependencies or binaries changed since the build. Run tools/build.py again.")
    flash = json.loads((build / "flasher_args.json").read_text())
    description = json.loads((build / "project_description.json").read_text())
    sdkconfig = inside(ROOT / "firmware", f"sdkconfig.{board}").read_text()
    if f"CONFIG_ESPTOOLPY_FLASHSIZE_{profile['flash_size_mb']}MB=y" not in sdkconfig:
        raise ValueError("Build sdkconfig does not match selected board")
    cache = (build / "CMakeCache.txt").read_text()
    if not re.search(rf"^TABY_HARDWARE_TARGET:[^=]+={re.escape(board)}$", cache, re.M):
        raise ValueError("Build target does not match selected board")
    if description.get("target") != "esp32s3":
        raise ValueError("Build is not for ESP32-S3")
    source = (ROOT / "firmware/main/taby_build_info.c").read_text()
    version = re.search(r'TABY_FIRMWARE_VERSION = "([^"]+)"', source)[1]
    if description.get("project_version") != version:
        raise ValueError("Application metadata does not match the reported firmware version; rebuild")
    assets = json.loads((ROOT / "assets" / board / "manifest.json").read_text())
    manifest = {"schema": "taby-install-v1", "board": board,
                "revision": profile["revision"], "chip": "esp32s3",
                "flash_size_mb": profile["flash_size_mb"],
                "firmware_version": version, "assets_version": assets["version"],
                "source_sha256": stamp["source_sha256"],
                "source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
                "source_dirty": bool(subprocess.check_output(["git", "status", "--porcelain"], cwd=ROOT, text=True).strip()),
                "images": []}
    destination = output / f"taby-{board}"
    destination.mkdir(parents=True, exist_ok=False)
    expected = {offset: kind for kind, (offset, _) in allowed_images(board).items()}
    actual = {int(offset, 0): path for offset, path in flash["flash_files"].items()}
    if set(actual) != set(expected):
        raise ValueError("Build flash map differs from reviewed board layout")
    for offset, name in actual.items():
        original = inside(build, name)
        kind = expected[offset]
        target = destination / f"{kind}.bin"
        shutil.copyfile(original, target)
        manifest["images"].append({"kind": kind, "file": target.name, "offset": offset,
                                   "size": target.stat().st_size, "sha256": sha256(target)})
    (destination / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    shutil.copyfile(ROOT / "LICENSE", destination / "LICENSE")
    shutil.copyfile(ROOT / "firmware/NOTICE", destination / "NOTICE")
    copy_dependency_notices(destination, description)
    load_bundle(destination, board)
    archive = output / f"taby-{board}.zip"
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as bundle:
        for path in sorted(destination.rglob("*")):
            if path.is_file():
                bundle.write(path, path.relative_to(destination).as_posix())
    (output / f"{archive.name}.sha256").write_text(f"{sha256(archive)}  {archive.name}\n")
    print(archive)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("board", choices=BOARDS)
    parser.add_argument("--output", type=Path, default=ROOT / "dist")
    args = parser.parse_args()
    package(args.board, ROOT / "firmware" / f"build-{args.board}", args.output)
