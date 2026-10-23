# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 02. ARCHITECTURE AND TECHNOLOGY STACK AUDIT

**Target System:** FightDFear Platform  
**Component Scope:** Backend, Frontend (JSP MVC), Mobile (Flutter), Database, Security Middleware, Storage & Realtime  
**Audit Status:** Complete Verified Architecture Inventory  

---

### 2.1 Discovered Technology Stack

Based on repository inspection of `pom.xml`, `mobile/pubspec.yaml`, `docker-compose.yml`, `deploy/nginx-fightdfire.conf`, and source packages:

| Layer | Component | Version / Specification | Role in FightDFear |
|---|---|---|---|
| **Runtime Environment** | Java Virtual Machine | Java 17 LTS (Eclipse Temurin) | Backend server execution environment |
| **Backend Framework** | Spring Boot | 3.4.3 (`spring-boot-starter-parent`) | Core web, dependency injection, and data access framework |
| **Web MVC / View** | Tomcat Embed Jasper & JSTL | Jakarta Servlet 6.0, JSTL 2.0.0 | Server-side rendering for 154 JSP management pages |
| **Security Framework** | Spring Security & JJWT | Spring Security 6.x, JJWT 0.11.5 | State management, RBAC, JWT tokens, CSRF protection |
| **Relational Database** | MySQL | MySQL 8.0 / Connector/J 8.3+ | Primary transactional relational database |
| **Schema Migrations** | Flyway | Flyway Core + Flyway MySQL | 51 versioned SQL schema migrations (`V1` to `V51`) |
| **Distributed Scheduling**| ShedLock | ShedLock 6.0.2 (Spring + JDBC) | Distributed `@SchedulerLock` across server nodes |
| **ORM / Data Access** | Hibernate / Spring Data JPA | Jakarta Persistence 3.1, Hibernate 6.6 | Entity-relational mapping, repositories, queries |
| **Realtime Messaging** | Spring WebSocket / STOMP | SockJS + STOMP simple broker | In-memory pub/sub for SOS alerts, chat, video updates |
| **Payment Gateway** | Razorpay SDK | `razorpay-java` 1.4.3 | Payment order creation, signature verification, webhooks |
| **Cloud Storage** | AWS SDK for Java | S3 SDK 2.29.45 | Scalable object storage backend for videos/photos (configurable) |
| **PDF Generation** | iTextPDF | 5.5.13.2 | Dynamic PDF generation for appointment and enrollment receipts |
| **Machine Learning** | Weka | 3.8.6 (`weka-stable`) | Machine learning algorithms for crime/safety classification |
| **Mobile Framework** | Flutter SDK & Dart | Flutter SDK (Dart ^3.12.2) | Cross-platform native mobile application (Android / iOS) |
| **Mobile State Mgmt** | Provider | `provider` 6.1.2 | Reactive application state, authentication state, and session |
| **Reverse Proxy** | Nginx | Custom Nginx configuration | Ingress traffic routing, WebSocket upgrades, sticky IP hashing |
| **Containerization** | Docker & Docker Compose | Docker Compose multi-service | Containerized production deployment of MySQL and App WAR |

---

### 2.2 Architectural Topology & Application Boundaries

FightDFear is built as a **hybrid modular monolith** combining traditional server-side rendered MVC with REST APIs and mobile clients:

