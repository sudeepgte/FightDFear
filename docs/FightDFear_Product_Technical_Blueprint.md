# FightDFear — Complete Product Blueprint, System Audit & Market Positioning

**Document type:** Product + technical blueprint (implementation-true)  
**Codebase audited:** KishorDfire / FightDFear repository (Spring Boot 3.4.3, Java 17, Flutter, JSP web, MySQL 8, Flyway). A second pass from [Audit FightDFear codebase](4708a5d0-6e42-4249-8f3b-3536ea5d1181) corrected stack and status labels.  
**Production URL:** `https://fightdfire.chethancodehub.com`  
**Release mobile API host:** `ApiConfig.productionHost` → same origin  
**Document date:** 14 August 2026  
**Classification:** Internal — suitable for engineering, product, management, and investors  

**Methodology**
- **Source of truth for “current state”:** this repository (entities, controllers, Flutter screens, admin routes, Flyway, `SecurityConfig`, payment/mail/JWT configuration). Planned or discussed features are labelled **Required** or **Future**, never **Existing**.
- **Youthian Blueprint:** used only as a structural/depth reference. The PPTX at `Youthian_blueprint.pptx` is **image-rasterized (38 slides, no extractable text)**. Section depth follows that style (~32 major sections) without copying Youthian content.
- **Market claims:** dated sources; numbers not invented. “Not publicly disclosed” where a competitor’s scale/pricing is not official.

---

## 0. Executive summary

FightDFear is **not only a SOS app**. The codebase implements a **women-oriented super platform**: safety + community video + Glow (beauty) + doctors + fitness + martial arts + jobs/lawyers marketplace + women products + events + entrepreneur/investor funding + financial literacy + creator hub — with a large **JSP admin** verification surface and Flutter **user + partner portals**. Thymeleaf is configured but `src/main/resources/templates` is empty; all server-rendered UI is JSP (`/WEB-INF/views/`).

**What it is today:** a feature-rich MVP/early production system with real APIs, Razorpay, JWT (mobile) + session (web), partner KYC-style profile completion, and admin approve/reject flows. Production uses `ddl-auto=validate` + Flyway; schema completeness has been an active incident class (reminder column names, missing `read_by_doctor`, missing `women_events` table).

**What it is not today:** a regulated financial institution, a police-dispatch network, a full RBAC/moderator product, or an LLM assistant (no OpenAI/Gemini client). The only “AI” class is `AISafetyService` (Weka J48), which needs `crime_data.arff` / `safety_model.model` and is **PLACEHOLDER** without those files. Wallet rewards are dummy in both `WalletController` and `MobileWalletController`. Push “FCM” **stores tokens and logs**; it does not send HTTP v1 messages.

**Strategic bet:** one identity and trust layer across safety, livelihood, health, and community — versus users juggling 112 India + Naukri/Kaabil + Urban Company/Sitha + Nykaa/SHE-MART + Instagram.

**Biggest near-term risks:** schema/ops (validate vs incomplete Flyway; `FlywayRepairConfig` runs `repair()` on startup); dual money systems; mixed auth and **CSRF disabled**; committed secrets in `application.properties` (mail, Razorpay test keys, Maps, JWT fallback); no dedicated moderator role; SOS not wired to ERSS-112 and **FCM not actually sent**; SMS off by default (`sms.enabled=false`); incomplete tests.

---

## 1. How to read this document

| Label | Meaning |
|---|---|
| **FULLY** | Substantially implemented end-to-end (mobile and/or web + backend) |
| **PARTIAL** | Real code, but missing workflow, admin, payment, or UX pieces |
| **UI ONLY** | Screen/template without complete backend |
| **BACKEND ONLY** | API/entity without usable client |
| **PLACEHOLDER** | Dummy data or scaffold |
| **MISSING** | No meaningful implementation |
| **BROKEN / REWORK** | Exists but unsafe, inconsistent, or ops-fragile |

**CURRENT → GAP → REQUIRED → FUTURE** is used per domain.

---

## 2. System snapshot (from the repo)

| Layer | What exists |
|---|---|
| **Mobile** | Flutter app `mobile/` (`fight_d_fear` 1.0.0+1), 100+ screens, release → production HTTPS |
| **Web user/partner** | Spring MVC + **JSP** (~285 views): public landing, login, partner dashboards (`/doctors`, `/centres`, `/salon`, `/marketplace`, `/entrepreneur`, `/investor`, `/creator-hub`, `/financial-literacy`, …). Thymeleaf: configured, **no pages**. |
| **Admin** | `AdminController` `@RequestMapping("/admin")` — dashboard, users, SOS, videos, doctors, providers, sellers, event hosts, events, salons, stylists, jobs, proposals, entrepreneurs, investors, fitness, safety points, broadcasts, reports |
| **API** | `/api/**` mobile REST (auth, doctors, glow, marketplace, martial-arts, fitness, women-events, products, delivery, landing, chat, videos, wallet, journey, buddy, creator-hub, financial-literacy, entrepreneur, investor) |
| **DB** | MySQL 8, JPA types under `in.sp.main.Entities` (~175 types), Flyway `V1`–`V45` |
| **Auth** | BCrypt; JWT filter for `/api/**`; session attributes for MVC; OTP email on partner register-quick |
| **Payments** | Razorpay keys via env; `PAYMENT_MOCK`; pending orders + webhook + fulfillment (V39); doctor/salon/enrollment/product payments |
| **Jobs** | ShedLock (`V41`), rate-limit buckets (`V42`) |
| **Maps** | Google Maps key in `application.properties` **and** hardcoded in Flutter `maps_config.dart` / `GoogleMapsService.FALLBACK_KEY` |
| **AI** | **No LLM.** `AISafetyService` = Weka J48 + `crime_data.arff` (PLACEHOLDER if files absent) |
| **Push** | Token register + log only (`PushNotificationService`) |

