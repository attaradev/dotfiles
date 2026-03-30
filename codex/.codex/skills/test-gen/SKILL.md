---
name: "test-gen"
description: "Generate tests for a file or function when the user asks to add coverage, write tests, or cover a behavior with unit, integration, or regression tests. Use when the user asks to add tests, generate unit or integration tests, or cover a behavior with matching project conventions."
---

# Test Generation

Use this skill to add tests that match the project’s existing style.

## Workflow

1. Read the target code completely and identify meaningful code paths.
2. Inspect existing tests to learn the project’s test style and helpers.
3. Generate tests for happy paths, error paths, and edge cases in priority order.
4. Write the test file in the project’s convention and avoid duplicating existing coverage.

## Output expectations

- State the target analysis, matched test pattern, and test plan before writing tests.
- Cover the most important exported behavior first.
- Call out anything explicitly left untested and why.

## Quality bar

- Tests must match the project’s existing patterns exactly; do not introduce a new framework or style.
- Each test must be independent and not rely on execution order.
- Assert observable behavior and outputs, not implementation details.
- Coverage summaries must be honest about gaps; name what is not covered and why.

## Resource map

- `references/testing-patterns.md` -> patterns, anti-patterns, and test-scope guidance
