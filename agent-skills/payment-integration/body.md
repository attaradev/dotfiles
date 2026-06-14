## Provider Selection

Choose based on target market, not familiarity:

| Provider | Markets | Local payment methods | Settlement currencies |
|---|---|---|---|
| **Stripe** | Global (40+ countries) | Cards, Link, bank debit | 135+ currencies |
| **PayPal** | Global | PayPal balance, cards | 25 currencies |
| **Square** | US, CA, AU, GB, JP | Cards, ACH | Local currency |
| **Paystack** | NG, GH, KE, ZA, CI, EG | Cards, bank transfer, USSD, mobile money | Local + USD |
| **Flutterwave** | 35+ African countries | Cards, mobile money, bank transfer, USSD | Multi-currency |
| **M-Pesa (Daraja)** | KE, TZ, UG, MW, MZ, EG, GH | Mobile money (STK push, C2B, B2C) | KES, TZS, UGX, etc. |
| **Peach Payments** | ZA, KE, MZ, NG | Cards, EFT, mobile money | ZAR + regional |
| **Ozow** | ZA | Instant EFT (bank-to-bank) | ZAR |

**Selection rule:** prefer the provider with the deepest local payment method support for your primary market. For multi-market: use Stripe or Flutterwave for routing, with provider-specific SDKs for country-level methods.

## Idempotency (non-negotiable)

Every mutating payment operation must be idempotent. A payment retry must never create a duplicate charge.

- **Stripe:** pass `idempotency_key` header on every charge/intent creation
- **Paystack:** generate a unique `reference` per transaction; Paystack rejects duplicate references
- **Flutterwave:** use `tx_ref` (unique per transaction); duplicate `tx_ref` returns the original transaction
- **M-Pesa:** use `CheckoutRequestID` returned by STK push; poll status using it

Generate idempotency keys as: `{userId}:{orderId}:{timestamp}` — deterministic so retries produce the same key.

Store payment attempts in your DB before calling the provider. If the call fails, retry with the same key.

## Webhook Security

Webhooks must be verified before processing. Never trust the payload without signature verification.

**Stripe:**
```
// Node.js example
const event = stripe.webhooks.constructEvent(
  req.rawBody,          // must be raw bytes, not parsed JSON
  req.headers['stripe-signature'],
  process.env.STRIPE_WEBHOOK_SECRET
);
```

**Paystack:**
```
// Node.js example
const hash = crypto.createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
  .update(JSON.stringify(req.body))
  .digest('hex');
if (hash !== req.headers['x-paystack-signature']) throw new Error('invalid signature');
```

**Flutterwave:**
Verify the `verif-hash` header matches your `FLW_HASH` env variable. For critical events, re-query the transaction by ID before fulfilling — the webhook payload alone is not sufficient.

**M-Pesa:**
M-Pesa does not sign callbacks. Verify by re-querying transaction status using `CheckoutRequestID` before fulfilling. Accept callbacks only from Safaricom IP ranges.

**General webhook rules:**
- Accept requests only on a dedicated endpoint (e.g., `/webhooks/stripe`)
- Return 200 immediately; process asynchronously via a queue
- Log raw payload and headers before any processing
- Implement event deduplication (store processed event IDs)

## M-Pesa STK Push (Daraja API)

STK push flow — the most common integration pattern:

1. **Initiate:** `POST /mpesa/stkpush/v1/processrequest` — triggers a PIN prompt on the customer's phone
2. **Callback:** Safaricom calls your `CallBackURL` with result (success or failure)
3. **Verify:** use `CheckoutRequestID` to query status via `POST /mpesa/stkpushquery/v1/query`

Key implementation details:
- Access token expires in 1 hour — cache it, don't request per-transaction
- Phone number format: `254XXXXXXXXX` (no `+`, no leading `0`)
- Timeout: STK push expires after ~2 minutes; implement timeout handling on your side
- Sandbox uses different URLs than production; use env variables for both
- Always verify via query endpoint — callbacks can be delayed or missed

```
// Timeout handling pattern
setTimeout(async () => {
  const status = await querySTKPush(checkoutRequestId);
  if (status === 'pending') await cancelOrder(orderId);
}, 2 * 60 * 1000);
```

## Subscription Lifecycle

Design state explicitly. Every subscription must have a defined state machine:

```
PENDING → ACTIVE → PAST_DUE → CANCELLED
                 ↘ PAUSED  ↗
```

Required events to handle:
- **Renewal success** — extend subscription end date, reset failure count
- **Renewal failure** — increment failure count, send dunning email, move to PAST_DUE
- **Dunning exhausted** — cancel subscription, revoke access, log churn reason
- **Upgrade/downgrade** — calculate proration, charge/credit immediately or at next cycle
- **Cancellation** — set `cancel_at_period_end`, retain access until period end
- **Reactivation** — restart from current date, charge immediately for new period

