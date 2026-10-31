# MASTER QA TEST PLAN

**Project:** Fight D Fear  
**Branch under QA:** `cursor/production-readiness`  
**Source of truth used:** implemented code, APIs, Flutter app, web/admin flows, `docs/QA_*` module handbooks, and `docs/PRODUCTION_READINESS_REPORT.md`  
**Execution status:** Test plan authored; execution pending unless marked otherwise.

## Scope

This plan covers implemented flows only:

- Web and Admin web workflows used by approvals/operations
- Flutter mobile app flows (Android + iOS targets)
- Backend API behavior and critical data/state transitions
- Production-readiness validations from Phases 2–12

## Modules covered

1. Authentication & OTP
2. Authorization & security controls
3. Payments & webhook verification
4. Women Doctor
5. Fitness & Wellness
6. Glow Space
7. Women Events
8. Creator Hub
9. Martial Arts / Self-Defence
10. Women Products + Delivery Guy
11. Women Jobs
12. Women Lawyer
13. Entrepreneur & Investor
14. Financial Literacy
15. Realtime (chat/SOS websocket + polling fallback)
16. Deployment / staging / multi-instance readiness checks

---

## 1) Smoke Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| SMK-001 | Auth | Flutter (Android/iOS) | Backend up, SMTP configured | Register member, send OTP, verify OTP, login | New member email/phone/password | Account created, login token/session valid | Invalid OTP rejected | P0 | Not Run | - |
| SMK-002 | Women Doctor | Flutter + Admin Web | Doctor profile submitted pending | Admin approves doctor, member opens Women Doctors browse | Doctor + member + admin accounts | Approved doctor visible; unapproved hidden | Pending doctor must not list | P0 | Not Run | - |
| SMK-003 | Payment | Flutter + API | `PAYMENT_MOCK=true` in non-prod env | Create paid booking/order, complete checkout, verify payment | Paid test booking (doctor/fitness/glow) | `/payment/verify` success; single fulfillment | Duplicate verify returns idempotent success | P0 | Not Run | - |
| SMK-004 | Chat | Flutter + API | Two users with allowed chat relation/booking | Send chat message via module chat or `/api/chat/messages` polling fallback | Two users | Message visible to receiver | Unauthenticated chat API rejected | P1 | Not Run | - |
| SMK-005 | Women Products | Flutter + Admin Web | Seller approved, product listed | Member adds to cart, checkout COD/online, seller processes | Seller/member/admin accounts | Order transitions correctly | Cancel after assignment blocked | P0 | Not Run | - |
| SMK-006 | Financial Literacy | Flutter + Admin Web | Educator approved and content published | Member watches free video and registers paid live | Educator/member/admin accounts | Video free; paid live requires payment | Duplicate active registration blocked | P1 | Not Run | - |

---

## 2) Functional Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| FUN-001 | Women Doctor | Flutter + Admin Web | Doctor registered | Complete 11-section profile, submit, admin approve, patient books slot | Doctor/member/admin accounts | End-to-end consult lifecycle works | Missing mandatory fields blocked with numbered errors | P0 | Not Run | - |
| FUN-002 | Fitness | Flutter + Admin Web | Trainer registered | Submit profile (credential required), admin approve, member books free and paid sessions | Trainer/member/admin | Free flow no payment; paid flow payment required | Unapproved trainer hidden | P0 | Not Run | - |
| FUN-003 | Glow Space | Flutter + Admin Web | Salon registered | Submit profile + service, admin approve, member books and views booking | Salon/member/admin | Booking lifecycle + payout eligibility works | Door booking without address rejected | P0 | Not Run | - |
| FUN-004 | Women Events | Flutter + Admin Web | Host + event submitted | Admin approves host and event, member registers, host checks in attendee | Host/member/admin | Event registration and attendance update work | Unapproved host/event hidden | P0 | Not Run | - |
| FUN-005 | Creator Hub | Flutter + API | Creator approved | Upload public + paid/subscriber content, member tip/sub/unlock | Creator/member | Public content free; paid paths route through payment types | Unapproved creator content hidden | P0 | Not Run | - |
| FUN-006 | Martial Arts | Flutter + Admin Web | Centre registered | Submit profile + first program, admin approve, member enrols, attendance tracked | Centre/member/admin | Enrolment + attendance + journey data consistent | Age <16 blocked | P0 | Not Run | - |
| FUN-007 | Women Jobs | Flutter + Admin Web | Worker registered | Submit profile, admin verify, member booking accepted then paid | Worker/member/admin | Request→accept→pay→complete flow works | Service Partner tile absent (intentional) | P0 | Not Run | - |
| FUN-008 | Women Lawyer | Flutter + Admin Web | Lawyer registered | Submit profile with Bar Council ID, admin approve, member requests consult | Lawyer/member/admin | Confirmed consult can be paid and completed | Missing Bar Council ID blocked | P0 | Not Run | - |
| FUN-009 | Entrepreneur/Investor | Flutter + Admin Web | Founder/investor registered | Approve both, approve pitch, investor expresses interest, admin release | Founder/investor/admin | Interest states transition and founder payout updates | Interest > remaining raise rejected | P0 | Not Run | - |
| FUN-010 | Financial Literacy | Flutter + Admin Web | Educator registered | Approve educator, publish video/live/workshop, member registers and pays where needed | Educator/member/admin | Video always free; paid enrollment credits educator wallet | Unapproved educator content hidden | P0 | Not Run | - |

