---
name: tech-blog
description: This skill should be used when the user asks to "write a tech blog post", "draft a technical article", "write an engineering blog", "explain this to a technical audience", "write up what we built", "document this architecture decision for external consumption", or "write a post-launch writeup". Produces a structured, engaging technical blog post.
disable-model-invocation: true
argument-hint: "[the topic, feature, or decision to write about]"
---

# Technical Blog Post

Topic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Recent commits (for context): !`git log --oneline -10 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Existing docs: !`find . -maxdepth 3 -name "*.md" -o -name "*.mdx" 2>/dev/null | grep -vE "(node_modules|vendor|\.git|CHANGELOG|LICENSE)" | head -8 || true`

## Task

Read the topic description and any relevant code or docs carefully. Write a complete, publication-ready technical blog post following `references/tech-blog-guide.md`.

Produce:
1. **Title** — specific, outcome-focused, search-friendly
2. **Introduction** — the problem that motivated the work (not "today we're going to talk about")
3. **Body** — what you built, why, and how — with code snippets, diagrams, or data where they help
4. **Results** — quantified impact (performance numbers, reliability improvement, dev velocity)
5. **Lessons learned** — what was harder than expected; what you'd do differently
6. **Conclusion** — brief; point to next steps or related reading

## Quality bar

- Lead with the problem, not the solution — readers need to care before they learn
- Every claim of improvement must be backed by a number: "40% faster" not "significantly faster"
- Code snippets must be minimal and illustrative — not a dump of the full implementation
- Avoid internal jargon and team-specific acronyms without explanation
- Tone: direct and conversational, not academic; write like a senior engineer explaining to a peer

## Additional resources

- **`references/tech-blog-guide.md`** — Post structure, intro anti-patterns, code snippet guidelines, diagram advice, SEO basics, and revision checklist.