**UserType enum (actual):** `USER, ADMIN, VOLUNTEER, CENTRE, DOCTOR, STYLIST, SALON, PROVIDER, SELLER, ENTREPRENEUR, INVESTOR, FITNESS_TRAINER, EVENT_HOST`  
**Partner tables/APIs not in `UserType`:** `FinancialEducator`, `DeliveryPartner`, Creator (flags on `User`), job worker (`JobApplication`).  
There is **no** `MENTOR`, `EMPLOYER`, `MODERATOR`, or `SUPER_ADMIN` enum value.

---

## 3. Current implementation inventory

| Domain | Status | Evidence |
|---|---|---|
| User auth (register/login/JWT/OTP/password reset) | **FULLY** (mobile+API); web session **PARTIAL** | `MobileAuthController`, `AuthController`, `JwtAuthenticationFilter` |
| SOS / panic / trusted contacts / SMS-email notify | **PARTIAL** | Mobile SOS+journey+contacts **FULLY**; panic/recording/battery/SOS audio **web/backend only**; SMS default off |
| Live location / journey | **PARTIAL** | Journey FULLY (web+mobile); live location MVC; Flutter SOS sends GPS in trigger |
| Danger points / safe routes / heatmap | **PARTIAL** | Danger map on Flutter; safe routes admin JSP |
| Emergency contacts / medical details | **PARTIAL** | Contacts FULLY web+mobile; medical MVC |
| Recording / SOS audio | **BACKEND ONLY** | `RecordingController`, `SOSAudioController` — no Flutter usage found |
| Volunteer SOS response | **PARTIAL** | Web volunteer respond; admin volunteer-management |
| Battery / offline flags | **BACKEND ONLY** | `BatteryStatusController` — no Flutter |
| Crime-score “AI” | **PLACEHOLDER** | `AISafetyService` Weka; needs ARFF/model files |
| Community video/reels/likes/comments/follow | **FULLY** (web core); mobile **PARTIAL** | Creator feed vs `/video` |
| Groups / Q&A / express posts | **PARTIAL** | Groups/express **MISSING** Flutter |
| Chat (user, doctor, salon, fitness, proposal) | **PARTIAL** | Web chat FULLY; mobile `/api/chat` PARTIAL |
| Women products / cart / orders / delivery / returns | **PARTIAL** | Returns **web-only**; mobile checkout/track/cancel/rate |
| Wallet coins / redeem | **PLACEHOLDER** | Dummy catalog on **web and** `/api/wallet` |
| INR wallet / Razorpay | **PARTIAL** | Real create-order+verify; local `PAYMENT_MOCK` default true |
| Push notifications | **PLACEHOLDER** | Tokens stored; FCM HTTP v1 **not wired** |
| AI assistant / recommendations | **MISSING** | No OpenAI/Gemini |
| Glow salons / bookings / stylists | **FULLY** (core) | `/api/glow`, `Booking1`, admin salons/stylists |
| Women doctors / appointments / Razorpay | **FULLY** (core); chat unread **recently schema-fragile** | `/api/doctors`, `DoctorAppointment` |
| Fitness trainers / bookings | **FULLY** (core) | `/api/fitness` |
| Martial arts centres / enrollment / certificates | **FULLY** (core) | `/api/martial-arts`, `Enrollment` |
| Jobs / workers / bookings | **FULLY** (core) | `/api/marketplace`, `JobApplication`, `WorkerBooking` |
| Lawyers / service providers | **FULLY** (core) | `ServiceProvider`, marketplace lawyer screens |
| Women products / cart / orders / delivery / returns | **FULLY** (core); settlement **PARTIAL** | `/api/women-products`, `WomenProductOrder` |
| Events / hosts / registration | **PARTIAL** — **prod table `women_events` missing until V45** | `/api/women-events`, `WomenEvent` |
| Entrepreneur / investor / proposals / investments | **PARTIAL** | `/api/entrepreneur`, `/api/investor`, admin proposals |
| Financial literacy (educator, videos, sessions, workshops) | **PARTIAL** | `/api/financial-literacy` — **education content, not regulated advice** |
| Creator hub / stories / tips / cashout | **PARTIAL** | `/api/creator-hub` |
| Wallet coins / redeem | **PARTIAL + PLACEHOLDER rewards** | `User.rewardPoints`, `WalletController` dummy list |
| INR wallet / Razorpay | **PARTIAL** | `User.walletBalance`, `PaymentPendingOrder` |
| Partner payout balances | **PARTIAL** | `payout_balance` / `payout_requested_at` on many partner entities |
| Admin verification factory | **FULLY** for listed partner types | `AdminController` verify/reject/request-changes |
| Fine-grained RBAC / audit log product | **MISSING** | no moderator role; no dedicated audit entity beyond payment webhooks |
| AI assistant / recommendations | **MISSING** | no LLM integration in Java |
| Official 112 / police dispatch | **MISSING** | private contact SOS only |
| iOS app | **MISSING** in this repo (Android Flutter APK) | `mobile/android` |

---

## 4. Super-platform map (current vs claimed)

FightDFear **should be documented as a women empowerment super platform**. Mapping to actual code:

