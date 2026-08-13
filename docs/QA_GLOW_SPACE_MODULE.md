# Glow Space Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Glow Space (salons, spa, beauty — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** salon + member flows. Do **not** treat website `/salons/login` as the primary salon portal for this cycle (existing web salon login must remain unchanged).

---

## 1. What this module does

Glow **salons** register on the **mobile app**, complete a numbered 11-section profile, wait for **admin approval**, then manage bookings, services, and UPI payouts.

Logged-in **members** browse approved salons, filter/sort, open salon detail (photos, reviews, next slot), book a service (with Razorpay or mock pay), cancel under policy, favourite salons, and write reviews.

Unapproved salons **must not** appear in member Explore.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Salons** (`/admin/salons`) |
| Member browse | App landing → **Glow Space** (member login required) |
| Salon portal | App landing → Login sheet → **Glow Space Login** **or** Join Us → **Glow Space** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid bookings complete without a real Razorpay card. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo uploads) |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check booking state instead. |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V30.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Salon (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (client) | App Join Us → Member / existing user register | Required to browse salons |
| Salon | App Join Us → Glow Space | Email OTP required |
| Admin | Existing web admin | Approves salons at `/admin/salons` |

Use unique emails each run (e.g. `qa.salon.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Salon

1. Landing → **Join Us** → **Glow Space** → Register.  
2. Landing → **Login** → **Glow Space Login**.  
3. After login, if profile is incomplete, **Complete Salon Profile** opens (or from the dashboard completion card).

### Member

1. Landing → **Glow Space** (login wall if guest).  
2. Member dashboard → Glow Space catalog.  
3. Screen tabs: **Explore | Favourites | My Bookings**.  
4. Explore sections: **Categories | Services | Salons | Offers**.

---

## 4. Salon registration (quick register)

Quick register collects only account fields. Full listing data is on **Complete Profile**.

### Fields

| # | Field | Rule |
|---|--------|------|
| 1 | Username | Required |
| 2 | Mobile | Required, **exactly 10 digits** |
| 3 | Email | Required, valid email |
| 4 | Send OTP / 6-digit OTP | Required before Create Account. Auto-verifies when 6 digits entered |
| 5 | Password | Min 6 chars, must include a **number** and a **special character** |
| 6 | Confirm password | Must match |
| 7 | Terms checkbox | Must be accepted |

### Expected

| Step | Expected result |
|------|-----------------|
| Invalid email | Inline error, OTP not sent |
| Send OTP | Snackbar “OTP sent to your email”; 60s resend timer |
| Wrong OTP | “Invalid or expired OTP” |
| OTP not verified | Cannot create account |
| Weak password | Error about number + special character |
| Password mismatch | Error |
| Terms off | Cannot submit |
| Success | Account created; salon is logged in; **Complete Salon Profile** is available |

**Negative:** Duplicate email / username should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on documents, but they **are** blocked without a valid OTP.

**Out of scope:** Do not test or “fix” website `/salons/login`. Mobile portal is the source of truth this cycle.

---

## 5. Salon Complete Profile (numbered UX — 11 sections)

After login, incomplete salons land on Complete Profile. Profile % is based on **14** mandatory items. Submit is enabled only when **missingItems is empty**.

Documents (10) and salon photos (11) are **optional**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Salon name | Name |
| 1.2 Salon type | Type dropdown |
| 1.3 Owner / manager | Contact person |
| 1.5 Official phone | 10-digit phone |
| 2.1 Landmark / address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Categories | At least one Glow category |
| 4.1 Who we serve | At least one audience |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About the salon | Bio |
| 8. First service | At least one service |

UPI (9.1) is **not** required to submit. It **is** required to withdraw from Finance.

### 1. Salon identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Salon name | Text | Yes |
| 1.2 | Salon type | Dropdown: Salon, Spa, Beauty parlour, Bridal studio, Nail studio, Unisex salon, Home service, Academy | Yes |
| 1.3 | Owner / manager | Text | Yes |
| 1.4 | Designation | Dropdown: Owner, Manager, Senior stylist, Beautician, Spa therapist, Receptionist | No |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Year started | 4-digit year | No |

### 2. Location

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Landmark / address | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin salon on map | Tap map **or** Use current location | No |

There is **no** single free-text hours box as the only availability field. City, state, and pincode are separate.

### 3. Categories

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Services you offer | Multi-select chips from GlowCatalog | Yes (at least one) |

**Catalog:** Hair, Skin Care, Makeup, Nail Care, Spa & Massage, Waxing, Threading, Eye Brow, Bridal, Mehendi, Wellness, Cosmetic, Packages, Training.

### 4. Who we serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips: Women, Men, Unisex, Bridal, Kids | Yes (at least one) |
| 4.2 | Door / home service | Toggle | No |
| 4.3 | Female staff available | Toggle | No |

### 5. Facilities

Optional chips: AC, Parking, Washroom, Waiting lounge, Wheelchair access, Sanitized tools, Private cabin, Card / UPI, Wi-Fi.

### 6. Hours & calendar

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 6.1 | Open days | Day chips MON–SUN | Yes (at least one) |
| 6.2 | Open time | **Time picker** (no typing `10:00 – 19:00` as the only input) | Yes |
| 6.3 | Close time | Time picker | Yes |
| 6.4 | Break start | Time picker | No |
| 6.5 | Break end | Time picker | No |
| 6.6 | Leave / blocked dates | Date picker chips | No |

### 7. About the salon

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 7.1 | About | Text | Yes |
| 7.2 | Hygiene & safety notes | Text | No |

### 8. First service

At least **one** Glow service is required to submit. Created from Complete Profile (or Services tab).

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Service name | Text (or pick from catalogue) | Yes |
| 8.2 | Category | Dropdown from GlowCatalog | Yes |
| 8.3 | Duration | Picker: 15 / 30 / 45 / 60 / 75 / 90 / 120 min | Yes |
| 8.4 | Buffer | 0 / 5 / 10 / 15 / 20 min | No |
| 8.5 | Price (₹) | Number | Yes |
| 8.6 | Mode | SALON / DOOR / BOTH | Yes |

### 9. Payout

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 9.1 | UPI ID | Text (`name@upi`) | No to submit; **Yes to withdraw** |
| 9.2 | Bank details | Text | No |

Earnings stay in the salon wallet until Finance → Request UPI payout. Minimum payout **₹100**.

### 10. Documents (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 10.1 | Profile photo | Image upload | No |

### 11. Salon photos (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 11.1 | Gallery photo | Image upload | No |

Interior / chair / storefront photos help members choose the salon. Skip is allowed.

### Save vs Submit

| Action | Behaviour |
|--------|-----------|
| **Save Profile** | Persists fields; refreshes % and missing chips |
| **Submit for Verification** | Enabled only when missingItems is empty. Status → Pending Approval |

**Skip for now** is not a substitute for required fields. Testers must fill 1–8 to submit.

---

## 6. Admin approval

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Salons** (`/admin/salons`).  
3. Find the pending salon.  
4. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Salon **not** listed in member Explore |
| Approved | Salon **is** listed; services bookable |
| Reject / changes requested | Salon stays off Explore; salon sees reason on Complete Profile |

Do **not** use website `/salons/login` for this cycle.

---

## 7. Salon dashboard (after approval)

Bottom nav: **Home | Bookings | (FAB add service) | Services | Profile**.  
Scrollable tabs: **Overview | Bookings | Services | Finance | Settings**.

### Overview

Stats: pending bookings, confirmed, services, earnings. Recent bookings. Catalogue by category.

### Bookings (booking file)

| Action | From status | To |
|--------|-------------|-----|
| Confirm / Reject / Cancel | PENDING | CONFIRMED / REJECTED / CANCELLED |
| Complete / Cancel | CONFIRMED or PAID | COMPLETED / CANCELLED |
| Add / edit notes | Any | Internal `coachNotes` saved |

Each row shows client, date, time, status, price. **Add / edit notes** is the booking history file.

**Slot window:** `joinWindowOpen` is true from **15 minutes before** appointment start through **15 minutes after**. Used as a hint to complete the visit; do not fail if the salon completes later.

### Services

- Add / edit with **category**, catalogue name, **duration picker**, **buffer**, **mode**, price.  
- First service can be added **before** approval (needed for Complete Profile).  
- After approval, add more services from this tab.  
- FAB on Home jumps to Services (or Complete Profile if not approved).

### Finance

| Field | Expected |
|-------|----------|
| Payout balance | Credits when a member **pays** a Glow booking (`type=GLOW_BOOKING`) |
| Confirmed earnings | Sum of CONFIRMED / PAID / COMPLETED booking prices |
| Request UPI payout | Fails without UPI; fails if balance &lt; ₹100; succeeds with UPI + ≥ ₹100 |

### Settings

Name, phone, city, address, bio, hours, UPI. Prefer **Complete profile** for the numbered 11-section form.

---

## 8. Member browse & booking

### Explore

| Section | What to check |
|---------|----------------|
| Categories | GlowCatalog grid; tap opens Services filtered by category |
| Services | Live bookable services from approved salons |
| Salons | Cards with city, rating, from-fee, **Available today**, next slot |
| Offers | Active offers; Book offer |

**Salon filters (Salons section):**

| Filter | Expected |
|--------|----------|
| City | Contains match on salon city |
| Available today | Only salons with at least one open slot today |
| Door service | Only salons with door/home service on |
| Sort: Top rated | Highest rating first |
| Sort: Fee | Lowest starting fee first |
| Sort: Nearest | Needs lat/lng; otherwise large distance |

Unapproved salons must **not** appear.

### Favourites tab

Heart on salon detail toggles favourite. Favourites tab lists saved salons. Empty copy: “No favourites yet”.

### Salon detail

| Item | Expected |
|------|----------|
| Photos | Profile image + gallery strip if uploaded |
| Rating / from-fee / next slot chips | Present when data exists |
| “No slots today” | When `slotsToday` is empty |
| Door service / Female staff | Chips when enabled |
| Cancel policy | “Free cancellation until 2 hours before the appointment…” |
| Services grouped by category | Book button per service |
| Reviews | List or “No reviews yet”; **Write review** |
| Heart | Toggles favourite |

### Book a service

1. Pick **date** (date picker, not typed `YYYY-MM-DD` as the only path).  
2. Pick **time** from available slots on that date (detail) or time picker (explore quick book).  
3. Type: **At salon** or **Door service** (address required for door).  
4. Optional notes.  
5. Policy copy is shown.  
6. If price &gt; 0 → pay (`type=GLOW_BOOKING`, `bookingId`). Mock pay confirms.  
7. If price = 0 → CONFIRMED immediately.

| Negative | Expected |
|----------|----------|
| Closed day / blocked date | “Salon is closed on …” |
| Slot already taken | “That slot is already booked” |
| Door without address | “Address is required for door booking” |

### My Bookings

Track: Placed → Confirmed → Completed.  
**Pay now** if still pending payment.  
**Cancel (free)** if more than **2 hours** before appointment.  
Confirmed/paid bookings inside 2 hours: cancel API returns the policy error.

---

## 9. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unapproved salons never appear in member Explore / detail. |
| BR-02 | Submit verification requires all numbered mandatory items including first service. |
| BR-03 | Documents and gallery are optional. |
| BR-04 | Open/close times are pickers, not a typed `10:00 – 19:00` hours string as the only input. |
| BR-05 | Double-book same salon + date + time is rejected. |
| BR-06 | Free cancel until **2 hours** before appointment start. After that, confirmed/paid bookings cannot be cancelled by the member. |
| BR-07 | Pending bookings can still be cancelled by the member (not yet paid). |
| BR-08 | Appointment reminder ~1 hour before (FCM log-only). |
| BR-09 | Paid Glow bookings credit salon `payoutBalance`. |
| BR-10 | Withdraw requires UPI ID and balance ≥ ₹100. |
| BR-11 | Website `/salons/login` is out of scope and must not be changed. |
| BR-12 | Slot generation uses open/close, skips break, skips past times today, skips taken times. |

### Booking status machine

| Actor | From | To |
|-------|------|-----|
| Member create (fee &gt; 0) | — | PENDING |
| Member pay | PENDING | CONFIRMED (and salon wallet credited) |
| Member create (fee = 0) | — | CONFIRMED |
| Salon | PENDING | CONFIRMED / REJECTED / CANCELLED |
| Salon | CONFIRMED / PAID | COMPLETED / CANCELLED |
| Member | PENDING | CANCELLED |
| Member | CONFIRMED / PAID | CANCELLED only if ≥ 2 hours before start |

---

## 10. Suggested test data

**Salon A (Hair + Bridal, approved)**  
- Type: Salon  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Categories: HAIR, BRIDAL  
- Audience: Women  
- Door service: on  
- Female staff: on  
- Open Mon–Sat 10:00–19:00, break 13:30–14:30  
- Block one future date as leave  
- Service 1: Hair Cut (Women), HAIR, 30 min, buffer 10, ₹499, SALON  
- Service 2: Bridal Makeup, BRIDAL, 90 min, buffer 15, ₹2999, SALON  
- UPI: `qa.salon@upi`

**Salon B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve.

**Member M1**  
- Book Hair Cut &gt; 2 hours away (cancel → allowed).  
- Book Bridal &lt; 2 hours away after confirm (cancel → blocked).  
- Rate salon + favourite.

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Salon onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| S-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| S-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| S-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| S-04 | Login existing salon | Username/email + password | Dashboard or Complete Profile |
| S-05 | Complete Profile opens | New salon | Numbered 1–11 form |
| S-06 | Profile mandatory | Save with empty 1.1 / 1.2 / 2.5 / 3.1 / 6.2 / 7.1 / no service | Numbered error (e.g. `2.5 Pincode must be 6 digits`) |
| S-07 | Location split | City / state / pincode / map pin | All save; listing shows city |
| S-08 | Time picker only | Open/close | Clock UI; not typed `10:00 – 19:00` as the only hours field |
| S-09 | Map pin | Tap map / Use current location | Lat/lng shown |
| S-10 | Optional docs | Skip photo + gallery, save | Save succeeds |
| S-11 | Gallery photo | Upload interior image | Appears on member salon detail |
| S-12 | First service required | Fill 1–7, skip 8, submit | Blocked until a service exists |
| S-13 | Submit verification | Fill mandatory + first service → submit | Status pending admin |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/salons` | New salon listed |
| A-02 | Approve | Approve | Salon approved |
| A-03 | Visibility | Member Explore refresh | Salon listed |
| A-04 | Unapproved hidden | Salon B not approved | Not in Explore |
| A-05 | Web login untouched | Open `/salons/login` | Existing web page still works; do not file “use mobile instead” as a product bug this cycle |

### C. Salon ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Finance tab | Open Finance | Payout balance + Request UPI payout (not a duplicate of Services) |
| O-02 | Add service pickers | Duration / buffer / mode dropdowns | Saved; duration not free-typed only |
| O-03 | Booking file | Add notes on a booking | Notes persist on reload |
| O-04 | Confirm booking | PENDING → CONFIRMED | Member My Bookings shows Confirmed |
| O-05 | Payout no UPI | Request payout | Error: add UPI ID |
| O-06 | Payout with UPI | After a paid booking | Success message |

### D. Member browse & book

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | Guest wall | Open Glow Space logged out | Login required |
| M-02 | City / category / door / today filters | Apply each on Salons | List updates |
| M-03 | Sort rating / fee | Toggle sort chip | Order changes |
| M-04 | Favourite | Heart on detail | Filled heart; appears on Favourites tab |
| M-05 | Reviews on detail | Write 5★ + comment | Shows on detail; rating updates |
| M-06 | Next slot / no slots today | Closed today vs open | Correct chip |
| M-07 | Photos | Gallery uploaded | Horizontal photos on detail |
| M-08 | Date + slot pickers | Book from detail | Date picker + slot dropdown; not typed YYYY-MM-DD as the only path |
| M-09 | Overlap | Book same salon/date/time twice | Second booking fails |
| M-10 | Door without address | Door type, empty address | Error |
| M-11 | Free book | Price 0 | Confirmed without pay |
| M-12 | Paid book | Price &gt; 0, mock pay | My Bookings shows CONFIRMED |

### E. Cancel, reminders

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| T-01 | Cancel pending | Unpaid PENDING | Cancel succeeds |
| T-02 | Cancel &gt; 2h | Confirmed, appointment &gt; 2h away | Cancel succeeds |
| T-03 | Cancel &lt; 2h | Confirmed, appointment soon | Policy error; stays confirmed |
| T-04 | Reminder | Appointment in ~1 hour | Backend log; do not fail if no OS push |

---

## 12. Priority for this cycle

**P0 (must pass before UAT sign-off)**  
S-02, S-05, S-06, S-08, S-12, S-13, A-02, A-03, A-04, O-01, O-03, M-06, M-08, M-12, T-02, T-03.

**P1**  
Filters/sort, favourites, reviews, gallery, payout, door service, overlap.

**P2 / known gaps (do not fail the build)**  
- Real FCM push on a locked phone (backend logs only).  
- Real Razorpay live keys (mock is default).  
- Real UPI settlement.  
- Website `/salons/login` (out of scope).  
- Independent stylist Join Us path (salon owner flow is the 10/10 target this cycle).

---

## 13. API cheat sheet (mobile)

| Method | Path | Who |
|--------|------|-----|
| POST | `/api/glow/provider/salon/otp/send-email` | Public |
| POST | `/api/glow/provider/salon/otp/verify-email` | Public |
| POST | `/api/glow/provider/salon/register-quick` | Public |
| POST | `/api/glow/provider/login/salon` | Public |
| GET/PUT | `/api/glow/provider/salon/profile` | Salon JWT |
| POST | `/api/glow/provider/salon/submit-verification` | Salon JWT |
| GET | `/api/glow/salon/me` | Salon JWT |
| POST | `/api/glow/salon/bookings/{id}/status` | Salon JWT |
| POST | `/api/glow/salon/bookings/{id}/notes` | Salon JWT |
| POST | `/api/glow/salon/services` | Salon JWT |
| POST | `/api/glow/salon/payout/request` | Salon JWT |
| POST | `/api/glow/salon/photos` | Salon JWT (multipart) |
| GET | `/api/glow/salons?city=&category=&availableToday=&doorService=&sort=` | Member |
| GET | `/api/glow/salons/{id}` | Member |
| GET | `/api/glow/salons/{id}/slots?date=` | Member |
| POST | `/api/glow/salons/{id}/reviews` | Member |
| POST | `/api/glow/salons/{id}/favorite` | Member |
| GET | `/api/glow/favorites` | Member |
| POST | `/api/glow/bookings` | Member |
| POST | `/api/glow/bookings/{id}/cancel` | Member |
| GET | `/api/glow/bookings/me` | Member |
| POST | `/payment/verify` with `type=GLOW_BOOKING` | Member |

---

## 14. Sign-off

| Check | Pass? |
|-------|--------|
| 11-section Complete Profile with catalogs / time pickers / map pin | |
| Documents optional | |
| First service required to submit | |
| Unapproved salon hidden from Explore | |
| Dashboard has Finance (UPI payout) separate from Services | |
| Booking file with notes | |
| Member filters + next slot / no slots today | |
| Reviews + favourites + photos | |
| Cancel policy 2 hours | |
| Website `/salons/login` unchanged | |

**Tester:** _________________ **Date:** _________________ **Build:** Flyway **V30** + current Flutter
