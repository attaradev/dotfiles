## Task

Run `scripts/collect-changes.sh` to get full structured change data with Bash:

```
bash "scripts/collect-changes.sh" 2>&1
```

If the script fails or is unavailable, fall back to: `git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD 2>/dev/null || git log --oneline -20` and classify each commit manually using the rules below.

Read the existing CHANGELOG to match its format exactly. If none exists, use the Keep a Changelog format.

Classify each commit into the appropriate category. If the user provides a version number, use it; otherwise infer from conventional commit types (any `feat!` or `BREAKING CHANGE` → major bump, `feat` → minor, `fix`/`perf` → patch).

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
- Commits without conventional format should be manually classified; flag ambiguous commits (implying both feat and fix) as needing user clarification

## Additional resources

- **`scripts/collect-changes.sh`** — Collects commits since last tag with full metadata for classification.
