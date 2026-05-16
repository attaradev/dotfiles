# API Design Conventions

## Style selection

| Style | Choose when |
|-------|------------|
| REST | Public APIs, resource-oriented CRUD, broad client compatibility |
| GraphQL | Complex client-driven queries, many resource types with overlapping fields, mobile clients with bandwidth constraints |
| gRPC | Internal service-to-service, streaming, high-throughput, strongly-typed contracts |

Default to the convention already in use in the codebase. Mixing styles requires explicit justification.

---

## REST conventions

### Resource naming

- Plural nouns for collections: `/users`, `/orders`, `/line-items`
- Kebab-case for multi-word: `/line-items` not `/lineItems` or `/line_items`
- Nest to express ownership, but no deeper than two levels: `/users/{id}/addresses` — avoid `/users/{id}/orders/{id}/items/{id}/shipments`
- Use sub-resources for actions that don't map to CRUD: `POST /orders/{id}/cancel`, `POST /payments/{id}/refund`

### HTTP method semantics

| Method | Semantics | Idempotent | Body |
|--------|----------|-----------|------|
| GET | Read | Yes | No |
| POST | Create or non-idempotent action | No | Yes |
| PUT | Full replace | Yes | Yes |
| PATCH | Partial update | No (by default) | Yes |
| DELETE | Remove | Yes | No |

### Status codes

| Code | When |
|------|------|
| 200 | Successful GET, PATCH, PUT, DELETE with response body |
| 201 | Successful POST that created a resource; include `Location` header |
| 202 | Accepted for async processing |
| 204 | Successful DELETE or action with no response body |
| 400 | Client input validation failure |
| 401 | Missing or invalid credentials |
| 403 | Authenticated but not authorised |
| 404 | Resource not found |
| 409 | Conflict (duplicate, optimistic lock failure) |
| 422 | Semantically invalid input (validation passed structurally but failed business rules) |
| 429 | Rate limited |
| 500 | Unexpected server error |
| 503 | Temporarily unavailable |

Never return 200 for an error. Never return 500 for a client error.

### Error format

Consistent error envelope across all endpoints:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "code": "invalid_format",
        "message": "Must be a valid email address"
      }
    ],
    "request_id": "req_01HXYZ"
  }
}
```

- `code` — machine-readable, stable identifier (snake_case)
- `message` — human-readable, may change
- `details` — field-level errors for validation failures
- `request_id` — always include for debuggability

### Pagination

For any list endpoint, design pagination upfront:

**Cursor-based** (preferred for large or frequently-changing datasets):
```
GET /orders?limit=50&after=cursor_abc123
→ { "data": [...], "pagination": { "next_cursor": "cursor_xyz", "has_more": true } }
```

**Offset-based** (simpler, acceptable for small stable datasets):
```
GET /orders?page=2&per_page=50
→ { "data": [...], "pagination": { "total": 1240, "page": 2, "per_page": 50 } }
```

Always include a maximum page size. Never allow unbounded results.

### Filtering and sorting

```
GET /orders?status=pending&created_after=2024-01-01&sort=-created_at,id
```

- Filter by field equality: `?status=pending`
- Date ranges: `?created_after=` / `?created_before=` (ISO 8601)
- Sort: comma-separated fields, `-` prefix for descending

### Idempotency

For POST requests that create resources or trigger side effects, support an `Idempotency-Key` header. Return the same response for duplicate requests within a TTL (typically 24 hours).

### Request/response field conventions

- Timestamps: ISO 8601 UTC — `"2024-01-15T10:30:00Z"`
- IDs: opaque strings (never expose sequential integers to clients)
- Monetary values: integers in smallest currency unit (cents) with explicit currency field
- Enums: snake_case strings — `"payment_failed"` not `"PAYMENT_FAILED"` or `2`

---

## Versioning strategy

| Strategy | When | Trade-off |
|----------|------|-----------|
| URL path (`/v1/`, `/v2/`) | Public APIs, long support windows | Simple; creates parallel codepaths |
| Header (`API-Version: 2024-01`) | Internal APIs, date-based versioning | Less visible; requires client discipline |
| No versioning | Internal service-to-service with coordinated deploys | No overhead; breaks with mismatched deploys |

**Breaking changes** (require version bump):
- Removing or renaming a field
- Changing a field type
- Changing HTTP method or URL
- Adding a required field
- Changing error codes that clients may branch on

**Non-breaking changes** (no version bump needed):
- Adding optional fields
- Adding new endpoints
- Adding new enum values (if clients handle unknown values gracefully)
- Loosening validation

---

## API contract template

For each endpoint:

```
### POST /resources

Create a new resource.

**Auth:** Bearer token (scope: `resources:write`)

**Request body:**
{
  "name": string (required, 1–100 chars),
  "type": "standard" | "premium" (required),
  "metadata": object (optional)
}

**Response 201:**
{
  "id": string,
  "name": string,
  "type": string,
  "created_at": string (ISO 8601),
  "updated_at": string (ISO 8601)
}

**Errors:**
- 400 `validation_failed` — missing required field or invalid value
- 401 `unauthenticated` — missing or expired token
- 403 `forbidden` — token lacks `resources:write` scope
- 409 `duplicate_name` — a resource with this name already exists
```

---

## gRPC conventions

- Service names: PascalCase (`OrderService`)
- RPC names: PascalCase verb + noun (`CreateOrder`, `ListOrders`, `CancelOrder`)
- Message names: PascalCase, no suffix (`CreateOrderRequest`, `CreateOrderResponse`)
- Field names: snake_case
- Use `google.protobuf.Timestamp` for timestamps
- Use `google.protobuf.FieldMask` for partial updates
- Define a `ErrorInfo` message in error details for structured error codes

## GraphQL conventions

- Types: PascalCase (`OrderConnection`, `LineItem`)
- Fields and arguments: camelCase
- Mutations: verb + noun (`createOrder`, `cancelOrder`, `updateLineItem`)
- Always implement Relay-style cursor pagination for list fields
- Use `@deprecated(reason: "...")` before removing fields; remove in the next major schema version
