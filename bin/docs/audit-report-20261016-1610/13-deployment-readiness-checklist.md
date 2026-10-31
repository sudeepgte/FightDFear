# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 13. DEPLOYMENT AND OPERATIONS READINESS CHECKLIST

**Environment:** Docker Compose / Linux VPS / Nginx Reverse Proxy  
**Branch:** `main`  
**Configuration Profiles:** `default` (Local Dev) vs `prod` (`application-prod.properties`)  

---

### 13.1 Deployment Readiness Checklist

| Category | Requirement | Verified Condition | Status |
|---|---|---|:---:|
| **Configuration** | Fail fast on startup if secrets are missing in `prod` profile | `ProductionEnvironmentValidator.java` asserts `JWT_SECRET`, `RAZORPAY_KEY_*`, `DB_*` | 🟢 PASS |
| **Secrets Management** | No plaintext production credentials committed to git | Plaintext Gmail and Razorpay test credentials committed in `application.properties` | 🔴 FAIL |
| **Database Migrations**| Automated schema versioning on startup | Flyway V1–V51 enabled; baseline version 1 | 🟢 PASS |
| **Database Safety** | Hibernate prohibited from mutating schema in production | `spring.jpa.hibernate.ddl-auto=validate` set in `application-prod.properties` | 🟢 PASS |
| **Boot DDL Isolation** | No raw DDL executed during application boot | `DatabaseSchemaUpdate.java` executes unmanaged raw DDL and destructive UPDATE on boot | 🔴 FAIL |
| **Transport Security** | All external HTTP traffic encrypted via TLS 1.3 | `nginx-fightdfire.conf` configured for port 80 HTTP only; no SSL/TLS | 🔴 FAIL |
| **HSTS Headers** | HTTP Strict Transport Security enforced | Missing in Nginx configuration | 🔴 FAIL |
| **Reverse Proxy** | WebSocket proxy headers (`Upgrade`, `Connection: Upgrade`) | Configured correctly for `/ws-chat/` and `/ws-sos/` | 🟢 PASS |
| **Health Probes** | Liveness and Readiness probes for zero-downtime deploy | `/actuator/health` enabled with probe support; details hidden | 🟢 PASS |
| **Graceful Shutdown** | Allow in-flight transactions to complete on container stop | `server.shutdown=graceful`, `timeout-per-shutdown-phase=30s` | 🟢 PASS |
| **Scheduler Safety** | Multi-instance scheduler deduplication | ShedLock configured with JDBC Template | 🟢 PASS |
| **Log Leak Prevention**| Suppress SQL parameters and stack traces in production | `show-sql=false`, `server.error.include-stacktrace=never` | 🟢 PASS |
| **Automated Deploy** | Health-gated rollout with rollback capability | `deploy/deploy.sh` waits for health URL; prunes images | 🟡 PARTIAL |
| **Database Backups** | Automated daily database snapshots and offsite archive | No automated cron backup script committed in `deploy/` | 🔴 FAIL |

---

### 13.2 Required Environment Variables for Production Launch

Before activating `SPRING_PROFILES_ACTIVE=prod`, the following environment variables MUST be supplied via Docker Secrets or secure VPS `.env`:

```bash
# --- Core Application ---
SPRING_PROFILES_ACTIVE=prod
APP_BASE_URL=https://fightdfear.org
PORT=8084

# --- Database ---
DB_URL=jdbc:mysql://db:3306/womenbesafe?createDatabaseIfNotExist=false&useSSL=true&characterEncoding=UTF-8&connectionCollation=utf8mb4_unicode_ci
DB_USERNAME=fightdfear_prod
DB_PASSWORD=<STRONG_RANDOM_PASSWORD_MIN_24_CHARS>

# --- Security & JWT ---
JWT_SECRET=<STRONG_CRYPTOGRAPHIC_SECRET_MIN_64_CHARS>
SESSION_COOKIE_SECURE=true

# --- Payment Gateway (Live Razorpay) ---
RAZORPAY_KEY_ID=rzp_live_<ACTUAL_LIVE_MERCHANT_KEY>
RAZORPAY_KEY_SECRET=<ACTUAL_LIVE_MERCHANT_SECRET>
RAZORPAY_WEBHOOK_SECRET=<CONFIGURED_WEBHOOK_SECRET>
PAYMENT_MOCK=false

# --- Outbound Mail (Production SMTP) ---
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=<SENDGRID_OR_SES_API_KEY>

# --- Emergency SMS & Telephony ---
SMS_ENABLED=true
SMS_PROVIDER=twilio
TWILIO_ACCOUNT_SID=<LIVE_TWILIO_SID>
TWILIO_AUTH_TOKEN=<LIVE_TWILIO_TOKEN>
TWILIO_PHONE_NUMBER=<APPROVED_10DLC_OR_TOLL_FREE_NUMBER>

# --- Cloud Storage ---
STORAGE_TYPE=s3
S3_BUCKET=fightdfear-production-media
S3_REGION=ap-south-1
S3_ACCESS_KEY=<AWS_IAM_ACCESS_KEY>
S3_SECRET_KEY=<AWS_IAM_SECRET_KEY>

# --- Mapping & Geolocation ---
GOOGLE_MAPS_API_KEY=<RESTRICTED_GOOGLE_MAPS_API_KEY>
```
