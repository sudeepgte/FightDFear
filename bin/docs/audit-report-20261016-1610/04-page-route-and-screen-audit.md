# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 04. PAGE ROUTE AND SCREEN AUDIT

**Target:** Web Views (JSP), Mobile Views (Flutter), and Administrative Consoles  
**Scope:** Complete Navigation Graph, Route Restrictions, and UI/UX State Verification  

---

### 4.1 Web Routes & JSP Page Inventory

FightDFear contains **154 top-level JSP view templates** in `src/main/webapp/WEB-INF/views/` plus 21 specialized domain subdirectories:

| Category | Discovered Views | Primary Controller | Access Restriction |
|---|---|---|---|
| **Public Landing & Info** | `index.jsp`, `features.jsp`, `heatmap.jsp`, `helpline.jsp`, `terms.jsp`, `blog.jsp` | `IndexController`, `HomeController` | Public (PermitAll in SecurityConfig) |
| **Authentication** | `login.jsp`, `forgotPassword.jsp`, `resetPassword.jsp`, `adminLogin.jsp`, `centreLogin.jsp`, `doctorLogin.jsp`, `fitnessTrainerLogin.jsp` | `LoginController`, `AuthController` | Public (Rate-limited on POST) |
| **Safety & SOS** | `sos-dashboard.jsp`, `sos-response-page.jsp`, `panic-button.jsp`, `panic-timer.jsp`, `trusted-contacts.jsp`, `emergency-contact.jsp`, `journey.jsp`, `listSafeRoutes.jsp`, `addSafeRoute.jsp` | `SosActivationController`, `SOSResponseController`, `EmergencyContactController` | Authenticated User Session |
| **User Profile & Hub** | `userDashboard.jsp`, `user-profile.jsp`, `userUpdateForm.jsp`, `friends.jsp`, `wallet.jsp` | `UserController`, `WalletController` | Authenticated User Session |
| **Doctor Telemedicine** | `doctor/dashboard.jsp`, `doctor/appointments.jsp`, `doctor/profile.jsp`, `doctor/reviews.jsp`, `doctor/verification.jsp` | `DoctorController` | Authenticated Doctor Session (`loggedDoctor`) |
| **Martial Arts Centres** | `centreDashboard.jsp`, `centreDetails.jsp`, `centreProfileCompletion.jsp`, `myBeltProgress.jsp`, `myAttendance.jsp`, `mySchedule.jsp` | `MartialArtsCenterController`, `AttendanceController` | Authenticated Centre (`loggedCentre`) |
| **Glow Space Salons** | `salon/dashboard.jsp`, `salon/bookings.jsp`, `salon/services.jsp`, `salon/packages.jsp`, `stylist/profile.jsp` | `SalonController`, `StylistController` | Authenticated Salon / Stylist Session |
| **Women Marketplace** | `women-products/catalog.jsp`, `women-products/cart.jsp`, `women-products/orders.jsp`, `women-products/seller-dashboard.jsp` | `WomenProductController` | Authenticated User / Seller Session |
| **Events & Ticketing** | `women-events/list.jsp`, `women-events/details.jsp`, `women-events/register.jsp`, `women-events/host-dashboard.jsp` | `WomenEventController` | Authenticated User / Host Session |
| **Creator Studio & Hub** | `creatorStudio.jsp`, `creatorHubFeed.jsp`, `creatorHubUpload.jsp`, `creatorMyProfile.jsp`, `creatorHubCoins.jsp` | `CreatorHubController` | Authenticated Creator / User Session |
| **Financial Literacy** | `financial-literacy/catalog.jsp`, `financial-literacy/session-room.jsp`, `financial-literacy/educator-dashboard.jsp` | `FinancialLiteracyController` | Authenticated User / Educator Session |
| **Funding & Proposals** | `entrepreneur/dashboard.jsp`, `investor/dashboard.jsp`, `aboutEntrepreneur.jsp`, `aboutCentre.jsp` | `EntrepreneurController`, `InvestorController` | Authenticated Partner Session |
| **Super Admin Console** | `adminDashboard.jsp`, `adminUserManagement.jsp`, `adminSOSMonitor.jsp`, `adminSafetyPoints.jsp`, `adminReportedVideos.jsp`, `adminPendingDoctors.jsp`, `adminPendingSellers.jsp`, etc. | `AdminController` | Authenticated Admin Session (`admin`) |

