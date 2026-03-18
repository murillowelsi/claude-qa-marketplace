#!/usr/bin/env bash
set -euo pipefail

# Validates a skill directory for marketplace compliance.
# Usage: ./scripts/validate-skill.sh qa-toolkit/skills/assess-risk

SKILL_DIR="${1:?Usage: validate-skill.sh <skill-directory>}"
SKILL_MD="$SKILL_DIR/SKILL.md"
ERRORS=0

err() { echo "ERROR: $1"; ((ERRORS++)); }
warn() { echo "WARN:  $1"; }

# --- Structure checks ---
[[ -d "$SKILL_DIR" ]] || { err "Directory $SKILL_DIR does not exist"; exit 1; }
[[ -f "$SKILL_MD" ]] || { err "SKILL.md not found in $SKILL_DIR"; exit 1; }

DIR_NAME=$(basename "$SKILL_DIR")
if [[ ! "$DIR_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  err "Directory name '$DIR_NAME' is not valid kebab-case"
fi

# --- Frontmatter checks ---
# Extract YAML frontmatter (between first pair of ---)
FRONTMATTER=$(awk '/^---$/{if(n++)exit;next}n' "$SKILL_MD")

if [[ -z "$FRONTMATTER" ]]; then
  err "No YAML frontmatter found (must be between --- delimiters)"
else
  for field in name description; do
    if ! echo "$FRONTMATTER" | grep -qE "^${field}:"; then
      err "Missing required frontmatter field: $field"
    fi
  done

  # Check name matches directory
  FM_NAME=$(echo "$FRONTMATTER" | grep -E "^name:" | sed 's/^name:[[:space:]]*//')
  if [[ -n "$FM_NAME" && "$FM_NAME" != "$DIR_NAME" ]]; then
    err "Frontmatter name '$FM_NAME' does not match directory name '$DIR_NAME'"
  fi
fi

# --- Size checks ---
LINE_COUNT=$(wc -l < "$SKILL_MD")
if (( LINE_COUNT > 500 )); then
  warn "SKILL.md is $LINE_COUNT lines (recommended: <500). Consider splitting into references/"
fi

# --- Script checks ---
if [[ -d "$SKILL_DIR/scripts" ]]; then
  for script in "$SKILL_DIR/scripts"/*; do
    [[ -f "$script" ]] || continue
    if [[ ! -x "$script" ]]; then
      err "Script $script is not executable (chmod +x)"
    fi
    if ! head -1 "$script" | grep -qE '^#!'; then
      warn "Script $script has no shebang line"
    fi
  done
fi

# --- Result ---
echo "---"
if (( ERRORS > 0 )); then
  echo "FAILED: $ERRORS error(s) found in $SKILL_DIR"
  exit 1
else
  echo "PASSED: $SKILL_DIR is valid"
  exit 0
fi
