---
name: "onboard"
description: "Orient a new contributor in a codebase when the user asks what the repo does, how it is structured, where to start, or how to get it running."
---

# Codebase Onboarding

Use this skill to explain a repository from the actual code, not just the README.

## Workflow

1. Inspect the repository structure, manifests, and recent changes.
2. Read key source files that explain the architecture and entry points.
3. Summarize the project’s purpose, structure, runtime, conventions, and gotchas.
4. Point the user to the highest-value files to read next.

## Output expectations

- Explain what the project is and who uses it.
- Show the important directories and entry points.
- Include how it runs locally when that is discoverable from the repo.
- Call out non-obvious conventions and newcomer gotchas.
- Recommend the first files or tasks a new contributor should start with.

## Quality bar

- Read the actual code before describing it; do not summarize the README alone.
- Every structural claim must be grounded in the file tree or source, not assumed.
- Gotchas must be specific and non-obvious; skip anything derivable from reading one file.
- If the user names a focus area, stay anchored to it rather than producing a generic overview.

## Resource map

- `references/onboard-guide.md` -> techniques for reading unfamiliar codebases, diagram conventions, and depth calibration
