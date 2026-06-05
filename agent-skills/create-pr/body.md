## Task

Read the full diff before writing anything. The diff is the authoritative source — the description must account for the entire diff, not just the most prominent commits. Be concise, clear, and accurate: every sentence must earn its place. The commit list shows the sequence of changes; do not copy, summarize, or paraphrase commit messages into the description.

Follow the template in `references/pr-format.md`. Write the description to match the scope of the change — a one-commit fix needs less than a multi-day feature.

If a Jira ticket was detected from the branch name, append `[PROJ-123]` to the PR title (e.g. "fix null check in user loader [PROJ-123]") and include a `**Jira:** PROJ-123` link in the body (place it below the Why heading). Omit if no ticket was found.

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

- Be concise and accurate — every sentence must carry information not visible in the diff
- Title must be specific: "fix null check in user loader" not "fix bug"
- Content must derive from the diff — never copy or paraphrase commit messages
- What describes the value being delivered — outcomes and decisions, not a file tour
- Why gives the rationale — the reasoning behind the approach, not just what problem exists
- Risks must be explicit — write "None" if there are none, never omit the section
- Validation must name concrete steps including edge cases; use checkboxes
- Do not include AI attribution or generic filler ("this PR aims to...")

## Additional resources

- **`references/pr-format.md`** — PR body template, section guidance, and examples.
