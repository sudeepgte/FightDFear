# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 16. RECOMMENDED REMEDIATION ROADMAP

**Standard:** Strict Non-Implementation Mode — Actionable Prioritized Engineering Directives Only  
**Prioritization Categories:** P0 (Release Blockers), P1 (Pre-Launch High Priority), P2 (Post-Launch Hardening), P3 (Backlog Improvements)  

---

### 16.1 Phase 1: P0 — Immediate Release-Blocking Remediations

#### P0-1: Revoke and Purge Plaintext Secrets (FF-SEC-001)
- **Rationale:** Hardcoded Gmail App Password and Razorpay Test Secret are present in `src/main/resources/application.properties`. Committing credentials to source control exposes accounts to unauthorized access and credential harvesting.
- **Recommended Action:**
  1. Immediately revoke the Google App Password `bzgsqpyofwdiwsqe` in Google Account Security.
  2. Regenerate the Razorpay Test Secret Key in the Razorpay Dashboard.
  3. Edit `application.properties` to replace hardcoded values with environment-only lookups:
     `spring.mail.password=${MAIL_PASSWORD:}`
     `razorpay.key.id=${RAZORPAY_KEY_ID:}`
     `razorpay.key.secret=${RAZORPAY_KEY_SECRET:}`
- **Dependencies:** None.
- **Verification Criteria:** `git grep -i "bzgsqpyofwdiwsqe"` returns zero results; application boots only when valid environment variables are supplied.

---

#### P0-2: Secure Emergency SOS Realtime Dispatch & Fix Coordinate Leak (FF-SOS-001)
- **Rationale:** Live victim coordinates, name, and Google Maps pin are broadcast over public STOMP topic `/topic/volunteer-alerts` where any authenticated user can listen without volunteer verification. In addition, broadcasting inside a volunteer loop generates duplicate messages.
- **Recommended Action:**
  1. In `StompAuthChannelInterceptor.java`, restrict subscriptions to `/topic/volunteer-alerts` (or user-specific queues) strictly to verified volunteers (`user.isVolunteer() && user.getVerificationStatus() == VerificationStatus.VERIFIED`).
  2. In `SosService.java`, remove the public broadcast from the `for (User volunteer : nearbyVolunteers)` loop.
  3. Dispatch alerts as point-to-point private STOMP messages using Spring's `convertAndSendToUser(volunteer.getEmail(), "/queue/volunteer-alerts", payload)`.
- **Dependencies:** None.
- **Verification Criteria:** Unit test verifying that a regular user subscription to volunteer alert destinations throws `IllegalArgumentException: Subscribe denied`.

---

#### P0-3: Eliminate Client-Supplied Price Tampering in Checkout (FF-FIN-001)
- **Rationale:** The fallback `else` clause in `PaymentController.createOrder` accepts client-arbitrary `amount` parameters for unrecognized types (such as `BEAUTY`), allowing users to purchase high-value services for ₹1.
- **Recommended Action:**
  1. Remove the open `else` branch in `PaymentController.createOrder`.
  2. Implement explicit database catalog lookups for all booking types (e.g. `serviceRepository.findById(serviceId)`).
  3. In `PaymentController.verify`, add strict price verification: assert that `Math.abs(catalogFee - amountPaid) < 0.01`, rejecting any mismatch with HTTP 400.
- **Dependencies:** Database service catalog entities.
- **Verification Criteria:** Integration test asserting that sending `{"type": "BEAUTY", "amount": 1}` for a ₹500 service is rejected by the server.

---

#### P0-4: Delete Destructive Boot Runner `DatabaseSchemaUpdate.java` (FF-DB-001)
- **Rationale:** Running raw `UPDATE financial_videos SET duration = NULL, level = NULL` and unversioned `ALTER TABLE` commands on every startup mutates data and conflicts with Flyway.
- **Recommended Action:**
  1. Delete `DatabaseSchemaUpdate.java`.
  2. Consolidate any missing column definitions into a new Flyway migration `V52__schema_cleanup.sql`.
