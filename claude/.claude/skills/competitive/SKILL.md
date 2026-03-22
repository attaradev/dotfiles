---
name: competitive
description: This skill should be used when the user asks to "competitive analysis", "how does X compare", "who else solves this", "competitive teardown", "compare us to competitors", "market landscape", or "who are the competitors". Produces a structured competitive analysis covering the player map, feature matrix, positioning gaps, and differentiation angle.
disable-model-invocation: true
argument-hint: "[product area, feature, or market to analyse competitively]"
---

# Competitive Analysis

Topic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing competitive docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(competitor|competitive|market|landscape|alternative)" 2>/dev/null | head -8 || true`

## Task

Read the topic carefully. Produce a structured competitive analysis following the framework in `references/competitive-framework.md`.

Work through:
1. **Player map** — who are the relevant competitors? (direct, indirect, non-consumption)
2. **Positioning** — how does each player position themselves and to whom?
3. **Feature matrix** — how do they compare on the dimensions that matter to users?
4. **Strengths and weaknesses** — where does each player win and lose?
5. **Gaps and opportunities** — where is demand underserved across the landscape?
6. **Differentiation angle** — given this landscape, what is the most defensible position?

Be analytical, not promotional. A good competitive analysis reveals uncomfortable truths about where competitors are stronger, not just where they are weaker.

Use publicly available information: product websites, documentation, review sites (G2, Capterra, App Store reviews), job postings, and engineering blogs.

Suggest saving the output to `docs/competitive-<slug>.md`.

## Quality bar

- Name specific competitors, not just "competitors in the space"
- Distinguish between direct competitors (same job, same segment) and indirect substitutes
- Feature matrix cells must reflect reality — do not give a competitor credit for a feature they do not have, or deny credit for one they do
- The differentiation angle must be specific: "we win on X for Y users because Z" not "we're better"
- Flag where you are working from incomplete information

## Additional resources

- **`references/competitive-framework.md`** — Analysis structure, player classification, positioning dimensions, and differentiation strategy.
