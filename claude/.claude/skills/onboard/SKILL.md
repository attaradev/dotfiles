---
name: onboard
description: This skill should be used when the user asks to "explain this codebase", "onboard me to this repo", "give me an overview of this project", "what is this repo", "how is this project structured", "help me understand this codebase", or "where do I start in this repo". Produces a structured codebase orientation covering purpose, structure, key entry points, and how to get started.
argument-hint: "[optional focus area — e.g. 'auth system' or 'data pipeline']"
---

# Codebase Onboarding

Focus: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Root files: !`ls -1 2>/dev/null | head -40 || true`
- Repository structure (depth 3): !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -not -path './vendor/*' -type f | sort | head -150 2>/dev/null || true`
- README: !`cat README.md 2>/dev/null | head -100 || cat readme.md 2>/dev/null | head -100 || echo "(no README)"`
- Key manifests: !`cat go.mod 2>/dev/null | head -20 || cat package.json 2>/dev/null | head -30 || cat pyproject.toml 2>/dev/null | head -20 || cat Cargo.toml 2>/dev/null | head -20 || true`
- Recent commits: !`git log --oneline -15 2>/dev/null || true`
- Top contributors: !`git shortlog -sn --no-merges 2>/dev/null | head -8 || true`

## Task

Read the live context fully before writing anything. Read key source files as needed to understand the architecture before describing it. Do not summarize the README — synthesize from the actual code.

If `$ARGUMENTS` names a focus area, anchor the explanation there while covering enough context to make it comprehensible.

## Output format

### What this is

Two to three sentences: what the project does, who uses it, and what problem it solves.

### Repository structure

Annotated directory tree of the key directories. For each: one sentence on purpose and what to expect inside.

```
src/
  api/        – HTTP handlers, routing, middleware
  domain/     – Core business logic, no framework dependencies
  infra/      – Database, cache, external service clients
  cmd/        – Entry points / binaries
```

### Key entry points

The 3–5 files a new contributor should read first. For each: file path and why it matters.

### How it runs

Local development: what commands to run to get it running. Pull from the README, Makefile, or scripts.

### Architecture in one diagram

ASCII diagram of the major components and how data or control flows between them.

### Conventions to know

Project-specific patterns, naming rules, or decisions that are not obvious from reading one file. Limit to genuinely non-obvious things.

### Gotchas

Two to four things that trip up newcomers. Be specific.

### Where to start

Recommended first PR or first exploration task for someone new to this codebase. Name specific files to read and change.

## Quality bar

- Read the actual code before describing it — do not summarize the README alone.
- Every structural claim must be grounded in the file tree or source, not assumed.
- Gotchas must be specific and non-obvious — skip anything derivable from reading one file.
- If `$ARGUMENTS` names a focus area, stay anchored to it rather than producing a generic overview.

## Additional resources

- **`references/onboard-guide.md`** — Techniques for reading unfamiliar codebases, diagram conventions, and calibrating depth.
