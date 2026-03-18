#!/usr/bin/env bash
set -euo pipefail

# Regenerates skill-index.json from all skills/ directories.
# Usage: ./scripts/generate-index.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec python3 "$SCRIPT_DIR/generate-index.py"
