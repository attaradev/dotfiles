# Review Checklist

Work through each category. Only surface findings traceable to the diff or strongly implied system context. Cite uncertainty explicitly ("I cannot verify this without seeing the callers").

---

## 0. Scope and intent

- Does the set of changed files match the PR description? Flag unrelated or accidental changes.
- Are there files that *should* have changed but didn't (missing test files, missing docs, missing migrations)?
- Does the PR do one thing, or is it conflating unrelated concerns?

---

## 1. Correctness and logic

- Off-by-one errors, inverted conditions, wrong operator precedence
- Early returns or short-circuits that skip required side effects
- State mutations that violate caller expectations
- Incorrect null/zero/empty handling
- Error paths that silently swallow failures or return wrong defaults
- Boolean logic that is correct in isolation but wrong in context

## 2. Edge cases and boundary conditions

- Empty collections, nil/null inputs, zero values, maximum/minimum values
- Concurrent access to shared state (races, lock ordering, atomicity gaps)
- Retry or backoff logic that can loop forever or amplify load under failure
- Pagination, streaming, or batching that breaks on last page or empty page
- Overflow, underflow, or precision loss in numeric operations

## 3. API and contract integrity

- Breaking changes to public interfaces, serialization formats, or wire protocols
- Backward-compatibility risks for clients not updated in this change
- Schema migrations that may fail, block, or corrupt data without a compatibility window
- Undocumented changes to headers, query parameters, or request/response body shapes
- Version bumps or deprecations that callers are not yet aware of

## 4. Security and privacy

- User-controlled input reaching SQL, shell commands, file paths, or eval without sanitization
- Credentials, tokens, or PII logged, stored in plaintext, or exposed in error responses
- Authorization checks missing, bypassable, or applied after the guarded operation executes
- Overly broad permissions granted to new IAM roles, service accounts, or OAuth scopes
- Dependency additions that introduce known-vulnerable packages
- Timing attacks, path traversal, or SSRF introduced by new code paths

## 5. Performance

- N+1 queries or nested loops over potentially large datasets
- Missing database indexes for new query patterns
- Unbounded in-memory accumulation (growing slices, maps, buffers without caps or pagination)
- Synchronous blocking calls on hot paths where async is required
- Cache invalidation gaps that cause stale reads after writes
- Expensive operations inside loops that could be hoisted or batched

## 6. Operability and observability

- New failure modes with no corresponding metric, log line, or alert
- Error messages that are ambiguous or omit enough context to diagnose in production
- Feature flags or rollout mechanisms absent for high-risk changes
- Deployment ordering dependencies not documented (e.g., DB migration must precede app rollout)
- Configuration drift that makes the change environment-specific or hard to reproduce

## 7. Maintainability and readability

- Logic that is genuinely hard to follow without documentation
- Abstraction that obscures rather than clarifies — wrong layer, premature generalization
- Duplicate logic that should be consolidated into a shared utility
- Code that will be painful to change or safely test in three months
- Naming that actively misleads readers about intent or behavior

## 8. Architectural consistency

- Established patterns or conventions in this codebase that this change violates
- Cross-cutting concerns (auth, logging, error handling, tracing) handled inconsistently
- Coupling introduced between layers or services that should be independent
- New patterns introduced without justification when existing ones would serve

## 9. Test quality

- Tests that assert implementation details instead of observable behavior (brittle)
- Tests that pass vacuously — no assertion, wrong mock setup, or assertion never reached
- Tests that enshrine a bug (assertions match incorrect behavior)
- Missing negative/error path tests for new error handling
- Test setup that duplicates so much production code that it could mask the same bug
