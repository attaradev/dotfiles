---
name: "docstring"
description: "Add or improve inline documentation comments for exported functions, methods, types, or constants when the user asks for docstrings, inline docs, JSDoc, godoc, or documentation comments."
---

# Docstring Generation

Use this skill to document code without changing behavior.

## Workflow

1. Read the target file completely and identify undocumented exported symbols.
2. Match the project's existing documentation style.
3. Write comments that explain purpose, caveats, return values, and errors when relevant.
4. Do not rewrite already-documented symbols or add filler comments.

## Output expectations

- Prefer meaningful context over restating the signature.
- Keep comments concise and consistent with the language conventions.
- Mention side effects, ownership, or thread-safety only when they matter.

## Resource map

- `references/docstring-conventions.md` -> language-specific documentation conventions