---

## 3) Negative Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| NEG-001 | Auth | Flutter/API | Register screen available | Submit invalid email/weak password/no terms | Invalid forms | Validation messages; no account | OTP send must not proceed | P0 | Not Run | - |
| NEG-002 | OTP | Flutter/API | OTP sent | Enter expired/wrong OTP | OTP older than 10 min | Verification fails | Resend before 60s blocked | P0 | Not Run | - |
| NEG-003 | Booking | Flutter/API | Service with slots exists | Attempt past time and blocked-date booking | Past datetime / leave date | API/UI reject | Overlap attempts rejected | P0 | Not Run | - |
| NEG-004 | Payment | API | Valid order exists | Verify with tampered amount or bad signature payload | Modified verify payload | Verification fails safely | No duplicate fulfillment row | P0 | Not Run | - |
| NEG-005 | Reviews | Flutter/API | User not eligible to review | Try review before completion/delivery/attendance | Non-eligible user | Review endpoint rejected | Duplicate review blocked where defined | P1 | Not Run | - |
| NEG-006 | Payout | Flutter/API | Provider has no UPI or low balance | Request payout <₹100 or without UPI | Provider account | Error response; no payout state change | Balance unchanged | P0 | Not Run | - |

---

## 4) Security Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| SEC-001 | Security config | API/Web | App running | Access public and protected routes without auth | None | Public allowed (`/api/auth/health`), protected denied | Unauthorized returns 401/403 | P0 | Not Run | - |
| SEC-002 | Webhook signature | API | `razorpay.webhook.secret` set | Call `/payment/webhook/razorpay` without/invalid signature | Sample webhook body | 401 for missing/invalid signature | Prod without secret should fail per validator | P0 | Not Run | - |
| SEC-003 | Rate limiting | API | Rate limit buckets active | Flood OTP/login endpoint within window | Repeated calls from same key | 429 returned after limit | Buckets should expire after window | P0 | Not Run | - |
| SEC-004 | JWT expiry | API/Flutter | Token issued | Use token after expiry window | Expired token | Request denied, re-login required | No silent refresh expected (not implemented) | P1 | Not Run | - |
| SEC-005 | Actuator exposure | Web/API | Non-local caller route available | Attempt access to restricted metrics | Remote request to `/actuator/prometheus` | Access blocked unless allowed by config | Health/info still reachable as configured | P1 | Not Run | - |

---

## 5) Payment Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| PAY-001 | Create/verify order | API/Flutter | Payment-enabled module booking | Trigger order create then verify | Module-specific payload | Verify success updates business entity | Missing required fields rejected | P0 | Not Run | - |
| PAY-002 | Idempotent verify | API | One payment already verified | Replay same verify multiple times | Same payment/order IDs | Same success response; no duplicate rows | Duplicate payment not re-fulfilled | P0 | Not Run | - |
| PAY-003 | Pending order recovery | API | Pending order in DB | Verify from different app instance/session | Existing pending order | Fulfillment succeeds via DB-backed pending state | Session-only state not required | P0 | Not Run | - |
| PAY-004 | Webhook dedupe | API | Webhook event persisted once | Replay same webhook event ID | Same event payload/id | Duplicate marked and ignored | No duplicate appointment/booking | P1 | Not Run | - |
| PAY-005 | Module payment types | API/Flutter | Module checkout ready | Validate `DOCTOR`, `FITNESS`, `GLOW_BOOKING`, `WORKER_BOOKING`, `LAWYER_BOOKING`, `WOMEN_EVENT`, `WOMEN_PRODUCT`, `FINANCIAL_BOOKING`, `CREATOR_*` flows | One scenario each | Correct target entity updated per type | Wrong type rejected | P0 | Not Run | - |

