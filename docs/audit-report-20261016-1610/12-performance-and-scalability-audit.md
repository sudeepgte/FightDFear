# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 12. PERFORMANCE AND SCALABILITY AUDIT

**Target:** JVM Memory Profile, Database Performance, Multipart Large Uploads, Clustering & Autoscaling  
**Load Testing Scripts Inspected:** `loadtests/` (k6 test scenarios for landing, creator feeds, and payments)  

---

### 12.1 Resource Limits & Memory Profile

1. **JVM Heap Exhaustion Finding (FF-QA-001):**
   - In `pom.xml`, the Surefire test runner is constrained to `-Xmx1024m -XX:+UseG1GC`.
   - Running full integration test suites caused `java.lang.OutOfMemoryError` on thread `MessageBroker-10` as successive Spring contexts, SockJS message brokers, and Hikari pools exhausted available heap.
   - **Production Recommendation:** Production JVM options should allocate a minimum of **2048 MB to 4096 MB** heap (`-Xms2g -Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200`).
2. **Tomcat Multipart & Large Video Upload Limits:**
   - In `application.properties`:
     `spring.servlet.multipart.max-file-size=2048MB`
     `spring.servlet.multipart.max-request-size=2048MB`
     `server.tomcat.max-swallow-size=-1`
     `server.tomcat.max-http-form-post-size=2048MB`
   - **Performance Risk:** Allowing 2 GB uploads into single-threaded Tomcat requests on low-RAM containers can cause out-of-memory crashes or request thread starvation. Large video uploads should be streamed directly to S3 via presigned multipart upload URLs rather than proxied through the Spring Boot JVM.

---

### 12.2 Database Performance & Indexing

- **Index Optimization Verified:**
  - `V40__performance_indexes.sql`: Indexes on foreign keys and active statuses.
  - `V50__concurrency_and_performance_indexes.sql`: Adds `idx_wallet_tx_user_date` and `idx_wp_orders_payment_id`.
- **Query Pagination:**
  - Creator feeds and product listings implement bounded queries with pagination (`PageRequest.of(page, size)`), preventing unconstrained full-table scans into JVM memory.
- **Scheduler Locks (ShedLock):**
  - All background cron tasks (e.g. `JourneyEscalationJob`, appointment reminders) are annotated with `@SchedulerLock(name = "...", lockAtLeastFor = "PT30S", lockAtMostFor = "PT5M")`.
  - When scaled to multiple containers connected to the same MySQL instance, only one container will execute each scheduled job, preventing duplicate email/SMS dispatch.

---

### 12.3 Horizontal Scalability Bottlenecks

| Subsystem | Scalability Architecture | Status | Bottleneck / Mitigation |
|---|---|:---:|---|
| **Web REST APIs** | Stateless REST | 🟢 Scalable | Can scale horizontally behind Nginx load balancer without shared session. |
| **Session Web (JSP)** | Sticky Session (`ip_hash`) | 🟡 Constrained | Requires sticky session routing; instance restart disconnects web users. |
| **Realtime STOMP** | In-Memory `SimpleBroker` | 🔴 Non-Scalable | Multi-instance deployment requires Redis Pub/Sub relay or RabbitMQ STOMP broker. |
| **File Storage** | Local Disk / AWS S3 | 🟡 Conditional | Local mode (`app.storage.type=local`) fails in cluster; requires `app.storage.type=s3`. |
| **Scheduled Jobs** | ShedLock via MySQL | 🟢 Scalable | Multi-instance safe; coordinated via database lock table. |
| **Database Tier** | Single MySQL 8.0 instance | 🟡 Limited | Single write instance; requires AWS RDS Read Replicas for > 10,000 active users. |

---

### 12.4 Load Testing Readiness

- Synthetic load test scripts exist in `loadtests/` using k6.
- **Audit Finding:** Staging load tests (100 VU and 500 VU) have **NOT been executed** against a live cluster.
- **Production Gate:** Load testing must be executed on a staging staging instance before public launch to verify that Nginx buffers large video streams without timing out.
