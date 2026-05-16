## Task

Read the full diff before writing anything. The diff is the authoritative source — derive all description content from it. The commit list shows the sequence of changes; do not copy, summarize, or paraphrase commit messages into the description.

Follow the template in `references/pr-format.md`. Write the description to match the scope of the change — a one-commit fix needs less than a multi-day feature.

If a Jira ticket was detected from the branch name, prepend `[PROJ-123]` to the PR title and include a `**Jira:** PROJ-123` link in the body (place it below the Why heading). Omit if no ticket was found.

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
- Content must derive from the diff — never copy or paraphrase commit messages
- What must cover the key decisions made, not just list files changed
- Why must explain the impact or need, not just restate what was done
- Risks must be explicit — write "None" if there are none, never omit the section
- Validation must name concrete steps, not say "tested locally"
- Do not include AI attribution or generic filler ("this PR aims to...")

## Additional resources

- **`references/pr-format.md`** — PR body template, section guidance, and examples.