---

## 6) Concurrency Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| CON-001 | Doctor booking slots | API/Flutter | Same slot visible to 2 users | Concurrent booking attempts same doctor/time | Two member accounts | One succeeds, one rejected | No duplicate booked slot | P0 | Not Run | - |
| CON-002 | Jobs/Lawyer overlap | API/Flutter | Same worker/lawyer time slot | Parallel bookings for same slot | Two clients | One accepted, overlap rejected | Duration+buffer respected | P0 | Not Run | - |
| CON-003 | Payment verify race | API | Simultaneous verify requests | Fire parallel verify for same payment | Load test script/manual parallel | Exactly one fulfillment row | No double-credit | P0 | Not Run | - |
| CON-004 | Seller stock consistency | API/Flutter | Limited stock product | Two checkouts depleting stock | Product stock 1 | Prevent oversell | Second checkout blocked/adjusted | P1 | Not Run | - |
| CON-005 | Scheduler singleton | Backend | 2 app instances + shared DB | Observe scheduled jobs with ShedLock | Multi-instance env | Job executes once per schedule window | No duplicate escalations/reminders | P1 | Not Run | - |

---

## 7) API Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| API-001 | Auth APIs | API | None | Validate register/login/health response schema and status | Valid and invalid payloads | Success and error contracts consistent | Bad payloads return 4xx | P0 | Not Run | - |
| API-002 | Creator feed pagination | API | Authenticated creator/member | Call `/api/creator-hub/feed?page=&size=` | Token + query params | `page/size/totalPages` returned; bounded size | Out-of-range size bounded | P1 | Not Run | - |
| API-003 | Landing feed stability | API | Public access | Call `/api/landing/feed` repeatedly | None | Deterministic response shape and bounded sections | No unbounded full-table pull behavior | P1 | Not Run | - |
| API-004 | Chat polling fallback | API | Two users with chat permission | Call `/api/chat/messages?peerId=&since=` after sending messages | Two users | Incremental backfill works | Unauthorized/forbidden denied | P0 | Not Run | - |
| API-005 | File upload endpoints | API | Authenticated module users | Upload valid and invalid media/docs | Image/PDF test files | Valid files saved and retrievable | Invalid type/oversize rejected | P1 | Not Run | - |
| API-006 | Loan application flow | API/Flutter | Member account | Submit loan application, list applications | Loan payload | Application persisted and visible | Missing mandatory fields rejected | P1 | Not Run | - |

---

## 8) Web Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| WEB-001 | Landing + auth pages | Web | App running | Open root/landing/login/register routes used by web | Browser | Pages load without server errors | 5xx not acceptable | P1 | Not Run | - |
| WEB-002 | Legacy web non-regression | Web | Existing web flows available | Open legacy module logins referenced as out-of-scope | Browser | Existing pages still accessible/unchanged behavior | Broken routes are regressions | P1 | Not Run | - |
| WEB-003 | Actuator health endpoint | Web/API | App running | Open `/actuator/health` and `/actuator/info` | Browser/curl | Reachable as configured | Prometheus not publicly open where restricted | P1 | Not Run | - |
| WEB-004 | Nginx websocket routes | Web infra | Nginx configured | Verify `/ws-chat/` and `/ws-sos/` upgrade headers path | Nginx config + browser dev tools | Upgrade path works through proxy | Missing upgrade headers fail WS | P0 | Not Run | - |

---

