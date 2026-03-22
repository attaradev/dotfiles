---
name: "create-pr"
description: "Draft a pull request title and body from the branch diff and commits. Use when the user asks to create a PR, write a PR description, or prepare review-ready pull request text."
---

# PR Description

Use this skill to produce a concise, review-ready pull request summary with a specific title, problem statement, solution summary, validation steps, and notes.

## Workflow

1. Read the branch diff and commit history completely before writing.
2. Identify the core problem the change solves, not just the files it touches.
3. Follow the PR body structure in `references/pr-format.md`.
4. Include validation steps a reviewer can verify.
5. Output a ready-to-run `gh pr create` or `gh pr edit` command, but do not execute it.

## Quality rules

- Keep the title specific and Conventional Commit shaped.
- Describe why the change exists and why this approach was chosen.
- Avoid file-by-file narration unless it clarifies the reasoning.
- Omit filler and AI attribution.

## Resources

- `references/pr-format.md` contains the PR body template, title guidance, and examples.