| Pillar | In code today | Do not over-claim |
|---|---|---|
| Safety | SOS, panic, contacts, journey, buddy, danger/safe points, volunteers, heatmap | Not ERSS-112; not a certified panic-button OEM |
| Community | Reels, comments, likes, follow, chat, groups, Q&A, reports/block | Not a full Instagram-scale graph or Trust & Safety org |
| Jobs / career | Job applications, worker bookings, admin approve | Not Naukri ATS; no “employer” role |
| Education / skills | Martial arts enrollment, online classes, financial literacy videos/sessions | Not a university LMS; certificates are centre-issued |
| Healthcare | Doctors, appointments, fees, chat, Rx JSON fields | Not a hospital HIS; not e-pharmacy |
| Fitness | Trainers, bookings, chat | Not Cult.fit scale |
| Marketplace | Products, orders, delivery partners, returns | Settlement/GST/tax **incomplete** |
| Entrepreneurship | Entrepreneurs, proposals, investors, investments, meetings, chat | Not a SEBI-registered funding platform |
| Events | Hosts, events, registrations | Schema/ops fragile (`women_events`) |
| Rewards | Coins + dummy redeem | Not a closed-loop payments license |
| AI | — | **Do not market AI until implemented** |

---

## 5. CURRENT vs GAP vs REQUIRED vs FUTURE (by module)

### 5.1 Safety

**CURRENT:** Panic activate + location posts (`/panic`); SOS request/response entities; trusted/emergency contacts; journey sessions; buddy requests; danger points + safe routes with admin verify; SOS audio upload; recording start/stop; volunteer responses; admin SOS list/resolve and CSV export; Flutter safety screens (journey, buddy).  
**GAP:** No 112/police API; SOS reliability depends on SMS/mail/FCM; live tracking multi-instance documented but not a dedicated geo-stream product; battery/offline are thin.  
**REQUIRED:** Tested SOS runbook, SMS failover, consent, retention, admin SLA, schema validate green.  
**FUTURE:** ERSS integration, offline SMS SOS, wearable, predictive unsafe-area (needs data + ethics).

### 5.2 Community / video

**CURRENT:** `user_videos` / reels APIs, likes, comments, views, bookmarks, reports, follow/block, admin block reported videos, reward-on-video.  
**GAP:** No dedicated moderator queue UX; creator payouts separate from user coins.  
**REQUIRED:** Moderation SLAs, CSAM/abuse policy, rate limits (partially present).  
**FUTURE:** Ranking ML, live streaming at scale.

### 5.3 Jobs

**CURRENT:** Worker register/login/OTP, applications, admin approve/reject, bookings, Flutter job screens.  
**GAP:** No employer company KYC as a distinct role; matching is listing-based.  
**REQUIRED:** Clear worker vs client contracts, dispute flow.  
**FUTURE:** Skills graph, verified returnships (HerJobs-like).

### 5.4 Education / martial arts / financial literacy

**CURRENT:** Centres, batches, enrollment, payment fields, certificates; financial educators, videos, live sessions, workshops, enrollments.  
**GAP:** Assessments shallow; financial module is **content + booking**, not banking.  
**REQUIRED:** Disclaimers; educator verification completeness.  
**FUTURE:** Accredited courses, NSDC alignment (partnership, not claimed).

### 5.5 Healthcare

**CURRENT:** Doctor register/OTP/profile completion, admin verify/reject/request-changes, appointments, Razorpay order/verify, chat, prescription JSON, reminders (column mapping recently fixed).  
**GAP:** Clinical governance, prescription legality, malpractice process.  
**REQUIRED:** License verification ops, consent, recording policy for consults.  
**FUTURE:** EHR interoperability — only if legally scoped.

### 5.6 Marketplace / Glow / lawyers / products

**CURRENT:** Parallel provider systems (salon `Booking1`, `ServiceProvider` lawyers, job workers, product sellers, delivery partners) with profile completion + admin queues. Orders, tracking lat/lng, returns.  
**GAP:** Multiple “wallet/payout” columns; commission ops incomplete; GST invoicing not a product.  
**REQUIRED:** One ledger; settlement reports; dispute.  
**FUTURE:** National logistics partners.

### 5.7 Entrepreneurship / events

**CURRENT:** Entrepreneur/investor portals, proposals, investments, meetings, chat; event hosts, event CRUD APIs, admin approve events/hosts.  
**GAP:** `women_events` missing in some prod DBs until V45; photos/reviews tables never Flyway-created. Funding is **not** a registered AIF.  
**REQUIRED:** Legal disclaimers; schema completeness.  
**FUTURE:** Government scheme deep-links (Mudra etc.) as **referrals**, not loan origination.

### 5.8 Wallet / coins

**CURRENT:** `rewardPoints` + `WalletTransaction`; web redeem with **dummy rewards list**; `walletBalance` Double on User; partner `payout_balance`; Razorpay for real INR; creator cashout/tips.  
**GAP:** Three+ money concepts; dummy redeem.  
**REQUIRED:** Single ledger; never block SOS behind coins.  
**FUTURE:** Prepaid instruments only with compliance.

### 5.9 AI

**CURRENT:** **MISSING.**  
**GAP:** Entire pillar.  
**REQUIRED:** None until privacy/security baseline.  
**FUTURE:** Safety copilot, routing, moderation assist — with human-in-the-loop.

---

## 6. Admin (deep)

**Entry:** `/admin/loginAdmin`, dashboard `/admin/adminDashboard`. Session-based admin (`Admin` entity), not Spring `ROLE_ADMIN` method security on each route.

