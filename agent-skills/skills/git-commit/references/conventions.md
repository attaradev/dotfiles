# Commit Conventions

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

Subject line is required. Body and footer are optional but expected for non-trivial changes.

---

## Subject line rules

- **Max 72 characters** — hard limit
- **Lowercase after the colon** — `feat(auth): add JWT refresh` not `Add JWT refresh`
- **No trailing period**
- **Imperative mood** — "add", "fix", "remove" not "added", "fixes", "removing"
- **Specific** — describe what changed, not the act of changing ("fix null check in user loader" not "fix bug")

### Banned subject words

Do not use these as the core verb or description:
- `update` — too vague; say what was updated and how
- `fixes` — use `fix` (imperative), or be specific about what was fixed
- `misc` / `miscellaneous` — break into separate commits or be specific
- `changes` — says nothing; describe the actual change
- `wip` — do not commit WIP; finish the work first

---

## Types

| Type | When to use |
|------|-------------|
| `feat` | New user-visible feature or capability |
| `fix` | Bug fix |
| `refactor` | Code restructuring with no behavior change |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `docs` | Documentation only |
| `chore` | Build, tooling, dependencies, config — no production code |
| `ci` | CI/CD pipeline changes |
| `revert` | Reverts a previous commit |

Use `!` after the type for breaking changes: `feat!: remove legacy auth endpoint`

---

## Scope

Optional. Use the module, package, or area affected: `feat(auth)`, `fix(checkout)`, `chore(deps)`.

Keep it lowercase and short. Omit if the change is genuinely cross-cutting.

---

## Body

Include a body when:
- The subject alone does not explain *why* the change was made
- The change is non-obvious or has surprising implications
- There are important caveats or follow-up items

Wrap at 80 characters. Separate from subject with a blank line. Explain the *why*, not the *what* — the diff shows the what.

---

## Footer

Use for:
- `BREAKING CHANGE: <description>` — mandatory for breaking changes alongside `!`
- `Closes #N`, `Fixes #N` — link to GitHub issues
- `Refs: PROJ-123` — link to a Jira ticket (include when branch name contains a ticket key)

Do not include AI attribution lines or co-author lines.

---

## Examples

```
feat(payments): add Stripe webhook signature verification

Webhooks were previously accepted without validating the Stripe-Signature
header, allowing any caller to trigger payment events. This validates the
signature using the endpoint secret before processing.

Closes #412
```

```
fix(cache): prevent stale read after concurrent write invalidation
```

```
chore(deps): bump golang.org/x/net to v0.23.0
```

```
refactor(user): extract email normalization into standalone func

Normalization logic was duplicated across registration, login, and
password reset flows. Centralising it removes three near-identical
implementations and makes the rule enforceable in tests.
```

---

## Anti-patterns

| Bad | Better |
|-----|--------|
| `fix: fixes` | `fix(cart): prevent double-charge on retry` |
| `feat: update stuff` | `feat(api): add pagination to /users endpoint` |
| `chore: misc changes` | `chore(lint): enable exhaustive enum checks` |
| `fix: wip` | (finish the work first) |
| `feat: add feature` | `feat(notifications): send email on order shipped` |
