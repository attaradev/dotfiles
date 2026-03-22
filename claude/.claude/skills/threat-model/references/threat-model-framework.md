# Threat Modelling Framework (STRIDE)

## STRIDE categories

| Category | Question | Example |
|----------|---------|---------|
| **S**poofing | Can an attacker pretend to be a legitimate user or service? | Forged JWT, session fixation, DNS spoofing |
| **T**ampering | Can data be modified in transit or at rest without detection? | SQL injection, MITM, log manipulation |
| **R**epudiation | Can an actor deny having taken an action? | Missing audit log, unsigned API calls |
| **I**nformation Disclosure | Can sensitive data be accessed by an unauthorised party? | IDOR, verbose error messages, unencrypted storage |
| **D**enial of Service | Can an attacker degrade or stop the service? | Unbounded queries, missing rate limits, memory exhaustion |
| **E**levation of Privilege | Can an attacker gain capabilities beyond what they were granted? | IDOR to admin resources, privilege escalation via parameter tampering |

---

## Threat severity scoring (DREAD-lite)

Rate each threat on:

| Factor | 1 (Low) | 2 (Medium) | 3 (High) |
|--------|---------|-----------|---------|
| **Impact** | Cosmetic / no data loss | Partial data exposure or degraded service | Full data breach or system compromise |
| **Exploitability** | Requires physical access or insider knowledge | Requires authenticated access | Unauthenticated, remotely exploitable |
| **Scope** | Affects one user | Affects a segment | Affects all users or the whole system |

**Severity = Impact × Exploitability × Scope**
- 1–4: Low
- 5–12: Medium
- 13–27: High

---

## Document template

---

**Threat Model: [System / Feature Name]**
**Author:** [Name] | **Date:** YYYY-MM-DD | **Scope:** [What is and is not included]

---

### Assets

What data or capabilities are worth protecting?

| Asset | Sensitivity | If compromised |
|-------|------------|---------------|
| User PII (email, name) | High | Regulatory exposure, user trust loss |
| Authentication tokens | Critical | Account takeover |
| Payment data | Critical | Fraud, PCI violation |
| Internal API keys | High | Service abuse, lateral movement |
| Audit logs | Medium | Repudiation attacks |

### Trust boundaries

List every boundary where data crosses a privilege or network perimeter:

| Boundary | From | To | Crossing point |
|----------|------|----|---------------|
| Internet → API | Untrusted client | API gateway | HTTPS request |
| API → Service | API gateway | Internal service | Internal network |
| Service → Database | Application | PostgreSQL | TCP/SQL |
| Service → Third-party | Application | Payment processor | HTTPS/webhook |

### Data flow diagram

Draw the key flows with trust boundaries marked. Use Mermaid or ASCII:

```
[Browser] --HTTPS--> [Load Balancer] --HTTP--> [API Service] --SQL--> [Database]
                                                      |
                                              [Queue] --AMQP--> [Worker]
                                                                    |
                                                             [Payment API]
```

Mark trust boundaries with `||`:

```
[Browser] --HTTPS--> || [LB → API] --HTTP--> || [API → DB (SQL)]
```

---

### STRIDE threat table

For each component or data flow:

| ID | Component / Flow | Category | Threat | Severity | Mitigation | Status |
|----|-----------------|---------|--------|---------|-----------|--------|
| T1 | Login endpoint | Spoofing | Brute-force credential stuffing | High | Rate limiting (10 req/min/IP), CAPTCHA after 5 failures, account lockout | Mitigated |
| T2 | User API | Information Disclosure | IDOR: user can access another user's data by guessing ID | High | Authorisation check on every request against session user ID | Mitigated |
| T3 | Admin panel | Elevation of Privilege | Regular user accesses admin endpoints by manipulating role parameter | High | Server-side role enforcement; never trust client-supplied role | Mitigated |
| T4 | Webhook receiver | Tampering | Attacker sends forged webhook events | Medium | HMAC signature verification on all incoming webhooks | Mitigated |
| T5 | Search endpoint | DoS | Unbounded query causes full table scan under load | Medium | Query timeout + result limit enforced at DB layer | Mitigated |
| T6 | Error responses | Information Disclosure | Stack traces reveal internal architecture | Low | Structured error responses; stack traces only in development | Mitigated |

---

### Residual risk

Threats that are accepted or only partially mitigated:

| ID | Threat | Why accepted | Owner | Review date |
|----|--------|-------------|-------|------------|
| T7 | Third-party dependency compromise | Vendor security is outside our control; mitigated by rotating API keys and monitoring anomalous calls | Security | Quarterly |
| T8 | Insider threat (privileged admin access) | Full mitigation requires HSM and split-knowledge controls beyond current budget | Engineering lead | Annual |

---

## Common web / API threat patterns

### Authentication and session
- Token stored in localStorage (XSS-accessible) → use httpOnly cookies
- No token expiry or rotation → implement short-lived access tokens + refresh tokens
- Weak password policy or no MFA → enforce minimum complexity and offer TOTP

### Authorisation
- IDOR: accessing resources by manipulating IDs without server-side ownership check
- Horizontal privilege escalation: user A accessing user B's data
- Vertical privilege escalation: user accessing admin functionality
- Missing function-level access control on internal endpoints

### Input handling
- SQL injection → parameterised queries, never string concatenation
- XSS → output encoding, Content-Security-Policy header
- SSRF → validate and allowlist outbound URLs; block private IP ranges
- Path traversal → validate file paths; use safe file APIs

### Transport
- Missing HSTS → forces HTTPS, prevents downgrade attacks
- Mixed content → all resources must be loaded over HTTPS
- Insecure CORS → never `Access-Control-Allow-Origin: *` for credentialed requests

### Secrets and data
- Secrets in code or logs → use environment variables or secrets manager; structured logging that scrubs PII
- Unencrypted PII at rest → encrypt sensitive columns; use encryption-at-rest for storage volumes
- Verbose error messages in production → return generic error messages to clients