| Capability | Existing | Partial | Missing | Required | Priority |
|---|---|---|---|---|---|
| Dashboard + heatmap JSON | Yes | | Analytics product | Real metrics, authz | P1 |
| Users list, ban/unban/delete | Yes | Soft-delete/audit | GDPR export/erasure SLA | P0 |
| Pending user verify/reject | Yes | | Document checklist UX | P1 |
| Doctors verify/reject/request-changes | Yes | | License authenticity ops | P0 |
| Providers (lawyers) same | Yes | | Bar ID ops | P1 |
| Sellers same | Yes | | GSTIN ops | P1 |
| Event hosts + women-events approve | Yes | Blocked if table missing | Schema + queue | P0 |
| Salons/stylists approve/reject | Yes | | | P1 |
| Job applications approve | Yes | | Employer side | P1 |
| Entrepreneurs/investors/proposals | Yes | Investment release | Securities disclaimer | P0 legal |
| Fitness verify/suspend | Yes | | | P1 |
| SOS list/resolve/export | Yes | No 112 | Runbook | P0 |
| Danger/route verify | Yes | | | P1 |
| Videos reward + reported block | Yes | No full moderator | Queue + CSAM | P0 |
| Broadcast messages | Yes | | Targeting/consent | P1 |
| Contact messages | Yes | | Ticketing | P2 |
| Product orders view | Yes | Refunds/settlement UI | Finance ops | P1 |
| Martial arts centre approve | Yes (`/approve/{id}`) | | | P1 |
| Fine-grained roles (moderator vs finance vs superadmin) | | | **Missing** | Split duties | P0 |
| Immutable audit log of admin actions | | | **Missing** | Who approved what | P0 |
| CMS / legal pages editor | | Thin offline/terms | Policy CMS | P2 |
| Support desk | | Contact messages only | | P2 |

**Workflows present:** verify, reject, request-changes (several partner types), ban/unban, SOS resolve, video block.  
**Workflows weak/missing:** dual-control for payouts, impersonation logs, field-level permission, automated SLA timers.

---

## 7. Mobile blueprint

**Stack:** Flutter, Provider, http, geolocator, Google Maps, image_picker, video_player, razorpay_flutter, shared_preferences.

**Auth:** `login_screen`, OTP partner `portal_auth_screen`, JWT via `ApiConfig`. Release builds **always production host** unless `--dart-define=API_BASE`.

**Major screen groups (implemented):** landing + user dashboard; safety (journey, buddy); doctors (booking + doctor dashboard + profile completion); glow (space, salon detail, salon dashboard, provider signup); fitness; martial arts (user + centre + admin); marketplace (jobs, lawyers, bookings); products (shop, seller, delivery); events (list + host portal); entrepreneur/investor/funding; financial literacy; creator hub; wallet; profile.

**Already implemented:** partner profile completion + skip; SOS-related navigation (via APIs); Razorpay checkout on paid modules; production API switch.

**Partial:** empty/error/retry recently improved on landing; not all modules have equivalent polish; iOS not in repo.

**Missing / required for production:** crash reporting (Sentry/Firebase) as first-class; forced-update; accessibility; Hindi/vernacular; proven SOS on low-network; certificate pinning; store listing + privacy nutrition labels.

**Permissions:** location, camera, mic (recording/SOS audio), notifications — must match Play policy and in-app consent.

---

## 8. Web ecosystem

| Surface | Path/pattern | Role |
|---|---|---|
| Public site | `/`, `/features`, `/map`, `/heatmap` | Discovery |
| User web | `/login`, `/user`, `/qna`, `/chat`, `/users/wallet`, SOS/panic, videos | End user |
| Admin | `/admin/**` | Operators |
| Doctor portal | `/doctors/**` | Doctors |
| Martial arts | `/centres/**`, `/enrollment/**` | Centres / users |
| Glow | `/salon/**`, `/stylists/**`, `/booking/**` | Salons |
| Marketplace | `/marketplace/**` | Jobs/lawyers web |
| Products | `/women-products/**` | Sellers/shop |
| Funding | `/entrepreneur/**`, `/investor/**`, `/funding/**` | Biz |
| Events | women-events MVC + `/api/women-events` | Hosts/users |
| Creator | `/creator-hub/**` | Creators |
| Financial | `/financial-literacy/**` | Educators/users |

Interaction: **same MySQL**, mixed session (web) and JWT (mobile). Partners often have **both** a web dashboard and a Flutter portal.

---

## 9–18. Module blueprints (condensed, evidence-based)

Each module below: purpose, users, impl, limits.

**SOS/Panic** — Purpose: alert trusted people. Users: USER. Backend: `/panic/activate`, `/sos`. Admin: list/resolve. Notifications: mail/SMS/FCM async. **Not** public-safety answering point. Payment: none (must stay free).

**Journey/Buddy** — Purpose: timed travel + companion. APIs `/api/journey`, `/api/buddy`. Partial realtime.

**Doctors** — Purpose: book verified women doctors. APIs `/api/doctors`, `/api/doctors/provider`. DB: `doctors`, `doctor_appointments`, chat, favorites. Admin verify. Payments Razorpay. Limitations: clinical/legal.

**Glow** — Salons/stylists/bookings. `/api/glow`. Table `booking1` (legacy name). Admin salon/stylist queues.

**Fitness** — `/api/fitness`. Bookings + chat.

**Martial arts** — `/api/martial-arts`. Enrollment, batches, certificates, attendance.

