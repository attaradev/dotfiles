## Live context

- Working directory: !`pwd`
- Target file: !`cat "$ARGUMENTS" 2>/dev/null | head -300 || echo "(search for target — provide a file path or function name)"`
- Existing test files (for pattern reference): !`find . -not -path './.git/*' -not -path './node_modules/*' \( -name "*_test.*" -o -name "*.test.*" -o -name "*.spec.*" -o -name "test_*.py" \) 2>/dev/null | head -20 || true`
- Nearest existing test (sibling): !`find . \( -name "$(basename "${ARGUMENTS%.*}")_test.*" -o -name "$(basename "${ARGUMENTS%.*}").test.*" -o -name "$(basename "${ARGUMENTS%.*}").spec.*" \) 2>/dev/null | head -5 || true`
- Test runner / framework: !`ls -1 jest.config.* vitest.config.* pytest.ini setup.cfg go.mod Makefile 2>/dev/null | head -5 || true`
