## Task

Read the target interface or service file completely before writing anything. Generate the appropriate test double for the detected language and framework.

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

## Anti-patterns

- **Mock without an assertion** — a mock that never calls `AssertExpectations` / `assert_called_*` is just a stub; name it correctly or add the assertion
- **`mock.Anything` / `ANY` for every argument** — the test then proves nothing about what was passed; use specific matchers for at least the meaningful arguments
- **Business logic inside the double** — if the mock is branching on input to decide what to return, that logic belongs in a fake or the real implementation
- **Re-using a mock that already recorded calls** — always create a fresh double per test; shared mocks accumulate state across tests and produce false passes

## Output format

Produce three blocks in order:
1. The mock/stub/fake struct or class (complete, with all interface methods)
2. A test snippet showing the happy path and at least one error/failure case
3. A one-sentence boundary note: what this double owns and what it must never do

## Additional resources

- **`references/mock-gen-guide.md`** — Double taxonomy, patterns by language (Go/TypeScript/Python), spy vs mock decision guide, and common pitfalls.
