---
name: "refactor"
description: "Safely restructure code, extract helpers, deduplicate patterns, or rename across a codebase when the user asks for a refactor or cleanup."
---

# Refactor

Use this skill to change structure without silently changing behavior.

## Workflow

1. Read the target code and find all call sites before editing.
2. State the scope, risk, and behavior-preserving invariant.
3. Make changes incrementally so the code stays valid after each step.
4. Verify the affected tests or manual checks before finishing.

## Output expectations

- Confirm what changes and what stays out of scope.
- List the call sites and risk level.
- Finish with what changed, how it was verified, and any residual risk.

## Resource map

- `references/refactor-checklist.md` -> pre-flight checks and safe refactor patterns
