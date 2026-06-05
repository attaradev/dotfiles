## Task

Read the commit history and any existing CHANGELOG carefully. Determine the correct version number using semantic versioning, then execute the release steps from `references/release-process.md`.

Steps:
1. Determine the new version (from the user request or derive from commit types: breaking→major, feat→minor, fix→patch)
2. Update the version file(s) for the detected language/ecosystem. For monorepos, identify all version files and confirm the source of truth before bumping.
3. Update CHANGELOG.md — move Unreleased content to the new version section
4. Create a git commit: `chore(release): v<version>`
5. Create an annotated git tag: `git tag -a v<version> -m "Release v<version>"`
6. Generate a `gh release create` command for the user to review and run

If commit history suggests a breaking change but no commit uses `feat!` or `BREAKING CHANGE`, flag it to the user and ask for intent before bumping major.

Do not push or publish — present the final `git push` and `gh release create` commands for the user to execute.

## Quality bar

- Semantic version must follow semver.org strictly — do not invent version schemes
- CHANGELOG format must follow Keep a Changelog (keepachangelog.com)
- The release commit must only contain version bump and CHANGELOG — no other changes
- CHANGELOG entries must describe user-visible impact, not commit internals: "Prevent double-charge on retry" not "fix(payments): idempotency key check"
- Flag any commits that suggest a breaking change that was not tagged as `feat!` or `BREAKING CHANGE`
- For monorepos, confirm the authoritative version file before bumping — do not update multiple version files without explicit confirmation

## Anti-patterns

- **Sneaking in fixes**: do not include any code changes in the release commit — only version file(s) and CHANGELOG
- **Raw commit messages in CHANGELOG**: never copy `feat(scope): message` verbatim; always rewrite as human-readable impact
- **Silent CHANGELOG link omission**: every new version section requires a comparison link at the bottom (e.g. `[2.4.1]: https://github.com/...`)
- **Pushing without user confirmation**: always present `git push` and `gh release create` as commands for the user to run — never execute them
- **Guessing the version**: if commit history is ambiguous (no conventional commits, or mixed signals), state the ambiguity and ask before bumping

## Additional resources

- **`references/release-process.md`** — Semver rules, CHANGELOG format, version file locations by ecosystem, release note writing, and the `gh release create` command.
