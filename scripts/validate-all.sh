#!/usr/bin/env bash
set -euo pipefail

# Validates all skills across all plugins.
# Usage: ./scripts/validate-all.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
FAILED=0

for plugin_dir in "$REPO_ROOT"/*/; do
  skills_dir="$plugin_dir/skills"
  [[ -d "$skills_dir" ]] || continue

  for skill_dir in "$skills_dir"/*/; do
    [[ -d "$skill_dir" ]] || continue
    echo "=== Validating $skill_dir ==="
    "$SCRIPT_DIR/validate-skill.sh" "$skill_dir" || FAILED=1
    echo
  done
done

if (( FAILED )); then
  echo "Some skills failed validation."
  exit 1
else
  echo "All skills passed validation."
fi
