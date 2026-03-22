---
name: "git-commit"
description: "Write a Conventional Commit message from the staged diff and create the commit. Use when the user asks to commit staged changes or write a commit message."
---

# Commit

Use this skill to turn a staged diff into a clear Conventional Commit message and create the commit.

## Workflow

1. Inspect the staged diff and recent commit style before writing the message.
2. Identify the behavior change, intent, and any important caveats.
3. Follow the conventions in `references/conventions.md`.
4. If nothing is staged, stop and report that instead of committing.

## Quality rules

- Keep the subject specific, imperative, and within 72 characters.
- Prefer why-focused body text when the change is non-obvious.
- Include a footer when the change needs issue or ticket references.

## Resources

- `references/conventions.md` documents the commit format, types, and examples.
