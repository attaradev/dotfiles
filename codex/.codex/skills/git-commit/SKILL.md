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

## Quality bar

- Subject lines must stay under 72 characters.
- The commit type must match the actual nature of the change; do not default to `feat`.
- Describe what changed and why, not just what the code does.
- If the staged diff mixes unrelated concerns, flag it rather than forcing a single subject.
- Never use `--no-verify` or `--amend` unless the user explicitly requested it.

## Resource map

- `references/conventions.md` documents the commit format, types, and examples.
