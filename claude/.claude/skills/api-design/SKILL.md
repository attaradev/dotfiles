---
name: api-design
description: This skill should be used when the user asks to "design this API", "REST spec for this", "OpenAPI for this", "API contract", "design the endpoints for this", "gRPC service design", "GraphQL schema for this", or "API interface design". Produces an API contract covering endpoints, request/response shapes, auth, error codes, and versioning strategy.
disable-model-invocation: true
argument-hint: "[the resource, capability, or system the API should expose]"
---

# API Design

API scope: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing API definitions: !`find . -maxdepth 4 -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) | xargs grep -l -iE "(openapi|swagger|paths:|rpc |schema)" 2>/dev/null | head -8 || true`
- Existing route / handler files: !`find . -maxdepth 5 -type f | xargs grep -l -iE "(router|handler|controller|endpoint|@app\.(get|post|put|delete))" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -10 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the scope and any existing API definitions carefully. Design the API following the conventions in `references/api-design-conventions.md`.

Produce:
1. **Design rationale** — resource model, key design decisions, and trade-offs considered
2. **API contract** — endpoints with method, path, request/response shapes, status codes, and auth requirements
3. **Error catalogue** — all error conditions with codes, messages, and recovery guidance
4. **Versioning strategy** — how breaking changes will be handled
5. **Open questions** — decisions that need stakeholder input before finalising

Choose the right style for the context (REST, GraphQL, or gRPC) and justify the choice if it is not the existing convention.

Suggest saving the output to `docs/api-design-<slug>.md` or as an OpenAPI spec to `api/<name>.yaml`.

## Quality bar

- Every endpoint must have: method, path, auth requirement, request shape, success response, and at least two error responses
- Field names must be consistent: pick snake_case or camelCase and apply it everywhere
- Pagination must be designed upfront for any list endpoint — do not defer it
- Idempotency must be addressed for any mutating operation
- Breaking vs non-breaking changes must be distinguished clearly

## Additional resources

- **`references/api-design-conventions.md`** — REST principles, naming rules, error format, pagination patterns, versioning strategies, and GraphQL/gRPC guidance.
