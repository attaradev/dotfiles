## Live context

- Working directory: !`pwd`
- Orchestration tools: !`find . -maxdepth 4 -name "*.py" -o -name "*.yaml" -o -name "*.yml" | xargs grep -l -iE "(airflow|dagster|prefect|luigi|dbt|spark|flink|kafka|kinesis|pubsub)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -8 || true`
- Existing pipelines: !`find . -maxdepth 4 -type f -name "*.dag*" -o -name "*pipeline*" -o -name "*etl*" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
