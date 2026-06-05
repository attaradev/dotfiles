# Changelog Format Reference

## Keep a Changelog format

```markdown
## [VERSION] - YYYY-MM-DD

### Added
- Added [user-visible capability].

### Changed
- Changed [existing behaviour] to [new behaviour].

### Deprecated
- Deprecated [feature]; use [alternative] instead.

### Removed
- Removed [feature or behaviour].

### Fixed
- Fixed [bug description from the user's perspective].

### Security
- Fixed [vulnerability description]; update recommended.
```

Omit any section that has no entries for the release.

---

## Commit-type → category mapping

| Commit type | Changelog category | Include? |
|-------------|-------------------|----------|
| `feat` | Added | Yes |
| `fix` | Fixed | Yes |
| `perf` | Changed (note improvement) | Yes |
| `refactor` | Changed (only if user-visible) | Conditional |
| `deprecate` | Deprecated | Yes |
| `remove` / `feat!` | Removed | Yes |
| `security` or security fix | Security | Yes |
| `chore`, `ci`, `test`, `docs` | — | No (omit) |

---

## Version bump rules (semver)

| Signal | Bump |
|--------|------|
| `feat!` or `BREAKING CHANGE` footer | Major |
| `feat` (no breaking change) | Minor |
| `fix`, `perf`, `security` | Patch |
| `chore`, `ci`, `docs`, `test` only | No bump |

---

## Entry phrasing rules

- Past-tense imperative: "Added X", "Fixed Y", "Removed Z"
- One line per entry — no implementation details
- User perspective: "Fixed crash when importing large CSVs" not "Fixed NPE in CsvParser.parse()"
- If a commit is ambiguous, emit `<!-- AMBIGUOUS: <sha> <subject> -->` inline for the author to resolve
