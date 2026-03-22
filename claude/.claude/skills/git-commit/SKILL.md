---
name: git-commit
description: This skill should be used when the user asks to "git commit", "make a commit", "write a commit message", "stage and commit", "commit my changes", "create a git commit", or "commit this with a proper message". Generates a Conventional Commit message from the staged diff and creates the commit.
disable-model-invocation: true
argument-hint: "[optional hint about scope or intent]"
---

# Commit

Hint: $ARGUMENTS

## Live context

- Status: !`git status --short --branch 2>/dev/null || true`
- Staged diff stat: !`git diff --cached --stat 2>/dev/null || true`
- Staged diff: !`git diff --cached 2>/dev/null || true`
- Recent commit style (for convention reference): !`git log --oneline -8 2>/dev/null || true`
- Jira ticket (from branch): !`git branch --show-current 2>/dev/null | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -1 || echo "(none)"`

## Task

Read the full staged diff before writing anything. Understand the change holistically — what it does, why it exists, and what area it touches.

Follow the conventions in `references/conventions.md` to compose the commit message. Choose the type that matches the *actual* nature of the change — do not default to `feat`:

- `feat` only for new user-visible capabilities
- `fix` for bug fixes, even if the fix involves restructuring
- `refactor` for restructuring, extractions, or simplifications with no behavior change
- `chore` for config, tooling, permissions, or dependency changes
- `docs` for documentation-only changes

When a commit mixes types (e.g. a fix plus a refactor), use the type that represents the dominant or most important change.

If a Jira ticket was detected from the branch name, include it in the footer as `Refs: PROJ-123`. Omit if none was found.

If nothing is staged, report that and suggest `git add` commands based on `git status`. Do not proceed.

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

## Additional resources

- **`references/conventions.md`** — Commit message format, type vocabulary, length rules, and anti-patterns.
