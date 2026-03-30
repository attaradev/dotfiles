---
name: user-story
description: This skill should be used when the user asks to "write user stories", "acceptance criteria for this", "BDD scenarios", "Given When Then for this", "create stories for this feature", "story map this", or "break this into user stories". Generates user stories with acceptance criteria in Given/When/Then format, covering the happy path, error states, and edge cases.
argument-hint: "[feature, epic, or workflow to break into user stories]"
---

# User Story Generation

Feature / epic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing specs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(user story|acceptance criteria|given when then|epic)" 2>/dev/null | head -8 || true`

## Task

Read the feature description carefully. Identify:
- Who are the distinct user types involved?
- What is the core happy path?
- What can go wrong, and what edge cases exist?

Generate a complete set of user stories following the format in `references/user-story-format.md`.

Write stories at the right level of granularity — one story per distinct user goal or outcome, not per screen or button click. Group related stories under epics if the scope warrants it.

For each story, write:
1. The story statement (As a / I want / So that)
2. Acceptance criteria in Given / When / Then
3. Edge cases and error conditions

Flag any story where the acceptance criteria cannot be verified without additional information.

## Quality bar

- Each story must deliver standalone value — a user should be able to get something useful even if no other stories ship
- Acceptance criteria must be testable: a QA engineer could write an automated test from them
- Cover at least: happy path, validation failure, empty state, and permission/auth edge case
- "So that" must describe the user's real goal, not the action: "so that I can make informed decisions" not "so that I can see the data"

## Additional resources

- **`references/user-story-format.md`** — Story syntax, acceptance criteria format, splitting patterns, and anti-patterns.