Prorated charges:
```
proration = (days_remaining / days_in_period) × (new_price - old_price)
```

## PCI Compliance

**Never touch raw card data.** The goal is SAQ A (the simplest PCI tier).

- Use provider-hosted payment fields (Stripe Elements, Paystack Popup, Flutterwave inline)
- Card numbers, CVV, expiry must never transit your servers — only the provider's tokenized representation
- Store only: payment method token, last 4 digits, card brand, expiry month/year
- Log everything except sensitive fields — mask anything resembling a card number in logs

**Required in all environments:**
- HTTPS only for any page that mentions payment
- No card data in URLs, query params, or error messages
- Audit log for all payment operations (charge, refund, dispute, method-change)

## Database Schema

Minimum required tables:

```sql
-- Payment records
CREATE TABLE payments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id),
  provider      TEXT NOT NULL,       -- 'stripe' | 'paystack' | 'mpesa' | etc.
  provider_id   TEXT NOT NULL UNIQUE, -- provider's transaction ID
  idempotency_key TEXT NOT NULL UNIQUE,
  amount        BIGINT NOT NULL,     -- in lowest currency unit (cents, kobo, etc.)
  currency      TEXT NOT NULL,       -- ISO 4217 code
  status        TEXT NOT NULL,       -- 'pending' | 'succeeded' | 'failed' | 'refunded'
  metadata      JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Subscriptions
CREATE TABLE subscriptions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id),
  plan_id       TEXT NOT NULL,
  provider      TEXT NOT NULL,
  provider_sub_id TEXT,              -- provider's subscription ID
  status        TEXT NOT NULL,
  current_period_start TIMESTAMPTZ,
  current_period_end   TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  failure_count INT DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Webhook events (for deduplication)
CREATE TABLE webhook_events (
  id            TEXT PRIMARY KEY,    -- provider's event ID
  provider      TEXT NOT NULL,
  event_type    TEXT NOT NULL,
  payload       JSONB NOT NULL,
  processed_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX ON payments(user_id);
CREATE INDEX ON subscriptions(user_id, status);
```

## Error Handling Taxonomy

Handle these categories differently — don't surface provider error codes to users:

| Category | Examples | Response |
|---|---|---|
| Card declined | insufficient funds, do not honour | "Your card was declined. Try a different card." |
| Expired / invalid | expired card, invalid CVV | "Check your card details and try again." |
| Network error | timeout, connection reset | Retry with same idempotency key; exponential backoff |
| Fraud block | fraud risk, stolen card | "Unable to process. Contact your bank." |
| Duplicate | same idempotency key | Return original transaction — success |
| Mobile money timeout | M-Pesa STK push not completed | "Request expired. Please try again." |
| Dispute / chargeback | dispute opened | Log, notify team, pause account if pattern |

Implement exponential backoff for network errors: `delay = min(initial × 2^attempt, max_delay)`.

## Test Mode Checklist

Before going live, verify:
- [ ] All webhook event types handled (not just `payment.success`)
- [ ] Failure path tested with provider's test card/reference for declines
- [ ] Idempotency tested: duplicate requests return same result, no duplicate charges
- [ ] Webhook signature verification tested (reject invalid signatures with 400)
- [ ] Mobile money timeout scenario handled
- [ ] Refund flow tested end-to-end
- [ ] Subscription cancellation and reactivation tested
- [ ] All secrets in environment variables, none hardcoded
- [ ] Test credentials removed from codebase and git history

## Quality Bar

- Every payment operation must be idempotent — no exceptions
- Webhooks must be verified before processing — no exceptions
- Card data must never transit your server — no exceptions
- All amounts in lowest currency unit (cents, kobo, pesewa) — never floats
- Every payment event logged with provider ID, user ID, amount, currency, and status
- Test the failure paths as thoroughly as the success paths

## Anti-Patterns

- **Floating-point money** — `FLOAT` or `DECIMAL` for amounts. Use `BIGINT` (integer cents/kobo).
- **Trusting the webhook amount** — always re-query the provider to confirm amount and status before fulfilling
- **Processing without verification** — skipping signature verification "for now"
- **Hardcoded secrets** — API keys in source code or committed `.env` files
- **Missing idempotency** — retrying without an idempotency key, leading to duplicate charges
- **Synchronous webhook processing** — blocking the webhook response while fulfilling orders; return 200 first
- **Single-provider lock-in** — coupling business logic to a specific provider's SDK; abstract behind a payment service interface
