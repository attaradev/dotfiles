## Live context

Read the target before explaining. If `$ARGUMENTS` is a file path, read it directly. If it names a function or concept, search for it first.

- Working directory: !`pwd`
- File content: !`cat "$ARGUMENTS" 2>/dev/null | head -300 || true`
- Related files (if target is a directory): !`find "$ARGUMENTS" -type f 2>/dev/null | head -30 || true`