## 9) Android Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| AND-001 | Flutter app bootstrap | Android | Android device/emulator | Launch app, confirm landing and auth bootstrap | Android 10+ device | App opens, no crash on startup | Cold start crash = blocker | P0 | Not Run | - |
| AND-002 | Media upload | Android | Authenticated user flow | Upload image/PDF in supported modules | Android gallery/files | Upload succeeds and previews where implemented | Invalid file path/permission handled gracefully | P1 | Not Run | - |
| AND-003 | Payment retry UX | Android | Paid booking path | Simulate transient network during verify, observe retry behavior | Controlled network throttling | Verify retries and settles idempotently | Persistent failure shows clear error | P0 | Not Run | - |
| AND-004 | Push/log fallback | Android | Notification hooks active | Trigger booking/session notifications | Test bookings | State updates visible in-app even if no OS push | Missing push alone should not fail test | P1 | Not Run | - |
| AND-005 | Deep flow navigation | Android | Multiple modules enabled | Navigate across modules from landing/dashboard | Test account | No navigation dead-ends/crashes | Broken back stack flagged | P1 | Not Run | - |

---

## 10) iOS Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| IOS-001 | Flutter app bootstrap | iOS | iOS device/simulator | Launch app, validate landing/auth screens | iOS 16+ | App opens and remains stable | Startup crash = blocker | P0 | Not Run | - |
| IOS-002 | Payment and booking parity | iOS | Paid module path ready | Execute paid booking end-to-end in at least 3 modules | iOS test accounts | Same status transitions as Android/API | Parity mismatch is defect | P0 | Not Run | - |
| IOS-003 | File/media selection | iOS | Authenticated user | Upload image/PDF in modules supporting upload | iOS Photos/Files access | Upload works and file URL/state persisted | Permission denial handled safely | P1 | Not Run | - |
| IOS-004 | Chat polling fallback | iOS | Two users, one with WS disabled | Send/receive chat, fallback polling every 5s | Two accounts | Messages eventually delivered via polling | Missing backfill after reconnect is defect | P1 | Not Run | - |

---

## 11) Admin Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| ADM-001 | Doctor approvals | Admin Web | Doctor pending profile | Approve/request changes/reject from pending doctors | Admin + doctor pending account | Status transitions reflected in doctor/member apps | Pending doctors must remain hidden | P0 | Not Run | - |
| ADM-002 | Trainer/salon/worker/lawyer approvals | Admin Web | Pending applicants exist | Approve each from corresponding queue pages | Admin + pending partner accounts | Approved users visible in consumer modules | Wrong category approval must not leak listing | P0 | Not Run | - |
| ADM-003 | Event/Funding approvals | Admin Web | Pending host/pitch/investments | Approve event entities; release funding | Admin + module test data | Market visibility/funding status updated | Unapproved entities stay hidden | P0 | Not Run | - |
| ADM-004 | Product seller & delivery approvals | Admin Web | Seller/delivery pending | Approve seller and delivery partner | Admin + pending accounts | Seller can list, courier can accept ready orders | Pending courier cannot accept | P0 | Not Run | - |
| ADM-005 | Admin SOS/monitor consistency | Admin Web + WS | SOS events available | Observe SOS monitor updates and fallback checks | Triggered SOS case | Admin sees alerts; persisted SOS accessible | Cross-node WS gap documented, fallback required | P1 | Not Run | - |

---

## 12) Regression Testing

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| REG-001 | Core auth | Web/Flutter/API | New build deployed | Run login/register/forgot/OTP sanity across roles | Multi-role accounts | No auth regression after phase changes | 401 loops/session breaks flagged | P0 | Not Run | - |
| REG-002 | Payment baseline | API/Flutter | Paid modules available | Re-run one paid flow per major module | Module test matrix | Payment still maps to correct target type | Wrong type mapping defect | P0 | Not Run | - |
| REG-003 | Module discoverability | Flutter | Landing/dashboard active | Verify all module entry points present and correct | Member account | Tiles route to intended modules | Wrong route (e.g., fitness/self-defence mix) defect | P0 | Not Run | - |
| REG-004 | Approval gating | Admin+Flutter | One approved + one pending account per module | Compare browse visibility | Prepared datasets | Only approved entities shown | Pending leakage defect | P0 | Not Run | - |
| REG-005 | File/media baseline | Flutter/API | Existing uploads exist | Open old and new media URLs post storage abstraction | Existing uploaded assets | Backward compatibility holds | Broken old URLs defect | P1 | Not Run | - |
| REG-006 | Scheduled reminders/escalations | Backend | Scheduler enabled | Verify reminders/escalations still run after ShedLock changes | Time-window test data | Expected reminders generated once | Missing or duplicate runs defect | P1 | Not Run | - |

---

