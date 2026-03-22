---
name: "changelog"
description: "Generate or update a changelog entry from recent commits. Use when the user asks for release notes, a changelog update, or a summary of changes since the last tag."
---

# Changelog

Use this skill to turn commit history into a structured changelog entry that matches the repository’s existing format.

## Workflow

1. Inspect the latest tag, recent commits, and the current changelog before writing.
2. Run `scripts/collect-changes.sh` to collect structured change data.
3. Classify commits into user-facing categories and omit internal noise.
4. Prepend the new entry using the repository’s existing changelog format.

## Quality rules

- Keep user-facing changes, not every internal commit.
- Respect breaking changes and version inference.
- Match the existing changelog style exactly.

## Resources

- `scripts/collect-changes.sh` gathers the structured commit data.
