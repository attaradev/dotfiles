---
name: release-notes
description: This skill should be used when the user asks to "write release notes", "draft a changelog entry", "summarize what's in this release", "write user-facing release notes for this version", "what changed in this sprint", or "generate release notes from commits". Produces clear, user-focused release notes from git history, PRs, or a feature list.
disable-model-invocation: true
argument-hint: "[version number, date range, or list of features/PRs to cover]"
---

# Release Notes

Release: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Recent commits: !`git log --oneline -30 2>/dev/null || true`
- Existing changelog: !`find . -maxdepth 2 -name "CHANGELOG*" -o -name "RELEASES*" 2>/dev/null | head -3 || true`
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the commit history and any provided feature descriptions. Write clear, user-focused release notes following `references/release-notes-guide.md`.

Produce:
1. **Version header** — version number and release date
2. **Highlights** (optional, for major releases) — 1–3 sentences on the biggest changes
3. **What's new** — new features, organized by theme or product area
4. **Improvements** — enhancements to existing features
5. **Bug fixes** — notable bugs fixed (omit trivial internal fixes)
6. **Breaking changes** — migration steps required (if any)
7. **Deprecations** — what is deprecated and when it will be removed

## Quality bar

- Write for the user, not the developer — "You can now export reports as CSV" not "Added CSV export endpoint"
- Every item must answer "so what?" — what can the user do now that they couldn't before?
- Breaking changes must include the exact migration step, not just a description of what changed
- Omit internal refactors, test changes, CI fixes, and dependency bumps unless they affect behavior
- Group related items under subheadings rather than a flat list of 20+ bullet points

## Additional resources

- **`references/release-notes-guide.md`** — Format templates, user-voice writing guide, categorization rules, breaking change migration format, and examples of good vs. bad entries.
