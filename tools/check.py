"""Check board layouts and all shipped assets without ESP-IDF or hardware."""
import json
import re
from common import BOARDS, ROOT, inside, partitions, sha256


def check_assets(board):
    root = ROOT / "assets" / board
    manifest_path = root / "manifest.json"
    manifest = json.loads(manifest_path.read_text())
    if manifest_path.stat().st_size > 16 * 1024:
        raise ValueError(f"{board}: runtime manifest exceeds firmware limit")
    metadata = manifest["catalog"]
    catalog_path = inside(root, metadata["relative_path"])
    if catalog_path.stat().st_size != metadata["byte_length"] or sha256(catalog_path) != metadata["sha256"]:
        raise ValueError(f"{board}: catalog checksum/size mismatch")
    catalog = json.loads(catalog_path.read_text())
    profile = BOARDS[board]
    if any(manifest["display"][key] != profile[key] for key in ("width", "height")):
        raise ValueError(f"{board}: wrong display geometry")
    index = {item["id"]: item["relative_path"] for item in manifest["animations"]}
    if len(index) != len(manifest["animations"]):
        raise ValueError(f"{board}: duplicate animation IDs")
    if len(catalog["animations"]) != len(index):
        raise ValueError(f"{board}: catalog/index mismatch")
    for item in catalog["animations"]:
        if not re.fullmatch(r"[a-z][a-z0-9_]{0,62}", item["id"]):
            raise ValueError("Invalid animation ID")
        if index[item["id"]] != item["relative_path"]:
            raise ValueError(f"{board}: catalog/index path mismatch")
        path = inside(root, item["relative_path"])
        if path.stat().st_size != item["byte_length"] or sha256(path) != item["sha256"]:
            raise ValueError(f"{board}: animation integrity failed: {item['id']}")
    icon_source = (ROOT / "firmware/main/generated/taby_reusable_icons.c").read_text()
    for icon, width, height in re.findall(r'"/assets/(icons/[^\"]+)"\s*,\s*(\d+)\s*,\s*(\d+)', icon_source):
        if inside(root, icon).stat().st_size != (int(width) * int(height) + 1) // 2:
            raise ValueError(f"{board}: missing or invalid icon {icon}")
    layout = partitions(board)
    previous_end = 0x9000
    for name, (offset, size) in layout.items():
        if offset < previous_end or offset + size > profile["flash_size_mb"] * 1024 * 1024:
            raise ValueError(f"{board}: overlapping/out-of-flash partition {name}")
        previous_end = offset + size
    total = sum(p.stat().st_size for p in root.rglob("*") if p.is_file())
    if total >= layout["assets"][1]:
        raise ValueError(f"{board}: raw assets exceed partition; ESP-IDF additionally checks filesystem overhead")
    print(f"{board}: {len(index)} animations, icons, catalog hashes and partition layout verified")


def check_hardware_catalog():
    catalog = json.loads((ROOT / "hardware/catalog.json").read_text())
    if catalog.get("schema") != "taby-hardware-v1":
        raise ValueError("Unsupported hardware catalog schema")
    targets = {(item.get("board"), item.get("revision")): item
               for item in catalog.get("targets", [])}
    if len(targets) != len(catalog.get("targets", [])):
        raise ValueError("Duplicate hardware catalog target")
    expected = {(board, profile["revision"]) for board, profile in BOARDS.items()}
    if set(targets) != expected:
        raise ValueError("Hardware catalog targets do not match supported boards")
    for board, profile in BOARDS.items():
        target = targets[(board, profile["revision"])]
        display = target.get("display", {})
        if (display.get("width_px"), display.get("height_px")) != (profile["width"], profile["height"]):
            raise ValueError(f"{board}: hardware catalog display geometry mismatch")
        if target.get("status") not in ("planned", "prototype", "verified"):
            raise ValueError(f"{board}: invalid hardware model status")
        if not isinstance(target.get("models"), list):
            raise ValueError(f"{board}: hardware models must be a list")
        for model in target["models"]:
            manifest_path = inside(ROOT / "hardware", model["manifest"])
            manifest = json.loads(manifest_path.read_text())
            if (manifest.get("schema"), manifest.get("board"), manifest.get("revision")) != (
                    "taby-print-v1", board, profile["revision"]):
                raise ValueError(f"{board}: print manifest target mismatch")
            if manifest.get("id") != model["id"] or manifest.get("version") != model["version"]:
                raise ValueError(f"{board}: print catalog/manifest mismatch")
            if not manifest.get("files"):
                raise ValueError(f"{board}: empty print pack")
            for entry in manifest["files"]:
                path = inside(manifest_path.parent, entry["file"])
                if path.stat().st_size != entry["size"] or sha256(path) != entry["sha256"]:
                    raise ValueError(f"{board}: print file integrity failed: {entry['file']}")
    print("hardware: board revisions and display geometry verified")


if __name__ == "__main__":
    for board in BOARDS:
        check_assets(board)
    check_hardware_catalog()
