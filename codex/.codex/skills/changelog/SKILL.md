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
4. If the user specified a version, use it; otherwise infer the version bump from conventional commits (`feat!`/`BREAKING CHANGE` -> major, `feat` -> minor, `fix`/`perf` -> patch).
5. Prepend the new entry using the repository’s existing changelog format.

## Quality bar

- Entries must be user-facing; omit internal chores, CI changes, and refactors with no visible effect.
- Use past tense and imperative phrasing ("Added X", "Fixed Y").
- Each entry should be one line with no implementation details.
- Do not fabricate entries for commits with no user-visible change.
- Match the existing changelog style exactly.
- Version bumps must follow semver: `feat!`/`BREAKING CHANGE` -> major, `feat` -> minor, `fix`/`perf` -> patch.

## Resource map

- `scripts/collect-changes.sh` -> structured commit data since the last tag
