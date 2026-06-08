## Task

Read the full diff before writing anything. The diff is the authoritative source — the description must account for the entire diff, not just the most prominent commits. Be concise, clear, and accurate: every sentence must earn its place. The commit list shows the sequence of changes; do not copy, summarize, or paraphrase commit messages into the description.

Follow the template in `references/pr-format.md`. Write the description to match the scope of the change — a one-commit fix needs less than a multi-day feature.

If a Jira ticket was detected from the branch name, append `[PROJ-123]` to the PR title (e.g. "fix null check in user loader [PROJ-123]") and include a `**Jira:** PROJ-123` link in the body (place it below the Why heading). Omit if no ticket was found.

After drafting the body, execute each validation item that can be verified locally — run test commands, check symlinks, check file existence, verify flags, etc. Mark `[x]` for items that pass and leave `[ ]` for items that fail, adding a brief inline note on failures. Leave items unchecked without a note only when they genuinely cannot be verified locally (manual UI steps, production-only checks, reviewer judgement calls).

Then output a ready-to-run command with the checkboxes already reflecting the results. Do not execute it — present it for the user to review and run:

```sh
gh pr create \
  --title "<title>" \
  --body "$(cat <<'EOF'
<body>
EOF
)"
```

If an open PR already exists on this branch, output a `gh pr edit` command instead.

## Quality bar

- Every sentence must carry information not already visible in the diff — trim anything that restates it
- Title must be specific: "fix null check in user loader" not "fix bug"
- Content must derive from the diff — never copy or paraphrase commit messages
- The What section describes value delivered — outcomes and decisions, not a file tour
- The Why section states the rationale for this approach, not just what problem exists
- Risks must be explicit — write "None" if there are none, never omit the section
- Validation items must be specific enough for another person to reproduce; use checkboxes
- Run every locally-verifiable validation item and mark its checkbox before outputting the command
- Do not include AI attribution or generic filler ("this PR aims to...")

## Additional resources

- **`references/pr-format.md`** — PR body template, section guidance, and examples.
