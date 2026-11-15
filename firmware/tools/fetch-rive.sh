#!/bin/bash
# Fetches the pinned Rive C++ runtime and PlutoVG into firmware/third_party/
# (git-ignored) for Taby talking live, and applies the one local Rive patch.
# Both are MIT; PlutoVG's rasterizer and stroker derive from FreeType (FTL).
set -euo pipefail
cd "$(dirname "$0")/.."
RIVE_COMMIT=60e398ba2d47f5278acd078535c8780e99bc9f74
PLUTOVG_COMMIT=f63f9b59dda96c7d1ca3c76e9b33e5ae4b91fab1
mkdir -p third_party
fetch() { # dir url commit
  if [ ! -d "third_party/$1/.git" ]; then
    git init -q "third_party/$1"
    git -C "third_party/$1" remote add origin "$2"
  fi
  git -C "third_party/$1" fetch -q --depth 1 origin "$3"
  git -C "third_party/$1" checkout -q --force FETCH_HEAD
}
fetch rive-runtime https://github.com/rive-app/rive-runtime.git "$RIVE_COMMIT"
fetch plutovg https://github.com/sammycage/plutovg.git "$PLUTOVG_COMMIT"
# On Xtensa uint32_t is unsigned long, so Rive's colorARGB/colorOpacity
# definitions no longer match their declarations.
git -C third_party/rive-runtime apply ../../patches/rive-runtime-colorint.patch
echo "third_party ready"
