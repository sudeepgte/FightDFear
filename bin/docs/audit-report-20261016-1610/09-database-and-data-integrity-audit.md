# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 09. DATABASE AND DATA INTEGRITY AUDIT

**Engine:** MySQL 8.0 Community / Commercial  
**Dialect:** `org.hibernate.dialect.MySQL8Dialect`  
**Connection Pool:** HikariCP (`maximum-pool-size=20`, `minimum-idle=5`)  
**Schema Governance:** Flyway 51 Migrations (`V1` through `V51`)  

---

### 9.1 Schema Architecture & Flyway Migrations Inventory

The database is defined across 51 SQL migrations in `src/main/resources/db/migration/`:

| Migration Range | Key Additions / Modifications | Purpose |
|---|---|---|
| **V1 – V12** | Baseline, Loan applications, Category columns, Service provider UTF-8 migrations | Initial domain foundation |
| **V13 – V17** | Doctor module Phase 1, profiles, verification tables, payments hardening | Healthcare telemedicine schema |
| **V18 – V20** | Martial arts centre completion, partner profiles, trainer status | Skill development & wellness |
| **V21 – V26** | Job applications, Lawyer profiles, Delivery partners, Order live tracking, Creator Hub | Marketplace & Creator Economy |
| **V27 – V38** | Financial literacy, Module 10 upgrades across Doctors, Martial Arts, Glow, Jobs, Products | Deep domain capability upgrades |
| **V39 – V41** | `payment_pending_orders`, `payment_fulfillments`, `payment_webhook_events`, V40 performance indexes, V41 `shedlock` | Idempotent payments & scheduler locks |
| **V42 – V49** | `rate_limit_buckets`, normalized product categories, `women_events` phase 1 | Rate limiting & event ticketing |
| **V50 – V51** | `idx_wallet_tx_user_date`, `idx_wp_orders_payment_id`, Admin `role` column (`SUPER_ADMIN`) | Concurrency indexes & Super Admin RBAC |

---

### 9.2 Critical Database Defects & Integrity Risks

#### 1. FF-DB-001 (High): Destructive Boot DDL & Data Mutation in `DatabaseSchemaUpdate.java`
- **Location:** `in.sp.main.Config.DatabaseSchemaUpdate.java`.
- **Mechanism:**
  ```java
  @Component
  public class DatabaseSchemaUpdate implements CommandLineRunner {
      @Override
      public void run(String... args) throws Exception {
          jdbcTemplate.execute("ALTER TABLE enrollment MODIFY COLUMN status VARCHAR(50)");
          jdbcTemplate.execute("UPDATE financial_videos SET duration = NULL, level = NULL");
          jdbcTemplate.execute("UPDATE financial_live_sessions SET meeting_url = '' WHERE ...");
          ...
      }
  }
  ```
- **Architectural Violation:**
  - This unprofiled bean runs automatically **on every single application boot**, including production.
  - Line 46 executes: `UPDATE financial_videos SET duration = NULL, level = NULL`. Any duration or difficulty level entered by financial educators is wiped upon every server restart!
  - Running unversioned raw `ALTER TABLE` statements outside Flyway creates out-of-band schema changes that conflict with `spring.jpa.hibernate.ddl-auto=validate`.
- **Remediation:** Remove `DatabaseSchemaUpdate.java` completely; encapsulate any necessary structural migrations into a new Flyway migration `V52__normalize_enrollment_and_videos.sql`.

---

#### 2. FF-DB-002 (Medium): Inconsistent DDL Strategy Across Environments
- In `application.properties`:
  `spring.jpa.hibernate.ddl-auto=update`
  `spring.flyway.enabled=true`
- In `application-prod.properties`:
  `spring.jpa.hibernate.ddl-auto=validate`
- **Risk:**
  - When development or testing environments run with `ddl-auto=update`, Hibernate automatically alters tables whenever an entity field is changed in Java code, without requiring a Flyway script.
  - If developers add an entity field locally, it works in dev/test, but **immediately fails on production startup** because production uses `ddl-auto=validate`, which throws `SchemaManagementException` if a column is missing in the database.

---

#### 3. FF-DB-003 (Medium): Missing Unique Index on Doctor Appointment Slots
- **Location:** `DoctorAppointment.java` / `db/migration/V13__doctor_module_phase1.sql`.
- **Issue:**
  - Double-booking prevention currently relies solely on application-level checks in `DoctorBookingService.java`:
    `requireAvailableDoctorSlot(doctor, appointmentTime)`.
  - There is no database-level unique constraint on `(doctor_id, appointment_time)` for appointments that are not cancelled. Under heavy concurrent booking pressure, race conditions can cause two users to simultaneously book the same appointment slot.
- **Remediation:** Add a partial or functional unique constraint on active bookings:
  `CREATE UNIQUE INDEX uq_doctor_active_slot ON doctor_appointments (doctor_id, appointment_time) WHERE status NOT IN ('CANCELLED', 'REJECTED');`

---

### 9.3 Concurrency & Performance Indexes Evaluation

- **V40 & V50 Indexes Verified:**
  - `idx_wallet_tx_user_date` on `wallet_transaction (user_id, transaction_date)` ensures rapid balance aggregation.
  - `idx_wp_orders_payment_id` on `women_product_orders (razorpay_payment_id)` prevents full table scans on payment reconciliation.
  - `idx_payment_pending_order_id` on `payment_pending_orders (order_id)` optimizes checkout callback lookups.
- **Connection Pool Configuration:**
  - HikariCP pool is tuned for 20 connections with a 30-second timeout, suitable for a mid-scale single instance (~100–200 concurrent requests).
  - Open-in-view is disabled in production (`spring.jpa.open-in-view=false`), preventing long-held database connections during view rendering.