**Jobs** — `/api/marketplace` jobs + worker dashboard. Admin job-application approve.

**Lawyers** — `ServiceProvider` + lawyer Flutter. Admin providers.

**Products** — Catalog, cart, wishlist, orders, delivery partner, returns. Admin sellers + orders list.

**Events** — Hosts + events + registrations. **V45 creates `women_events`.** Photos/reviews still Flyway-absent.

**Funding** — Proposals, investments, meetings, chat. Admin approve + investment release. **Not a fund.**

**Financial literacy** — Educators, videos, sessions, workshops. Disclaimer required.

**Creator hub** — Profiles, stories, tips, cashout, reviews.

**Community video** — `/api/videos`, `/video`.

---

## 19. Rewards / wallet / coins — overlap

| Mechanism | Where | Status |
|---|---|---|
| `rewardPoints` + redeem | `User`, `WalletController` | Dummy catalog (“10% Off Salon…”) |
| `walletBalance` | `User` | INR-like Double; incomplete product |
| `WalletTransaction` | ledger-ish | Partial |
| Razorpay orders | doctors, glow, enrollment, products | Real path; mock flag |
| `payout_balance` on partners | Doctor, Salon, Seller, etc. | Ops incomplete |
| Creator tips/cashout | creator entities | Partial |

**Required:** one money architecture document; SOS never paywalled.

---

## 20. AI

**Implemented:** none found (`openai|gemini|chatgpt` grep empty in `in.sp.main`).  
**Do not claim** AI safety copilot.  
**Future (after P0 security):** moderation assist, route risk **with** Safetipin-like data partnerships, not scraped rumor maps. Privacy: location + SOS must not be sent to third-party LLMs without explicit consent.

---

## 21. Roles & permissions matrix (actual roles)

Legend: V view, C create, U update, D delete, A approve, M moderate, $ payments.

| Module | USER | VOLUNTEER | CENTRE | DOCTOR | STYLIST/SALON | PROVIDER | SELLER | ENTREPRENEUR | INVESTOR | EVENT_HOST | FITNESS_TRAINER | ADMIN |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Own profile | VCU | VCU | VCU | VCU | VCU | VCU | VCU | VCU | VCU | VCU | VCU | A/D |
| SOS | C | V respond | — | — | — | — | — | — | — | — | — | A resolve |
| Reels | VCUM | — | — | — | — | — | — | — | — | — | — | M |
| Doctor booking | C | — | — | VCU | — | — | — | — | — | — | — | A verify doctor |
| Glow book | C | — | — | — | VCU | — | — | — | — | — | — | A salon |
| Jobs | C apply | — | — | — | — | — | — | — | — | — | — | A applications |
| Products | C order | — | — | — | — | — | VCU | — | — | — | — | A seller |
| Events | C register | — | — | — | — | — | — | — | — | VCU | — | A event |
| Funding | V | — | — | — | — | — | — | VCU | VCU $ | — | — | A + release $ |
| Admin console | — | — | — | — | — | — | — | — | — | — | — | All (unsplit) |

**Gap:** ADMIN is omnipotent; no Moderator / Finance / SuperAdmin split.

---

## 22. End-to-end journeys (as coded)

**New user:** Flutter register/login (`/api/auth`) → landing feed (`/api/landing`) → dashboard → optional profile/location picker. Web: `/login` session.

**Emergency:** Panic/SOS APIs → notify contacts (SMS/email/FCM) → admin SOS queue → resolve. **No automatic police.**

**Job seeker:** marketplace jobs register-quick + OTP → apply → admin may approve application → worker bookings.

**Provider (doctor/salon/lawyer/trainer/centre):** register-quick + email OTP → profile completion → `partner_profile_status` → admin verify/reject/request-changes → dashboard bookings.

**Seller:** women-products seller auth → catalog → orders → delivery partner assignment → tracking fields.

**Entrepreneur:** register → proposal → admin approve → investor interest/investment → chat/meetings.

---

## 23. Architecture

```
Flutter (JWT) ──┐
Thymeleaf web (session) ──┼── Spring Boot 3.4 ── MySQL 8
Admin session ──┘              │
                               ├── Flyway V1–V45
                               ├── Razorpay
                               ├── SMTP
                               ├── FCM / SMS
                               ├── Google Maps
                               └── File uploads (local/object — see STORAGE_MIGRATION.md)
```

**Weaknesses:** two auth modes; huge public matcher list; Hibernate validate vs historically Hibernate-created schema; monolith WAR; mixed JSP/Thymeleaf; no API gateway; search is DB queries not Elasticsearch.

**Production requirements:** already partially listed in `docs/PRODUCTION_READINESS_REPORT.md`, `DEPLOYMENT.md`, ShedLock, rate-limit, payment fulfillment tables.

---

## 24. Database (conceptual)

**Do not invent tables.** Core clusters:

- Identity: `user`, `admin`, OTP, password_reset_tokens, rate_limit_buckets  
- Safety: sos_*, panic_log, trusted_contact, emergency_contact, live_location, journey_sessions, buddy_*, danger_points, safe_route, recordings  
- Community: user_videos, video_*, groups, chat_message, express_*  
- Glow: salons, services, booking1, stylists  
- Health: doctors, doctor_appointments, doctor_chat_messages, doctor_*  
- Fitness / martial arts / financial_* / marketplace / women_products* / women_events* / entrepreneurs-investors / creator_* / payment_* / shedlock  

**Proposed (not existing as first-class):** `admin_audit_log`, `moderation_case`, `ledger_entry` (unified), `consent_record`.

