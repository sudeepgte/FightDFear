# Women Doctor Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Women Doctors (mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** doctor + patient flows. Do **not** treat website `/doctors/login` as the primary doctor portal for this cycle (existing web login must remain unchanged).

---

## 1. What this module does

Women doctors register on the **mobile app**, complete a numbered profile, wait for **admin approval**, then manage appointments, chat, video, prescriptions, and payouts.

Logged-in **members (patients)** browse verified doctors, filter/sort, book (with Razorpay or mock pay), upload reports, chat after booking, join video in a time window, download/share prescriptions, book follow-ups, and rate visits.

Unapproved doctors **must not** appear in patient browse.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending Doctors** |
| Patient browse | App landing → **Women Doctors** (member login required) |
| Doctor portal | App landing → Login sheet → **Women Doctor Login** **or** Join Us → **Women Doctor** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid bookings complete without a real Razorpay card. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on ID/license uploads) |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check in-app notifications / appointment state instead. |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V28.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Doctor (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (patient) | App Join Us → Member / existing user register | Required to browse doctors |
| Doctor | App Join Us → Women Doctor | Email OTP required |
| Admin | Existing web admin | Approves doctors at `/admin/pending-doctors` |

Use unique emails each run (e.g. `qa.doctor.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Doctor

1. Landing → **Join Us** → **Women Doctor** → Register tab.  
2. Landing → **Login** → **Women Doctor Login** → Login tab.  
3. After login, if profile is incomplete, **Complete Profile** opens automatically.

### Patient

1. Landing → **Women Doctors** (login wall if guest).  
2. Member dashboard → Doctors catalog.  
3. Screen title: **Women Doctors** with tabs **Browse** and **My Bookings**.  
4. FAB: **Instant Consult**.

---

## 4. Doctor registration (Register tab)

### Fields

| # | Field | Rule |
|---|--------|------|
| 1 | Full name | Required |
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
| Success | Account created; doctor is logged in; **Complete Profile** opens |

**Negative:** Duplicate email/phone should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on documents, but they **are** blocked without a valid OTP.

---

## 5. Doctor Complete Profile (numbered UX)

After login, incomplete doctors land on Complete Profile. Sections:

### 1. Professional info

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Doctor name | Text | Yes |
| 1.2 | Specialization | Dropdown (+ Other) | Yes |
| 1.3 | Qualification | Dropdown (+ Other) | Yes |
| 1.4 | Medical registration number | Text | Yes |
| 1.5 | Years of experience | Number 0–50 | Yes |

**Specialization catalog (must match patient pills):** Gynecologist, Obstetrician, Psychologist, Psychiatrist, General Physician, Dermatologist, Pediatrician, Nutritionist, Fertility Specialist, Endocrinologist, Physiotherapist, Other.

### 2. Clinic / hospital

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Hospital / clinic name | Text | Yes |
| 2.2 | Clinic address | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin clinic on map | Tap map **or** Use current location | No |

### 3. Consultation modes (at least one)

`CLINIC` (In Clinic), `VIDEO`, `ONLINE` (Online/Chat), `OFFLINE` (Home visit).

If **Video** is selected and clinic fee is 0 / empty, **7.4 Video fee** is required.  
If **Online/Chat** is selected and clinic fee is 0 / empty, **7.2 Chat fee** is required.

### 4. Availability

- Add at least one day slot (day + start + end). End must be after start.  
- **Slot length:** 15 / 20 / 30 minutes.  
- **Buffer** minutes between patients.  
- **Break** start–end (e.g. 13:00–14:00) — those times must not be bookable.  
- **Leave / blocked dates** — those calendar days must not be bookable.  
- **Auto-confirm:** ON = new bookings go to `CONFIRMED`; OFF = `PENDING` (doctor accepts).

### 5. Languages

At least one: English, Hindi, Kannada, Tamil, Telugu, Marathi, Malayalam, Gujarati, Punjabi, Bengali, Urdu.

### 6. Services

Optional chips (General consultation, Follow-up, Women’s wellness, etc.).

### 7. Fees

| Serial | Field | Mandatory |
|--------|--------|-----------|
| 7.1 | Consultation fee (clinic) | Yes (≥ 0) |
| 7.2 | Chat fee | If ONLINE mode and clinic fee is 0 |
| 7.3 | Call fee | No |
| 7.4 | Video fee | If VIDEO mode and clinic fee is 0 |
| — | Emergency / instant available | Toggle (needed later for Instant Consult) |

### 8. Bio

Optional.

### 9. Payout

| Serial | Field | Mandatory for withdraw |
|--------|--------|-------------------------|
| 9.1 | UPI ID | Required before dashboard **Withdraw** |
| 9.2 | Bank details | No |

### 10. Documents — **optional this cycle**

| Serial | Type | Notes |
|--------|------|--------|
| 10.1 | Profile photo | JPG/PNG, max 5 MB |
| 10.2 | Government ID | JPG/PNG/PDF, max 5 MB |
| 10.3 | Medical registration certificate | Optional |
| 10.4 | Medical license | Optional |
| 10.5 | Extra certificates | Optional |
| 10.6 | Clinic photos (waiting room / signage) | Optional images |

Do **not** fail the cycle if documents are skipped.

### Save / submit

1. **Save Profile** — validates mandatory fields; profile % updates.  
2. When mandatory items are filled, doctor can **submit for verification**.  
3. Status becomes `PENDING_ADMIN_APPROVAL` / ready for admin queue.  
4. Doctor is **not** visible to patients until admin **Approve**.

---

## 6. Admin verification (web)

**URL:** `/admin/pending-doctors`  
**Doctor profile:** `/admin/doctors/{id}/profile`

| Action | Result |
|--------|--------|
| Approve | `DoctorProfileStatus = APPROVED`, `VerificationStatus = VERIFIED`. Doctor appears in patient Browse. |
| Request changes | Doctor returns to Complete Profile; not listed to patients. |
| Reject | Not listed to patients. |

**Must test:** Unapproved doctor is absent from Women Doctors browse. After approve + pull-to-refresh, the doctor appears with correct name, specialization, city, fee, modes.

---

## 7. Doctor dashboard (mobile)

Bottom nav: **Home | Appointments | Patients | Messages | Profile**

### Home
- Counts: pending / today / earnings.  
- Online toggle (required for Instant Consult).  
- Notifications list.  
- Instant consult FAB / pending offers: **Accept** / **Decline** (offer TTL **5 minutes**).

### Appointments
- Filters: All, Today, Pending, Completed, Video, In Clinic.  
- Actions by status:  
  - `PENDING` → Confirm or Cancel  
  - `CONFIRMED` → Complete, Cancel, Reschedule, Chat  
  - Video/Online `CONFIRMED` → **Join** only inside join window (see rules)  
  - Join also sends “Doctor is waiting on video” ping  
  - **Prescription:** medicine, dosage, days, advice → patient sees text + PDF  
- **Withdraw / payout:** needs UPI; records a payout request (not a live bank transfer in this build).

### Patients
- Unique patients from appointments.  
- Open **patient file**: past visits, Rx, notes, reports.  
- Chat (only with booked patients).

### Messages
- Threads with booked patients. Chat polls ~**4 seconds**. Attach photo or PDF.

### Profile
- Edit Complete Profile, online status, logout.

---

## 8. Patient flows

### 8.1 Browse

Tabs: Browse | My Bookings.

**Filters / sort (Browse)**

| Control | Expected |
|---------|----------|
| Search | Name, specialization, city |
| Specialty pills | All Experts + Gynecologist, Psychologist, GP, Dermatologist, Pediatrician, Nutritionist |
| Online now | Only `isOnline = true` |
| Available today | Only doctors with a remaining slot today |
| Saved | Only favourited doctors |
| Language | Matches doctor languages |
| Max fee | ₹300 / 500 / 800 / 1200 |
| Sort | Rating (default), fee (low→high), experience (high→low) |

**Listing tags:** rating, Online now, emergency, qualification, years, fee.

**Open card** → Doctor Profile (not a tiny dialog).

### 8.2 Doctor profile

- Photo, name, specialization, rating, fee, modes, languages, services, clinic, maps link.  
- **Reviews** list (or “No reviews yet”).  
- **Heart** favourite / unfavourite.  
- Clinic photo strip if uploaded.  
- If no slots this week: *“No slots this week…”*  
- **Book appointment**.  
- **No chat on this screen** (chat only after a booking).

### 8.3 Book appointment

| Serial | Field | Rule |
|--------|--------|------|
| 1.1 | Patient name | Required |
| 1.2 | Age | 1–120 |
| 1.3 | Gender | Dropdown |
| 1.4 | Symptoms / reason | Required |
| 2.1 | Mode | Only modes the doctor enabled |
| 2.2 | Date | Only days with generated slots |
| 2.3 | Time | From slot length + buffer; not in break; not on leave; **≥ 15 minutes from now** |
| 3 | Reports | Optional JPG/PNG/PDF, uploaded after booking succeeds |

**Policy copy on screen:** *Free cancellation until 2 hours before the appointment. After that the fee is not refunded.*

**Follow-up booking:** banner *Follow-up visit — 50% of the usual fee.*

**Fee = 0:** Request booking (no Razorpay).  
**Fee > 0:** Pay ₹X & book → mock payment auto-confirms in local/test.

**Empty slots:** *No slots this week. Try another doctor or Instant Consult.*

### 8.4 My Bookings

- List of appointments with status, time, mode, payment pending, prescription ready, Join now, Rate this visit.  
- **Calendar view** groups by date.  
- Details sheet:  
  - Cancel policy  
  - Pay now (if `PENDING_PAYMENT`)  
  - Chat (only if PENDING / CONFIRMED / COMPLETED)  
  - Join video (only if `canJoin` = true)  
  - Reschedule  
  - Receipt  
  - Upload scan/lab report  
  - Download Rx PDF / WhatsApp share  
  - Book follow-up in 7 days (50% fee) — when COMPLETED  
  - Leave a review / Rate visit — when COMPLETED  
  - Cancel  

### 8.5 Instant Consult

1. Doctor must be **Online** **and** **Emergency available**.  
2. Patient taps FAB **Instant Consult** → Request now.  
3. Banner status: waiting (`OFFERED`/`QUEUED`) → accepted → pay/join from My Bookings.  
4. Offer expires in **5 minutes** if doctor does not accept.  
5. If no online+emergency doctor: error *No doctors available for instant consult right now*.

---

## 9. Business rules (assert these)

| ID | Rule |
|----|------|
| BR-01 | Only `APPROVED` / `VERIFIED` doctors appear in Browse. |
| BR-02 | Slots respect per-day hours, slot duration, buffer, break, blocked dates. |
| BR-03 | Booking time must be at least **15 minutes** in the future. |
| BR-04 | Overlapping slot for the same doctor is rejected. |
| BR-05 | Auto-confirm ON → `CONFIRMED`; OFF → `PENDING`. |
| BR-06 | Video fee / chat fee used by mode; clinic fee otherwise. Follow-up = **50%**. |
| BR-07 | Paid cancel: refund if appointment is **more than 2 hours** away; **no refund** inside 2 hours. |
| BR-08 | Video **Join** only if status `CONFIRMED` and now is **5 minutes before start** through **slot duration + 15 minutes after**. |
| BR-09 | Chat forbidden before a booking exists (API + UI). |
| BR-10 | Instant consult only to doctors with Online + Emergency. |
| BR-11 | Platform commission default **15%** (earning = paid − platform fee). |
| BR-12 | Withdraw requires UPI ID. |
| BR-13 | Documents optional; JPG/PNG/PDF; max 5 MB. |
| BR-14 | Join opens **Jitsi** in an external browser/app (not an in-app custom video chrome). |

### Appointment status machine

| Actor | From | To |
|-------|------|-----|
| Doctor | PENDING | CONFIRMED or CANCELLED |
| Doctor | CONFIRMED | COMPLETED or CANCELLED |
| Patient | PENDING or CONFIRMED | CANCELLED |
| Either | PENDING or CONFIRMED | Reschedule (time change, same booking) |

Terminal: COMPLETED, CANCELLED.

---

## 10. Suggested test data

**Doctor A (clinic + video, auto-confirm ON)**  
- Specialization: Gynecologist  
- City: Bengaluru, State: Karnataka, Pincode: 560001  
- Modes: CLINIC + VIDEO  
- Mon–Fri 10:00–13:00 and 15:00–18:00  
- Slot 30 min, buffer 0, break 13:00–14:00  
- Block one future date as leave  
- Clinic fee ₹500, video fee ₹400  
- Emergency ON, then toggle Online ON after approval  
- UPI: `qa@upi`

**Doctor B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve.

**Patient P1**  
- Book clinic slot > 2 hours away (cancel → refund).  
- Book video slot; join only in window.  
- Upload a dummy lab PDF.  
- After complete: rate + follow-up.

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Doctor onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| D-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| D-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| D-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| D-04 | Login existing doctor | Email + password | Dashboard or Complete Profile |
| D-05 | Auto-open Complete Profile | New doctor login | Profile screen opens without extra tap |
| D-06 | Profile mandatory | Save with empty 1.1 / 2.5 / 3 / 4 / 5 / 7.1 | Numbered error (e.g. `2.5 Pincode must be exactly 6 digits`) |
| D-07 | Specialization Other | Pick Other + type | Saves custom value; still browsable via search |
| D-08 | Slot end before start | End 09:00 start 10:00 | Error |
| D-09 | Video without video fee | VIDEO on, clinic fee 0, video fee empty | `7.4 Video fee is required…` |
| D-10 | Map pin | Tap map / Use current location | Lat/lng shown; maps URL filled |
| D-11 | Optional docs | Skip all docs, save | Save succeeds |
| D-12 | Clinic photo | Upload waiting-room image | Appears on patient doctor profile |
| D-13 | Submit verification | Fill mandatory → submit | Status pending admin |
| D-14 | Leave date | Block tomorrow | Patient cannot pick that date |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/pending-doctors` | New doctor listed |
| A-02 | Approve | Open profile → Approve | Flash “Doctor approved.” |
| A-03 | Visibility | Patient Browse refresh | Doctor listed |
| A-04 | Unapproved hidden | Doctor B not approved | Not in Browse |
| A-05 | Request changes | Request changes + note | Doctor can edit; still hidden from patients |

### C. Patient browse & book

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| P-01 | Guest wall | Open Women Doctors logged out | Login required |
| P-02 | Specialty pill | Gynecologist | Only matching doctors |
| P-03 | Online now | Doctor offline vs online | Filter matches toggle |
| P-04 | Available today | Doctor with only future-week slots | Hidden when filter on |
| P-05 | Language / max fee / sort | Apply each | List updates correctly |
| P-06 | Favourite | Heart on profile, Saved filter | Doctor in Saved |
| P-07 | Reviews on profile | Before any booking | List or “No reviews yet” (not only after booking) |
| P-08 | No pre-book chat | Profile / listing | No chat button |
| P-09 | Empty slots copy | Doctor with no hours | “No slots this week” |
| P-10 | Book clinic paid | Fill 1.x–2.x, pay | Booking in My Bookings |
| P-11 | Reports at book | Attach PDF then pay | Report on appointment / doctor patient file |
| P-12 | Break blocked | Try 13:30 when break 13–14 | Time not offered / API reject |
| P-13 | Buffer | 30 min slot + 10 buffer | Next slot not immediately adjacent |
| P-14 | Double book same slot | Two patients same time | Second fails |
| P-15 | < 15 min | Slot too soon | Rejected |

### D. Appointments, video, Rx, chat

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| C-01 | Auto-confirm | Doctor auto-confirm ON | Status CONFIRMED after pay |
| C-02 | Manual confirm | Auto-confirm OFF | PENDING until doctor confirms |
| C-03 | Doctor reschedule | Doctor picks new slot | Patient sees new time |
| C-04 | Patient reschedule | My Bookings → Reschedule | New time; old slot freed |
| C-05 | Cancel > 2h | Paid booking far away | Cancel + refund message |
| C-06 | Cancel < 2h | Paid booking soon | Cancelled, **no refund** |
| C-07 | Join too early | 20 min before start | Join hidden / “not allowed” |
| C-08 | Join in window | 4 min before | Join works; Jitsi URL opens |
| C-09 | Join too late | After duration+15 | Join blocked |
| C-10 | Waiting ping | Doctor Join | Patient notified in-app / log |
| C-11 | Structured Rx | Medicine + dose + days | Patient details + PDF download + WhatsApp share |
| C-12 | Chat after book | Open chat both sides | Messages appear within ~4s |
| C-13 | Chat attach | Photo + PDF | Bubble / open attachment |
| C-14 | Chat before book | Call chat API / UI | Forbidden |
| C-15 | Complete + rate | Doctor completes → patient Rate visit | Review on doctor profile |
| C-16 | Follow-up | Book follow-up | Fee is 50% of mode fee |
| C-17 | Calendar view | Toggle calendar | Grouped by date |
| C-18 | Receipt | After paid booking | Receipt shown |

### E. Instant consult & payout

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| I-01 | No online doctor | All offline | “No doctors available…” |
| I-02 | Happy path | Doctor online+emergency; patient request; doctor accept | Status ACCEPTED; appointment created; pay if fee > 0 |
| I-03 | Decline / expire | Decline or wait 5+ min | Patient banner expired/declined |
| I-04 | Track banner | After request | Waiting → Track → My Bookings |
| W-01 | Withdraw no UPI | Request payout | Error: add UPI |
| W-02 | Withdraw with UPI | Request | Success message; balance shown (transfer is recorded, not a real bank payout) |

---

## 12. Priority for this cycle

**P0 (must pass before UAT sign-off)**  
D-02, D-05, D-06, D-13, A-02, A-03, A-04, P-08, P-10, C-01, C-05, C-07, C-08, C-11, C-12, C-14, C-15, I-02.

**P1**  
Filters/sort, leave/break/buffer, follow-up 50%, reports, calendar, favourite, map pin, clinic photos, payout.

**P2 / known gaps (do not fail the build)**  
- Real FCM push on a locked phone (backend logs only).  
- Real Razorpay live keys (mock is default).  
- Real UPI settlement.  
- In-app Jitsi chrome (opens external).  
- Website `/doctors/login` (out of scope; do not “fix” or regress it).  
- Mandatory documents (intentionally optional until go-live).

---

## 13. Defect logging template

```
Module: Women Doctor
Role: Doctor / Patient / Admin
Build: <apk date / commit>
Device: <model + OS>
Steps:
Expected:
Actual:
Screenshot / video:
API (if known): method + path + status + body snippet
```

Useful API prefixes:

- Doctor auth: `/api/doctors/provider/...`  
- Patient: `/api/doctors/...`  
- Pay: `/payment/create-order` `type=DOCTOR`, then `/payment/verify`  
- Admin pages: `/admin/pending-doctors`, `/admin/doctors/{id}/profile`

---

## 14. Smoke path (30–40 minutes)

1. Register doctor + OTP + Complete Profile (Gynecologist, CLINIC+VIDEO, weekday hours, fee ₹500/₹400, emergency ON). Skip documents.  
2. Admin approve.  
3. Doctor: Online ON.  
4. Patient: Browse → open profile → favourite → book video slot + attach a PDF → mock pay.  
5. Doctor: confirm if pending → chat text + photo → write Rx → Join inside window.  
6. Patient: chat received, PDF download, Join.  
7. Doctor: Complete visit. Patient: Rate visit + follow-up 50%.  
8. Patient: cancel a **second** paid booking > 2 hours away → refund copy.  
9. Instant Consult: patient request → doctor accept.  
10. Confirm unapproved doctor never appeared in Browse.

If this smoke path passes, the module is test-ready for the full case list in §11.
