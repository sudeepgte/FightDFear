# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 08. BACKEND, API AND INTEGRATIONS AUDIT

**Scope:** 164 Spring Controllers, 179 Services, REST Endpoints, Third-Party Integrations, Error Handling  
**Audit Standard:** Spring Framework 6.x Best Practices, RESTful API Standards, Resilience & Integration Health  

---

### 8.1 API Controller Structure & Endpoints Mapping

The backend exposes hundreds of endpoints divided between server-side HTML/JSP rendering routes and mobile JSON REST APIs:

| Functional Domain | Key Controllers | Primary Endpoints | Auth Mechanism |
|---|---|---|---|
| **Safety & SOS** | `SOSRestController`, `SosActivationController` | `POST /api/sos/trigger`<br>`GET /api/sos/active`<br>`POST /api/sos/cancel/{id}`<br>`GET /api/sos/history` | Bearer JWT (Mobile) or Session (Web) |
| **Location & Danger** | `LiveLocationController`, `DangerPointController`, `SafeRouteController` | `POST /api/live-location/update`<br>`GET /danger-points/all`<br>`POST /safeRoute/add` | Bearer JWT / Session |
| **Payments** | `PaymentController` | `POST /payment/create-order`<br>`POST /payment/verify`<br>`POST /payment/webhook/razorpay`<br>`GET /payment/config` | Bearer JWT / Session / Webhook HMAC |
| **Healthcare** | `DoctorController`, `MobileDoctorController`, `MobileDoctorAuthController` | `GET /api/doctors/list`<br>`POST /api/doctors/book`<br>`POST /api/doctors/provider/register-quick` | Public & Authenticated Doctor/User |
| **Martial Arts** | `MartialArtsCenterController`, `MobileMartialArtsController`, `OnlineClassController` | `GET /api/martial-arts/centres`<br>`POST /api/martial-arts/enroll`<br>`GET /api/martial-arts/attendance/qr` | Public browse & Member JWT |
| **Wellness & Glow** | `SalonController`, `StylistController`, `MobileGlowSpaceController` | `GET /api/glow/salons`<br>`POST /api/glow/book`<br>`GET /api/glow/stylists/{id}` | Public browse & Client JWT |
| **Marketplace** | `WomenProductController`, `MobileMarketplaceController`, `WomenProductDeliveryPartnerController` | `GET /api/marketplace/products`<br>`POST /api/marketplace/order/create`<br>`GET /api/delivery/orders/assigned` | User & Seller & Delivery Partner |
| **Events & Education** | `WomenEventController`, `FinancialLiteracyController`, `MobileWomenEventController` | `GET /api/women-events`<br>`POST /api/women-events/register`<br>`GET /api/financial-literacy/videos` | User & Event Host & Educator |
| **Funding & Startups**| `EntrepreneurController`, `InvestorController`, `MobileFundingCollaborationController` | `GET /api/funding/proposals`<br>`POST /api/funding/proposal/submit`<br>`POST /api/funding/meeting/request` | Entrepreneur & Investor JWT |
| **Creator Hub** | `CreatorHubController`, `MobileCreatorHubController`, `VideoUploadController` | `GET /api/creator-hub/feed`<br>`POST /api/creator-hub/video/upload`<br>`POST /api/creator-hub/tip` | Creator & Member JWT |
| **Administration** | `AdminController`, `MobileAdminController`, `AnalyticsController` | `GET /admin/dashboard.meta`<br>`POST /admin/approve/{id}`<br>`POST /admin/user/{id}/ban` | `ADMIN` / `SUPER_ADMIN` Role |

---

### 8.2 Validation, Error Handling & Exception Mapping

1. **Global Error Handling (`ApiExceptionHandler.java` & `GlobalErrorController.java`):**
   - `@RestControllerAdvice` captures standard validation exceptions (`MethodArgumentNotValidException`, `IllegalArgumentException`, `ResponseStatusException`).
   - Responses are serialized into standard JSON: `{"success": false, "error": "..."}`.
   - **Production Hardening Verified:** In `application-prod.properties`, stack traces and exception class names are suppressed (`server.error.include-stacktrace=never`, `server.error.include-exception=false`).
2. **Duplicate Request Handling & Idempotency:**
   - Handled robustly for payments via `PaymentPendingOrderService` and `payment_fulfillments` database table.
   - Handled for SOS triggers via `SosService.getActiveSOSForUser`, returning `alreadyActive: true` if an alert is already in progress.
3. **Transaction Boundaries (`@Transactional`):**
   - Core services (`SosService`, `DoctorBookingService`, `WomenProductOrderLifecycleService`) declare `@Transactional`.
   - **Risk:** In `PaymentController.java`, several multi-table updates (e.g. updating booking status and triggering async notification) occur within controller methods rather than a single atomic service transaction.

---

### 8.3 External Integrations Audit

| Integration | Provider | Implementation Class | Production Readiness Status | Key Concern |
|---|---|---|:---:|---|
| **Payment Gateway** | Razorpay | `PaymentController`, `DoctorPaymentService` | 🟡 **CONDITIONAL** | SDK configured; webhook signature verified; but price tampering risk exists on fallback types. |
| **Emergency SMS** | Twilio / Msg91 | `SMSService` | 🔴 **NOT CONFIGURED** | Disabled by default (`sms.enabled=false`); provider keys blank; fails silently. |
| **Email Service** | Google Mail SMTP | `EmailService`, `EmailAsyncService` | 🔴 **HIGH RISK** | Hardcoded credentials in `application.properties`; requires migration to AWS SES / SendGrid. |
| **Maps & Directions**| Google Maps API | `GoogleMapsService` | 🟡 **CONDITIONAL** | Distance matrix & static maps implemented; API key empty by default in properties. |
| **Object Storage** | AWS S3 | `S3StorageService` | 🟡 **CONDITIONAL** | Abstracted via `StorageService`; defaults to `local` disk; requires S3 in multi-instance. |
| **Realtime STOMP** | Spring WebSocket | `WebSocketConfig` | 🔴 **NOT CLUSTER-READY** | Simple in-memory broker; multi-instance deployment drops messages across nodes. |
| **Push Notifications**| Firebase / WebPush | `PushNotificationService` | 🟡 **PARTIAL** | Device tokens stored in `user_device_tokens`; FCM credentials required via environment. |
| **AI Safety Risk** | Weka ML | `AISafetyService` | 🔴 **BROKEN** | Dataset file `crime_data.arff` missing from repository root; classifier fails to train on startup. |
