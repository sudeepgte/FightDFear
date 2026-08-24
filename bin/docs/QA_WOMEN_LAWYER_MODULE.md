# Women Lawyer Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Women Lawyer (legal consults — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** lawyer + member flows. Do **not** treat website marketplace / provider logins as the primary portal for this cycle (existing web logins must remain unchanged).

---

## 1. What this module does

**Lawyers** register on the **mobile app**, complete a numbered 11-section profile (Bar council ID is required), wait for **admin approval**, then manage consults and UPI payouts.

Logged-in **members** browse approved lawyers from **Legal Help**, filter/sort, open lawyer detail (photos, reviews, next slot), request a consult (Razorpay or mock pay after the lawyer confirms), cancel under the 2-hour policy, favourite lawyers, and write reviews.

Unapproved lawyers **must not** appear in member Legal Help.

Women Lawyer is **separate** from Women Jobs. Service Partner was removed earlier; leftover `service_partner` still opens Women Jobs.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending providers** (`/admin/pending-providers`) — filter **WOMEN_LAWYER** |
| Member browse | App landing → **Legal Help** (member login required) |
| Lawyer portal | App landing → Login sheet → **Women Lawyer Login** **or** Join Us → **Women Lawyer** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid consults complete without a real Razorpay card. Type = `LAWYER_BOOKING`. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo uploads). **Bar council ID is required** (typed credential, not an upload). |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check booking state instead. |
| Flyway | Confirm **V32** (`women_lawyer_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V32.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Women Lawyer (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (client) | App Join Us → Member / existing user register | Required to browse Legal Help |
| Lawyer | App Join Us → Women Lawyer | Email OTP required; category locked to WOMEN_LAWYER |
| Admin | Existing web admin | Approves lawyers at `/admin/pending-providers` |

Use unique emails each run (e.g. `qa.lawyer.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Lawyer

1. Landing → **Join Us** → **Women Lawyer** → Register.  
2. Landing → **Login** → **Women Lawyer Login**.  
3. After login, if profile is incomplete, **Complete Lawyer Profile** opens (or from the dashboard completion card).

Category is locked to legal consultations. Do not use Women Jobs / Service Partner for this module.

### Member

1. Landing → **Legal Help** (login wall if guest).  
2. Member dashboard → Legal Help catalog.  
3. Screen tabs: **Listings | My Bookings**.  
4. Filters: practice-area chips, city/area, available today, saved, sort (rating / fee), max fee.

---

## 4. Lawyer registration (quick register)

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
| 7 | Terms checkbox | Must be accepted |

Category is locked to **WOMEN_LAWYER** (not a free-text category picker).

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
| Success | Account created; lawyer logs in; **Complete Lawyer Profile** is available |

**Negative:** Duplicate email should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on photos, but they **are** blocked without a valid OTP **and** without a Bar council ID on Complete Profile.

**Out of scope:** Do not test or “fix” website marketplace / provider logins. Mobile Women Lawyer portal is the source of truth this cycle.

---

## 5. Lawyer Complete Profile (numbered UX — 11 sections)

After login, incomplete lawyers land on Complete Profile. Profile % is based on **15** mandatory items. Submit is enabled only when **missingItems is empty**.

Documents (10) and chamber photos (11) are **optional**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Full name | Name |
| 1.2 Designation | Advocate / Senior Advocate / … |
| 1.5 Official phone | 10-digit phone |
| 1.8 Bar council ID | Enrolment / registration number (typed, not upload) |
| 2.1 Chamber address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Practice areas | At least one LawyerCatalog area |
| 4.1 Who I serve | At least one audience |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio |
| 8. First offering | Consult mode + duration + fee + service mode |

UPI (9.1) is **not** required to submit. It **is** required to withdraw from Finance.

### 1. Lawyer identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Full name | Text | Yes |
| 1.2 | Designation | Dropdown: Advocate, Senior Advocate, Legal consultant, Legal aid lawyer, In-house counsel, Other | Yes |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Years of experience | Number 0–60 | No |
| 1.8 | Bar council ID | Text (enrolment / registration number) | **Yes** |

### 2. Chamber location

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Chamber address | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin chamber on map | Tap map **or** Use current location | No |

There is **no** single free-text hours box as the only availability field. City, state, and pincode are separate.

### 3. Practice areas

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Practice areas | Multi-select chips from LawyerCatalog | Yes (at least one) |

**Catalog:** Family Law, Domestic Violence, Divorce & Maintenance, Child Custody, Harassment at Workplace, Property & Inheritance, Cyber Crime, Consumer Rights, Labour & Employment, Criminal Defense, Documentation & Contracts, Legal Aid / Pro Bono.

### 4. Who I serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips: Women, Families, Survivors of violence, Working professionals, Students | Yes (at least one) |
| 4.2 | Home / chamber visits | Toggle | No |
| 4.3 | Languages | Chips | No |

### 5. Chamber facilities

Optional chips: Private chamber, Waiting area, Wheelchair access, Female staff, Video consult ready, Documents notarised, UPI / card.

### 6. Hours & calendar

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 6.1 | Open days | Day chips MON–SUN | Yes (at least one) |
| 6.2 | Open time | **Time picker** (no typing `10:00 – 19:00` as the only input) | Yes |
| 6.3 | Close time | Time picker | Yes |
| 6.4 | Break start | Time picker | No |
| 6.5 | Break end | Time picker | No |
| 6.6 | Leave / blocked dates | Date picker chips | No |

### 7. About the practice

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 7.1 | About | Text | Yes |

### 8. First consult offering

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Consultation mode | In-person / Video / Phone / Chat | Yes |
| 8.2 | Duration | Picker: 30 / 45 / 60 / 90 / 120 min | Yes |
| 8.3 | Buffer | 0 / 5 / 10 / 15 / 20 / 30 min | No |
| 8.4 | Consultation fee (₹) | Number | Yes |
| 8.5 | Mode | CHAMBER / VIDEO / BOTH | Yes |

### 9. Finance / UPI

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 9.1 | UPI ID | Text (`name@upi`) | No to submit; **Yes to withdraw** |
| 9.2 | Bank details | Text | No |

Earnings stay in the lawyer wallet until Finance → Request UPI payout. Minimum payout **₹100**.

### 10. Documents (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 10.1 | Profile photo | Image upload | No |

### 11. Chamber photos (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 11.1 | Gallery photo | Image upload | No |

Skip is allowed.

### Save vs Submit

| Action | Behaviour |
|--------|-----------|
| **Save Profile** | Persists fields; refreshes % and missing chips |
| **Submit for Verification** | Enabled only when missingItems is empty. Status → PENDING_ADMIN_APPROVAL |

**Skip for now** is not a substitute for required fields. Testers must fill 1–8 (including **1.8 Bar council ID**) to submit.

---

## 6. Admin approval

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Pending providers** (`/admin/pending-providers`).  
3. Filter / find the **WOMEN_LAWYER** application.  
4. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Lawyer **not** listed in member Legal Help |
| Approved (VERIFIED) | Lawyer **is** listed; consults bookable |
| Reject | Lawyer stays off Legal Help; lawyer sees Rejected on dashboard |

Do **not** use website provider login for this cycle.

---

## 7. Lawyer dashboard (after approval)

Bottom nav: **Home | Consults | Finance | Profile**.

### Home

Stats: New, Confirmed, Done. Incoming consults. Complete-profile card until verified.

### Consults (consult file)

| Action | From status | To |
|--------|-------------|-----|
| Accept / Reject | PENDING | CONFIRMED / CANCELLED |
| Complete | CONFIRMED or PAID | COMPLETED |
| Notes | Any | Internal `coachNotes` saved |
| Chat | CONFIRMED or PAID | Marketplace booking chat |

Each row shows client, requested time, member note, lawyer file notes. **Notes** is the consult history file.

### Finance

| Field | Expected |
|-------|----------|
| Payout balance | Credits when a member **pays** a consult (`type=LAWYER_BOOKING`) |
| Confirmed earnings | Sum of PAID + COMPLETED consult totals |
| Request UPI payout | Fails without UPI; fails if balance &lt; ₹100; succeeds with UPI + ≥ ₹100 |

### Profile

Shows name, phone, location, practice areas, status. **Edit lawyer profile** opens the numbered 11-section form.

---

## 8. Member browse & booking

### Legal Help listings

Cards show practice areas, fee, next slot, **Available today** when slots exist today.

**Filters:**

| Filter | Expected |
|--------|----------|
| Practice-area chips | LawyerCatalog browse filters + All Lawyers |
| City / area | Contains match on lawyer city |
| Available today | Only lawyers with at least one open slot today |
| Saved | Heart-saved lawyers only |
| Sort: rating | Highest rating first |
| Sort: fee | Lowest consultation fee first |
| Max fee | ₹500 / ₹1,000 / ₹2,000 / ₹5,000 |

Unapproved lawyers must **not** appear.

Copy: book up to **60 days** ahead.

### Lawyer detail

| Item | Expected |
|------|----------|
| Photos | Profile image + gallery strip if uploaded |
| Rating / fee / next slot chips | Present when data exists |
| Practice areas | Up to 3 chips |
| “No slots today” | When `slotsToday` is empty |
| Home / chamber visit / Available today | Chips when enabled |
| Cancel policy | “Free cancellation until 2 hours before the consult…” |
| Reviews | List or “No reviews yet”; **Write a review** |
| Heart | Toggles favourite |
| Request consult | Date picker + **slot dropdown** for that date + note |

### Request a consult

1. Pick **date** (date picker, up to 60 days).  
2. Pick **time** from available slots on that date.  
3. Optional notes.  
4. Policy copy is shown.  
5. Request creates `PENDING` booking. Lawyer must **Accept** (CONFIRMED).  
6. Member **Pay** on My Bookings after CONFIRMED (`type=LAWYER_BOOKING`, `bookingId` / `targetId` = booking id). Mock pay marks PAID and credits lawyer payout.

| Negative | Expected |
|----------|----------|
| Closed / blocked date | “Lawyer is not available on this date” |
| Slot already taken | “This time slot is already booked” |
| No slots on date | Confirm disabled / “No slots on this date” |
| Past time | “Booking time cannot be in the past” |

### My Bookings

Lawyer rows: status, fee, **Pay** when CONFIRMED.  
**Open chat** after CONFIRMED / PAID.  
**Cancel consult** if PENDING / CONFIRMED / PAID and the 2-hour window still allows it.  
Confirmed/paid inside 2 hours: cancel API returns the policy error.

---

## 9. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unverified lawyers never appear in member Legal Help / detail. |
| BR-02 | Submit verification requires all numbered mandatory items including Bar council ID and first offering. |
| BR-03 | Documents and gallery are optional. Bar council ID is a typed credential, not an upload. |
| BR-04 | Open/close times are pickers, not a typed `10:00 – 19:00` hours string as the only input. |
| BR-05 | Double-book same lawyer + overlapping time is rejected (duration + buffer). |
| BR-06 | Free cancel until **2 hours** before consult start. After that, confirmed/paid bookings cannot be cancelled by the member. |
| BR-07 | Pending bookings can still be cancelled by the member (not yet paid). |
| BR-08 | Consult reminder ~1 hour before (FCM log-only). |
| BR-09 | Paid lawyer bookings credit `ServiceProvider.payoutBalance`. |
| BR-10 | Withdraw requires UPI ID and balance ≥ ₹100. |
| BR-11 | Website logins are out of scope and must not be changed. |
| BR-12 | Slot generation uses open/close, skips break, skips past times today, skips taken times. |
| BR-13 | Women Lawyer stays a separate Join Us / Login option from Women Jobs. |
| BR-14 | Member pay happens **after** lawyer confirms, not at request time. |

### Booking status machine

| Actor | From | To |
|-------|------|-----|
| Member create | — | PENDING |
| Lawyer | PENDING | CONFIRMED / CANCELLED |
| Member pay | CONFIRMED | PAID (lawyer payout credited) |
| Lawyer | CONFIRMED or PAID | COMPLETED |
| Member | PENDING | CANCELLED |
| Member | CONFIRMED / PAID | CANCELLED only if ≥ 2 hours before start |

---

## 10. Suggested test data

**Lawyer A (Family Law, approved)**  
- Designation: Advocate  
- Bar council ID: `MH/1234/2018`  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Practice areas: Family Law, Divorce & Maintenance, Child Custody  
- Audience: Women, Families  
- Home / chamber visits: on  
- Open Mon–Sat 10:00–18:00, break 13:00–14:00  
- Block one future date as leave  
- Offering: In-person, 60 min, buffer 10, ₹1500, CHAMBER  
- UPI: `qa.lawyer@upi`

**Lawyer B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve.

**Member M1**  
- Book a consult &gt; 2 hours away (cancel → allowed).  
- Book a consult &lt; 2 hours away after confirm (cancel → blocked).  
- Rate lawyer + favourite.

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Lawyer onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| L-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| L-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| L-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| L-04 | Login existing lawyer | Email + password | Dashboard or Complete Profile |
| L-05 | Complete Profile opens | New lawyer | Numbered 1–11 form |
| L-06 | Profile mandatory | Save with empty 1.1 / 1.8 / 2.5 / 3.1 / 6.2 / 7.1 / no offering | Numbered error (e.g. `1.8 Bar council ID is required`) |
| L-07 | Bar council required | Fill everything except 1.8, submit | Blocked; missing `1.8 Bar council ID` |
| L-08 | Location split | City / state / pincode / map pin | All save; listing shows city |
| L-09 | Time picker only | Open/close | Clock UI; not typed `10:00 – 19:00` as the only hours field |
| L-10 | Map pin | Tap map / Use current location | Lat/lng shown |
| L-11 | Optional docs | Skip photo + gallery, save | Save succeeds |
| L-12 | Gallery photo | Upload chamber image | Appears on member lawyer detail |
| L-13 | First offering required | Fill 1–7, skip 8, submit | Blocked until mode + fee + duration exist |
| L-14 | Submit verification | Fill mandatory including 1.8 + first offering → submit | Status pending admin |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/pending-providers` | New WOMEN_LAWYER listed |
| A-02 | Approve | Approve | Status APPROVED / VERIFIED |
| A-03 | Visibility | Member Legal Help refresh | Lawyer listed |
| A-04 | Unapproved hidden | Lawyer B not approved | Not in Legal Help |
| A-05 | Web login untouched | Open existing website marketplace/provider login | Existing web page still works |

### C. Lawyer ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Finance tab | Open Finance | Payout balance + Request UPI payout |
| O-02 | Consult file | Add notes on a consult | Notes persist on reload |
| O-03 | Accept consult | PENDING → CONFIRMED | Member My Bookings shows Pay |
| O-04 | Payout no UPI | Request payout | Error: add UPI ID |
| O-05 | Payout with UPI | After a paid consult | Success message |
| O-06 | Chat after confirm | Open Chat on CONFIRMED consult | Messages send |

### D. Member browse & book

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | Legal Help entry | Landing → Legal Help | Verified lawyers list |
| M-02 | Filters | City + available today + practice area + sort | List updates; unapproved hidden |
| M-03 | Favourites | Heart on detail; Saved chip | Lawyer appears in saved filter |
| M-04 | Next slot | Detail chips | Next slot or “No slots today” |
| M-05 | Slot picker | Request consult → pick date with no slots | Confirm disabled / no-slots copy |
| M-06 | Book + confirm + pay | Member books → lawyer accepts → Pay | PAID; lawyer payout increases |
| M-07 | Review | Write 5★ review | Shows on detail; rating updates |
| M-08 | Cancel free | Cancel PENDING or CONFIRMED &gt; 2h | CANCELLED |
| M-09 | Cancel blocked | CONFIRMED/PAID inside 2h | Policy error |
| M-10 | Join Us | Open Join Us and Login sheets | Women Lawyer present; Service Partner absent |

### E. Regression / out of scope

| ID | Title | Expected |
|----|--------|----------|
| R-01 | Website logins | Unchanged |
| R-02 | Women Jobs | Separate portal still works; no Providers tab on marketplace |
| R-03 | Legal Help vs Marketplace | Lawyers do not appear on Women Marketplace Workers |

---

## 12. Known limitations this cycle

- FCM reminders are **log-only**. Pass if booking exists; do not fail on missing OS notification.  
- Photos are optional. Bar council ID is required as text.  
- Payout is a **request** (not a live bank transfer).  
- Member pay happens **after** lawyer confirms, not at request time.  
- Website marketplace / provider logins are intentionally unchanged.

---

## 13. Sign-off

| Area | Tester | Date | Result |
|------|--------|------|--------|
| Lawyer onboarding 1–11 (incl. Bar council ID) | | | |
| Admin approve / hide | | | |
| Lawyer consults + Finance | | | |
| Member filters / book / cancel / favourite / review | | | |
| Website logins untouched | | | |
