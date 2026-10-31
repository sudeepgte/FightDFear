# Martial Arts / Self-Defence Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Martial Arts & Self-Defence (mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval; mobile admin screen is optional extra  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** centre + member flows. Do **not** treat website `/centres/login` as the primary centre portal for this cycle (existing web centre login must remain unchanged).

Gym, Zumba, Yoga and similar programs belong under **Fitness & Wellness**, not this module.

---

## 1. What this module does

Self-defence / martial arts **centres** register on the **mobile app**, complete a numbered 11-section profile, wait for **admin approval**, then manage batches, students, attendance, live classes, and UPI payouts.

Logged-in **members** browse approved centres, filter/sort, open centre detail (photos, reviews, next batch / seats), enrol (with Razorpay or mock pay), cancel / transfer under policy, join online class in a time window, track journey & attendance, and favourite centres.

Unapproved centres **must not** appear in member Explore.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Martial Management** (`/admin/martialManagement`) |
| Member browse | App landing → **Self Defence** (member login required) |
| Centre portal | App landing → Login sheet → **Self-Defense Center Login** **or** Join Us → **Self-Defense Trainer** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid enrollments complete without a real Razorpay card. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo/certificate uploads) |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check in-app notifications / enrollment state instead. |
| Video | Live class Join opens **Jitsi** in an external browser/app |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V29.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Centre (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (student) | App Join Us → Member / existing user register | Required to browse centres; **min age 16** to enrol |
| Centre / trainer | App Join Us → Self-Defense Trainer | Email OTP required |
| Admin | Existing web admin | Approves centres at `/admin/martialManagement` |

Use unique emails each run (e.g. `qa.centre.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Centre

1. Landing → **Join Us** → **Self-Defense Trainer** → Register.  
2. Landing → **Login** → **Self-Defense Center Login**.  
3. Member Martial Arts screen → **Register trainer** / **Centre sign in** / **My dashboard**.  
4. After login, if profile is incomplete, **Complete Centre Profile** opens automatically.

### Member

1. Landing → **Self Defence** (login wall if guest).  
2. Member dashboard → Martial Arts / Self Defence catalog.  
3. Screen tabs: **Explore | Enrollments | Journey | Attendance | Online**.

---

## 4. Centre registration (quick register)

Quick register collects only account fields. Full listing data is on **Complete Profile**.

### Fields

| # | Field | Rule |
|---|--------|------|
| 1 | Centre / trainer name | Required |
| 2 | Contact person | Optional at register; **required later as 1.3** |
| 3 | Mobile | Required, **exactly 10 digits** |
| 4 | Email | Required, valid email |
| 5 | Send OTP / 6-digit OTP | Required before Create Account. Auto-verifies when 6 digits entered |
| 6 | Password | Min 6 chars, must include a **number** and a **special character** |
| 7 | Confirm password | Must match |
| 8 | Terms checkbox | Must be accepted |

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
| Success | Account created; centre is logged in; **Complete Centre Profile** opens |

**Negative:** Duplicate email should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on documents, but they **are** blocked without a valid OTP.

**Out of scope:** Do not test or “fix” website `/centres/login`. Mobile portal is the source of truth this cycle.

---

## 5. Centre Complete Profile (numbered UX — 11 sections)

After login, incomplete centres land on Complete Profile. Profile % is based on 16 mandatory items. Submit is enabled only when **missingItems is empty**.

### 1. Centre identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Centre name | Text | Yes |
| 1.2 | Centre type | Dropdown: Academy, Dojo, Training hall, Home studio, Community hall, Outdoor | Yes |
| 1.3 | Owner / manager | Text | Yes |
| 1.4 | Designation | Dropdown: Owner, Head coach, Manager, Instructor | No |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Year started | 4-digit year | No |
| 1.8 | Affiliation | Dropdown: None, WKF, ITF, Shotokan, National body, Other | No |

### 2. Location

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Hall / landmark | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin centre on map | Tap map **or** Use current location | No |

There is **no** single free-text “location” box as the only address field. City, state, and pincode are separate.

### 3. Styles taught

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Martial arts styles | Multi-select chips | Yes (at least one) |

**Style catalog:** Karate, Taekwondo, Judo, Kung Fu, Self-Defence, MMA, Boxing, Kickboxing, Muay Thai, Krav Maga, Aikido, Kalaripayattu, Wrestling, Jiu-Jitsu, Other.

**Must fail:** Saving a batch styled Gym / Zumba / Yoga (error: those belong under Fitness & Wellness).

### 4. Who can join

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips: Women, Girls (under 16), Mixed, Men | Yes (at least one) |
| 4.2 | Women-only batches | Toggle | No |
| 4.3 | Female instructor available | Toggle | No |
| 4.4 | Age groups | Chips: Kids 6–12, Teens 13–17, Adults 18+, 40+ | No |

### 5. Facilities

Optional chips: Mats, Changing room, Washroom, Drinking water, CCTV, First-aid, Parking, AC, Women-only hours, Beginner-friendly.

### 6. Hours & calendar

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 6.1 | Open days | Day chips MON–SUN | Yes (at least one) |
| 6.2 | Open time | **Time picker** (no typing `06:00`) | Yes |
| 6.3 | Close time | Time picker | Yes |
| 6.4 | Break start | Time picker | No |
| 6.5 | Break end | Time picker | No |
| 6.6 | Leave / blocked dates | Date picker chips | No |

### 7. About the centre

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 7.1 | About | Text | Yes |
| 7.2 | How we teach | Text | Yes |
| 7.3 | What we offer | Chips: Regular class, Trial class, Belt grading, Workshops, Self-defence crash course | Yes (at least one) |

### 8. First program / batch

At least **one** martial arts program is required to submit.

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Program name | Text | Yes (when creating first batch) |
| 8.2 | Style | Dropdown from catalog | Yes |
| 8.3 | Batch days | Day chips | Yes |
| 8.4 | Start time | **Time picker** | Yes |
| 8.5 | End time | Time picker (must be after start) | Yes |
| 8.6 | Duration | 45 / 60 / 90 minutes | No (default 60) |
| 8.7 | Buffer minutes | 0 / 5 / 10 / 15 | No |
| 8.8 | Instructor | Text | Yes |
| 8.9 | Capacity | 5–100 | Yes |
| 8.11 | Monthly fee (₹) | Number ≥ 0 | Yes |
| 8.12 | Admission fee (₹) | Number | No |
| 8.13 | Trial | None / Free 1 class / Paid trial | No |
| 8.14 | Mode | Offline / Online / Hybrid | Yes |

More batches are added later from the dashboard **Batches** tab (same time pickers + buffer + trial).

### 9. Payout

| Serial | Field | Mandatory for withdraw |
|--------|--------|-------------------------|
| 9.1 | UPI ID | Required before dashboard **Request UPI payout** |
| 9.2 | Bank details | No |
| 9.3 | Starting monthly fee | No (listing hint) |

### 10. Documents — **optional this cycle**

| Serial | Type | Notes |
|--------|------|--------|
| 10.1 | Profile photo | JPG/PNG |
| 10.2 | Trainer / affiliation certificate | JPG/PNG/PDF |

Do **not** fail the cycle if documents are skipped.

### 11. Centre photos — **optional this cycle**

| Serial | Type | Notes |
|--------|------|--------|
| 11.1 | Gallery photo | Hall / mats / entrance; shows on member centre detail |

### Save / submit

1. **Save Profile** — validates mandatory fields; profile % updates.  
2. Create first program if none exists.  
3. When mandatory items are filled, centre can **Submit for Verification**.  
4. Status becomes `PENDING_ADMIN_APPROVAL`.  
5. Centre is **not** visible to members until admin **Approve**.

### Status labels

| `centreProfileStatus` | Label shown |
|------------------------|-------------|
| REGISTERED / PROFILE_INCOMPLETE | Profile Incomplete |
| READY_FOR_VERIFICATION | Ready to Submit |
| PENDING_ADMIN_APPROVAL | Pending Approval |
| APPROVED | Approved |
| CHANGES_REQUESTED | Changes Requested |
| REJECTED | Rejected |
| SUSPENDED | Suspended |

---

## 6. Admin verification (web)

**URL:** `/admin/martialManagement`  
**Approve:** `POST /admin/approve/{id}`  
**Reject:** `POST /admin/reject/{id}` (removes the centre in current web flow)

| Action | Result |
|--------|--------|
| Approve | `approved = true`, `CentreProfileStatus = APPROVED`. Centre appears in member Explore. Email “Your Martial Arts Center is Now Approved!” |
| Reject | Centre removed / not listed to members |

**Must test:** Unapproved centre is absent from Explore. After approve + pull-to-refresh, the centre appears with correct name, city, styles, fee, trial badge.

**Do not** use website `/centres/login` as the centre’s working portal this cycle.

---

## 7. Centre dashboard (mobile)

**Tab bar (scrollable):** Overview | Batches | Students | Attendance | **Live** | **Finance** | More  

**Bottom nav:** Home | Students | Batches | FAB (+) | Live | Finance | Profile  

Known prior bug (fixed this build): the tab labelled Finance used to show Live Classes. **Finance must show earnings / UPI payout. Live must show online classes.**

### Overview
- Profile completion card → opens Complete Profile.  
- Counts: batches, enrollments, today classes, pending admissions.  
- Shortcuts to Batches / Students / Attendance / Live / Settings.

### Batches
- Create / edit / delete.  
- Start and end times via **time picker** (read-only fields; no typing `06:00-07:00`).  
- Days chips, start/end date pickers, capacity 5–100, fee ≥ 0.  
- Extra: admission fee, buffer minutes, trial type, Offline / Online / Hybrid.  
- Style Gym/Zumba/Yoga is rejected by API.

### Students
- Search by name or batch.  
- Status chips: APPROVED, IN_PROGRESS, COMPLETED, REJECTED.  
- **Open student file:** phone, email, batch, health notes, **attendance history**, **coach notes** (save).  
- This is not a flat name list only.

### Attendance
- Pick date → sessions (batches that run that weekday + online classes that day).  
- Mark Present / Absent / Late with optional notes → Save.

### Live
- Schedule class: title, **date picker**, **start/end time pickers**, meeting link (optional — Jitsi is generated on start if empty).  
- Start is allowed from **15 minutes before** scheduled start.  
- Member join window is **5 minutes before start through 15 minutes after start** (or while status is LIVE until end + 15).  
- Join hint is shown on the card. Starting too early shows an error snackbar.

### Finance
- Gross enrollments.  
- Wallet / payout balance.  
- UPI ID from Complete Profile.  
- **Request UPI payout** — fails without UPI; succeeds by recording a request and zeroing wallet (not a live bank transfer).

### More (Settings)
- Name, email, phone, location, about, profile photo, gallery.

---

## 8. Member flows

### 8.1 Explore

Tabs: Explore | Enrollments | Journey | Attendance | Online.

**Filters / sort (Explore)**

| Control | Expected |
|---------|----------|
| Search | Name, location, city |
| City | Filter sheet text field |
| Style | Catalog dropdown |
| Max fee | Any / under ₹1000 / 2000 / 4000 |
| Batch today | Only centres with a batch running today |
| Online | Only centres with Online or Hybrid batches |
| Sort | Rating (default), fee (low→high), nearest (needs lat/lng on centre) |

**Listing tags:** fee, rating, next-batch / seats label, Trial badge, styles.

**Open card** → Centre detail (not a tiny dialog).

### 8.2 Centre detail

- Photo, name, city/state/pincode, maps, about, what we offer.  
- **Availability label:** e.g. “Batch today · N seats left” or “Next batch: …” or **“No seats this week”**.  
- **Trial class available** when centre/batch trial is set.  
- **Heart** favourite / unfavourite.  
- **Gallery** photo strip if uploaded.  
- **Reviews & ratings** list (or “No reviews yet”) + submit review (after the member has enrolled).  
- Batches: style, mode, days, time, instructor, seats left, trial, **Enroll** (disabled when full / no seats).

### 8.3 Enrol

Member must be **at least 16**.

| Area | Rule |
|------|------|
| Personal | Name, 10-digit phone, email, DOB, age ≥ 16, address |
| Emergency | Name + 10-digit phone (must differ from member phone) |
| Health | Medical conditions or “I have no medical conditions” |
| Start date | Today or later |
| Payment | Fee 0 → enrol without Razorpay. Fee > 0 → mock pay to confirm seat |
| Consents | Accuracy, training rules, **and cancel/transfer policy** — all required |

**Policy copy on screen (must be accepted):**

> Free cancellation until 24 hours before the first class. After that the fee is not refunded. Batch transfer is allowed once if requested 48 hours in advance.

**Empty seats:** Enroll button reads **No seats this week** / **Batch full**.

### 8.4 Enrollments

- Status + payment chips.  
- **Pay now** if `paymentRequired`.  
- Policy text + **Cancel enrollment** when `canCancel`.  
  - Allowed until **24 hours before first class**.  
  - Inside 24 hours: API error, fee not refunded.  
- Transfer: allowed **once**, at least **48 hours** before first class, to another batch at the **same centre** with seats.  
- Certificate download when issued (after centre marks COMPLETED).

### 8.5 Journey / Attendance / Online

- **Journey:** paid/active trainings, progress %, attendance %.  
- **Attendance:** total / present / rate + dated records.  
- **Online:** live / upcoming / invitations / completed.  
  - **Join** only when `canJoin` is true; otherwise snackbar with join-window hint.  
  - Join opens Jitsi URL externally.

---

## 9. Business rules (assert these)

| ID | Rule |
|----|------|
| BR-01 | Only **approved** centres appear in Explore. Unapproved / pending / rejected are hidden. |
| BR-02 | Gym, Zumba, Yoga and similar styles cannot be saved as martial arts batches. |
| BR-03 | City, state, pincode are separate required fields (not one location box). |
| BR-04 | Batch start/end must be chosen with time pickers; end after start. |
| BR-05 | Enrolment min age **16**. |
| BR-06 | Capacity: paid enrollments cannot exceed batch capacity; status may become Full. |
| BR-07 | Duplicate enrol in the same batch is rejected. |
| BR-08 | Fee = 0 → immediate PAID/APPROVED. Fee > 0 → PENDING until `/payment/verify` with `type=MARTIAL_ARTS`. |
| BR-09 | Cancel free until **24 hours** before first class; after that no refund. |
| BR-10 | Transfer once only, **48 hours** before first class, same centre, seats available. |
| BR-11 | Live **member Join** only **5 min before start** through **15 min after start** (or while LIVE until end + 15). |
| BR-12 | Centre may **Start** class from **15 min before** scheduled start. |
| BR-13 | Class reminders ~1 hour before (in-app / FCM log-only). |
| BR-14 | Review only after the member has enrolled at that centre. |
| BR-15 | Withdraw requires UPI ID. Paid enrollments credit centre `payoutBalance`. |
| BR-16 | Documents optional. |
| BR-17 | Join opens **Jitsi** externally (not in-app custom video chrome). |
| BR-18 | Website `/centres/login` is out of scope and must not be changed. |

### Enrolment status machine

| Actor | From | To |
|-------|------|-----|
| Member pay (fee > 0) | PENDING | APPROVED (`paymentStatus=PAID`) |
| Member (fee = 0) | — | APPROVED immediately |
| Centre | PENDING / APPROVED | IN_PROGRESS, COMPLETED, REJECTED |
| Centre | COMPLETED | Certificate generated |
| Member | PENDING / APPROVED / IN_PROGRESS | CANCELLED (if 24h rule met) |
| Member | APPROVED / IN_PROGRESS | TRANSFERRED (once, 48h rule) |

Terminal: COMPLETED, CANCELLED. TRANSFERRED remains on the new batch.

---

## 10. Suggested test data

**Centre A (Karate + Self-Defence, approved)**  
- Type: Academy  
- City: Bengaluru, State: Karnataka, Pincode: 560001  
- Styles: Karate, Self-Defence  
- Audience: Women + Mixed  
- Open Mon–Sat 06:00–21:00, break 13:00–14:00  
- Block one future date as leave  
- Batch 1: Karate Beginner, Mon/Wed/Fri, 06:00–07:00, Offline, capacity 20, fee ₹1500, trial Free 1 class  
- Batch 2: Self-Defence, Tue/Thu, 18:00–19:00, Online, capacity 15, fee ₹800  
- UPI: `qa.centre@upi`

**Centre B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve.

**Member M1 (age 22)**  
- Enrol paid offline batch > 24h away (cancel → allowed).  
- Enrol online batch; Join only in window.  
- After a class: rate centre + favourite.

**Member M2 (age 15)**  
- Enrol must fail (min age 16).

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Centre onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| C-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| C-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| C-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| C-04 | Login existing centre | Email + password | Dashboard or Complete Profile |
| C-05 | Auto-open Complete Profile | New centre login | Profile screen opens without extra tap |
| C-06 | Profile mandatory | Save with empty 1.1 / 1.2 / 2.5 / 3.1 / 6.2 / 7.1 / no batch | Numbered error (e.g. `2.5 Pincode must be 6 digits`) |
| C-07 | Location split | City / state / pincode / map pin | All save; listing shows city |
| C-08 | Time picker only | Open/close and batch start/end | Clock UI; no typed `06:00-07:00` as the only input |
| C-09 | Fitness style blocked | Try batch style Yoga / Gym | API/UI error pointing to Fitness & Wellness |
| C-10 | Map pin | Tap map / Use current location | Lat/lng shown; maps URL filled |
| C-11 | Optional docs | Skip photo + certificate, save | Save succeeds |
| C-12 | Gallery photo | Upload hall image | Appears on member centre detail |
| C-13 | First batch required | Fill 1–7, skip 8, submit | Blocked until a program exists |
| C-14 | Submit verification | Fill mandatory + first batch → submit | Status pending admin |
| C-15 | Blocked date | Add a leave date | Visible on profile; members still see other days |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/martialManagement` | New centre listed under pending |
| A-02 | Approve | Approve | Flash “Centre approved successfully!” |
| A-03 | Visibility | Member Explore refresh | Centre listed |
| A-04 | Unapproved hidden | Centre B not approved | Not in Explore |
| A-05 | Web login untouched | Open `/centres/login` | Existing web page still works; do not file “use mobile instead” as a product bug this cycle |

### C. Centre ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Finance vs Live tabs | Open Finance, then Live | Finance = earnings/payout; Live = classes |
| O-02 | Create batch pickers | Create batch with clock + days + buffer + trial | Saved; times not free-typed |
| O-03 | Student file | Open a student | Attendance history + notes save |
| O-04 | Attendance | Mark present/absent, save | Persists on reload |
| O-05 | Start class too early | Start 40 min before | Error with join-window hint |
| O-06 | Start in window | Start 10 min before | LIVE; Jitsi link opens |
| O-07 | Payout no UPI | Request payout | Error: add UPI ID |
| O-08 | Payout with UPI | After a paid enrol | Success; wallet goes to 0 |

### D. Member browse & enrol

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | Guest wall | Open Self Defence logged out | Login required |
| M-02 | City / style / fee filters | Apply each | List updates |
| M-03 | Batch today | Centre with no class today | Hidden when filter on |
| M-04 | Online filter | Offline-only centre | Hidden when Online on |
| M-05 | Sort rating / fee | Toggle sort chip | Order changes |
| M-06 | Favourite | Heart on detail | Filled heart after reload |
| M-07 | Reviews on detail | Before any enrol | List or “No reviews yet” |
| M-08 | Next batch / no seats | Full vs open batch | Correct label + Enroll disabled when full |
| M-09 | Trial badge | Centre with trial | “Trial” on listing and detail |
| M-10 | Photos | Gallery uploaded | Horizontal photos on detail |
| M-11 | Age 15 | Enrol as 15 | Blocked (min 16) |
| M-12 | Policy checkbox | Uncheck cancel/transfer policy | Cannot submit |
| M-13 | Free enrol | Fee 0 | Enrolled without pay |
| M-14 | Paid enrol | Fee > 0, mock pay | Enrollments tab shows PAID |
| M-15 | Duplicate batch | Enrol same batch twice | Error already enrolled |

### E. Cancel, transfer, live join, reviews

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| T-01 | Cancel > 24h | Paid enrol, first class > 24h away | Cancel succeeds |
| T-02 | Cancel < 24h | First class soon | Error; no refund copy |
| T-03 | Transfer once | Transfer 48h+ ahead to sibling batch | New batch; second transfer fails |
| T-04 | Transfer too late | Inside 48h | Error |
| T-05 | Join too early | 20 min before class | Join blocked / hint |
| T-06 | Join in window | 4 min before | Jitsi URL opens |
| T-07 | Join too late | After start + 15 (and not LIVE) | Join blocked |
| T-08 | Review after enrol | Submit 5★ + comment | Shows on centre detail; rating updates |
| T-09 | Review without enrol | New member, never enrolled | API error |
| T-10 | Reminder | Class in ~1 hour | Backend log / in-app; do not fail if no OS push |
| T-11 | Certificate | Centre marks COMPLETED | Member can download certificate |

---

## 12. Priority for this cycle

**P0 (must pass before UAT sign-off)**  
C-02, C-05, C-06, C-08, C-09, C-13, C-14, A-02, A-03, A-04, O-01, O-03, O-06, M-08, M-12, M-14, T-01, T-02, T-05, T-06.

**P1**  
Filters/sort, favourites, reviews, trial, gallery, student file notes, payout, transfer, attendance.

**P2 / known gaps (do not fail the build)**  
- Real FCM push on a locked phone (backend logs only).  
- Real Razorpay live keys (mock is default).  
- Real UPI settlement.  
- In-app Jitsi chrome (opens external).  
- Website `/centres/login` (out of scope; do not “fix” or regress it).  
- Mandatory documents (intentionally optional until go-live).  
- Gym/Zumba/Yoga belong in Fitness & Wellness (rejecting them here is correct).

---

## 13. Defect logging template

```
Module: Martial Arts / Self-Defence
Role: Centre / Member / Admin
Build: <apk date / commit>
Device: <model + OS>
Steps:
Expected:
Actual:
Screenshot / video:
API (if known): method + path + status + body snippet
```

Useful API prefixes:

- Centre auth/ops: `/api/martial-arts/centre/...`  
- Member: `/api/martial-arts/centres`, `/api/martial-arts/enroll`, `/api/martial-arts/my-enrollments`  
- Favourites: `POST|DELETE /api/martial-arts/favorites/{centreId}`  
- Reviews: `/api/martial-arts/centres/{id}/reviews`  
- Cancel / transfer: `/api/martial-arts/enrollments/{id}/cancel`, `.../transfer`  
- Live join: `GET /api/martial-arts/online-classes/{id}/join`  
- Pay: `/payment/create-order` `type=MARTIAL_ARTS`, then `/payment/verify`  
- Admin pages: `/admin/martialManagement`, `/admin/approve/{id}`, `/admin/reject/{id}`

---

## 14. Smoke path (30–40 minutes)

1. Register centre + OTP + Complete Profile (all 11 sections; Karate + Self-Defence; Bengaluru; Mon–Sat hours via time pickers; first batch 06:00–07:00 picker, fee ₹1500, trial on). Skip documents.  
2. Admin approve at `/admin/martialManagement`.  
3. Member: Explore → filter city/style → open centre → favourite → see next batch / seats → enrol paid batch + accept cancel policy → mock pay.  
4. Centre: Students → open student file → add a note → mark attendance.  
5. Centre: Live → schedule class for now+10 min → Start in window → Jitsi opens.  
6. Member: Online tab → Join in window.  
7. Member: cancel a **second** enrolment whose first class is **> 24 hours** away.  
8. Centre: Finance → Request UPI payout (after adding UPI).  
9. Confirm unapproved Centre B never appeared in Explore.  
10. Confirm Yoga/Gym cannot be added as a martial arts batch.

If this smoke path passes, the module is test-ready for the full case list in §11.
