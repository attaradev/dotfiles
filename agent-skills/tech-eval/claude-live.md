## Live context

- Working directory: !`pwd`
- Existing architecture or tech docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|tech stack|decision|adr|evaluation)" 2>/dev/null | head -8 || true`
- Current dependencies: !`cat package.json go.mod requirements.txt Gemfile pom.xml 2>/dev/null | head -40 || true`