```
                                  +------------------------------------+
                                  |     Mobile Clients (Flutter)       |
                                  |  - Native Android (app-release)    |
                                  |  - Native iOS                      |
                                  +------------------+-----------------+
                                                     | (HTTPS / WSS)
                                                     v
+-------------------------------+       +------------+------------+
| Web Browsers (JSP Frontend)   |       |   Reverse Proxy (Nginx) |
|  - Users, Doctors, Centres    +------>+  - Port 80 (HTTP)       |
|  - Salons, Sellers, Admin     |       |  - ip_hash upstream     |
+-------------------------------+       +------------+------------+
                                                     |
                                                     v
                                  +------------------+-----------------+
                                  |   Spring Boot WAR (Port 8084)      |
                                  |  +-------------------------------+ |
                                  |  | Security & Auth Filters       | |
                                  |  |  - JwtAuthenticationFilter    | |
                                  |  |  - CsrfCookieFilter           | |
                                  |  |  - CorrelationId / RequestId  | |
                                  |  +---------------+---------------+ |
                                  |                  |                 |
                                  |  +---------------+---------------+ |
                                  |  | Presentation Layers           | |
                                  |  |  - 164 Controllers            | |
                                  |  |  - JSP Views (/WEB-INF/views) | |
                                  |  |  - REST APIs (/api/**)        | |
                                  |  |  - STOMP Broker (/ws-*)       | |
                                  |  +---------------+---------------+ |
                                  |                  |                 |
                                  |  +---------------+---------------+ |
                                  |  | Service Layer (179 Services)  | |
                                  |  |  - SosService, DoctorService  | |
                                  |  |  - PaymentPendingOrderService | |
                                  |  |  - RateLimitService, ShedLock | |
                                  |  +---------------+---------------+ |
                                  +------------------+-----------------+
                                                     |
                         +---------------------------+---------------------------+
                         |                           |                           |
                         v                           v                           v
              +----------+----------+     +----------+----------+     +----------+----------+
              | MySQL 8.0 Database  |     | External Services   |     | File / Cloud Storage|
              |  - 258 JPA Entities |     |  - Razorpay Gateway |     |  - Local disk storage|
              |  - Flyway V1-V51    |     |  - Twilio / Msg91   |     |  - AWS S3 (Opt-in)  |
              |  - ShedLock table   |     |  - Google Maps API  |     +---------------------+
              +---------------------+     |  - Google Mail SMTP |
                                          +---------------------+
```

---

### 2.3 Authentication & Session Architecture

The application uses an ingenious but complex **Dual Authentication Model**:
1. **Web (JSP MVC):** Traditional `HttpSession` storing domain entity instances (`user`, `admin`, `loggedDoctor`, `loggedCentre`, `loggedSalon`, etc.).
2. **Mobile (Flutter REST):** Stateless `Authorization: Bearer <JWT>` header using 30-day HMAC-SHA256 tokens signed via JJWT.
3. **The Bridge (`JwtAuthenticationFilter.java`):**
   - When a mobile client sends a Bearer token or cookie, the filter validates the signature and extracts the subject and role.
   - It populates the Spring Security `SecurityContextHolder`.
   - Crucially, it **hydrates the legacy `HttpSession`** by fetching the user or partner from the database and setting session attributes. This allows controllers written for JSP session models to seamlessly handle mobile API requests!

---

### 2.4 Real-Time & WebSocket Architecture

- **Endpoints:** `/ws-chat` and `/ws-sos` registered with SockJS support.
- **Interceptors:**
  - `JwtHandshakeInterceptor`: Extracts JWT from request headers or query params during WebSocket handshake.
  - `StompAuthChannelInterceptor`: Validates STOMP `CONNECT`, `SUBSCRIBE`, and `SEND` commands.
- **Broker:** Spring's in-memory `SimpleBroker` mounted on `/topic`.
- **Architectural Bottleneck:** Because the broker is in-memory and not connected to an external message relay (RabbitMQ / Redis), Nginx is forced to use `ip_hash` to bind clients to a single server instance. If multiple backend instances are deployed without a shared broker, messages sent by a user connected to Instance A will NOT reach a subscriber connected to Instance B!

---

### 2.5 Storage Architecture

- **Abstracted Interface:** `StorageService` interface in `in.sp.main.Service.storage`.
- **Implementations:**
  - `LocalStorageService`: Writes directly to local disk (`uploads/` directory on container).
  - `S3StorageService`: Streams uploads to AWS S3 using AWS Java SDK 2.29.45.
- **Current Mode:** Configured by default to `app.storage.type=local`.
- **Multi-Instance Risk:** In a multi-instance container deployment without S3 configured, files uploaded to Instance 1 are unavailable on Instance 2, resulting in broken images and video playback failures.

---

### 2.6 Key Architectural Concerns & Findings

1. **Monolithic Controller Bloat:** `AdminController.java` is 3,184 lines long, `PaymentController.java` is 1,357 lines, and `SosService.java` is 748 lines. Responsibilities are heavily concentrated in single classes.
2. **In-Memory WebSocket Single Point of Failure:** The lack of a Redis Pub/Sub relay prevents horizontal autoscaling of realtime emergency alerts across multiple app instances.
3. **Database Concurrency Gaps:** While ShedLock handles scheduled cron jobs and V50 adds performance indexes, unique constraints on booking appointment slots are not fully enforced at the database schema level.
