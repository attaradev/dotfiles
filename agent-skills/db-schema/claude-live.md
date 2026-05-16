## Live context

- Working directory: !`pwd`
- Existing schema / migrations: !`find . -maxdepth 6 -type f \( -name "*.sql" -o -name "schema.rb" -o -name "schema.prisma" -o -name "models.py" \) | grep -vE "(node_modules|vendor)" | head -10 2>/dev/null || true`
- Migration files: !`find . -maxdepth 6 -type f -name "*migration*" -o -name "*migrate*" | grep -vE "(node_modules|vendor)" | head -10 2>/dev/null || true`
- ORM models: !`find . -maxdepth 6 -type f | xargs grep -l -iE "^class.*Model|@Entity|schema\.define|table\s*:" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
