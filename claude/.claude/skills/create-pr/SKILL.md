---
name: create-pr
description: This skill should be used when the user asks to "create a PR", "open a pull request", "write a PR description", "draft the PR body", "write up this PR", "describe these changes for review", or "write the PR". Generates a structured pull request body from the branch diff and commits, then offers a ready-to-run gh pr create command.
disable-model-invocation: true
argument-hint: "[optional: target base branch, defaults to main/master]"
---

# PR Description

Base branch: $ARGUMENTS

## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- Base branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main"`
- Jira ticket (from branch): !`git branch --show-current 2>/dev/null | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -1 || echo "(none)"`
- Commits on this branch: !`git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline main..HEAD 2>/dev/null || git log --oneline -10`
- Commit messages with bodies: !`git log --format="%s%n%b%n---" origin/HEAD..HEAD 2>/dev/null | head -100 || true`
- Diff stat: !`git diff --stat origin/HEAD..HEAD 2>/dev/null || git diff --stat main..HEAD 2>/dev/null || true`
- Full diff: !`git diff origin/HEAD..HEAD 2>/dev/null || git diff main..HEAD 2>/dev/null || true`
- Existing open PR (if any): !`gh pr view --json title,body,url 2>/dev/null || echo "(no open PR)"`

## Task

Read the commits and diff completely. Understand the change holistically before writing.

Follow the template in `references/pr-format.md`. Write the description to match the scope of the change — a one-commit fix needs less than a multi-day feature.

If a Jira ticket was detected from the branch name, prepend `[PROJ-123]` to the PR title and include a `**Jira:** [PROJ-123](https://jira.example.com/browse/PROJ-123)` link in the body (in the Notes section, or below the Problem heading if Notes is omitted). Omit if no ticket was found.

After generating the body, output a ready-to-run command:

```sh
gh pr create \
  --title "<title>" \
  --body "$(cat <<'EOF'
<body>
EOF
)"
```

Do not run the command — present it for the user to review and execute.

If an open PR already exists on this branch, output a `gh pr edit` command instead.

## Quality bar

- Title must be specific: "fix null check in user loader" not "fix bug"
- Problem statement must explain *why* this change is needed, not just what it does
- Solution summary must cover the key decisions made, not just list files changed
- Validation section must name concrete steps, not say "tested locally"
- Do not include AI attribution or generic filler ("this PR aims to...")

## Additional resources

- **`references/pr-format.md`** — PR body template, section guidance, and examples.
