---
name: "refactor"
description: "Safely restructure code, extract helpers, deduplicate patterns, or rename across a codebase when the user asks for a refactor or cleanup."
---

# Refactor

Use this skill to change structure without silently changing behavior.

## Workflow

1. Identify the language from project files (go.mod, package.json, pyproject.toml, etc.) and check whether test coverage data exists (coverage.out, .coverage, lcov.info).
2. Read the target code and find all call sites before editing.
3. State the scope, risk, and behavior-preserving invariant. Flag as high-risk if the change touches more than 5 files or a public interface.
4. Make changes incrementally so the code stays valid after each step.
5. Verify the affected tests or manual checks before finishing.

## Output expectations

- Confirm what changes and what stays out of scope.
- List the call sites and risk level.
- Finish with what changed, how it was verified, and any residual risk.

## Resource map

- `references/refactor-checklist.md` -> pre-flight checks and safe refactor patterns
