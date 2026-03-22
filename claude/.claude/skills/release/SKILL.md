---
name: release
description: This skill should be used when the user asks to "cut a release", "tag this version", "draft release notes", "bump the version", "prepare a release", "create a GitHub release", or "release this". Handles end-to-end release preparation: version bump, CHANGELOG update, git tag, and GitHub release draft.
disable-model-invocation: true
argument-hint: "[version number or bump type: patch | minor | major]"
---

# Release Preparation

Version / bump: $ARGUMENTS

## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "(no tags yet)"`
- Commits since last tag: !`git log $(git describe --tags --abbrev=0 2>/dev/null)..HEAD --oneline 2>/dev/null || git log --oneline -20`
- Current version files: !`cat package.json 2>/dev/null | grep '"version"' | head -1 || cat go.mod 2>/dev/null | head -3 || cat pyproject.toml setup.py VERSION 2>/dev/null | head -5 || true`
- CHANGELOG exists: !`ls CHANGELOG.md CHANGELOG.rst HISTORY.md 2>/dev/null || echo "(none found)"`
- Unreleased CHANGELOG section: !`awk '/## \[Unreleased\]|## Unreleased/{found=1} found{print; if(/^## \[/ && !/Unreleased/) exit}' CHANGELOG.md 2>/dev/null | head -40 || true`

## Task

Read the commit history and any existing CHANGELOG carefully. Determine the correct version number using semantic versioning, then execute the release steps from `references/release-process.md`.

Steps:
1. Determine the new version (from `$ARGUMENTS` or derive from commit types: breaking→major, feat→minor, fix→patch)
2. Update the version file(s) for the detected language/ecosystem
3. Update CHANGELOG.md — move Unreleased content to the new version section
4. Create a git commit: `chore(release): v<version>`
5. Create an annotated git tag: `git tag -a v<version> -m "Release v<version>"`
6. Generate a `gh release create` command for the user to review and run

Do not push or publish — present the final `git push` and `gh release create` commands for the user to execute.

## Quality bar

- Semantic version must follow semver.org strictly — do not invent version schemes
- CHANGELOG format must follow Keep a Changelog (keepachangelog.com)
- The release commit must only contain version bump and CHANGELOG — no other changes
- Release notes must be readable by a non-engineer: group by impact, not by commit type
- Flag any commits that suggest a breaking change that was not tagged as `feat!` or `BREAKING CHANGE`

## Additional resources

- **`references/release-process.md`** — Semver rules, CHANGELOG format, version file locations by ecosystem, release note writing, and the `gh release create` command.
