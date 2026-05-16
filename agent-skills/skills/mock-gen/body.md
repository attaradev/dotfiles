## Task

Read the target interface or service carefully. Generate the appropriate test double for the detected language and framework.

Follow the patterns in `references/mock-gen-guide.md`:

1. **Choose the right double type** — mock, stub, fake, or spy (pick based on what the test actually needs to verify)
2. **Generate the implementation** — idiomatic for the detected language; match the exact method signatures
3. **Show usage example** — a test that uses the mock correctly, covering the happy path and at least one error case
4. **Explain the boundary** — what responsibility does this double own, and what should it never do

## Quality bar

- Match the exact interface: every method, parameter type, and return type
- Use the project's existing mock library if one is already in use — do not introduce a new one
- Stubs return hard-coded values; mocks assert call expectations — pick the right tool
- Fakes have working logic (e.g. in-memory store); use them only when stub complexity grows unwieldy
- Never put business logic in a mock — that belongs in the real implementation

## Additional resources

- **`references/mock-gen-guide.md`** — Double taxonomy, patterns by language (Go/TypeScript/Python/Ruby), spy vs mock decision guide, and common pitfalls.
