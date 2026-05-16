# SaaS Pricing Guide

## Pricing model taxonomy

| Model | How it works | Best for |
|-------|-------------|---------|
| **Per-seat** | Price per user/month | Collaboration tools, productivity, CRMs |
| **Usage-based** | Price per unit consumed (API calls, records, GB) | Infrastructure, developer tools, transactional products |
| **Flat-rate** | Single price for all features | Simple products, single-segment markets |
| **Tiered flat** | Multiple flat tiers with feature gates | Most B2B SaaS — balances simplicity with segmentation |
| **Hybrid** | Base platform fee + usage component | Products where both seat count and usage vary |

Default to **tiered flat** for most B2B SaaS. Pure usage-based is hard to forecast and scary for buyers; pure per-seat punishes viral adoption.

---

## Acquisition motion decision

```
Does your product deliver value before a sales conversation?
  YES → Is the product viral / network-effect driven?
          YES → Freemium (free tier drives paid conversion via team spread)
          NO  → Free trial (14–30 days, no credit card)
  NO  → Is ACV > $5,000/year?
          YES → Demo / sales-led (prospects need a conversation before they buy)
          NO  → Paid trial or free trial with upgrade friction
```

### Freemium vs free trial

| | Freemium | Free trial |
|--|---------|-----------|
| **User intent** | Exploring / casual use | Evaluating a purchase |
| **Conversion rate** | 1–5% (typical) | 15–25% (typical) |
| **Free tier cost** | Ongoing infra + support burden | One-time evaluation cost |
| **Viral potential** | High (free users invite others) | Low |
| **Best for** | Network-effect products; broad top-of-funnel | Products with clear evaluation criteria |

---

## Value metric selection

The value metric is the unit of pricing that scales linearly with customer value. It must:
1. Correlate with customer success (as they get more value, they pay more)
2. Be easy for the customer to predict and budget
3. Scale smoothly — avoid cliff edges that cause customers to churn at tier boundaries

| Good value metrics | Why |
|-------------------|-----|
| Active seats | Correlates with adoption and team spread |
| Monthly active users | Correlates with engagement for end-user tools |
| API calls / requests | Correlates with integration depth |
| Records / contacts | Correlates with database size and customer scale |
| Revenue processed | Aligns your success with the customer's success |

Avoid pricing on features (e.g., "pay for SSO") — it punishes security-conscious customers and creates resentment.

---

## Tier architecture

### Rule of three tiers

Three tiers is the sweet spot for most products:

```
Starter     ←  self-serve, low friction, captures SMB
Growth      ←  the "obvious choice" — best value per dollar (anchor here)
Enterprise  ←  removes limits, adds security/compliance, unlocks sales conversation
```

### Tier design rules

1. **Each tier must represent a real buyer persona** — not arbitrary feature splitting
2. **Gate by usage limits or workflow scope**, not by basic functionality
3. **The growth tier must be the obvious value choice** — price the enterprise tier high enough to make growth look reasonable
4. **Enterprise tier must include**: SSO/SAML, audit logs, SLA, dedicated support, custom contracts
5. **Free / starter tier must not be too generous** — the upgrade path must be visible within 30 days of use

### Tier gate examples

| Gate type | Example | Effect |
|-----------|---------|--------|
| Seat limit | Free: 3 users, Growth: 25 users | Triggers when team grows |
| Usage limit | Free: 1,000 records, Growth: 50,000 | Triggers on data growth |
| Feature gate | Enterprise: SSO, audit logs | Triggers on compliance requirement |
| Workflow gate | Growth: automations, Enterprise: multi-org | Triggers on operational maturity |

---

## Price anchoring

- List the enterprise tier first (left to right: Enterprise → Growth → Starter)
- Enterprise price makes Growth feel like a bargain
- Annual pricing with a 15–20% discount drives LTV and reduces churn
- If charging monthly, offer annual at checkout — some buyers will take it

---

## Common pricing mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Pricing by cost + margin | Ignores willingness to pay | Price by value delivered |
| Too many tiers (5+) | Analysis paralysis | Collapse to 3 tiers |
| Per-seat only | Punishes viral spread | Add a team/org tier or usage component |
| Charging for SSO ("SSO tax") | Poisons enterprise reputation | Include SSO in any enterprise-adjacent tier |
| Never raising prices | Leaves money on table; signals low confidence | Increase prices annually for new customers; grandfather existing for 12 months |
| Freemium with no upgrade path visible | Converts at < 1% | Define a clear trigger that forces a conversion decision |

---

## Price testing

Before committing to price points:

1. **Van Westendorp price sensitivity meter** — ask 4 questions: too cheap / cheap / expensive / too expensive; find the acceptable range
2. **A/B test landing page price** — two cohorts, different price points, measure conversion rate difference
3. **Willingness-to-pay interview** — ask 10 current customers "at what monthly price would you cancel?" — answers cluster into natural tiers
4. **Competitor analysis** — map competitor price points vs features; find the gap you can own

Test annually, especially after product-market fit shifts. Most SaaS products are underpriced at the $10–$49/mo range.
