"""Shared board and release validation. No device operations."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BOARDS = json.loads((ROOT / "firmware/boards.json").read_text())


def sha256(path):
    with Path(path).open("rb") as stream:
        digest = hashlib.sha256()
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
        return digest.hexdigest()


def inside(root, name):
    root = Path(root).resolve()
    path = (root / name).resolve()
    if not path.is_relative_to(root) or path == root:
        raise ValueError(f"Path escapes its directory: {name}")
    return path


def source_digest():
    """Bind a release to all firmware/asset inputs present during its build."""
    paths = list((ROOT / "assets").rglob("*"))
    paths += list((ROOT / "firmware/main").rglob("*"))
    paths += list((ROOT / "firmware/targets").rglob("*"))
    paths += [ROOT / "firmware" / name for name in
              ("boards.json", "CMakeLists.txt", "sdkconfig.defaults", "partitions.csv")]
    digest = hashlib.sha256()
    for path in sorted(p for p in paths if p.is_file()):
        digest.update(path.relative_to(ROOT).as_posix().encode())
        digest.update(sha256(path).encode())
    return digest.hexdigest()


def build_fingerprint(board, build):
    flash = json.loads((build / "flasher_args.json").read_text())
    return {
        "board": board,
        "source_sha256": source_digest(),
        "config_sha256": sha256(ROOT / "firmware" / f"sdkconfig.{board}"),
        "dependencies_sha256": sha256(ROOT / "firmware/dependencies.lock"),
        "images": {name: sha256(inside(build, name))
                   for name in flash["flash_files"].values()},
    }


def partitions(board):
    result = {}
    path = ROOT / "firmware" / BOARDS[board]["partitions"]
    for line in path.read_text().splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        name, _, _, offset, size, *_ = [part.strip() for part in line.split(",")]
        result[name] = (int(offset, 0), int(size, 0))
    return result


def allowed_images(board):
    layout = partitions(board)
    return {
        "bootloader": (0, 0x8000),
        "partition-table": (0x8000, 0x1000),
        "ota-data": layout["otadata"],
        "firmware": layout["ota_0"],
        "assets": layout["assets"],
    }


def load_bundle(directory, board):
    directory = Path(directory).resolve()
    manifest = json.loads((directory / "manifest.json").read_text())
    profile = BOARDS[board]
    if manifest.get("schema") != "taby-install-v1":
        raise ValueError("Unsupported installation manifest")
    for key, expected in (("board", board), ("chip", profile["chip"]),
                          ("flash_size_mb", profile["flash_size_mb"]),
                          ("revision", profile["revision"])):
        if manifest.get(key) != expected:
            raise ValueError(f"Release {key} does not match selected board")
    for key in ("firmware_version", "assets_version"):
        if not isinstance(manifest.get(key), str) or not manifest[key]:
            raise ValueError(f"Missing {key}")
    allowed = allowed_images(board)
    images = manifest.get("images", [])
    if len(images) != len(allowed) or {x["kind"] for x in images} != set(allowed):
        raise ValueError("Release must contain exactly the five installation images")
    files = []
    for entry in images:
        offset, capacity = allowed[entry["kind"]]
        if type(entry["offset"]) is not int or entry["offset"] != offset:
            raise ValueError(f"Wrong offset for {entry['kind']}")
        path = inside(directory, entry["file"])
        if path.suffix != ".bin" or not path.is_file():
            raise ValueError(f"Missing binary: {entry['kind']}")
        size = path.stat().st_size
        if size <= 0 or size > capacity or size != entry["size"]:
            raise ValueError(f"Invalid size for {entry['kind']}")
        if sha256(path) != entry["sha256"]:
            raise ValueError(f"Checksum mismatch for {entry['kind']}")
        files.append((offset, path))
    if len({path for _, path in files}) != len(files):
        raise ValueError("Release reuses an image path")
    return manifest, sorted(files)
