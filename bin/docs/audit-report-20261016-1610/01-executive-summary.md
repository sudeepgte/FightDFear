# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 01. EXECUTIVE SUMMARY

**Platform Name:** FightDFear (Women Empowerment Super Platform)  
**Audit Type:** Master Pre-Deployment Architectural, Safety, Security, Database, QA & Production Readiness Audit  
**Audit Mode:** STRICT READ-ONLY MODE (Zero Code Mutations, Non-Destructive Inspection)  
**Audit Date:** October 16, 2026  
**Auditor:** Principal Software Architect, Senior Spring Boot Engineer, Mobile Architect & Cybersecurity Auditor  
**Repository Branch:** `main` (Head synchronized with `origin/main`)  
**Audit Artifacts Location:** `docs/audit-report-20261016-1610/`  

---

### 1.1 Executive Overview & Verdict

FightDFear is an ambitious, multi-faceted women's empowerment super-platform spanning personal emergency safety (SOS, live GPS sharing, buddy journeys, safe routes), healthcare (Women Doctor telemedicine), legal advisory (Women Lawyers), skill development (Martial Arts training centres), wellness (Glow Space salons & stylists, fitness coaches), peer community (reels, video hub, creator economy), entrepreneurship & funding (investor-entrepreneur matching, business proposals), financial literacy (workshops, live sessions, courses), women-led marketplace (products, multi-seller catalog, delivery partners), and administrative oversight.

Following an exhaustive, non-destructive audit of the entire codebase — spanning **164 Spring Boot controllers**, **258 JPA entities**, **179 services**, **51 Flyway database migrations**, **154 JSP view templates**, and a complete **Flutter mobile application with 19 sub-module suites** — the platform demonstrates significant engineering breadth and notable security hardening in specific subsystems. 

However, **critical release-blocking architectural and safety risks remain unresolved**.

### Final Deployment Recommendation: **NO-GO FOR PUBLIC PRODUCTION RELEASE**
*(Conditional Go ONLY for a strictly contained, closed internal pilot with mock payments and synthetic emergency recipients, subject to P0 emergency delivery and security mitigations).*

---

### 1.2 System Health & Scorecard

| Assessment Domain | Score (/10) | Readiness Status | Primary Risk / Key Finding |
|---|:---:|:---:|---|
| **Emergency Safety & SOS Reliability** | **4.5 / 10** | 🔴 HIGH RISK | Outbound SMS requires external unconfigured credentials; `/topic/volunteer-alerts` broadcasts unencrypted victim GPS to all subscribers; repeated duplicate broadcasts per volunteer. |
| **Authentication & Authorization** | **6.5 / 10** | 🟡 MODERATE RISK | Hybrid JWT/Session hydration works well, but JWT cookies lack `Secure` flag on web login, allowing plaintext transmission over HTTP; some endpoints rely on client-asserted IDs. |
| **Payment & Financial Integrity** | **5.5 / 10** | 🔴 HIGH RISK | `PaymentController.createOrder` accepts client-arbitrary amount for unrecognized types (e.g. `BEAUTY`), enabling price tampering where a user can book high-value services for ₹1. |
| **Database & Schema Integrity** | **6.0 / 10** | 🟡 MODERATE RISK | Startup class `DatabaseSchemaUpdate.java` executes unmanaged raw DDL and wipes `financial_videos` duration/level on every boot; ShedLock table missing from H2 test profiles. |
| **Backend Architecture & APIs** | **7.0 / 10** | 🟢 STABLE | Spring Boot 3.4.3 on Java 17; well-structured layers; correlation IDs; Rate limiting on login and OTP; ShedLock scheduler coordination. |
| **Mobile Architecture (Flutter)** | **7.5 / 10** | 🟢 STABLE | Flutter 3.12+ null-safe architecture; offline handling, GPS permissions, retry mechanisms on payment verification, geolocator integration. |
| **Security & OWASP Compliance** | **5.0 / 10** | 🔴 HIGH RISK | Hardcoded SMTP App Password and Razorpay Test Key in `application.properties`; default dev JWT secret; public broadcast of victim coordinates. |
| **Observability & Operations** | **7.0 / 10** | 🟢 STABLE | Actuator hardened (no stack trace leak, health details hidden); Prometheus exposed for localhost only; JSON structured logging supported. |
| **Infrastructure & Deployment** | **5.5 / 10** | 🟡 MODERATE RISK | `nginx-fightdfire.conf` configured for port 80 HTTP only (no SSL/TLS, no HTTPS redirect); in-memory STOMP broker requires sticky session; single point of failure. |

