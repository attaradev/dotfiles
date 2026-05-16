## Live context

- Working directory: !`pwd`
- Architecture docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|auth|security|api|endpoint)" 2>/dev/null | head -8 || true`
- Auth / security configuration: !`find . -maxdepth 4 -type f | xargs grep -l -iE "(jwt|oauth|cors|csp|rbac|permission|acl)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Data model: !`find . -maxdepth 5 -type f -name "*.sql" -o -name "schema.*" -o -name "*migration*" 2>/dev/null | head -8 || true`
