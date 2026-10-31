# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 07. SECURITY AND PRIVACY AUDIT

**Framework Standard:** OWASP Top 10 (2021/2026), CWE / SANS Top 25, India Digital Personal Data Protection Act (DPDP)  
**Audit Scope:** Authentication, Authorization, Sensitive PII & Medical Data, Cryptography, Network Transport, OWASP Flaws  

---

### 7.1 OWASP Top 10 Vulnerability Assessment

#### A01: Broken Access Control
- **Finding FF-SEC-002 (High):** Public STOMP subscription on sensitive topic `/topic/volunteer-alerts`.
  - In `StompAuthChannelInterceptor.java`, any authenticated user with role `USER` can subscribe to `/topic/volunteer-alerts` and harvest live coordinates and identities of women triggering SOS alerts.
- **Finding FF-SEC-003 (Medium):** Direct Session Casts in Controllers without Principle Authorization.
  - While many controllers verify ownership (e.g. `EmergencyContactController.owns()`), several administrative operations in `AdminController.java` check only `session.getAttribute("admin") != null` rather than validating active database status or specific administrative roles (`SUPER_ADMIN` vs `MODERATOR`).
- **Status:** PARTIAL COMPLIANCE (IDOR on emergency contacts is guarded; WebSocket topic authorization has serious leaks).

---

#### A02: Cryptographic Failures & Credential Exposure
- **Finding FF-SEC-001 (Critical): Plaintext Secrets Committed to Repository.**
  - **Evidence:** `src/main/resources/application.properties`:
    - Line 67–68: `spring.mail.username=kishorhavanur07@gmail.com`, `spring.mail.password=bzgsqpyofwdiwsqe` (Active Google Mail App Password).
    - Line 80–81: `razorpay.key.id=rzp_test_RIlD5bEKRjyn3h`, `razorpay.key.secret=Ltg6uo9vI8TiFMVfj2cGm4I8` (Active Razorpay Test Secret Key).
    - Line 92: `jwt.secret=${JWT_SECRET:LOCAL_DEV_ONLY_change_me_min_32_chars_abcdefgh}`.
  - **Remediation:** Immediately rotate both Google App Password and Razorpay keys; remove all hardcoded defaults from `application.properties`; enforce strict env-only resolution as done in `application-prod.properties`.
- **Finding FF-SEC-004 (Medium): Missing `Secure` Flag on JWT Auth Cookie.**
  - In `LoginController.java`, the `JWT_TOKEN` cookie is initialized with `cookie.setHttpOnly(true)` and `cookie.setMaxAge(365 * 24 * 60 * 60)`, but `cookie.setSecure(true)` is omitted. In non-HTTPS deployments, this cookie is transmitted in cleartext.

---

#### A03: Injection (SQLi, XSS, Command Injection)
- **SQL Injection:**
  - JPA Repositories utilize parameterized Spring Data queries.
  - Dynamic queries in services use named parameters (`:userId`, `:orderId`).
  - Raw SQL in `DatabaseSchemaUpdate.java` uses hardcoded DDL strings without external user input concatenation.
  - **Verdict:** LOW RISK for SQL Injection.
- **Cross-Site Scripting (XSS):**
  - JSTL `<c:out value="..."/>` is utilized across modern view templates.
  - `SecurityConfig.java` defines a strict Content Security Policy (`script-src 'self' 'unsafe-inline' ... https://checkout.razorpay.com`).
  - **Verdict:** LOW RISK for Stored/Reflected XSS.

---

#### A04: Insecure Design & Price Tampering
- **Finding FF-FIN-001 (High): Client-Arbitrary Price Acceptance in `PaymentController.java`.**
  - In `createOrder` (lines 617–630), unrecognized payment types default to reading `amount` directly from client request payload:
    `amount = Double.parseDouble(amountStr);`
  - In `/payment/verify` for type `BEAUTY`, the server creates a confirmed booking without verifying that `amountPaid` matches `service.getPrice()`.
  - **Impact:** An attacker can alter HTTP requests to purchase expensive salon or wellness services for ₹1.00.

---

#### A05: Security Misconfiguration & Transport Security
- **Finding FF-DEP-001 (High): Cleartext HTTP Transport in Nginx Configuration.**
  - `deploy/nginx-fightdfire.conf` listens exclusively on Port 80.
  - Passwords, JWT tokens, medical consultations, and live SOS coordinates are susceptible to Man-in-the-Middle (MitM) sniffing and packet capture on unencrypted public Wi-Fi networks.
  - **Remediation:** Configure Let's Encrypt / TLS 1.3, listen on port 443 with `ssl_certificate`, and add `return 301 https://$host$request_uri;` on port 80.

---

#### A07: Identification & Authentication Failures
- **Token Expiry:**
  - Mobile JWT tokens expire in 30 days (`JwtUtil.java`), which is an acceptable compromise between convenience and security.
  - **Limitation:** There is no token revocation or blacklisting mechanism (e.g. Redis blocklist). If a user account is banned or compromised, existing issued JWT tokens remain valid until expiration.
- **Brute Force Protection:**
  - Login attempts are protected via `RateLimitService.java` using a sliding window of 5 failed attempts per 15 minutes.
  - Registration email/SMS OTP verification enforces 10-minute expirations and 60-second resend cooldowns.

---

#### A09: Security Logging & Monitoring
- **Positive Security Implementation:**
  - `SecurityAuditLogger.java` provides standardized structured audit logging (`[SECURITY-AUDIT] event=...`) for authentication success/failure, payment signature verification, access denials, and administrative approvals.
  - `CorrelationIdFilter.java` and `RequestIdFilter.java` inject unique tracking headers (`X-Request-Id`) across logs.
  - `LogSanitizer.java` sanitizes user input before logging to prevent CRLF log injection attacks.

---

### 7.2 Privacy & Sensitive Data Protection Audit (DPDP Compliance)

| Sensitive Data Category | Storage Location | Access Controls | Risk & Findings |
|---|---|---|---|
| **Live GPS Coordinates** | `live_locations`, `sos_requests` | Session-based / WebSocket | **HIGH RISK:** Broadcast to all subscribers on `/topic/volunteer-alerts` without verified volunteer checks. |
| **Medical Details** | `medical_details` | User ID lookup | Resticted to authenticated user; doctor consultation notes protected by appointment ID. |
| **Emergency Contacts** | `emergency_contacts`, `trusted_contacts` | Controller `owns()` check | Correctly isolated per user; unauthenticated access blocked. |
| **Identity Verification Files** | `uploads/` or AWS S3 | File upload service | Uploaded files currently stored on local disk with predictable filenames; requires S3 private bucket with presigned URLs. |
| **Financial / Payment Records** | `payment_pending_orders`, `wallet_transaction` | User ID check | Amounts and transaction IDs are tracked; card numbers are never stored (delegated to Razorpay). |
