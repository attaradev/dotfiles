# Feature Flag Guide

## Flag types

| Type | Use case | Example |
|------|----------|---------|
| Boolean | On/off kill switch or simple rollout | `enable_new_checkout` |
| String | Variant selection or config value | `recommendation_algo: "v2"` |
| Number | Threshold or percentage override | `rate_limit_rps: 500` |
| JSON | Complex configuration | `{ "layout": "grid", "limit": 20 }` |

Default to boolean unless the feature requires configuration.

---

## Naming conventions

```
<verb>_<noun>           # Boolean: enable_dark_mode
<noun>_<variant>        # String: search_algorithm
<team>_<feature>        # Namespaced: payments_3ds_challenge
```

- Lowercase snake_case
- Prefix with team name for large orgs to avoid collisions
- Avoid negatives: `enable_feature` not `disable_legacy`
- Never encode the expected value in the name: `show_v2` is fine; `show_v2_true` is not

---

## Targeting rules (from most to least specific)

1. **User ID list** — exact match; zero false positives
   ```
   user_id IN ["u_abc123", "u_def456"]
   ```
2. **Org / tenant ID** — rolls out to all users in an org
   ```
   org_id IN ["org_acme", "org_beta_partner"]
   ```
3. **User attribute** — role, plan, region, cohort
   ```
   user.plan == "enterprise" AND user.region == "us-east"
   ```
4. **Percentage rollout** — hash of stable identifier (user ID, not session)
   ```
   percentage_rollout(user_id, 10%)  # 10% of users, stable
   ```
5. **Date/time** — scheduled activation
   ```
   current_time >= "2026-04-01T00:00:00Z"
   ```

Never target by IP address (proxy-unsafe) or session ID (unstable across requests).

---

## Evaluation pattern

Evaluate flags **once, at the entry point**. Pass the resolved value down — do not re-evaluate inside helper functions.

```go
// Good: evaluate once, pass the result
enabled := flags.Bool(ctx, "enable_new_checkout", user)
processCheckout(ctx, cart, enabled)

// Bad: scattered evaluation
func processCheckout(ctx, cart) {
    if flags.Bool(ctx, "enable_new_checkout", currentUser(ctx)) { ... }
}
func calculateShipping(ctx, cart) {
    if flags.Bool(ctx, "enable_new_checkout", currentUser(ctx)) { ... }
}
```

**One evaluation site per feature.** If the flag gates a multi-layer feature, extract the flag check to the outermost controller/handler layer and inject the boolean value.

---

## Rollout strategy

```
Phase 0 — OFF (default: false for all)
  ↓ internal dogfood
Phase 1 — Internal (employee user IDs or internal org)
  ↓ validate no regressions, error rate stable
Phase 2 — Beta (~5–10% or named beta customers)
  ↓ monitor for 1 week; check metrics dashboard
Phase 3 — Gradual (25% → 50% → 75% → 100%)
  ↓ pause at each step if error rate rises > 0.5%
Phase 4 — GA (100%; targeting rule removed)
  ↓ schedule cleanup (default: 2–4 weeks after GA)
Phase 5 — Cleanup (flag removed from code and flag service)
```

Set the cleanup date **before** the flag ships to prod. Flags with no cleanup date accumulate indefinitely.

---

## Flag lifetime targets

| Flag type | Maximum lifetime |
|-----------|-----------------|
| Release flag (default off, enables new feature) | 4–8 weeks |
| Experiment flag (A/B test) | Duration of experiment + 2 weeks |
| Ops flag (kill switch, circuit breaker) | Indefinite (document as permanent) |
| Permission flag (role/plan gate) | Indefinite (document as permanent) |

Kill switches and permission gates are **permanent ops flags** — they should not be cleaned up, but must be documented as such in the flag metadata.

---

## Cleanup checklist

When removing a flag after GA:

- [ ] Identify all call sites: `grep -r "flag_name" .`
- [ ] Remove the flag evaluation call
- [ ] Remove the `else` / disabled branch (keep only the enabled path)
- [ ] Remove any feature-flag-related test setup/teardown
- [ ] Delete flag definition from the flag service
- [ ] Remove flag from any dashboards or monitors that reference it
- [ ] Update CHANGELOG

---

## Test strategy

Test **both states** in every PR that adds a flag.

```go
// Enabled path
func TestNewCheckout_FlagEnabled(t *testing.T) {
    ctx := flags.WithOverride(ctx, "enable_new_checkout", true)
    // assert new behaviour
}

// Disabled path (legacy behaviour must be preserved)
func TestNewCheckout_FlagDisabled(t *testing.T) {
    ctx := flags.WithOverride(ctx, "enable_new_checkout", false)
    // assert legacy behaviour unchanged
}
```

In integration/E2E tests, set flags via environment variable override, not by mocking — test the real evaluation path.

---

## Common anti-patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Flag evaluated in multiple layers | Inconsistent state within a request | Evaluate once at entry point; pass boolean down |
| `if enabled { new() } else { new() }` — both paths call new code | Flag doesn't protect legacy path | Keep old code in the `else` branch unchanged |
| No default value set | Behaviour undefined if flag service is unavailable | Always define a safe default (usually `false`) |
| Flag removed before 100% rollout confirmed | Can't roll back | Only remove flag after confirming 100% stable |
| Long-lived experiment flags | Accumulate as dead code | Set cleanup date before shipping; enforce via linter |
| Targeting by session ID | User flips between variants | Always use stable user/org ID for hashing |
