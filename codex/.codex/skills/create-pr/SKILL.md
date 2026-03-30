---
name: "create-pr"
description: "Draft a pull request title and body from the branch diff and commits. Use when the user asks to create a PR, write a PR description, or prepare review-ready pull request text."
---

# PR Description

Use this skill to produce a concise, review-ready pull request summary with a specific title and `What`, `Why`, `Risks`, and `Validation` sections.

## Workflow

1. Resolve the base branch from the user prompt. If it is not specified, infer it from the repository’s default branch.
2. Read the branch diff and commit history against that base completely before writing.
3. Identify the core problem the change solves, not just the files it touches.
4. If the branch name contains a Jira ticket, prepend it to the title and include `**Jira:** PROJ-123` below the `## Why` heading.
5. Follow the PR body structure in `references/pr-format.md`.
6. Include validation steps a reviewer can verify.
7. Output a ready-to-run `gh pr create` command, or `gh pr edit` if a PR already exists for the branch, but do not execute it.

## Quality bar

- Title must be specific: "fix null check in user loader" not "fix bug".
- `What` must cover the key decisions made, not just list files changed.
- `Why` must explain the impact or need, not just restate what was done.
- `Risks` must be explicit; write `None` if there are none and never omit the section.
- `Validation` must name concrete steps, not say "tested locally."
- Do not include AI attribution or generic filler ("this PR aims to...").

## Resource map

- `references/pr-format.md` contains the PR body template, title guidance, and examples.
