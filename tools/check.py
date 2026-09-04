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


if __name__ == "__main__":
    for board in BOARDS:
        check_assets(board)
