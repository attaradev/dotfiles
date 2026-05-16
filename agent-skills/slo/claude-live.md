## Live context

- Working directory: !`pwd`
- Existing SLO or monitoring config: !`find . -maxdepth 4 -type f | xargs grep -l -iE "(slo|sli|sla|error.budget|availability|p99|latency)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Alerting / monitoring definitions: !`find . -maxdepth 4 -name "*.yaml" -o -name "*.yml" | xargs grep -l -iE "(alert|promethe|grafana|datadog|slo)" 2>/dev/null | head -8 || true`
