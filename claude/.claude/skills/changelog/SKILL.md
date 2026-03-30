---
name: changelog
description: This skill should be used when the user asks to "update the changelog", "write the changelog", "generate changelog", "what changed since last release", "draft release notes", or "add changelog entry". Generates a structured CHANGELOG entry from commits since the last tag, following Keep a Changelog format.
argument-hint: "[version number or release name — optional]"
---

# Changelog

Version: $ARGUMENTS

## Live context

- Last tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "(no tags)"`
- Current CHANGELOG (first 60 lines): !`head -60 CHANGELOG.md 2>/dev/null || head -60 CHANGES.md 2>/dev/null || echo "(no CHANGELOG found)"`
- Today's date: !`date +%Y-%m-%d`

## Task

Run `scripts/collect-changes.sh` to get full structured change data via Bash tool:

```
bash "$HOME/.claude/skills/changelog/scripts/collect-changes.sh" 2>&1
```

Read the existing CHANGELOG to match its format exactly. If none exists, use the Keep a Changelog format.

Classify each commit into the appropriate category. If `$ARGUMENTS` provides a version number, use it; otherwise infer from conventional commit types (any `feat!` or `BREAKING CHANGE` → major bump, `feat` → minor, `fix`/`perf` → patch).

Prepend the new entry to the CHANGELOG file.

## Classification rules

| Commit type | Changelog category |
|-------------|-------------------|
| `feat` | Added |
| `fix` | Fixed |
| `perf` | Changed (with note on improvement) |
| `refactor` | Changed (only if user-visible) |
| `deprecate` | Deprecated |
| `remove` / `feat!` | Removed |
| `security` or security-related fix | Security |
| `chore`, `ci`, `test`, `docs` | Omit (internal, not user-facing) |

Omit internal chores entirely unless they affect users (e.g., a dependency upgrade that changes behavior).

## Quality bar

- Entries must be user-facing — omit internal chores, CI changes, and refactors with no visible effect
- Use past tense and imperative phrasing ("Added X", "Fixed Y")
- Each entry should be one line — no implementation details
- Do not fabricate entries for commits with no user-visible change
- Version bump must follow semver: `feat!`/`BREAKING CHANGE` → major, `feat` → minor, `fix`/`perf` → patch

## Additional resources

- **`scripts/collect-changes.sh`** — Collects commits since last tag with full metadata for classification.
