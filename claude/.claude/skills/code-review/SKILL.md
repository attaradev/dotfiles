---
name: code-review
description: This skill should be used when the user asks to "review my changes", "code review", "review this diff", "review before merge", "check my implementation", "review this branch", or "look at my PR locally". Performs senior/staff-level review of local working-tree or branch changes with severity-ranked findings and concrete remediation steps.
disable-model-invocation: true
argument-hint: "[branch, file, or scope — defaults to working tree vs HEAD]"
---

# Code Review

Review scope: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Changed files (vs HEAD): !`git diff --name-status HEAD 2>/dev/null || true`
- Diff stat: !`git diff --stat HEAD 2>/dev/null || true`
- Recent commits: !`git log --oneline -n 10 2>/dev/null || true`

If `$ARGUMENTS` names a branch, compare against it (e.g., `git diff origin/main...HEAD`). If it names a file or directory, scope the diff accordingly.

## Task

Read the full diff before forming any opinion. Work through every category in `references/review-checklist.md`. Only surface findings that are traceable to the diff or strongly implied by surrounding-system context. Do not comment on formatting or naming unless it impairs readability or correctness.

## Output format

### Overall assessment

One paragraph: scope and intent of the change, confidence level (note any limits from diff size or missing context), and dominant risks.

### Blockers

Issues that must be resolved before merge — correctness bugs, data loss, security holes, broken contracts.

**[LABEL]** — `path/file.ext` (line N)
> What is wrong, why it matters, what to do instead. Be concrete.

### Major concerns

Significant but non-blocking: performance problems, missing observability, backward-compat risks, important test gaps. Same format as Blockers.

### Minor concerns

Low-severity only — unclear names, missing error context, cosmetic drift. Include a tight set or omit.

### Test coverage gaps

For each untested behavior: what is untested, why it is risky, what a useful test would assert. Omit if coverage is adequate.

### Positive observations

Well-executed decisions worth calling out. Omit if nothing stands out.

### Approval recommendation

Choose one with a one-sentence rationale:
- **Approve** — no blockers, concerns minor or addressed
- **Approve with comments** — no blockers, non-trivial concerns to address
- **Request changes** — blockers present (list by label)
- **Cannot fully assess** — missing context; explain the gap

## Additional resources

- **`references/review-checklist.md`** — Eight review categories with specific signals to look for. Read this before forming findings.