ER (conceptual): User 1—N SOS, bookings, orders; Doctor 1—N appointments; Salon 1—N booking1; EventHost 1—N women_events; Entrepreneur 1—N proposals; Proposal 1—N investments.

---

## 25. API architecture

**Existing (prefixes):** `/api/auth`, `/api/landing`, `/api/doctors`, `/api/doctors/provider`, `/api/glow`, `/api/glow/salon`, `/api/glow/provider`, `/api/glow/admin`, `/api/fitness`, `/api/fitness/trainer`, `/api/fitness/chat`, `/api/martial-arts` (+ centre/admin), `/api/marketplace` (+ provider), `/api/women-events` (+ host), `/api/women-products/seller`, `/api/delivery`, `/api/entrepreneur`, `/api/investor`, `/api/financial-literacy` (+ educator), `/api/creator-hub`, `/api/videos`, `/api/chat`, `/api/journey`, `/api/buddy`, `/api/wallet` (mobile), `/api/sos/audio`.

Auth: JWT on `/api/**` except listed public register/login/OTP.  
**Proposed:** versioned `/api/v1`, OpenAPI spec, idempotent SOS, 112 webhook — **not built**.

---

## 26. Security & privacy

| Area | Current | Gap |
|---|---|---|
| Passwords | BCrypt | OK |
| JWT | env `JWT_SECRET` | rotation/runbook |
| Secrets | env in prod properties | keep gitignored `.env` |
| HTTPS | assumed at reverse proxy | verify HSTS |
| Authz | filter + controller checks | PUBLIC_URLS sprawl; IDOR risk if checks skip |
| Location | stored for SOS/journey | retention/consent UI |
| ID docs | paths on partner entities | storage ACL, encryption at rest |
| Medical | `MedicalDetails`, Rx JSON | extra sensitivity |
| ddl-auto | prod **validate** | schema incidents (ongoing) |
| Payments | webhook secret, fulfillment table | mock must stay off in prod |
| Account deletion | admin delete user | user self-serve DPDP |
| AI | n/a | don’t send SOS to LLMs |
| Audit | weak | P0 |

India **DPDP Act** readiness: treat as **Needs work** until consent, purpose limitation, erasure, and processor contracts are explicit.

---

## 27. 2026 market research (sourced)

**Violence against women (India, official statistics — reported crime only)**  
- NCRB *Crime in India*: **4,41,534** registered crimes against women in **2024**, vs **4,48,211** in 2023 (−1.4%). Rate **64.6 per lakh** women (2024) vs 66.2 (2023).  
  Sources: The Print summary of NCRB (2026); CEDA Ashoka analysis of 2024 statistics (notes under-reporting: ~one FIR every 71 seconds).  
- 2023: **4,48,211** cases (Economic Times / NCRB). Cruelty by husband/relatives remains the largest bucket.

**Government safety stack (not a startup competitor — table stakes)**  
- **ERSS-112** and **112 India app**; **Women Helpline 181**; Nirbhaya Fund: PIB (Mar 2025) states allocation **₹7,712.85 crore** up to FY 2024–25, utilisation **₹5,846.08 crore (~76%)**. ERSS in all 36 States/UTs.  
  Source: PIB document “India’s Commitment to Women’s Safety” (March 2025); PIB PRID 2085607.

**Women safety app market**  
- Commercial outlook reports (Intel Market Research, MarketGrowthReports, 2026–2034) describe growth driven by smartphones and 112-class integrations. **Treat vendor TAM/CAGR as estimates, not audited.** Key names they list: Safetipin, Himmat Plus, Nirbhayam, bSafe, Life360, Noonlight.  
- India consumer roundups (2026) still recommend **112 India + Himmat Plus + Safetipin + a private SOS app** as a *bundle*, which is FightDFear’s opportunity (one app) and threat (users already have 112).

**Livelihood / marketplace**  
- **Sitha** — women-exclusive gig + handmade marketplace; Hindu Business Line (2025/26) quotes founder goal to empower **1 million women entrepreneurs by 2027**; SheJobs sister portal ~**1 lakh** women in database (company-stated, not independently audited).  
- **SHE-MART** — MSME Promotion Council women-first marketplace; public site claims **60,000+** products, government-scheme linkage (Mudra, SHG).  
- **HerJobs** / **Kaabil (Mahindra)** — women job discovery; Kaabil is a major distribution threat.

**Healthcare / wellness for women**  
- Fragmented: Practo, Tata 1mg, local clinic apps. Women-only practitioner networks exist as small brands; **scale not publicly disclosed** for most.

---

## 28. Competitor landscape

### Direct / overlapping super-app

| Platform | Country | Purpose | Model | Lesson |
|---|---|---|---|---|
| **Sitha** | India | Women gig + products | Marketplace + boosters | Closest **livelihood** overlap |
| **SHE-MART** | India | SHG/artisan commerce | Marketplace + govt schemes | Trust via KYC + policy |
| FightDFear | India | Safety + many verticals | Mixed (see §33) | Breadth vs depth |

### Women safety

