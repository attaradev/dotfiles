---
name: "release"
description: "Handle end-to-end release preparation when the user asks to cut a release, bump a version, tag a version, or draft a GitHub release."
---

# Release Preparation

Use this skill to determine the next version, update release notes, create the release commit and tag, and generate the GitHub release command.

## Workflow

1. Read the latest tag, commits since the last tag, and the existing changelog.
2. Derive or confirm the next semantic version.
3. Update the version file(s) and move unreleased notes into the versioned section.
4. Create the release commit and annotated tag.
5. Generate, but do not run, the `git push` and `gh release create` commands.

## Quality rules

- Keep the release commit limited to versioning and changelog changes.
- Follow semantic versioning and Keep a Changelog conventions.
- Group notes by user impact rather than commit type.
- Flag possible breaking changes that were not tagged clearly.

## Resources

- `references/release-process.md` covers semver rules, changelog format, version file locations, and release commands.
