# Financial Literacy Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Financial Literacy (videos, live sessions, workshops, loans — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for educator approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** educator + member flows. Do **not** treat website `/financial-literacy` logins or JSP admin content pages as the primary portal for this cycle (existing web pages must remain unchanged).

---

## 1. What this module does

**Financial educators** register on the **mobile app**, complete a numbered 11-section profile (NISM / SEBI / IRDAI / CFP number is required), wait for **admin approval**, then publish videos, live sessions and workshops, manage signups, and request UPI payouts.

Logged-in **members** browse **Financial Literacy**: free videos, live sessions and workshops (fee ₹0 = free; otherwise Razorpay / mock pay with `type=FINANCIAL_BOOKING`), filter by category / city / sort, register, pay, cancel under the 2-hour policy, review completed sessions, and apply for loans.

Unapproved educators’ content **must not** appear in the member hub.

Videos are always **free**. Live / workshop fee is set when the educator publishes.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Educator Approvals** (`/admin/pending-educators`) |
| Member browse | App landing → **Financial Literacy** (member login required) |
| Educator portal | App landing → Login sheet → **Financial Educator Login** **or** Join Us → **Financial Educator** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid live/workshop enrollments complete without a real Razorpay card. Type = `FINANCIAL_BOOKING`. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo uploads). **NISM / SEBI / IRDAI / CFP number is required** (typed credential, not an upload). |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check enrollment state instead. |
| Flyway | Confirm **V34** (`financial_literacy_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V34.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Financial Educator (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (learner) | App Join Us → Member / existing user register | Required to browse Financial Literacy |
| Educator | App Join Us → Financial Educator | Email OTP required |
| Admin | Existing web admin | Approves educators at `/admin/pending-educators` |

Use unique emails each run (e.g. `qa.educator.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Educator

1. Landing → **Join Us** → **Financial Educator** → Register.  
2. Landing → **Login** → **Financial Educator Login**.  
3. After login, if profile is incomplete, **Complete Educator Profile** opens (or from the dashboard completion card).

### Member

1. Landing → **Financial Literacy** (login wall if guest).  
2. Member dashboard → Financial Literacy catalog.  
3. Screen tabs: **Videos | Live | Workshops | My bookings | Loans**.  
4. Filters (Videos / Live / Workshops): expertise chips, city, sort (rating / fee).

---

## 4. Educator registration (quick register)

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
| Success | Account created; educator logs in; **Complete Educator Profile** is available |

**Negative:** Duplicate email should fail with a clear API error.

**OTP troubleshooting:** Check the mailbox (and spam). If SMTP is down, check Spring Boot console for send failure. Testers should not be blocked on photos, but they **are** blocked without a valid OTP **and** without a NISM / SEBI / IRDAI / CFP number on Complete Profile.

**Out of scope:** Do not test or “fix” website `/financial-literacy` logins or JSP add-video / add-live pages. Mobile Financial Educator portal is the source of truth this cycle. Website admin **Educator Approvals** (`/admin/pending-educators`) **is** in scope.

---

## 5. Educator Complete Profile (numbered UX — 11 sections)

After login, incomplete educators land on Complete Profile. Profile % is based on **15** mandatory items. Submit is enabled only when **missingItems is empty**.

Documents (10) and studio photos (11) are **optional**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Full name | Name |
| 1.2 Role | Designation |
| 1.5 Official phone | 10-digit phone |
| 1.8 NISM / SEBI / IRDAI / CFP number | Enrolment / registration number (typed, not upload) |
| 2.1 Address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Expertise | At least one FinancialCatalog area |
| 4.1 Who I serve | At least one audience |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio |
| 8. First offering | Session mode + duration + typical fee |

UPI (9.1) is **not** required to submit. It **is** required to withdraw from Finance.

### 1. Educator identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Full name | Text | Yes |
| 1.2 | Designation | Dropdown: Certified educator, SEBI RIA, NISM certified, Banker, Insurance advisor, CFP, Other | Yes |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Years of experience | Number 0–60 | No |
| 1.8 | NISM / SEBI / IRDAI / CFP number | Text (enrolment / registration number) | **Yes** |

### 2. Location

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 2.1 | Address | Text | Yes |
| 2.3 | City | Text | Yes |
| 2.4 | State | Dropdown (+ Other) | Yes |
| 2.5 | Pincode | 6 digits | Yes |
| 2.6 | Google Maps link | Text | No |
| 2.7 | Pin studio on map | Tap map **or** Use current location | No |

There is **no** single free-text hours box as the only availability field. City, state, and pincode are separate.

### 3. Expertise

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Expertise | Multi-select chips from FinancialCatalog | Yes (at least one) |

**Catalog:** Saving, Investing, Loans, Banking, Insurance, Government Schemes.

### 4. Who I serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips: Women, Families, First-time investors, Working professionals, Students, Small business owners | Yes (at least one) |
| 4.2 | In-person / vernacular workshops | Toggle | No |

### 5. Facilities

Optional chips: Video studio, In-person workshop, Vernacular sessions, 1:1 coaching, UPI / card, Notes PDF.

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

### 8. First session offering

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Session mode | Live / Workshop / 1:1 | Yes |
| 8.2 | Duration | Picker: 30 / 45 / 60 / 90 / 120 min | Yes |
| 8.3 | Buffer | 0 / 5 / 10 / 15 / 20 / 30 min | No |
| 8.4 | Typical fee (₹, 0 = free) | Number | Yes |

### 9. Finance / UPI

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 9.1 | UPI ID | Text (`name@upi`) | No to submit; **Yes to withdraw** |
| 9.2 | Bank details | Text | No |

Earnings stay in the educator wallet until Finance → Request UPI payout. Minimum payout **₹100**.

### 10. Documents (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 10.1 | Profile photo | Image upload | No |

### 11. Studio photos (optional)

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 11.1 | Gallery photo | Image upload | No |

Skip is allowed.

### Save vs Submit

| Action | Behaviour |
|--------|-----------|
| **Save Profile** | Persists fields; refreshes % and missing chips |
| **Submit for Verification** | Enabled only when missingItems is empty. Status → PENDING_ADMIN_APPROVAL |

**Skip for now** is not a substitute for required fields. Testers must fill 1–8 (including **1.8 NISM / SEBI / IRDAI / CFP number**) to submit.

---

## 6. Admin approval

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Educator Approvals** (`/admin/pending-educators`).  
3. Find the new educator.  
4. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Educator content **not** listed in member Financial Literacy |
| Approved (VERIFIED) | Educator **is** listed; videos / live / workshops they publish are visible |
| Reject | Educator stays off the hub; educator sees Rejected on dashboard |

Do **not** use website `/financial-literacy` educator login for this cycle.

---

## 7. Educator dashboard (after approval)

Bottom nav: **Home | Content | Signups | Finance**.

### Home

Stats: videos, live, workshops, pending signups. Complete-profile card until verified.

### Content

Published videos, live sessions, workshops. FAB **+** to add:

| Kind | Required | Fee |
|------|----------|-----|
| Video | Title + YouTube URL | Always free |
| Live session | Title, date, time, meeting URL, seats | Fee (₹, **0 = free**) + category |
| Workshop | Title, venue, city, date, time, seats | Fee (₹, **0 = free**) + category |

Unapproved educators cannot publish (gated). After publish, content appears in the member hub **only if the educator is approved**.

### Signups (enrollment file)

| Action | From status | To |
|--------|-------------|-----|
| Accept / Reject | pending **or** paid | approved / rejected |
| Complete | approved **or** paid | completed |
| Notes | Any | Internal `coachNotes` saved |

Each row shows learner name, session title, status, educator notes. **Notes** is the session history file.

### Finance

| Field | Expected |
|-------|----------|
| Payout balance | Credits when a member **pays** a live/workshop enrollment (`type=FINANCIAL_BOOKING`) |
| Confirmed earnings | Sum of paid enrollments |
| Request UPI payout | Fails without UPI; fails if balance &lt; ₹100; succeeds with UPI + ≥ ₹100 |
| Edit educator profile | Opens the numbered 11-section form |

Free enrollments (fee ₹0) do **not** credit payout.

---

## 8. Member browse, register & pay

### Financial Literacy hub

Cards show title, host, date/time, seats left, **fee** when &gt; 0.

**Filters (Videos / Live / Workshops):**

| Filter | Expected |
|--------|----------|
| Expertise chips | Saving, Investing, Loans, Banking, Insurance, Government Schemes |
| City | Contains match on educator / workshop city |
| Sort: rating | Highest educator rating first |
| Sort: fee | Lowest fee first (videos always ₹0) |

Unapproved educators’ content must **not** appear.

### Session / workshop detail

| Item | Expected |
|------|----------|
| Title, host, date/time, city/venue | Present when data exists |
| Seats left | Shown for live / workshop |
| Fee | Shown when &gt; 0 |
| Cancel policy | “Free cancellation until 2 hours before the session…” |
| Video | **Watch** opens YouTube (no pay) |
| Live / workshop | **Register** then Pay if fee &gt; 0 |

### Register (live / workshop)

1. Open a published live session or workshop from an **approved** educator.  
2. Tap **Register**.  
3. If fee is **₹0**: enrollment is FREE; waiting for educator confirmation.  
4. If fee **&gt; 0**: `paymentRequired=true`; mock / Razorpay checkout opens (`type=FINANCIAL_BOOKING`, `registrationId` / `targetId` = enrollment id).  
5. After pay: status `paid`, `paymentStatus=PAID`, educator payout credited.

| Negative | Expected |
|----------|----------|
| No seats left | “No seats left” |
| Already registered (pending / paid / approved) | “You already registered…” |
| Unapproved educator content | Not listed / not found |

### My bookings

| Action | When |
|--------|------|
| **Pay** | `needsPayment` (fee &gt; 0 and not PAID / cancelled / rejected) |
| **Review** | Status `completed` and no rating yet |
| **Cancel** | `canCancel` (see business rules) |

### Loans

Loans tab: list existing applications; **Apply for a loan** (type, amount, purpose). This is an application, not a payout.

---

## 9. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unverified educators never appear in member Financial Literacy (their videos / live / workshops stay hidden). |
| BR-02 | Submit verification requires all numbered mandatory items including NISM / SEBI / IRDAI / CFP number and first offering. |
| BR-03 | Documents and gallery are optional. Credential is a typed number, not an upload. |
| BR-04 | Open/close times are pickers, not a typed `10:00 – 19:00` hours string as the only input. |
| BR-05 | Videos are always free. Live / workshop fee ₹0 = free; otherwise pay with `FINANCIAL_BOOKING`. |
| BR-06 | Free cancel until **2 hours** before session start. After that, approved/paid enrollments cannot be cancelled by the member. |
| BR-07 | Pending enrollments can still be cancelled by the member (even inside 2 hours). |
| BR-08 | Registration notify is FCM log-only. |
| BR-09 | Paid live/workshop enrollments credit `FinancialEducator.payoutBalance`. |
| BR-10 | Withdraw requires UPI ID and balance ≥ ₹100. |
| BR-11 | Website `/financial-literacy` JSPs and website logins are out of scope and must not be changed. |
| BR-12 | Duplicate active registration for the same live/workshop is rejected. |
| BR-13 | Seats count pending + approved + paid (cancelled / rejected / completed do not hold a seat). |
| BR-14 | Review is allowed only after educator marks the enrollment **completed**. |
| BR-15 | Educator payout is **not** credited on free (₹0) enrollments. |

### Enrollment status machine

| Actor | From | To |
|-------|------|-----|
| Member register | — | pending (`paymentStatus` PENDING if fee &gt; 0, else FREE) |
| Member pay | pending | paid (`paymentStatus` PAID; educator wallet credited) |
| Educator | pending or paid | approved / rejected |
| Educator | approved or paid | completed |
| Member | pending | cancelled (always, if not already cancelled) |
| Member | approved / paid | cancelled only if ≥ 2 hours before start |

---

## 10. Suggested test data

**Educator A (Investing, approved)**  
- Designation: NISM certified  
- Credential: `NISM-123456`  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Expertise: Investing, Saving  
- Audience: Women, First-time investors  
- Open Mon–Sat 10:00–18:00, break 13:00–14:00  
- Offering: Live, 60 min, buffer 10, typical fee ₹500  
- UPI: `qa.educator@upi`  
- Publish: 1 free YouTube video; 1 live session fee ₹200; 1 workshop fee ₹0

**Educator B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve. Publish a video anyway (if gated, confirm publish is blocked). Content must not appear in member hub.

**Member M1**  
- Watch a free video.  
- Register a ₹0 workshop (no pay).  
- Register a paid live session &gt; 2 hours away → Pay (mock) → cancel (allowed).  
- Register another paid session &lt; 2 hours away after pay (cancel → blocked).  
- After educator completes a session → Review 5★.

---

## 11. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Educator onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| E-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| E-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| E-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| E-04 | Login existing educator | Email + password | Dashboard or Complete Profile |
| E-05 | Complete Profile opens | New educator | Numbered 1–11 form |
| E-06 | Profile mandatory | Save with empty 1.1 / 1.8 / 2.5 / 3.1 / 6.2 / 7.1 / no offering | Numbered error (e.g. `1.8 NISM / SEBI / IRDAI / CFP number is required`) |
| E-07 | Credential required | Fill everything except 1.8, submit | Blocked; missing `1.8 NISM / SEBI / IRDAI / CFP number` |
| E-08 | Location split | City / state / pincode / map pin | All save; listing shows city |
| E-09 | Time picker only | Open/close | Clock UI; not typed `10:00 – 19:00` as the only hours field |
| E-10 | Map pin | Tap map / Use current location | Lat/lng shown |
| E-11 | Optional docs | Skip photo + gallery, save | Save succeeds |
| E-12 | Gallery photo | Upload studio image | Save succeeds (member hub does not require photos) |
| E-13 | First offering required | Fill 1–7, skip 8, submit | Blocked until mode + duration + fee exist |
| E-14 | Submit verification | Fill mandatory including 1.8 + first offering → submit | Status pending admin |

### B. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Pending queue | Open `/admin/pending-educators` | New educator listed |
| A-02 | Approve | Approve | Status APPROVED / VERIFIED |
| A-03 | Visibility | Member Financial Literacy refresh | Educator’s published content listed |
| A-04 | Unapproved hidden | Educator B not approved | Content not in hub |
| A-05 | Web login untouched | Open existing website `/financial-literacy` pages | Existing web pages still work |

### C. Educator ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Finance tab | Open Finance | Payout balance + Request UPI payout |
| O-02 | Signup file | Add notes on a registration | Notes persist on reload |
| O-03 | Accept signup | pending → approved | Member My bookings updates |
| O-04 | Publish video | Add YouTube video | Appears in member Videos (after approval) |
| O-05 | Publish paid live | Fee ₹200 | Member sees fee; Pay after register |
| O-06 | Publish free workshop | Fee ₹0 | Member registers with no Pay |
| O-07 | Payout no UPI | Request payout | Error: add UPI ID |
| O-08 | Payout with UPI | After a paid enrollment, balance ≥ ₹100 | Success message |
| O-09 | Complete session | paid/approved → completed | Member can Review |

### D. Member browse & book

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | Hub entry | Landing → Financial Literacy | Videos / live / workshops of approved educators |
| M-02 | Filters | City + expertise chip + sort rating/fee | List updates; unapproved hidden |
| M-03 | Free video | Open video → Watch | Opens URL; no payment |
| M-04 | Free workshop | Register fee ₹0 | FREE; no Pay button |
| M-05 | Paid live | Register fee &gt; 0 → Pay | `FINANCIAL_BOOKING`; PAID; educator payout increases |
| M-06 | Duplicate register | Register same session again | Error: already registered |
| M-07 | Review | After completed | 5★ review accepted; second review blocked |
| M-08 | Cancel free | Cancel pending (any time) | cancelled |
| M-09 | Cancel blocked | paid/approved inside 2h | Policy error |
| M-10 | Loans | Apply Personal loan | Application listed |
| M-11 | Join Us | Open Join Us and Login sheets | Financial Educator present |

### E. Regression / out of scope

| ID | Title | Expected |
|----|--------|----------|
| R-01 | Website `/financial-literacy` JSPs | Unchanged |
| R-02 | Website logins | Unchanged |
| R-03 | Other modules | Doctor / Glow / Jobs / Lawyer / Products still work |

---

## 12. Known limitations this cycle

- FCM notifications are **log-only**. Pass if enrollment exists; do not fail on missing OS notification.  
- Photos are optional. NISM / SEBI / IRDAI / CFP number is required as text.  
- Payout is a **request** (not a live bank transfer).  
- Videos stay free; only live / workshop can be paid.  
- Website `/financial-literacy` pages and website logins are intentionally unchanged.

---

## 13. Sign-off

| Area | Tester | Date | Result |
|------|--------|------|--------|
| Educator onboarding 1–11 (incl. NISM / SEBI / IRDAI / CFP number) | | | |
| Admin approve / hide (`/admin/pending-educators`) | | | |
| Educator content + Signups + Finance | | | |
| Member filters / register / pay / cancel / review / loans | | | |
| Website `/financial-literacy` JSPs untouched | | | |
