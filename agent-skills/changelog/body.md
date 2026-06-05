## Task

**Before writing anything:** read the existing CHANGELOG.md (or CHANGES.md) to match its format exactly. If none exists, use the Keep a Changelog format (see example below).

Run `scripts/collect-changes.sh` to get full structured change data with Bash:

```
bash "scripts/collect-changes.sh" 2>&1
```

If the script fails or is unavailable, fall back to: `git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD 2>/dev/null || git log --oneline -20` and classify each commit manually using the rules below.

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
- Use past-tense imperative phrasing: "Added X", "Fixed Y", "Removed Z" (not "Adds X" or "add X")
- Each entry should be one line — no implementation details
- Do not fabricate entries for commits with no user-visible change
- Version bump must follow semver: `feat!`/`BREAKING CHANGE` → major, `feat` → minor, `fix`/`perf` → patch
- Commits without conventional format should be manually classified; for commits that are ambiguous (e.g., subject implies both a feature and a bug fix), output a `<!-- AMBIGUOUS: <sha> <subject> — clarify before publishing -->` comment inline so the user can resolve before merging the entry

## Anti-patterns

- **Leaking implementation details**: "Fixed null pointer in `UserService.fetchById` line 42" → write "Fixed crash when loading a user by ID"
- **Padding with chore/ci commits**: "Updated GitHub Actions to use Node 20" does not belong unless it changes a user-visible behavior
- **Vague entries**: "Improved performance" → write "Reduced dashboard load time by batching API requests"
- **Wrong verb tense**: "Adds dark mode support" or "add dark mode support" → "Added dark mode support"
- **Version inflation**: marking a `fix` release as minor, or a `feat` as patch — version bump must follow the classification rules above

## Entry format example

```markdown
## [1.3.0] - 2026-06-05

### Added
- Added CSV export to the reports page.

### Fixed
- Fixed session timeout not resetting on user activity.

### Changed
- Improved bulk-import speed by processing records in parallel.
```

## Additional resources

- **`scripts/collect-changes.sh`** — Collects commits since last tag with full metadata for classification.