---

### 4.2 Mobile Screens (Flutter Architecture)

The Flutter mobile application (`mobile/lib/screens/`) contains **19 modular screen suites**:

```
mobile/lib/screens/
├── admin/          (Mobile Admin dashboard, approvals, SOS monitor)
├── auth/           (Unified login, registration, OTP verify screens)
├── creator/        (Creator studio, video reels feed, upload sheet, coins)
├── doctors/        (Doctor search, specialty filter, booking modal, call screen)
├── entrepreneur/   (Pitch deck viewer, proposal editor, founder profile)
├── events/         (Event browse, ticket QR viewer, host registration)
├── financial/      (Video course player, live webinar room, quiz cards)
├── fitness/        (Trainer booking, workout logger, QR check-in)
├── funding/        (Investor pitch decks, match cards, chat screen)
├── glow/           (Salon locator, stylist service selector, appointment slot picker)
├── investor/       (Deal pipeline, entrepreneur Q&A thread, term sheet)
├── landing/        (Hero carousel, emergency SOS trigger, quick action cards)
├── marketplace/    (Category chips, search bar, product detail, shopping cart)
├── martial_arts/   (Centre directory, belt journey timeline, attendance QR)
├── portals/        (Partner portal launcher, quick registration flows)
├── products/       (Seller order management, product upload, inventory table)
├── safety/         (SOS circular button, countdown timer, active SOS map, contacts list)
├── user/           (Personal profile, emergency history, settings, dark mode)
└── wallet/         (Coin balance, transaction history, cash-out redeem form)
```

---

### 4.3 Route Protection & Access Control Audit

1. **Web CSRF Defense:**
   - Spring Security uses `CookieCsrfTokenRepository.withHttpOnlyFalse()` with custom `SpaCsrfTokenRequestHandler`.
   - Web JSP forms and AJAX requests pass `_csrf` or header `X-XSRF-TOKEN`.
   - **Exemptions:** Bearer token requests (Mobile clients) and public registration/webhook paths are correctly exempted in `SecurityConfig.java`.
2. **Session Hijacking & Session Fixation:**
   - Session migration is enforced on authentication (`sessionFixation().migrateSession()`).
   - Session cookie is configured with `HttpOnly=true` and `SameSite=Lax`.
   - **Gap:** When running without the production profile, `server.servlet.session.cookie.secure` defaults to `false`.
3. **Admin URL Protection:**
   - In `SecurityConfig.java`, unauthenticated requests to `/admin/**` are redirected to `/admin/loginAdmin`.
   - However, in `AdminController.java`, authorization relies on checking `session.getAttribute("admin") == null`. If a regular user session acquires an admin attribute or if session serialization fails, administrative actions could be compromised.

---

### 4.4 Discovered UI/UX & Responsive Defects

| Bug ID | Screen / Route | Issue Description | Severity | Impact |
|---|---|---|---|---|
| **FF-UI-001** | `index.jsp` / Mobile Safari | Large 2GB video upload form causes layout shifting on viewports < 375px. | Low | Visual inconsistency on mobile web browsers. |
| **FF-UI-002** | `heatmap.jsp` | If Google Maps API key is blank (default config), the map canvas renders a grey box without friendly error messaging. | Medium | User cannot determine if safe routes are loaded. |
| **FF-UI-003** | `safety/home_screen.dart` | When location permission is denied, banner displays "Location permission required", but button remains clickable without redirecting to app settings. | Medium | Frustrating user experience during emergency situation. |
| **FF-UI-004** | `adminSOSMonitor.jsp` | Auto-refresh via polling (`/admin/dashboard.meta`) re-renders entire table DOM nodes rather than appending, resetting table scroll position. | Low | Admin workflow disruption during incident monitoring. |
