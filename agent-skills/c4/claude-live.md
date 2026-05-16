## Live context

- Working directory: !`pwd`
- Existing architecture docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|c4|container|component|system diagram)" 2>/dev/null | head -8 || true`
- Key source directories: !`ls -d */ 2>/dev/null | head -20 || true`
- Docker / compose files: !`find . -maxdepth 3 -name "docker-compose*.yml" -o -name "Dockerfile" 2>/dev/null | head -10 || true`
- Service definitions (k8s, terraform): !`find . -maxdepth 4 -name "*.tf" -o -name "*.yaml" -o -name "*.yml" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -15 || true`
