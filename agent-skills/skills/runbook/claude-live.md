## Live context

- Working directory: !`pwd`
- Existing runbooks: !`find . -iname "*.md" \( -path "*/runbook*" -o -path "*/playbook*" -o -path "*/ops*" -o -path "*/oncall*" \) 2>/dev/null | grep -v node_modules | head -10 || true`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -type f 2>/dev/null | head -80 || true`
- Deployment / infra config: !`ls -1 docker-compose* Dockerfile* k8s/ helm/ terraform/ .github/workflows/ Makefile 2>/dev/null | head -10 || true`
- Key config files: !`ls -1 *.yaml *.yml *.toml *.env.example 2>/dev/null | head -10 || true`
- Alerts and monitors: !`find . -maxdepth 4 \( -iname "*alert*" -o -iname "*monitor*" -o -iname "*dashboard*" \) 2>/dev/null | head -5 || true`
