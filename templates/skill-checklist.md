# Skill Pre-Publish Checklist

## Structure
- [ ] Skill directory uses kebab-case naming
- [ ] `SKILL.md` exists at the root of the skill directory
- [ ] YAML frontmatter contains: `name`, `description`
- [ ] `name` in frontmatter matches directory name
- [ ] Description includes trigger phrases and contexts (not just a summary)

## Content Quality
- [ ] SKILL.md body is under 500 lines
- [ ] Instructions are in imperative voice directed at Claude
- [ ] No hardcoded paths, credentials, or PII
- [ ] No environment-specific assumptions

## Resources (if applicable)
- [ ] Scripts have shebang lines and are executable (`chmod +x`)
- [ ] Reference files are pointed to from SKILL.md with "when to read" guidance
