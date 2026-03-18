#!/usr/bin/env bash
set -euo pipefail

# Packages a skill directory into a .skill file (tar.gz archive).
# Usage: ./scripts/package-skill.sh skills/my-skill [output-dir]

SKILL_DIR="${1:?Usage: package-skill.sh <skill-directory> [output-dir]}"
OUTPUT_DIR="${2:-.}"
SKILL_NAME=$(basename "$SKILL_DIR")

if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
  echo "ERROR: $SKILL_DIR/SKILL.md not found" >&2
  exit 1
fi

# Validate first
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"$SCRIPT_DIR/validate-skill.sh" "$SKILL_DIR" || {
  echo "ERROR: Validation failed. Fix errors before packaging." >&2
  exit 1
}

# Package
OUTPUT_FILE="$OUTPUT_DIR/${SKILL_NAME}.skill"
tar -czf "$OUTPUT_FILE" -C "$(dirname "$SKILL_DIR")" "$SKILL_NAME"

echo "Packaged: $OUTPUT_FILE ($(du -h "$OUTPUT_FILE" | cut -f1))"