- **Dependencies:** Flyway migration engine.
- **Verification Criteria:** Application boots without executing raw JDBC DDL; financial video durations are preserved across restarts.

---

#### P0-5: Configure TLS 1.3 / HTTPS Encryption in Nginx (FF-DEP-001)
- **Rationale:** `deploy/nginx-fightdfire.conf` serves unencrypted HTTP on port 80. Cleartext passwords, session cookies, and live victim coordinates can be intercepted over the network.
- **Recommended Action:**
  1. Issue valid SSL/TLS certificates via Let's Encrypt / Certbot.
  2. Update Nginx to listen on port 443 with `ssl_certificate` and modern cipher suites.
  3. Add port 80 HTTP-to-HTTPS permanent redirect (`return 301 https://$host$request_uri;`).
  4. Enable HSTS headers (`Strict-Transport-Security "max-age=31536000; includeSubDomains" always;`).
- **Dependencies:** DNS domain resolution and Certbot on host.
- **Verification Criteria:** `curl -I http://fightdfire.chethancodehub.com` returns `HTTP/1.1 301 Moved Permanently` to `https://...`.

---

#### P0-6: Provision Live Outbound SMS Provider (FF-SOS-002)
- **Rationale:** SMS is disabled by default (`sms.enabled=false`), causing emergency SOS alerts to fail silently while the UI claims contacts were notified.
- **Recommended Action:**
  1. Provision a production Twilio or Msg91 account with approved DLT / 10DLC emergency templates.
  2. Configure `SMS_ENABLED=true`, `SMS_PROVIDER=twilio`, and carrier API keys in production environment variables.
  3. Update `home_screen.dart` to display a distinct warning if SMS delivery fails on the server.
- **Dependencies:** Twilio / Msg91 carrier registration.
- **Verification Criteria:** Successful SMS delivery of SOS live coordinates to a designated physical test mobile number.

---

### 16.2 Phase 2: P1 — Pre-Launch High-Priority Hardening

| Item ID | Target Component | Recommended Action | Verification Criteria |
|---|---|---|---|
| **P1-1** | `LoginController.java` | Add `cookie.setSecure(true)` to `JWT_TOKEN` cookie when `SESSION_COOKIE_SECURE=true`. | Cookie header includes `Secure; HttpOnly; SameSite=Lax`. |
| **P1-2** | `pom.xml` | Configure Surefire with `forkCount=1`, `reuseForks=false`, and `-Xmx2048m` to prevent test OOM. | `mvn test` completes all 33 test suites without heap exhaustion. |
| **P1-3** | `DoctorAppointment.java` | Add database unique index `(doctor_id, appointment_time)` for non-cancelled appointments. | Concurrent booking test fails second booking at database level. |
| **P1-4** | `deploy/` | Add automated daily MySQL backup script (`mysqldump`) with offsite S3 sync and retention policy. | Backup script successfully generates `.sql.gz` dump. |
| **P1-5** | `StorageConfig.java` | Activate AWS S3 storage backend (`app.storage.type=s3`) for production multi-container deployments. | Uploaded media stored in S3 bucket and served via CDN. |

---

### 16.3 Phase 3: P2 & P3 — Post-Launch Architecture Evolution

- **P2-1 (Redis Realtime Relay):** Replace Spring's in-memory STOMP broker with an external Redis Pub/Sub relay or RabbitMQ STOMP broker to enable horizontal scaling of WebSocket connections across multiple instances.
- **P2-2 (JWT Token Revocation):** Implement a Redis-backed token revocation blacklist to instantly invalidate compromised tokens upon user password change or admin ban.
- **P2-3 (Offline Emergency Contacts Cache):** Implement local SQLite / Hive encrypted storage on Flutter mobile devices so emergency contacts are available even in airplane mode.
- **P3-1 (Direct S3 Multipart Upload):** Refactor 2GB video upload endpoints to use presigned S3 URLs, relieving Tomcat and JVM memory from buffering large video files.
- **P3-2 (AI Safety Dataset):** Commit the missing `crime_data.arff` dataset or deploy a standalone Python FastAPI microservice for crime risk machine learning.
