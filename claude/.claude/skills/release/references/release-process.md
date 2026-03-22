# Release Process Reference

## Semantic versioning

**Format:** `MAJOR.MINOR.PATCH` (e.g., `2.4.1`)

| Bump | When | Commit signal |
|------|------|--------------|
| `MAJOR` | Breaking change — callers must update their code | `feat!:`, `fix!:`, `BREAKING CHANGE:` footer |
| `MINOR` | New backward-compatible feature | `feat:` |
| `PATCH` | Backward-compatible bug fix | `fix:`, `perf:`, `refactor:` with no behaviour change |

Rules:
- `0.x.y` is pre-1.0: anything may break at any time; MINOR may contain breaking changes
- Once 1.0 is released, semver guarantees are binding
- Pre-release: `1.0.0-alpha.1`, `1.0.0-rc.2` — sort before the release
- Build metadata: `1.0.0+build.42` — ignored in version precedence

---

## Version file locations by ecosystem

| Ecosystem | File | Field |
|-----------|------|-------|
| Node.js | `package.json` | `"version": "x.y.z"` |
| Go | `go.mod` (tag only; no version field) | Git tag drives module version |
| Python | `pyproject.toml` | `version = "x.y.z"` under `[project]` |
| Python (legacy) | `setup.py` | `version='x.y.z'` |
| Python | `src/<pkg>/__init__.py` | `__version__ = "x.y.z"` |
| Rust | `Cargo.toml` | `version = "x.y.z"` under `[package]` |
| Ruby | `lib/<gem>/version.rb` | `VERSION = "x.y.z"` |
| Java/Maven | `pom.xml` | `<version>x.y.z</version>` |

For Go modules: version is communicated entirely through git tags. For major versions ≥ v2, the module path must include the major version: `module github.com/user/repo/v2`.

---

## CHANGELOG format (Keep a Changelog)

```
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [2.4.1] - 2024-01-15

### Fixed
- Prevent double-charge when retrying a failed payment request (#412)
- Correct timezone handling in scheduled report generation

## [2.4.0] - 2024-01-08

### Added
- Bulk user import via CSV for admin users
- Webhook delivery retry with exponential backoff

### Changed
- Report generation now runs asynchronously; results delivered by email

### Deprecated
- `POST /v1/import` is deprecated; use `POST /v2/bulk-import` instead

## [2.3.2] - 2023-12-20

### Security
- Upgrade `json-parse` to 3.1.0 to address CVE-2023-XXXX

[Unreleased]: https://github.com/user/repo/compare/v2.4.1...HEAD
[2.4.1]: https://github.com/user/repo/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/user/repo/compare/v2.3.2...v2.4.0
```

### Sections (use only what applies)
- **Added** — new features
- **Changed** — changes to existing functionality
- **Deprecated** — soon-to-be removed features
- **Removed** — features removed in this release
- **Fixed** — bug fixes
- **Security** — security fixes (always include CVE reference if applicable)

### Writing CHANGELOG entries for humans

Map commit types to sections, but rewrite for clarity:

| Commit | CHANGELOG entry |
|--------|----------------|
| `feat(payments): add Stripe webhook signature verification` | **Added:** Stripe webhook signature verification to prevent forged payment events |
| `fix(cache): prevent stale read after concurrent write` | **Fixed:** Stale cache reads that could occur under high write concurrency |
| `perf(search): add index on user_id column` | **Changed:** Search queries now use an index on `user_id`, reducing p99 latency by ~60% |

Group by impact, not by commit order. Merge multiple small commits into a single meaningful entry.

---

## Release commit and tag

```sh
# Stage version file and CHANGELOG
git add package.json CHANGELOG.md   # adjust for ecosystem

# Release commit — only version bump and CHANGELOG
git commit -m "chore(release): v2.4.1"

# Annotated tag
git tag -a v2.4.1 -m "Release v2.4.1"
```

---

## GitHub release command

Present this for the user to review and run:

```sh
git push origin main --tags

gh release create v2.4.1 \
  --title "v2.4.1" \
  --notes "$(cat <<'EOF'
## What's changed

### Fixed
- Prevent double-charge when retrying a failed payment request
- Correct timezone handling in scheduled report generation

**Full changelog:** https://github.com/user/repo/compare/v2.4.0...v2.4.1
EOF
)"
```

For pre-releases:
```sh
gh release create v2.5.0-rc.1 --prerelease --title "v2.5.0-rc.1" --notes "..."
```

---

## Release checklist

Before tagging:
- [ ] All CI checks passing on the release branch
- [ ] Version bumped in all version files
- [ ] CHANGELOG updated: Unreleased content moved to new version section; comparison links updated
- [ ] No uncommitted changes except the release commit
- [ ] Release commit is the only change (no sneaked-in fixes)

After tagging:
- [ ] Tag pushed to remote
- [ ] GitHub release created (or draft created for review)
- [ ] Package published to registry if applicable (npm, PyPI, crates.io)
- [ ] Deployment pipeline triggered if applicable