## 13) Performance / Load Verification

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| PRF-001 | Public browse load | API/k6 | k6 installed, staging URL | Run `loadtests/browse.js` at 100 VU, 2m | Staging env | Capture p95 and failure rate vs target | If run not possible, mark Blocked | P0 | Blocked | ENV-K6-MISSING |
| PRF-002 | High-load browse | API/k6 | Same as above | Run `loadtests/browse.js` at 500 VU, 3m | Staging env | Bottlenecks documented with evidence | If not run, cannot claim high-load readiness | P0 | Blocked | ENV-STAGING-NOT-RUN |
| PRF-003 | Auth probe load | API/k6 | k6 installed | Run `loadtests/login_probe.js` | Staging env | Health + auth rejection stable | Excess 5xx indicates instability | P1 | Blocked | ENV-K6-MISSING |
| PRF-004 | Authenticated feed load | API/k6 | Valid `AUTH_TOKEN` | Run `loadtests/creator_feed.js` | Auth token | Feed API remains stable under configured VUs | Elevated latency/failures logged | P1 | Blocked | ENV-AUTH-TOKEN-MISSING |
| PRF-005 | Multi-instance payment | API/Infra | 2 app nodes + nginx sticky | Create order on node A, verify on node B | Two-node staging | Verify succeeds (DB pending/fulfillment) | Any cross-node failure = P0 defect | P0 | Blocked | ENV-2NODE-NOT-READY |
| PRF-006 | Multi-instance storage/realtime | API/Infra | 2 nodes + S3/shared storage + nginx | Upload on A/read on B; WS + polling fallback tests | Two-node staging + S3 | File read works cross-node; realtime behavior matches docs | WS cross-node misses without fallback must be documented | P0 | Blocked | ENV-S3-OR-2NODE-MISSING |

---

## 14) Production Readiness Checks

| Test Case ID | Module | Platform | Preconditions | Test steps | Test data / credentials required | Expected result | Negative cases | Priority | Status | Bug/Defect ID |
|---|---|---|---|---|---|---|---|---|---|---|
| PROD-001 | Config & secrets | Infra | Staging `.env` prepared | Verify required env vars and no secrets in repo | `.env.staging.example` | App boots with prod profile and validator checks | Missing required secret blocks startup | P0 | Not Run | - |
| PROD-002 | DB migrations | Backend | Staging DB snapshot | Run startup and verify V39–V42 applied | Staging DB | Migration succeeds without unsafe manual constraints | Data issues/blocking migration logged | P0 | Not Run | - |
| PROD-003 | Health-gated deploy | Infra/Web | Server access | Execute `deploy/deploy.sh` and observe health gate | VPS access | Deployment fails fast on health failure | Silent unhealthy rollout not allowed | P0 | Not Run | - |
| PROD-004 | Observability | Backend | Logs/actuator available | Validate request IDs in logs and metrics endpoint policy | Log access | Correlated request logs present | Prometheus overexposure flagged | P1 | Not Run | - |
| PROD-005 | Open P0 gate validation | Cross-cutting | Staging ready | Verify unresolved P0s from final audit are tracked | Audit report | Open gates explicitly marked before go-live | False production-ready claim prohibited | P0 | Not Run | - |

---

## Final QA Sign-off Checklist

Mark each item ✅ / ❌ / N/A:

- [ ] Smoke suite complete (all P0 smoke cases pass)
- [ ] Core auth + OTP + role logins validated
- [ ] Approval gating validated across all partner modules
- [ ] Payment idempotency and webhook signature checks validated
- [ ] Booking/consult/enrollment cancellation windows validated
- [ ] Chat and notification fallback behavior validated
- [ ] File/media upload and retrieval validated
- [ ] Admin workflows validated (all approval queues in scope)
- [ ] Regression suite run across all documented modules
- [ ] Android sanity suite passed
- [ ] iOS sanity suite passed
- [ ] Web/admin non-regression checks passed
- [ ] Staging load tests (100/500 VU) executed and evidence attached
- [ ] Multi-instance verification executed and evidence attached
- [ ] No P0 defects open
- [ ] Release recommendation documented with known limitations

---

## Environment / dependency blockers to track during execution

- k6 not installed in current local environment (load tests blocked unless installed)
- No staging VPS execution evidence attached yet for 100/500 VU runs
- No completed 2-node multi-instance runtime evidence attached yet
- Push notifications are documented as log-only in current setup (device delivery validation limited)

