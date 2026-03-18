#!/usr/bin/env python3
"""Regenerates skill-index.json from all skills/ directories."""

import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path


def extract_frontmatter(skill_md: Path) -> dict:
    """Extract YAML frontmatter fields from a SKILL.md file."""
    text = skill_md.read_text(encoding="utf-8")
    # Match content between first pair of ---
    match = re.match(r"^---\s*\n(.*?)\n---", text, re.DOTALL)
    if not match:
        return {}

    fm_text = match.group(1)
    result = {}

    # Parse simple key: value fields
    for field in ("name", "version", "author"):
        m = re.search(rf"^{field}:\s*(.+)$", fm_text, re.MULTILINE)
        if m:
            result[field] = m.group(1).strip().strip("\"'")

    # Parse description (handles multi-line with > or |)
    desc_match = re.search(r"^description:\s*(.*)$", fm_text, re.MULTILINE)
    if desc_match:
        first_line = desc_match.group(1).strip()
        if first_line in (">", "|", ">-", "|-"):
            # Collect indented continuation lines
            lines = fm_text[desc_match.end():].split("\n")
            desc_lines = []
            for line in lines:
                if line and (line[0] == " " or line[0] == "\t"):
                    desc_lines.append(line.strip())
                elif not line.strip():
                    continue
                else:
                    break
            result["description"] = " ".join(desc_lines)
        else:
            result["description"] = first_line.strip("\"'")

    # Parse tags: [tag1, tag2] or YAML list
    tags_match = re.search(r"^tags:\s*\[([^\]]*)\]", fm_text, re.MULTILINE)
    if tags_match:
        raw = tags_match.group(1)
        result["tags"] = [t.strip().strip("\"'") for t in raw.split(",") if t.strip()]
    else:
        # Try YAML list format (- item)
        tags_start = re.search(r"^tags:\s*$", fm_text, re.MULTILINE)
        if tags_start:
            tags = []
            for line in fm_text[tags_start.end():].split("\n"):
                m = re.match(r"^\s+-\s+(.+)$", line)
                if m:
                    tags.append(m.group(1).strip().strip("\"'"))
                elif line.strip() and not line.startswith(" "):
                    break
            result["tags"] = tags

    if not result.get("tags"):
        result["tags"] = ["uncategorized"]

    return result


def main():
    repo_root = Path(__file__).resolve().parent.parent
    skills_dir = repo_root / "skills"
    index_file = repo_root / "skill-index.json"

    if not skills_dir.is_dir():
        print("No skills/ directory found", file=sys.stderr)
        sys.exit(1)

    skills = []
    for skill_dir in sorted(skills_dir.iterdir()):
        if not skill_dir.is_dir():
            continue
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.exists():
            continue

        fm = extract_frontmatter(skill_md)
        if not fm.get("name"):
            print(f"WARN: Skipping {skill_dir.name} — no name in frontmatter", file=sys.stderr)
            continue

        # Read marketplace metadata (version, author, tags)
        market = {}
        market_json = skill_dir / "marketplace.json"
        if market_json.exists():
            try:
                market = json.loads(market_json.read_text(encoding="utf-8"))
            except json.JSONDecodeError:
                print(f"WARN: Invalid JSON in {market_json}", file=sys.stderr)

        skills.append({
            "name": fm.get("name", skill_dir.name),
            "description": fm.get("description", ""),
            "version": market.get("version", "0.0.0"),
            "author": market.get("author", ""),
            "tags": market.get("tags", ["uncategorized"]),
            "path": f"skills/{skill_dir.name}",
        })

    index = {
        "$schema": "./skill-index.schema.json",
        "version": "1.0.0",
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "skills": skills,
    }

    with open(index_file, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"Generated {index_file} with {len(skills)} skill(s)")


if __name__ == "__main__":
    main()
