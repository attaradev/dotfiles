---
name: test-gen
description: This skill should be used when the user asks to "write tests for", "generate tests", "add tests to", "test this function", "cover this with tests", "add unit tests", "add integration tests", or "this needs tests". Generates tests for a file or function by reading the target, finding existing test patterns in the project, and producing tests that match the project's conventions.
disable-model-invocation: true
argument-hint: "[file path or function name to test]"
---

# Test Generation

Target: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Target file: !`[ -f "$ARGUMENTS" ] && cat "$ARGUMENTS" 2>/dev/null | head -300 || echo "(search for target)"`
- Existing test files (for pattern reference): !`find . -not -path './.git/*' -not -path './node_modules/*' \( -name "*_test.*" -o -name "*.test.*" -o -name "*.spec.*" -o -name "test_*.py" \) 2>/dev/null | head -20 || true`
- Nearest existing test (sibling): !`ARG="$ARGUMENTS"; BASE="${ARG%.*}"; find . -name "${BASE##*/}_test.*" -o -name "${BASE##*/}.test.*" -o -name "${BASE##*/}.spec.*" 2>/dev/null | head -5 || true`
- Test runner / framework: !`ls -1 jest.config.* vitest.config.* pytest.ini setup.cfg go.mod Makefile 2>/dev/null | head -5 || true`

## Task

### Step 1 — Read the target

Read the target file completely (or locate the named function). Identify:
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

## Additional resources

- **`references/testing-patterns.md`** — What makes a good test, anti-patterns to avoid, and guidance on test scope and naming.
