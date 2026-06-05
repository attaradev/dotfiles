## Task

Read `references/release-notes-guide.md` before writing anything.

Gather commits since the last release tag with `git log <prev-tag>..HEAD --oneline` (or `git log --oneline -50` if no tag is known). Read each commit body, not just the subject line, for user-facing context. Then write clear, user-focused release notes following the guide.

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

## Anti-patterns

Reject or rewrite any entry that matches these patterns:

- **Developer voice**: "Refactored auth module to use JWT" — rewrite as what the user gains, or omit entirely.
- **Vague quantification**: "Improved performance" or "significantly faster" — require a number ("3× faster", "reduced from 800ms to 250ms") or omit.
- **Breaking change without migration**: Listing what changed without a before/after example and an exact migration step — the reference format requires all three.
- **Noise items**: CI fixes, test changes, linting, code style, and dependency bumps (unless a CVE fix) must be omitted — do not include them under any section header.
- **Hedged omission**: Do not include an item "just in case" — if a non-engineer would ask "so what does this mean for me?" and the answer is "nothing visible," leave it out.

## Additional resources

- **`references/release-notes-guide.md`** — Format templates, user-voice writing guide, categorization rules, breaking change migration format, and examples of good vs. bad entries.
