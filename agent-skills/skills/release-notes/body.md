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
- Include a commit only if a non-engineer would ask "what does this mean for me?" — if the answer is "nothing visible," omit it
- Omit internal refactors, test changes, CI fixes, and dependency bumps unless they affect behavior
- Group related items under subheadings rather than a flat list of 20+ bullet points
- If the release has no user-visible changes, warn the user and ask whether to publish a 'reliability improvements' note or delay the release

## Additional resources

- **`references/release-notes-guide.md`** — Format templates, user-voice writing guide, categorization rules, breaking change migration format, and examples of good vs. bad entries.
