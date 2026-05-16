## Live context

- Working directory: !`pwd`
- Existing API definitions: !`find . -maxdepth 4 -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) | xargs grep -l -iE "(openapi|swagger|paths:|rpc |schema)" 2>/dev/null | head -8 || true`
- Existing route / handler files: !`find . -maxdepth 5 -type f | xargs grep -l -iE "(router|handler|controller|endpoint|@app\.(get|post|put|delete))" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -10 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
