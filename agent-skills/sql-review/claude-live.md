## Live context

- Working directory: !`pwd`
- Schema / table definitions: !`find . -maxdepth 6 -type f \( -name "*.sql" -o -name "schema.rb" -o -name "schema.prisma" \) | grep -vE "(node_modules|vendor)" | head -5 2>/dev/null || true`
- Database engine: !`cat .env .env.local docker-compose.yml 2>/dev/null | grep -iE "(postgres|mysql|sqlite|database_url)" | head -5 || true`
- Existing indexes: !`find . -maxdepth 6 -name "*.sql" | xargs grep -i "create index" 2>/dev/null | head -20 || true`
