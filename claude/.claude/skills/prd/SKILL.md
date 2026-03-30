---
name: prd
description: This skill should be used when the user asks to "write a PRD", "draft the requirements", "spec out this feature", "product requirements document", "write the spec", "feature brief", or "define the requirements for". Generates a complete Product Requirements Document covering problem, goals, user stories, scope, constraints, and success metrics.
argument-hint: "[feature or product area to spec out]"
---

# Product Requirements Document

Feature: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing specs or docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(prd|requirements|spec|feature brief|acceptance criteria)" 2>/dev/null | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the feature description carefully. Before writing, consider:
- Who is this for and what job does it help them do?
- What does success look like in six months?
- What is explicitly out of scope?

Produce a complete PRD following the template in `references/prd-template.md`. Calibrate depth to the scope of the feature — a small UX tweak needs less than a major new capability.

Do not invent requirements. Where information is missing, flag it as an open question.

Suggest saving the output to `docs/prd-<slug>.md`.

## Quality bar

- Goals must be measurable — "increase retention" is not a goal; "increase 30-day retention by 10%" is
- Non-goals are as important as goals — they prevent scope creep
- User stories must cover the happy path, error states, and edge cases
- Every constraint must have a reason — "must support IE11 because 18% of our enterprise users are on it"
- Open questions must be assigned to an owner and have a resolution date

## Additional resources

- **`references/prd-template.md`** — Full PRD template with section guidance, examples, and scope calibration.
