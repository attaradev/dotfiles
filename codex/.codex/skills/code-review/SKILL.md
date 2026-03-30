---
name: "code-review"
description: "Perform senior-level review of local working-tree or branch changes with severity-ranked findings and concrete remediation steps. Use when the user asks to review changes, review a diff, check an implementation before merge, or look at a local PR or branch."
---

# Code Review

Use this skill to review local changes with a staff-engineer mindset. Findings come first, ordered by severity, and every concern must be traceable to the diff or strongly implied by surrounding code.

## Workflow

1. Resolve the review scope from the user request. Default to the working tree versus `HEAD`.
2. Gather context with the smallest useful set of git commands: branch, status, changed files, diff stat, and recent commits.
3. If the user names a branch, review the diff against the appropriate merge base, usually with triple-dot diffing.
4. If the user names a file or directory, scope the diff accordingly.
5. Read the full diff before forming any opinion.
6. Read `references/review-checklist.md` and work through every category.

## Output expectations

- Lead with findings, not a summary.
- Prioritize correctness bugs, regressions, security risks, compatibility breaks, and missing tests.
- Include file and line references whenever the diff supports them.
- Call out test coverage gaps for important untested behavior.
- Include positive observations only when something genuinely stands out.
- End with an explicit approval recommendation (`Approve`, `Approve with comments`, `Request changes`, or `Cannot fully assess`).
- Be explicit about uncertainty when context is missing.
- If there are no findings, say so plainly and note any residual risk or testing gaps.
- Keep style comments out unless they materially affect readability or correctness.

## Quality bar

- All findings must be traceable to the diff; do not invent issues without evidence.
- Blockers must name a specific fix, not just describe the problem.
- Do not flag formatting or naming unless it impairs correctness or readability.
- Approval recommendation must be explicit; do not hedge with "it depends."
- Positive observations should be omitted if nothing genuinely stands out.

## Resource map

- `references/review-checklist.md` -> review categories covering correctness, edge cases, contracts, security, performance, operability, maintainability, and architectural consistency
