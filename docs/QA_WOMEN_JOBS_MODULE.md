# Women Jobs Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Women Jobs (home / care / hourly workers — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** worker + member flows. Do **not** treat website marketplace / provider logins as the primary portal for this cycle (existing web logins must remain unchanged).

---

## 1. What this module does

**Workers** register on the **mobile app**, complete a numbered 11-section profile, wait for **admin approval**, then manage job bookings and UPI payouts.

Logged-in **members** browse approved workers, filter/sort, open worker detail (photos, reviews, next slot), book a visit (Razorpay or mock pay after the worker accepts), cancel under policy, favourite workers, and write reviews.

Unapproved workers **must not** appear in member Workers.

**Service Partner** was removed from Join Us / Login because it duplicated Women Jobs. Leftover `service_partner` deep links still open **Women Jobs**. **Women Lawyer** stays as a separate Join Us / Login option.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Job applications** (`/admin/job-applications`) |
| Member browse | App landing → **Women Marketplace** (member login required) |
| Worker portal | App landing → Login sheet → **Women Jobs Login** **or** Join Us → **Women Jobs** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid bookings complete without a real Razorpay card. Type = `WORKER_BOOKING`. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo uploads) |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check booking state instead. |
| Flyway | Confirm **V31** (`women_jobs_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V31.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Worker (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (client) | App Join Us → Member / existing user register | Required to browse workers |
| Worker | App Join Us → Women Jobs | Email OTP required |
| Admin | Existing web admin | Approves workers at `/admin/job-applications` |

Use unique emails each run (e.g. `qa.worker.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Worker

1. Landing → **Join Us** → **Women Jobs** → Register.  
2. Landing → **Login** → **Women Jobs Login**.  
3. After login, if profile is incomplete, **Complete Worker Profile** opens (or from the dashboard completion card).

**Do not expect** a Join Us tile named **Service Partner**. If a leftover link still uses `service_partner`, it must open Women Jobs (not a second marketplace-provider portal).

### Member

1. Landing → **Women Marketplace** (login wall if guest).  
2. Member dashboard → marketplace catalog.  
3. Screen tabs: **Workers | My Bookings | My Classes**.  
4. There is **no Providers tab** on this member screen this cycle.

---

## 4. Worker registration (quick register)

Quick register collects only account fields. Full listing data is on **Complete Profile**.

### Fields

| # | Field | Rule |
|---|--------|------|
| 1 | Full name | Required |
| 2 | Phone | Required, **exactly 10 digits** |
| 3 | Email | Required, valid email |
| 4 | Send OTP / 6-digit OTP | Required before Create Account. Auto-verifies when 6 digits entered |
| 5 | Password | Min 6 chars, must include a **number** and a **special character** |
| 6 | Confirm password | Must match |
| 7 | Job category | Dropdown from JobCatalog |
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
| Success | Account created; worker logs in; **Complete Worker Profile** is available |

**Negative:** Duplicate email should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on documents, but they **are** blocked without a valid OTP.

**Out of scope:** Do not test or “fix” website marketplace / provider logins. Mobile Women Jobs portal is the source of truth this cycle.

---

## 5. Worker Complete Profile (numbered UX — 11 sections)

After login, incomplete workers land on Complete Profile. Profile % is based on **14** mandatory items. Submit is enabled only when **missingItems is empty**.

Documents (10) and work photos (11) are **optional**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Full name | Name |
| 1.2 Role type | Designation / category |
| 1.5 Official phone | 10-digit phone |
| 2.1 Landmark / address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Work categories | At least one JobCatalog category |
| 4.1 Who I serve | At least one audience |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio |
| 8. First offering | Role + hourly rate + service mode |

UPI (9.1) is **not** required to submit. It **is** required to withdraw from Finance.

### 1. Worker identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Full name | Text | Yes |
| 1.2 | Role type | Dropdown: Worker, Caregiver, Babysitter, Cook, Housekeeper, Beautician, Tutor, Tailor, Office assistant, Other | Yes |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Years of experience | Number | No |

### 2. Location

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Landmark / address | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin work area on map | Tap map **or** Use current location | No |

There is **no** single free-text hours box as the only availability field. City, state, and pincode are separate.

### 3. Work categories

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Categories you offer | Multi-select chips from JobCatalog | Yes (at least one) |

**Catalog:** Caregiver, Babysitting, Housekeeping, Cooking, Beauty & Salon, Healthcare, Teaching, Office Jobs, Retail, Hospitality, Customer Support, Delivery & Logistics, Domestic Help, Tailoring & Fashion, Digital Jobs, Freelancing, Entrepreneurship.

### 4. Who I serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips: Women, Families, Elderly, Kids, Working professionals | Yes (at least one) |
| 4.2 | Door / home visits | Toggle | No |
| 4.3 | Languages | Chips | No |
| 4.4 | Skills | Chips | No |

### 5. Facilities & readiness

Optional chips: Own tools, ID proof, Police verification, First aid trained, Can travel, Night available, Weekend available, UPI / cash.

### 6. Hours & calendar

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 6.1 | Open days | Day chips MON–SUN | Yes (at least one) |
| 6.2 | Open time | **Time picker** (no typing `10:00 – 19:00` as the only input) | Yes |
| 6.3 | Close time | Time picker | Yes |
| 6.4 | Break start | Time picker | No |
| 6.5 | Break end | Time picker | No |
| 6.6 | Leave / blocked dates | Date picker chips | No |

### 7. About you

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 7.1 | About | Text | Yes |

### 8. First offering

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Primary category | Dropdown from JobCatalog | Yes |
| 8.2 | Role / service | Subcategory picker | Yes |
| 8.3 | Duration | Picker: 30 / 45 / 60 / 90 / 120 / 180 min | Yes |
| 8.4 | Buffer | 0 / 5 / 10 / 15 / 20 / 30 min | No |
| 8.5 | Hourly rate (₹) | Number | Yes |
| 8.6 | Mode | DOOR / CENTRE / BOTH | Yes |
| 8.7 | Work type | Full time / Part time / Hourly / Live-in / On demand | No |

### 9. Payout

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 9.1 | UPI ID | Text (`name@upi`) | No to submit; **Yes to withdraw** |
| 9.2 | Bank details | Text | No |

Earnings stay in the worker wallet until Finance → Request UPI payout. Minimum payout **₹100**.

### 10. Documents (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 10.1 | Profile photo | Image upload | No |

### 11. Work photos (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 11.1 | Gallery photo | Image upload | No |

Skip is allowed.

### Save vs Submit

| Action | Behaviour |
|--------|-----------|
| **Save Profile** | Persists fields; refreshes % and missing chips |
| **Submit for Verification** | Enabled only when missingItems is empty. Status → PENDING |

**Skip for now** is not a substitute for required fields. Testers must fill 1–8 to submit.

---

## 6. Admin approval

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Job applications** (`/admin/job-applications`).  
3. Find the pending worker application.  
4. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Worker **not** listed in member Workers |
| Approved (VERIFIED) | Worker **is** listed; visits bookable |
| Reject | Worker stays off Workers; worker sees Rejected on dashboard |

Do **not** use website provider login for this cycle.

---

## 7. Worker dashboard (after approval)

Bottom nav: **Dashboard | Bookings | Finance | Profile**.

### Dashboard

Stats: pending, accepted, completed, earnings. Incoming bookings. Complete-profile card until verified.

### Bookings (booking file)

| Action | From status | To |
|--------|-------------|-----|
| Accept / Reject | PENDING | ACCEPTED / REJECTED |
| Complete | ACCEPTED | COMPLETED |
| Notes | Any | Internal `coachNotes` saved |

Each row shows client, date, amount, hours, status. **Notes** is the visit history file.

### Finance

| Field | Expected |
|-------|----------|
| Payout balance | Credits when a member **pays** a worker booking (`type=WORKER_BOOKING`) |
| Confirmed earnings | Sum of COMPLETED booking totals |
| Request UPI payout | Fails without UPI; fails if balance &lt; ₹100; succeeds with UPI + ≥ ₹100 |

### Profile

Shows name, phone, category, status. **Update profile** opens the numbered 11-section form.

---

## 8. Member browse & booking

### Workers tab

Cards show category, hourly rate, next slot, **Available today** when slots exist today.

**Filters:**

| Filter | Expected |
|--------|----------|
| Category chips | JobCatalog categories + All Workers |
| City | Contains match on worker city |
| Available today | Only workers with at least one open slot today |
| Door service | Only workers with door/home visits on |
| Favourites | Heart-saved workers only |
| Sort: Top rated | Highest rating first |
| Sort: Fee | Lowest hourly rate first |

Unapproved workers must **not** appear.

Copy: “book up to **60 days** ahead” (not 2 days).

### Worker detail

| Item | Expected |
|------|----------|
| Photos | Profile image + gallery strip if uploaded |
| Rating / rate / next slot chips | Present when data exists |
| “No slots today” | When `slotsToday` is empty |
| Door service / Available today | Chips when enabled |
| Cancel policy | “Free cancellation until 2 hours before the visit…” |
| Reviews | List or “No reviews yet”; **Write a review** |
| Heart | Toggles favourite |
| Book visit | Date picker + **slot dropdown** for that date + hours + note |

### Book a visit

1. Pick **date** (date picker, up to 60 days).  
2. Pick **time** from available slots on that date.  
3. Hours (default 1) × hourly rate = amount.  
4. Optional notes.  
5. Policy copy is shown.  
6. Request creates `PENDING` booking. Worker must **Accept**.  
7. Member **Pay now** on My Bookings after ACCEPTED (`type=WORKER_BOOKING`, `targetId` = booking id). Mock pay marks PAID and credits worker payout.

| Negative | Expected |
|----------|----------|
| Closed / blocked date | “Worker is not available on this date” |
| Slot already taken | “This time slot is already booked” |
| No slots on date | Confirm disabled / “No slots on this date” |
| Past time | “Booking time cannot be in the past” |

### My Bookings

Worker rows: status, amount, **Pay now** when ACCEPTED.  
**Cancel booking** from Details if not COMPLETED / CANCELLED / REJECTED / PAID.  
Accepted/paid inside 2 hours: cancel API returns the policy error.

### My Classes

Unchanged marketplace class enrollments (not Women Jobs workers). Still present on the same screen.

---

## 9. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unverified workers never appear in member Workers / detail. |
| BR-02 | Submit verification requires all numbered mandatory items including first offering. |
| BR-03 | Documents and gallery are optional. |
| BR-04 | Open/close times are pickers, not a typed `10:00 – 19:00` hours string as the only input. |
| BR-05 | Double-book same worker + overlapping time is rejected (duration + buffer). |
| BR-06 | Free cancel until **2 hours** before visit start. After that, accepted/paid bookings cannot be cancelled by the member. |
| BR-07 | Pending bookings can still be cancelled by the member (not yet paid). |
| BR-08 | Visit reminder ~1 hour before (FCM log-only). |
| BR-09 | Paid worker bookings credit `JobApplication.payoutBalance`. |
| BR-10 | Withdraw requires UPI ID and balance ≥ ₹100. |
| BR-11 | Website logins are out of scope and must not be changed. |
| BR-12 | Slot generation uses open/close, skips break, skips past times today, skips taken times. |
| BR-13 | Service Partner is hidden from Join Us / Login; Women Lawyer remains. |
| BR-14 | Member marketplace has no Providers tab this cycle. |

### Booking status machine

| Actor | From | To |
|-------|------|-----|
| Member create | — | PENDING |
| Worker | PENDING | ACCEPTED / REJECTED |
| Member pay | ACCEPTED | PAID (worker payout credited) |
| Worker | ACCEPTED | COMPLETED |
| Member | PENDING | CANCELLED |
| Member | ACCEPTED / PAID | CANCELLED only if ≥ 2 hours before start |

---

## 10. Suggested test data

**Worker A (Housekeeping, approved)**  
- Role: Housekeeper  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Categories: Housekeeping, Cooking  
- Audience: Families  
- Door service: on  
- Open Mon–Sat 09:00–18:00, break 13:00–14:00  
- Block one future date as leave  
- Offering: Housekeeper, 60 min, buffer 10, ₹250/hr, DOOR  
- UPI: `qa.worker@upi`

**Worker B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve.

**Member M1**  
- Book a visit &gt; 2 hours away (cancel → allowed).  
- Book a visit &lt; 2 hours away after accept (cancel → blocked).  
- Rate worker + favourite.

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Worker onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| W-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| W-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| W-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| W-04 | Login existing worker | Email + password | Dashboard or Complete Profile |
| W-05 | Complete Profile opens | New worker | Numbered 1–11 form |
| W-06 | Profile mandatory | Save with empty 1.1 / 2.5 / 3.1 / 6.2 / 7.1 / no offering | Numbered error (e.g. `2.5 Pincode must be 6 digits`) |
| W-07 | Location split | City / state / pincode / map pin | All save; listing shows city |
| W-08 | Time picker only | Open/close | Clock UI; not typed `10:00 – 19:00` as the only hours field |
| W-09 | Map pin | Tap map / Use current location | Lat/lng shown |
| W-10 | Optional docs | Skip photo + gallery, save | Save succeeds |
| W-11 | Gallery photo | Upload work image | Appears on member worker detail |
| W-12 | First offering required | Fill 1–7, skip 8, submit | Blocked until role + rate + mode exist |
| W-13 | Submit verification | Fill mandatory + first offering → submit | Status pending admin |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/job-applications` | New worker listed |
| A-02 | Approve | Approve | Status VERIFIED |
| A-03 | Visibility | Member Workers refresh | Worker listed |
| A-04 | Unapproved hidden | Worker B not approved | Not in Workers |
| A-05 | Web login untouched | Open existing website marketplace/provider login | Existing web page still works |

### C. Worker ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Finance tab | Open Finance | Payout balance + Request UPI payout |
| O-02 | Booking file | Add notes on a booking | Notes persist on reload |
| O-03 | Accept booking | PENDING → ACCEPTED | Member My Bookings shows Pay now |
| O-04 | Payout no UPI | Request payout | Error: add UPI ID |
| O-05 | Payout with UPI | After a paid booking | Success message |

### D. Member browse & book

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | No Providers tab | Open Women Marketplace | Tabs: Workers, My Bookings, My Classes |
| M-02 | Filters | City + available today + door + sort | List updates; unapproved hidden |
| M-03 | Favourites | Heart on detail; Favourites chip | Worker appears in favourites filter |
| M-04 | Next slot | Detail chips | Next slot or “No slots today” |
| M-05 | Slot picker | Book → pick date with no slots | Confirm disabled / no-slots copy |
| M-06 | Book + accept + pay | Member books → worker accepts → Pay now | PAID; worker payout increases |
| M-07 | Review | Write 5★ review | Shows on detail; rating updates |
| M-08 | Cancel free | Cancel PENDING or ACCEPTED &gt; 2h | CANCELLED |
| M-09 | Cancel blocked | ACCEPTED/PAID inside 2h | Policy error |
| M-10 | Join Us cleanup | Open Join Us and Login sheets | Women Jobs present; Service Partner absent; Women Lawyer present |

### E. Regression / out of scope

| ID | Title | Expected |
|----|--------|----------|
| R-01 | Website logins | Unchanged |
| R-02 | Women Lawyer | Separate portal still works |
| R-03 | My Classes | Still lists marketplace class enrollments |

---

## 12. Known limitations this cycle

- FCM reminders are **log-only**. Pass if booking exists; do not fail on missing OS notification.  
- Photos are optional.  
- Payout is a **request** (not a live bank transfer).  
- Member pay happens **after** worker accepts, not at request time.  
- Service Partner Join Us tile is intentionally gone.

---

## 13. Sign-off

| Area | Tester | Date | Result |
|------|--------|------|--------|
| Worker onboarding 1–11 | | | |
| Admin approve / hide | | | |
| Worker bookings + Finance | | | |
| Member filters / book / cancel / favourite / review | | | |
| Join Us: no Service Partner; Lawyer stays | | | |