| Platform | Notes | Pricing | Strength | Weakness vs FDF |
|---|---|---|---|---|
| **112 India / ERSS** | Official dispatch | Free | Authority, nationwide | Not a community/jobs app |
| **Himmat Plus** | Delhi/state police association | Free | Police trust | Geography-limited brand |
| **My Safetipin** | Crowdsourced safety scores | Freemium (not fully disclosed) | Route intelligence | Not SOS dispatch |
| **bSafe** | Global SOS + live stream | ~$4.99/mo reported (ImAlive Jul 2026, **reported**) | Product polish | Weak India livelihood |
| **Life360** | Family circles | Official US Jul 2026: Silver **$7.99**, Gold **$14.99**, Platinum **$24.99**/mo (life360.com; some pages show $9.99 Silver — **verify geo**) | Scale, brand | Family tracker, not women-econ |
| **Noonlight** | US panic + dispatch | Core panic **free** (US); Premium ~$9.99/mo **reported** | Real monitoring | US-only |
| **Hollie Guard** | UK | Extra £7.99/mo **verified** ImAlive Jul 2026 | URN/police | UK |
| **Raksha / VithU / Shake2Safety** | India SOS | Typically free/ad | Simple SOS | Little platform |

### Career / education / health / finance / events

- Career: **Kaabil**, **HerJobs**, Naukri (indirect).  
- Education: Unacademy/BYJU’S (indirect); NSDC (govt).  
- Health: Practo (indirect).  
- Finance: **Not** competing with banks/UPI apps; financial **literacy** only.  
- Events: All Events, district meetup apps (indirect).  
- Community: Instagram/YouTube (indirect; reels).

**User/community scale for most India women-startups:** **Not publicly disclosed** unless cited above as company-stated.

---

## 29. Feature comparison (FightDFear = code status)

| Feature | FightDFear | 112 India | Himmat+ | Safetipin | Life360 | Sitha | Kaabil |
|---|---|---|---|---|---|---|---|
| SOS to private contacts | PARTIAL | Official 112 | Police | Limited | Circle | — | — |
| Live location / journey | PARTIAL | Yes (emergency) | Yes | Scores | Strong | Tracking on jobs | — |
| Community video | FULLY core | — | — | — | — | — | — |
| Jobs | FULLY core | — | — | — | — | Gigs | Strong |
| Doctors | FULLY core | — | — | — | — | Wellness gigs | — |
| Beauty marketplace | FULLY core | — | — | — | — | Services | — |
| Products | FULLY core | — | — | — | — | Handmade | — |
| Events | PARTIAL | — | — | — | — | — | — |
| Funding matching | PARTIAL | — | — | — | — | — | — |
| Financial literacy content | PARTIAL | — | — | — | — | — | — |
| AI | MISSING | — | — | — | Some | Matching claims | Matching |
| Verification admin | FULLY queues | Govt ID | Police | — | — | KYC claimed | Employer vetting |
| Wallet/coins | PLACEHOLDER+PARTIAL | — | — | — | Sub | Payments | — |

---

## 30. Pricing & business models (competitors)

- **Public emergency apps:** free (taxpayer/Nirbhaya).  
- **Life360:** freemium subscriptions (official 2026 plan pages).  
- **Noonlight:** free US panic + premium add-on (**reported**).  
- **Sitha:** bookings + “booster plans” (site). Commission **not publicly disclosed**.  
- **SHE-MART:** marketplace; Startup India DPIIT sellers **0% commission 6 months** (site claim).  
- **Kaabil:** consumer job app; employer side **not fully disclosed**.

FightDFear current code: **take-rate fields** (`commission_percent`, platform_fee on doctor appointments) exist; **consumer subscription SKU not a complete product**.

---

## 31. Market gaps (genuine)

1. **112 is trusted but not a livelihood OS.** Women still need jobs, clinics, salons, selling — in a **safer, verified-women** context.  
2. **Sitha/SHE-MART/Kaabil don’t own emergency graph.**  
3. **Safety-only apps don’t pay the bills** → retention dies after install.  
4. **Verification theatre:** many apps claim KYC; ops quality is the gap FightDFear’s admin queues try to fill.  
5. **Trust & Safety staffing** is the hidden gap — software queues without people fail.  
6. **Do not pretend to replace 112.** Partner or deep-link; never delay SOS for login/paywall.

---

## 32. Differentiation

**Why one app vs ten?** Shared identity, verified partners, SOS graph that already knows contacts, and (if executed) a reputation that travels from “booked this doctor” to “hired this worker.”

**UVP (honest):** “Verified women-centric services **plus** personal emergency tools” — not “AI police.”

**Do not compete head-on with:** Instagram (attention), Naukri (white-collar scale), 112 (dispatch), UPI wallets (payments license).

**Network effects:** only if supply (verified doctors/salons/workers) and demand (users) densify **city by city**.

---

## 33. Monetization (realistic, SOS-safe)

| Stream | Fit | Caution |
|---|---|---|
| Marketplace commission (glow, products, jobs) | High | Transparent fees |
| Doctor/fitness booking take-rate | High | Already in schema |
| Event tickets / booth | Medium | After events table stable |
| Partner subscriptions / boosters | Medium | Like Sitha boosters |
| Employer/job slots | Medium | Don’t spam workers |
| Creator boost / ads | Low-medium | Safety of ads |
| CSR / NGO / state Safe City | High strategic | Procurement long |
| Premium AI | Later | After trust |
| **SOS / panic** | **Never paywall** | Ethical + regulatory |

---

## 34. Roadmap

**NOW (P0, 0–90 days)**  
- Keep `ddl-auto=validate` green (Flyway completeness: events family, other missing tables as they appear).  
- SOS drill: SMS+FCM+admin resolve.  
- Split admin duties + audit log.  
- Kill dummy wallet redeem or replace with real catalog.  
- DPDP consent + deletion.  
- Deploy V45+ and monitor Flyway.

