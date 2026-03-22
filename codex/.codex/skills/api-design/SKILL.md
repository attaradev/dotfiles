---
name: "api-design"
description: "Design APIs and contracts for REST, GraphQL, or gRPC. Use when the user asks for an API design, OpenAPI spec, REST endpoints, service contract, or interface design."
---

# API Design

Use this skill to design a clear, versioned API contract with explicit request and response shapes.

## Workflow

1. Read the existing API style in the codebase before proposing anything new.
2. Choose REST, GraphQL, or gRPC based on the current convention and the access pattern.
3. Define the resource model, auth, pagination, error handling, and idempotency.
4. Call out breaking changes and versioning strategy explicitly.

## Quality rules

- Keep field naming consistent across the contract.
- Design pagination up front for any list endpoint.
- Include at least two meaningful error responses per endpoint.
- Justify any deviation from the existing API style.

## Resource map

- `references/api-design-conventions.md` -> style selection, REST conventions, versioning, error envelopes, pagination, and GraphQL/gRPC guidance
