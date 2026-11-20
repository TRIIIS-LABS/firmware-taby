#!/usr/bin/env python
"""Refresh the size and checksum of every file listed in print.json. Run it after rebuilding the hats."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
path = HERE / "print.json"
manifest = json.loads(path.read_text())
for entry in manifest["files"]:
    data = (HERE / entry["file"]).read_bytes()
    entry["size"], entry["sha256"] = len(data), hashlib.sha256(data).hexdigest()
path.write_text(json.dumps(manifest, indent=2) + "\n")
print(f"{len(manifest['files'])} files recorded")