**Composite Production Readiness Index:** **5.9 / 10**

---

### 1.3 Critical Release-Blocking Vulnerabilities (P0 Summary)

1. **FF-SEC-001 (Critical): Hardcoded Third-Party Credentials in Source Code**
   - In `src/main/resources/application.properties`, Google Mail credentials (`spring.mail.username=kishorhavanur07@gmail.com`, `spring.mail.password=bzgsqpyofwdiwsqe`) and Razorpay keys (`razorpay.key.id=rzp_test_RIlD5bEKRjyn3h`, `razorpay.key.secret=Ltg6uo9vI8TiFMVfj2cGm4I8`) are committed in plaintext.
2. **FF-SOS-001 (Critical): Privacy Leak & Broadcast Flooding in Emergency SOS**
   - In `SosService.triggerSOS`, when nearby volunteers are discovered, the victim's name, precise latitude/longitude, and Google Maps URL are published to `/topic/volunteer-alerts`. Any logged-in user can subscribe to this topic via WebSocket without verified volunteer status. Furthermore, the message is broadcast in a loop for each volunteer, causing N duplicate notifications to every subscriber.
3. **FF-FIN-001 (High): Price Tampering in Service Bookings**
   - In `PaymentController.java`, the `createOrder` endpoint falls back to parsing client-provided `amount` for service types not explicitly intercepted (such as `BEAUTY`), and the verification logic confirms the booking without verifying that `amountPaid` matches the actual service catalog price.
4. **FF-DB-001 (High): Destructive Boot Queries in `DatabaseSchemaUpdate.java`**
   - `DatabaseSchemaUpdate.java` implements `CommandLineRunner` and runs `UPDATE financial_videos SET duration = NULL, level = NULL` and raw `ALTER TABLE` statements on every startup, bypassing Flyway versioning and destroying video duration metadata.
5. **FF-DEP-001 (High): Unencrypted Transport in Nginx Reverse Proxy**
   - `deploy/nginx-fightdfire.conf` listens exclusively on Port 80 HTTP with no TLS certificates, SSL termination, or HTTP-to-HTTPS redirect rules. Passwords, session cookies, and live coordinates are transmitted unencrypted over the wire.
6. **FF-SOS-002 (High): Unverified Outbound Emergency Telephony & SMS**
   - In `application.properties`, `sms.enabled=false` and provider keys are blank by default. Unless explicitly configured with Twilio or Msg91 in production environment variables, SMS and automated phone calling will fail silently to reach emergency contacts.

---

### 1.4 Scope of Discovery & Artifacts Generated

- **Total Java Controllers Audited:** 164
- **Total JPA Entities & Enums:** 258
- **Total Services & Managers:** 179
- **Total JSP Views:** 154
- **Total Mobile Screens & Modules:** 19 sub-packages (Safety, Doctors, Martial Arts, Glow Space, Marketplace, Products, Events, Fitness, Financial Literacy, Creator Hub, Entrepreneur, Investor, Wallet, Admin, Auth, Landing, Portals, User)
- **Total Test Classes Audited:** 33 test classes (unit, integration, security, repository, flutter tests)
- **Total Automated Maven Tests:** 17+ core test suites running in isolated H2 test profile
- **Full Audit Directory Created:** `docs/audit-report-20261016-1610/`

---

### 1.5 Immediate Remediation Priority (P0 Roadmap)

1. **Rotate & Purge Credentials:** Immediately revoke the exposed Gmail App Password and Razorpay Test Secret; migrate all secrets to encrypted environment variables.
2. **Secure SOS STOMP Channels:** Restrict `/topic/volunteer-alerts` so only users with `isVolunteer == true` and `verificationStatus == VERIFIED` can subscribe; replace topic broadcast with point-to-point `/user/queue/alerts` messaging; eliminate duplicate loop publishing.
3. **Enforce Authoritative Server-Side Pricing:** Ensure `PaymentController.createOrder` strictly looks up catalog fees from the database for ALL booking types and rejects any client-supplied price parameters.
4. **Remove Destructive Startup Schema Updates:** Delete or disable `DatabaseSchemaUpdate.java`; manage all forward schema modifications via Flyway migrations (`V52+`).
5. **Enable TLS/HTTPS in Nginx:** Provision SSL/TLS certificates (e.g. Let's Encrypt / Certbot), configure port 443 SSL termination, and enforce HSTS and automatic HTTP-to-HTTPS redirection.
6. **Set `Secure` Flag on JWT Cookies:** Update `LoginController.java` to set `cookie.setSecure(true)` when HTTPS is active (`session.cookie.secure=true`).
