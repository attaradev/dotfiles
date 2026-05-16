## Live context

- Working directory: !`pwd`
- Existing prompt files: !`find . -maxdepth 5 -type f \( -name "*.txt" -o -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | xargs grep -l -iE "(system.?prompt|user.?prompt|instruction|you are a|act as)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Model being used: !`grep -r -iE "(claude|gpt|gemini|llama|mistral|model.?=)" .env .env.local *.py *.ts *.js 2>/dev/null | grep -vE "(node_modules|vendor)" | head -5 || true`
