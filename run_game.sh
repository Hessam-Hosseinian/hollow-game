#!/usr/bin/env bash
set -euo pipefail
ASHEN_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$ASHEN_ROOT/.godot/imported" ]; then
  godot --headless --editor --path "$ASHEN_ROOT" --quit-after 120
fi
exec godot --path "$ASHEN_ROOT" "$@"
