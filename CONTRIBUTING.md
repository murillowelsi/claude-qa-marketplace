# Contributing

## Adding a New Skill

1. Create a directory under the appropriate plugin's `skills/` folder using kebab-case: `qa-toolkit/skills/your-skill-name/`.
2. Copy `templates/SKILL_TEMPLATE.md` to `qa-toolkit/skills/your-skill-name/SKILL.md`.
3. Fill in the frontmatter fields and write your instructions.
4. Run `./scripts/validate-skill.sh qa-toolkit/skills/your-skill-name` and fix any issues.
5. Open a PR. CI will validate structure and frontmatter.

## Updating an Existing Skill

- Preserve the original `name` field in frontmatter.
- Document what changed in the PR description.

## Style

- Write SKILL.md instructions in imperative voice directed at Claude, not at the user.
- Keep instructions concrete and actionable. Avoid vague guidance like "be helpful."
- If a skill needs more than 500 lines, split into SKILL.md (workflow + routing) and `references/` files (domain detail).
