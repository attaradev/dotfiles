# Testing Patterns

What makes a good test, what to avoid, and how to scope test cases.

---

## What a good test does

**Tests behavior, not implementation.** A good test calls public interfaces and asserts observable outcomes — return values, state changes, errors, side effects. A bad test calls private methods or asserts that an internal variable was set.

**Fails for one reason.** If a test can fail because of A or B, it is two tests. Isolate each assertion to a single code path.

**Reads like a specification.** The test name and body should make the expected behavior obvious without reading the implementation. `TestGetUser_ReturnsNotFoundError_WhenUserDoesNotExist` is better than `TestGetUser2`.

**Is deterministic.** The same test always produces the same result. Any source of non-determinism (time, random numbers, goroutine scheduling, external services) must be controlled.

**Fails before the fix, passes after.** For bug fixes: write the test first, confirm it fails on the current code, then fix. A test that passes before the fix was not testing what you thought.

---

## Test naming

| Language | Convention | Example |
|----------|-----------|---------|
| Go | `TestFuncName_Scenario_ExpectedOutcome` | `TestGetUser_UserNotFound_ReturnsNotFoundError` |
| Python | `test_scenario_expected_outcome` | `test_get_user_not_found_returns_404` |
| JS/TS | `describe('FuncName') / it('does X when Y')` | `it('returns null when user is not found')` |
| Rust | `fn test_scenario_expected_outcome` | `fn test_get_user_returns_error_when_missing` |

---

## What to test (priority order)

1. **Happy path** — the main success case with valid input
2. **Error paths** — every branch that returns an error or throws
3. **Boundary values** — empty string, zero, nil/null, max value, min value
4. **Invariants** — properties that must always hold (e.g., sorted output stays sorted)
5. **Concurrency** (when relevant) — race conditions, ordering, atomicity

Do not write tests purely to hit a coverage percentage. A test that does not assert meaningful behavior is noise.

---

## Table-driven tests (Go / parameterized)

Prefer table-driven tests when the same logic is exercised with multiple inputs. Each row should have a name, input, and expected output.

```go
tests := []struct {
    name     string
    input    string
    wantErr  bool
    wantOut  string
}{
    {"empty input", "", true, ""},
    {"valid input", "hello", false, "HELLO"},
    {"unicode", "café", false, "CAFÉ"},
}
for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
        got, err := Transform(tt.input)
        if (err != nil) != tt.wantErr {
            t.Errorf("err = %v, wantErr = %v", err, tt.wantErr)
        }
        if got != tt.wantOut {
            t.Errorf("got = %q, want %q", got, tt.wantOut)
        }
    })
}
```

---

## Mocking guidance

**Mock at the boundary, not inside the unit.** Mock the database interface, HTTP client, or file system — not the function calling them.

**Prefer fakes over mocks.** A fake is a lightweight implementation (in-memory store, stub HTTP server). A mock records calls and verifies them. Fakes are simpler and less brittle.

**Do not mock what you own.** If you're testing a function that calls another function in the same package, do not mock the internal function — test them together. Mock only external dependencies (network, database, clock, filesystem).

**Mock the clock for time-sensitive code.** Do not call `time.Now()` directly in production code that needs to be tested. Accept a `clock` interface or `time.Time` parameter.

---

## Anti-patterns

| Anti-pattern | Problem | Better |
|-------------|---------|--------|
| Testing private methods | Brittle, breaks on refactor | Test via public interface |
| One giant test | Hard to diagnose failures | Split into named cases |
| `assert True` on everything | Does not document what is expected | Assert specific values |
| Sleeping in tests | Flaky, slow | Use channels, waitgroups, or retries with timeout |
| Sharing state between tests | Order-dependent failures | Each test sets up its own state |
| Mocking the thing under test | Tests nothing real | Mock only external dependencies |
| Testing implementation details | Breaks when you refactor | Test outcomes, not mechanism |

---

## Scoping guidance

**Unit tests** — test a single function or method in isolation. Fast, no I/O, no network. Should run in milliseconds. Write many of these.

**Integration tests** — test a component with its real dependencies (database, filesystem). Slower. Write for critical paths and data layer.

**End-to-end tests** — test the full system. Slow and brittle. Write sparingly for the most critical user flows.

When generating tests, default to unit tests. Flag if integration tests are clearly needed (database queries, external APIs, file I/O in the target).

---

## Coverage is not the goal

100% line coverage with weak assertions is worse than 60% coverage with strong assertions. A test that executes code without asserting anything is a false signal.

The right question is not "is this line covered?" but "if this line had a bug, would a test catch it?"
