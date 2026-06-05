## Task

### Step 1 — Read the target

If the user request is a file path, read it directly. If it names a function or type, search the codebase to locate the file containing it, then read that file. Identify:
- All exported/public functions or methods
- All meaningful code paths (happy path, error paths, edge cases)
- Any existing tests (do not duplicate them)

### Step 2 — Identify the test pattern

Read one or two existing test files from the live context. Extract:
- Test file naming convention
- Test framework and assertion style
- How test cases are structured (table-driven, individual functions, describe/it blocks)
- How mocks, fixtures, or test helpers are set up

Match the project's pattern exactly. Do not introduce a new test framework or style.

### Step 3 — Generate tests

Write tests covering, in priority order:
1. Each exported function or method's happy path
2. Error paths and failure modes
3. Edge cases: empty input, nil/null, zero values, boundary values
4. Concurrency behavior (if the code involves goroutines, async, or shared state)

Follow the guidance in `references/testing-patterns.md` for what makes a good test.

### Step 4 — Write to file

Place the test file in the correct location following the project convention. State the file path before writing.

## Output format

Before writing tests, state:

1. **Target analysis** — functions to test and code paths identified
2. **Pattern matched** — which existing test file was used as a reference and what conventions were adopted
3. **Test plan** — list of test cases to generate

Then write the test file. After writing:

4. **Coverage summary** — what is now covered and what is explicitly not covered (and why)

## Quality bar

- Tests must match the project's existing patterns exactly — do not introduce a new framework or style
- Each test must be independent and not rely on execution order
- Assert return values, error types, and observable state — not that an internal variable was set or that a private function was called
- Coverage summary must list every exported function or method that is not tested and every skipped code path, with a one-line reason for each omission
- If no existing tests are found in the project, follow the testing framework's official style guide for the detected language

## Anti-patterns

- **Stub without assertion** — writing `t.Run("case", func(t *testing.T) {})` or `pass` as a body; every test must assert at least one outcome
- **Duplicating existing tests** — always check existing test files in Step 1; do not re-test what is already covered
- **Importing a new test framework** — if the project uses `testify`, do not add `gomega`; if it uses `pytest`, do not add `unittest`; match what exists
- **Testing only the happy path** — if the target function has error returns or branches, they must appear in the test plan or be explicitly called out as out-of-scope
- **Asserting implementation details** — do not assert that a specific internal method was called; assert the returned value or the observable state change

## Additional resources

- **`references/testing-patterns.md`** — What makes a good test, anti-patterns to avoid, and guidance on test scope and naming.
