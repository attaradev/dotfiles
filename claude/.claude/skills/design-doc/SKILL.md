---
name: design-doc
description: This skill should be used when the user asks to "write a design doc", "write a tech spec", "draft a technical design", "design this feature", "write up the approach before we build", "create a design document for", or "spec this out". Produces a technical design document for a feature or system change — heavier than an ADR (one decision) and broader than an execution plan (task breakdown).
disable-model-invocation: true
argument-hint: "[feature or system to design]"
---

# Design Document

Feature: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -type f | sort | head -80 2>/dev/null || true`
- Existing design docs: !`find . -iname "*.md" \( -path "*/design*" -o -path "*/spec*" -o -path "*/rfc*" -o -path "*/docs*" \) 2>/dev/null | grep -v node_modules | head -15 || true`
- Recent commits (for context): !`git log --oneline -15 2>/dev/null || true`
- Key manifests: !`ls -1 go.mod package.json pyproject.toml Cargo.toml 2>/dev/null | head -5 || true`

## Task

Read the live context before planning. Understand the existing system before designing additions to it.

If `$ARGUMENTS` is underspecified, state what assumptions are being made and flag them as open questions at the end.

Write the design doc using the template in `references/design-doc-template.md`. Save it to the project's docs directory (match existing conventions from the live context, or default to `docs/design/`).

## Quality bar

- Goals and non-goals must be explicit — a design with no non-goals accepts unlimited scope
- Alternatives considered must be real alternatives that were actually evaluated, not strawmen
- Security and privacy sections are required for any design touching auth, data storage, or external APIs
- Open questions must be specific enough to be resolvable — "we need to think about X" is not an open question
- Do not propose a design that contradicts existing system constraints without acknowledging the conflict

## Additional resources

- **`references/design-doc-template.md`** — Full template with section guidance and an annotated example.
