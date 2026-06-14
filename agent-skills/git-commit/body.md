## Task

Read the full staged diff before writing anything. The diff is the authoritative source for the message content — derive everything from it. Recent commits are format/style reference only; do not copy, summarize, or paraphrase them.

Follow the conventions in `references/conventions.md` to compose the commit message. Choose the type that matches the *actual* nature of the change — do not default to `feat`:

- `feat` only for new user-visible capabilities
- `fix` for bug fixes, even if the fix involves restructuring
- `refactor` for restructuring, extractions, or simplifications with no behavior change
- `chore` for config, tooling, permissions, or dependency changes
- `docs` for documentation-only changes

When a commit mixes types (e.g. a fix plus a refactor), use the type that represents the dominant or most important change.

Scope is optional and can be used freely for any module, package, or area (`feat(auth)`, `fix(checkout)`). When a Jira ticket is detected from the branch name, use it as the scope: `feat(PROJ-123): description`. Omit scope entirely when the change is genuinely cross-cutting and no ticket is present.

If nothing is staged, report that and suggest specific `git add` commands based on `git status`. Do not auto-stage. Do not proceed.

Once the message is ready, run:

```sh
git commit -m "$(cat <<'EOF'
<subject line>

<body paragraph if needed>

<footer if needed>
EOF
)"
```

Do not use `--no-verify`. Do not amend unless explicitly asked.

## Quality bar

- Subject line must be under 72 characters
- Type must match the actual nature of the change — do not default to `feat`
- Content must come from the staged diff — never paraphrase or copy prior commit messages
- Subject must reflect what the diff actually changes, not a summary of a summary
- Subject and body must describe the change itself — never reference the prompt, review tool, or reviewer (e.g. no "address Copilot feedback", "fix review comment", "per PR review")
- If the diff mixes unrelated concerns, flag it rather than forcing a single subject
- Never use `--no-verify` or `--amend` unless explicitly requested

## Anti-patterns

- **Auto-staging files** — never run `git add -A` or `git add .`; only stage what was already staged or what the user explicitly requests
- **Copying prior commit messages** — the diff is the source of truth; recent commits are style reference only
- **Amending silently** — `--amend` rewrites history; only use it when the user explicitly asks
- **Forcing a single type on a mixed diff** — if the staged changes clearly span two unrelated concerns, flag it and ask the user to split before committing
- **Defaulting to `feat`** — use the type that matches the dominant change; `chore`, `fix`, and `refactor` are each more specific than `feat` for most diffs
- **Referencing the prompt or review tool** — "address Copilot review", "fix PR feedback", "per review comment" are process noise; describe what changed and why, derived from the diff

## Additional resources

- **`references/conventions.md`** — Commit message format, type vocabulary, length rules, and anti-patterns.
