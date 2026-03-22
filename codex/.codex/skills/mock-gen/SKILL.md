---
name: "mock-gen"
description: "Generate mocks, stubs, fakes, or spies that match the project’s language and test framework when the user asks for a test double."
---

# Mock Generation

Use this skill to create the right test double for the target interface or service.

## Workflow

1. Determine whether the test needs a stub, mock, fake, or spy.
2. Match the project’s existing test framework and conventions.
3. Generate an idiomatic double with the exact method signatures.
4. Show a usage example that covers the happy path and one failure path.
5. Explain the boundary of responsibility for the double.

## Quality rules

- Use the existing mock library if the project already uses one.
- Keep business logic out of doubles.
- Prefer stubs unless call verification is the actual purpose of the test.
- Match the exact interface shape, including return types and errors.

## Resources

- `references/mock-gen-guide.md` covers double taxonomy and language-specific examples.
