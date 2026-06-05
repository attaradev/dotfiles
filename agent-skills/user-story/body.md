## Task

Read `references/user-story-format.md` before writing anything.

Read the feature description carefully. Identify:
- Who are the distinct user types involved?
- What is the core happy path?
- What can go wrong, and what edge cases exist?

Generate a complete set of user stories following the format in `references/user-story-format.md`.

Write stories at the right level of granularity — one story per distinct user goal or outcome, not per screen or button click. Group related stories under epics if the scope warrants it.

Happy path and major edge cases can be scenarios within a single story. If an edge case introduces a new actor, requires a separate workflow, or cannot be tested independently, promote it to its own story.

For each story, write:
1. The story statement (As a / I want / So that)
2. Acceptance criteria in Given / When / Then
3. Edge cases and error conditions

For any story where the acceptance criteria cannot be verified without additional information, add a `> BLOCKED: <specific question>` note directly under that story's ACs — do not omit the story.

## Output format

Produce a flat or grouped list of stories in this order:
1. Epic heading (if scope warrants grouping) — `## Epic: <name>`
2. Each story: statement, acceptance criteria, edge cases
3. BLOCKED notes immediately after the affected story's ACs

## Quality bar

- Each story must deliver standalone value — a user can complete a meaningful workflow end-to-end without other stories shipping. Stories that only make sense when 2+ others also ship should be merged into an epic or split differently.
- Acceptance criteria must be testable: a QA engineer could write an automated test from them
- Cover at least: happy path, validation failure, empty state, and permission/auth edge case
- "So that" must describe the user's real goal, not the action: "so that I can make informed decisions" not "so that I can see the data"

## Additional resources

- **`references/user-story-format.md`** — Story syntax, acceptance criteria format, splitting patterns, and anti-patterns.
