#!/usr/bin/env bash
set -euo pipefail
ASHEN_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec godot --path "$ASHEN_ROOT" "$@"