**NEXT (3–6 months)**  
- Unified ledger; settlement reports.  
- Moderator console.  
- 112 deep-link + tested dual-app guidance.  
- Vernacular + accessibility.  
- Load tests beyond `docs/LOAD_TEST_RESULTS.md`.

**LATER (6–12 months)**  
- City densification (one metro).  
- iOS.  
- Careful AI moderation assist.

**FUTURE (12–24 months)**  
- Government/CSR.  
- Safetipin-class mapping partnership.  
- Not: becoming a bank or AIF.

---

## 35. Production readiness

| Area | Status |
|---|---|
| Functionality breadth | Yellow — wide, uneven |
| UX mobile | Yellow — landing/dashboard improved; uneven modules |
| Backend | Yellow — monolith works; schema incidents |
| Database/Flyway | Red/Yellow — validate + incomplete CREATE history |
| API | Yellow — no OpenAPI/versioning |
| Security | Yellow/Red — PUBLIC_URLS, IDOR vigilance, no audit log |
| Payments | Yellow — real Razorpay path; mock must be false |
| Performance | Yellow — indexes V40; pooling exists |
| Monitoring | Yellow — actuator/prometheus; need APM |
| Testing | Red — few automated tests vs 567 Java files |
| CI/CD | Yellow — GitHub; VPS deploy still operationally manual in places |
| Backup/DR | Unknown in-repo — **ops must confirm** |
| Admin | Yellow — powerful, unsplittable |
| Moderation | Yellow |
| Legal/privacy | Red/Yellow — DPDP, healthcare, funding disclaimers |
| AI | N/A |

---

## 36. Master gap table

| Module | Current | Major gaps | Production requirement | Priority |
|---|---|---|---|---|
| Schema/Flyway | PARTIAL | Missing tables/columns under validate | CREATE/ALTER migrations; no silent ddl | **P0** |
| SOS | PARTIAL | No 112, reliability | Drills, failover, free forever | **P0** |
| Admin RBAC/audit | MISSING/PARTIAL | God-admin | Roles + audit | **P0** |
| Security/DPDP | PARTIAL | Consent/erasure | Policy + features | **P0** |
| Doctors | FULLY core | Clinical/legal | Verification SOP | **P1** |
| Glow/jobs/products | FULLY core | Settlement | Ledger | **P1** |
| Events | PARTIAL | Table missing historically | V45 + related tables later | **P0/P1** |
| Funding | PARTIAL | Legal perimeter | Disclaimers | **P0** |
| Wallet | PLACEHOLDER | Dummy redeem | Real or remove | **P1** |
| Community T&S | PARTIAL | People + CSAM process | Moderator | **P0** |
| AI | MISSING | — | Don’t fake | **P3** |
| iOS | MISSING | — | After Android stable | **P2** |
| Financial literacy | PARTIAL | Not advice | Disclaimers | **P2** |

---

## 37. Final strategic blueprint

### What FightDFear is today
A **broad women-centric Super App MVP in production clothing**: real Flutter + Spring + MySQL + Razorpay + a serious admin verification factory — still fighting schema/ops and Trust & Safety maturity.

### What it should become
The **trusted operating system for a woman’s safety graph and verified local economy** in selected Indian cities — with SOS that never charges, and services that pay for the company.

### What makes it different
Combining **personal emergency tooling** with **verified doctors, salons, jobs, products, events, and funding discovery** in one identity — if quality and trust stay high.

### Biggest weaknesses
Schema/ops under `validate`; money-model sprawl; unsplittable admin; no AI (don’t advertise it); no police integration; test debt; legal surfaces (health, funding).

### Biggest opportunities
City-level density; CSR/Nirbhaya-adjacent partnerships **without replacing 112**; Sitha-like gigs **plus** SOS graph; Kaabil users who also need safety.

### Biggest technical risks
Hibernate validate vs incomplete Flyway; dual auth; IDOR; file storage of ID docs; payment webhook races (partially addressed in V39).

### Biggest business risks
Trying to win every vertical against specialists; funding-module regulatory perception; SOS failure in a real incident; Play policy (permissions).

### Next 90 days
Ship schema stability; SOS drill; audit logs; wallet honesty; DPDP basics; one-city supply quality.

### Next 6 months
Ledger + moderator + 112 deep-link + vernacular + iOS decision.

### Next 12–24 months
Partnerships, careful AI, not a bank.

---

## Appendix A — Quality checklist

1. Repo inspected (entities, 100+ controllers, Flutter screens, AdminController, SecurityConfig, Flyway V1–V45).  
2. Major modules identified and status-labelled.  
3. Current vs planned separated.  
4. Admin documented from real mappings.  
5. Mobile documented from `mobile/lib/screens`.  
6. Web portals listed from `@RequestMapping`.  
7. DB/API from entities/controllers.  
8. Roles from `UserType` — not invented Mentor/SuperAdmin.  
9. Verification workflows from admin verify/reject/request-changes.  
10. Security gaps listed.  
11. 2026 market: NCRB 2024, PIB Nirbhaya/112 (2025), competitor pricing with dates.  
12. Youthian used as structure only (PPTX had no extractable text).  
13. AI not claimed.  
14. A new team can start from this file + `docs/DEPLOYMENT.md` + module QA docs.

## Appendix B — Related internal docs
`PRODUCTION_READINESS_REPORT.md`, `DEPLOYMENT.md`, `MASTER_QA_TEST_PLAN.md`, per-module `QA_*_MODULE.md`, `STORAGE_MIGRATION.md`, `REALTIME_MULTI_INSTANCE.md`.

*End of blueprint.*
