---
name: "audit"
description: "Perform a focused security audit of code, diffs, or PRs when the user asks for a security review, vulnerability check, threat model, or auth/security pass."
---

# Security Review

Use this skill to assess security risk in code or diffs.

## Workflow

1. Read the target completely before forming findings.
2. Inspect the surrounding code and the relevant security reference checklist.
3. Focus on the attack surface, trust boundaries, authn/authz, input handling, secrets, and unsafe side effects.
4. State uncertainty when the risk depends on unseen callers, deployment details, or runtime context.

## Output expectations

- Start with the threat surface.
- Rank findings by severity.
- Explain how each issue could be exploited and what to change.
- Include positive observations when a control is implemented well.
- End with prioritized next steps.

## Quality bar

- All findings must be traceable to specific code; no theoretical risks without evidence.
- Critical and High findings must include a concrete fix, not just a description of the problem.
- Omit an entire severity section rather than writing "None found"; empty sections create noise.
- Stay security-focused; do not conflate security findings with general code quality.

## Resource map

- `references/security-checklist.md` -> security signals to check while auditing
