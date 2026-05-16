## Live context

- Working directory: !`pwd`
- Existing integration or messaging code: !`find . -maxdepth 5 -type f \( -name "*.go" -o -name "*.ts" -o -name "*.py" -o -name "*.js" -o -name "*.rb" \) 2>/dev/null | xargs grep -l -iE "(kafka|rabbitmq|sqs|pubsub|webhook|event|message.bus|queue|http.client|api.client|adapter|gateway|connector)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -10 || true`
