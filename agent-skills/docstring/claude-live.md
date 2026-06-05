## Live context

- Working directory: !`pwd`
- Target file: !`cat "$ARGUMENTS" 2>/dev/null || echo "(not a direct file path — search for target)"`
- Language detected: !`printf '%s' "$ARGUMENTS" | grep -oE '\.[^.]+$' 2>/dev/null || true`
- Existing documented examples (for style reference): !`grep -A3 -E '^\s*(//|#|/\*\*|"""|\x27\x27\x27)' "$ARGUMENTS" 2>/dev/null | head -40 || true`
