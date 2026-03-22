# Security Checklist

Work through each category. Focus depth on categories relevant to what the code does. Only surface findings traceable to the code — cite uncertainty when risk depends on unseen context.

---

## 1. Injection

- SQL injection: user input concatenated into queries without parameterization
- Command injection: user input reaching `exec`, `system`, shell interpolation, `subprocess`
- Path traversal: user-controlled paths reaching `open`, `readFile`, file system APIs without canonicalization
- Template injection: user input rendered in server-side templates
- LDAP / XPath / NoSQL injection in query construction
- Log injection: user input written to logs without sanitization (enables log forging)

**High-signal patterns:** string concatenation with query keywords, `fmt.Sprintf` / f-strings / template literals in queries, `os.exec` with user data, `filepath.Join` without `filepath.Clean` / `path.resolve`

---

## 2. Authentication

- Missing authentication on endpoints that require it
- Authentication applied after the protected operation executes
- Weak or predictable session token generation (insufficient entropy, non-random)
- Session tokens not invalidated on logout or password change
- JWT: missing signature verification, `alg: none` accepted, weak secret, missing expiry check
- OAuth: missing state parameter (CSRF), open redirect in callback URL, token not bound to client
- Password: plaintext storage, weak hashing (MD5, SHA1, unsalted), missing brute-force protection
- Multi-factor bypass: fallback paths that skip MFA

---

## 3. Authorization

- Missing authorization check (function reachable without required role/permission)
- Authorization checked on ID from request body/URL instead of authenticated user's identity
- IDOR (Insecure Direct Object Reference): resource ID accessible without ownership check
- Privilege escalation: low-privilege user can trigger high-privilege actions
- Horizontal privilege escalation: user A can access user B's data
- Missing authorization on internal/admin endpoints that are network-accessible
- Overly permissive roles granted to service accounts, IAM roles, or OAuth scopes

---

## 4. Sensitive data exposure

- Credentials, API keys, or tokens hardcoded in source or config files committed to version control
- PII or secrets written to logs, error messages, or stack traces
- Sensitive data in URL query parameters (logged by proxies and servers)
- Unencrypted storage of passwords, tokens, or PII at rest
- Sensitive fields included in API responses that don't need them
- Debug endpoints or verbose error modes enabled in production config
- Secrets in environment variables exposed through reflection endpoints (`/env`, `/actuator`)

---

## 5. Cryptography

- Weak algorithms: MD5, SHA1 for security purposes; DES, RC4, ECB mode for encryption
- Hardcoded or predictable IVs / nonces
- Missing integrity check on encrypted data (use authenticated encryption: AES-GCM, ChaCha20-Poly1305)
- Key derivation: passwords hashed without bcrypt/argon2/scrypt — raw SHA is not key derivation
- TLS: certificate validation disabled, outdated protocol versions (TLS 1.0/1.1) accepted, self-signed certs trusted in production
- Insufficient randomness: `Math.random()`, `rand.Intn` used for security-sensitive values (tokens, nonces, IDs)

---

## 6. Input validation

- Missing or insufficient length limits (potential for DoS via large inputs)
- Missing type validation (string accepted where integer expected)
- Regex without anchors allowing partial matches
- File uploads: missing content-type validation, MIME sniffing not disabled, uploads served from same origin
- XML: external entity processing enabled (XXE), unbounded entity expansion (billion laughs)
- JSON: prototype pollution in JavaScript, unbounded deserialization
- Integer overflow / underflow in size calculations

---

## 7. Security controls and headers (web)

- Missing `Content-Security-Policy` — XSS risk
- Missing `X-Frame-Options` or `frame-ancestors` CSP — clickjacking risk
- `X-Content-Type-Options: nosniff` absent — MIME sniffing risk
- `Strict-Transport-Security` absent — downgrade attack risk
- CORS: wildcard origin (`*`) with credentials, overly permissive `Access-Control-Allow-Origin`
- CSRF: missing token validation on state-changing requests, SameSite cookie attribute absent
- Cookies: missing `HttpOnly`, missing `Secure`, overly broad domain/path

---

## 8. Rate limiting and abuse prevention

- No rate limiting on authentication endpoints (brute force)
- No rate limiting on password reset, OTP, or verification endpoints
- No rate limiting on resource-intensive operations (search, export, report generation)
- No account lockout or exponential backoff after failed auth attempts
- API endpoints callable without authentication or quota

---

## 9. Dependencies and supply chain

- Dependencies with known CVEs — check against OSV, NVD, or Snyk
- Unpinned dependency versions (can receive malicious updates)
- Transitive dependency with abandoned maintenance
- Build scripts fetching from the internet without checksum verification
- Overly permissive dependency permissions (npm `postinstall` scripts, pip with network access)

---

## 10. Infrastructure and configuration

- Secrets in environment variables exposed to child processes unnecessarily
- Debug mode / development settings in production config
- Overly permissive file permissions on config files containing credentials
- Service listening on `0.0.0.0` when only localhost access is needed
- Default credentials not changed
- Unnecessary ports or services exposed
- Cloud: public S3 buckets, overly broad IAM policies, instance metadata endpoint accessible to application code

---

## 11. Race conditions and concurrency (security-relevant)

- TOCTOU (Time-of-Check to Time-of-Use): check-then-act without atomicity guarantee
- Double-spend: financial or inventory operations that can race
- Session fixation: session ID not rotated after privilege escalation
- Unsafe concurrent access to shared security state (token stores, permission caches)

---

## 12. Error handling and logging

- Stack traces or internal system details exposed in API error responses
- Error messages that distinguish valid from invalid users (user enumeration)
- Sensitive values (passwords, tokens, PII) interpolated into log messages
- Exceptions caught and swallowed without logging (hides attack indicators)
- Missing audit log for security-relevant events: login, privilege change, data export, admin action
