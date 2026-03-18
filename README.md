# QA Plugins Marketplace

A Claude Code plugin marketplace focused on QA engineering workflows and testing tools.

## Architecture

```
Plugin marketplace (this repo)          Target project repo
─────────────────────────────           ──────────────────────
qa-toolkit plugin                       CLAUDE.md
  skills/                                 → Project key, test environment,
    assess-risk/SKILL.md                    build cmds, architecture
    ...future skills
                                        .claude/settings.json
                                          → Permissions allowlist

                                        .claude/rules/
                                          → Always-on constraints
```

## Installation

### One-time marketplace setup

```bash
claude plugin marketplace add your-org/qa-plugins
```

For private repo access, ensure `GH_TOKEN` or `GITHUB_TOKEN` is set in your shell environment for background auto-updates.

### Per-project setup

```bash
# Install QA toolkit (user scope — works across all repos)
claude plugin install qa-toolkit@qa-plugins --scope user

# Or install for a specific project only
claude plugin install qa-toolkit@qa-plugins --scope project
```

### Updating plugins

```bash
# Pull latest marketplace catalog
claude plugin marketplace update qa-plugins

# Reinstall plugins to pick up new versions
claude plugin install qa-toolkit@qa-plugins --scope user
```

## Available Plugins

### qa-toolkit

Cross-stack QA toolkit for test planning, risk assessment, and quality engineering.

**Skills:**
- `assess-risk` — Assess risk and prioritise test cases using ISTQB risk-based testing (Likelihood × Impact)

## Adding a New Skill

1. Create `qa-toolkit/skills/{skill-name}/SKILL.md` with frontmatter (`name`, `description`) and instructions.
2. Bump the version in `qa-toolkit/.claude-plugin/plugin.json`.
3. Update this README with the new skill description.

## Adding a New Plugin

1. Create `{plugin-name}/` directory with `.claude-plugin/plugin.json`.
2. Add skills under `skills/`.
3. Register the plugin in `.claude-plugin/marketplace.json`.
4. Document installation in this README.

---

This is a living repository. Additions, corrections, and discussions are welcome via PR.
