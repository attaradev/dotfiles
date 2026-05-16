---
name: "docstring"
description: "This skill should be used when the user asks to \"add docstrings\", \"document this file\", \"add JSDoc\", \"add godoc comments\", \"write inline docs\", \"document these functions\", or \"add documentation comments\". Generates inline documentation for undocumented functions and types in a file, matching the language's documentation convention and the project's existing doc style."
argument-hint: "[file path or function name]"
---

# Docstring Generation

Target: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Target file: !`cat "$ARGUMENTS" 2>/dev/null || echo "(not a direct file path — search for target)"`
- Language detected: !`echo "$ARGUMENTS" | grep -oE '\.[^.]+$' 2>/dev/null || true`
- Existing documented examples (for style reference): !`grep -A3 -E '^\s*(//|#|/\*\*|"""|\x27\x27\x27)' "$ARGUMENTS" 2>/dev/null | head -40 || true`

## Task

Read the target file completely. Identify all exported/public functions, methods, types, and constants that lack documentation comments. Do not touch already-documented symbols.

Match the documentation style and convention from `references/docstring-conventions.md` for the detected language. If the file already has some doc comments, match their style exactly — do not introduce a different format.

Write documentation comments that explain:
- **What** the function does (not how — that's in the code)
- **Why** it exists (when non-obvious)
- **Parameters** — type and meaning for non-obvious params
- **Return values** — what is returned and under what conditions
- **Errors** — what errors can be returned and what they mean
- **Caveats** — thread safety, ownership, side effects, performance notes

Generate the docstring content and show it alongside each function. Do not write to the file directly — let the user apply the changes. Do not add comments that merely restate the function name ("GetUser returns the user") — add them only when there is something meaningful to say.

## Quality bar

- A docstring that restates the function signature is worse than no docstring
- "// GetUser returns a user" on `func GetUser(id string) (*User, error)` adds zero value
- Doc the *why* and *caveats*, not the *what* when the name is already self-explanatory
- For complex functions, a single sentence of context is worth more than three lines of parameter descriptions
- A function is self-documenting if: (1) the name clearly states what it does, (2) parameters are typed and clearly named, (3) return values are obvious — only add a docstring if there are non-obvious caveats, side effects, or thread-safety constraints

## Additional resources

- **`references/docstring-conventions.md`** — Language-specific documentation format conventions (Go, Python, TypeScript/JS, Rust).
