## Task

Read `references/api-design-conventions.md` first. Then read the scope and any existing API definitions before writing anything. Design the API following those conventions.

Produce:
1. **Design rationale** — resource model, key design decisions, and trade-offs considered
2. **API contract** — endpoints with method, path, request/response shapes, status codes, and auth requirements
3. **Error catalogue** — all error conditions with codes, messages, and recovery guidance
4. **Versioning strategy** — how breaking changes will be handled
5. **Open questions** — decisions that need stakeholder input before finalising

Choose the right style for the context (REST, GraphQL, or gRPC) and justify the choice if it is not the existing convention.

Suggest saving the output to `docs/api-design-<slug>.md` or as an OpenAPI spec to `api/<name>.yaml`. Confirm the location with the user if it is not obvious from the project structure.

## Quality bar

- Every endpoint must have: method, path, auth requirement, request shape, success response, and at least two error responses
- Field names must be consistent: pick snake_case or camelCase and apply it everywhere
- Pagination must be designed upfront for any list endpoint — do not defer it
- Idempotency: identify the uniqueness key (request ID, resource ID) and specify conflict resolution (replace, merge, or error) for every mutating operation
- Breaking vs non-breaking changes must be explicitly labelled using the definitions in the conventions (field removal = breaking; adding optional field = non-breaking)
- Every error in the error catalogue must include a machine-readable code, an HTTP status code, and at least one sentence of recovery guidance for the caller

## Anti-patterns

- **CRUD endpoints for domain operations** — `POST /orders/{id}/status` with `{"status": "cancelled"}` instead of `POST /orders/{id}/cancel`. Use sub-resource actions for state transitions.
- **Sequential integer IDs** — exposing `id: 42` lets clients enumerate resources. Always use opaque strings.
- **Deferring pagination** — "we'll add it later" is not a design. Every list endpoint must specify cursor or offset strategy before the design is complete.
- **Catch-all 400** — returning `400 Bad Request` for every error. Use 401/403/404/409/422 where semantically correct.
- **Undocumented auth scopes** — listing an endpoint without stating the required scope or token type.

## Additional resources

- **`references/api-design-conventions.md`** — REST principles, naming rules, error format, pagination patterns, versioning strategies, and GraphQL/gRPC guidance.
