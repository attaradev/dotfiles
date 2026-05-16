## Task

Read the full staged diff before writing anything. The diff is the authoritative source for the message content — derive everything from it. Recent commits are format/style reference only; do not copy, summarize, or paraphrase them.

Follow the conventions in `references/conventions.md` to compose the commit message. Choose the type that matches the *actual* nature of the change — do not default to `feat`:

- `feat` only for new user-visible capabilities
- `fix` for bug fixes, even if the fix involves restructuring
- `refactor` for restructuring, extractions, or simplifications with no behavior change
- `chore` for config, tooling, permissions, or dependency changes
- `docs` for documentation-only changes

When a commit mixes types (e.g. a fix plus a refactor), use the type that represents the dominant or most important change.

If a Jira ticket was detected from the branch name, include it in the footer as `Refs: PROJ-123`. Omit if none was found.

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
- If the diff mixes unrelated concerns, flag it rather than forcing a single subject
- Never use `--no-verify` or `--amend` unless explicitly requested

## Additional resources

- **`references/conventions.md`** — Commit message format, type vocabulary, length rules, and anti-patterns.
