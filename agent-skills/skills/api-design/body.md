## Task

Read the scope and any existing API definitions carefully. Design the API following the conventions in `references/api-design-conventions.md`.

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
- Breaking vs non-breaking changes must be distinguished clearly

## Additional resources

- **`references/api-design-conventions.md`** — REST principles, naming rules, error format, pagination patterns, versioning strategies, and GraphQL/gRPC guidance.
