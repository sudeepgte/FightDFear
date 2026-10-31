# Entrepreneur & Investor Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Entrepreneurship funding (pitches + investor marketplace — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** entrepreneur + investor flows. Do **not** treat website `/entrepreneur` or `/investor` logins, or `/funding` JSPs, as the primary portal for this cycle (existing web pages must remain unchanged).

---

## 1. What this module does

**Entrepreneurs** register on the **mobile app**, complete a numbered 11-section profile (**GST / Udyam / CIN number** required), wait for **admin approval**, then publish pitches, chat with investors, accept meetings, and request UPI payouts on released funds.

**Investors** register on the **mobile app**, complete a numbered 11-section profile (**PAN / SEBI / AIF number** required), wait for **admin approval**, subscribe, browse Market (category / city / sort), express interest (commitment, not live bank transfer), withdraw pending interest, request meetings, chat, and review after admin **releases** funds.

Unapproved entrepreneurs’ pitches **must not** appear on Market. Unapproved investors **cannot** express interest.

Photos/docs are **optional**. Credentials are **typed**, not uploads.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending proposals** (`/admin/pending-proposals`) — entrepreneurs, investors, and pitches |
| Entrepreneur portal | Landing → Login → **Entrepreneur Login** **or** Join Us → **Entrepreneur** |
| Investor portal | Landing → Login → **Investor Login** **or** Join Us → **Investor** |
| Commission | 2% on released funds. Mock-marked paid via entrepreneur `commission/pay` (`type=FUNDING_COMMISSION`). Interest itself is **not** Razorpay. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional**. GST / Udyam / CIN (entrepreneur) and PAN / SEBI / AIF (investor) are **required typed credentials**. |
| Push (FCM) | **Log-only**. Do not fail tests if the phone does not show a system notification. |
| Flyway | Confirm **V35** (`entrepreneur_investor_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V35.
2. flutter run on Android emulator or device.
3. Keep three accounts: Entrepreneur A, Investor I1, Admin (web).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Entrepreneur | Join Us → Entrepreneur | Email OTP required |
| Investor | Join Us → Investor | Email OTP required; Subscribe after approval to interest |
| Admin | Existing web admin | Approves people + pitches at `/admin/pending-proposals` |

Use unique emails each run (e.g. `qa.founder.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Entrepreneur

1. Landing → **Join Us** → **Entrepreneur** → Register.  
2. Landing → **Login** → **Entrepreneur Login**.  
3. Incomplete profile opens **Complete Entrepreneur Profile** (or from dashboard).

Bottom nav: **Home | Proposals | Funding | Profile**. FAB creates a pitch (approved only).

### Investor

1. Landing → **Join Us** → **Investor** → Register.  
2. Landing → **Login** → **Investor Login**.  
3. Incomplete profile opens **Complete Investor Profile**.

Bottom nav: **Home | Market | Portfolio | Profile**. FAB opens Market.

There is **no** public member catalog. Investor Market is the browse hub.

---

## 4. Quick register (both portals)

Same rules as other partner modules.

| # | Field | Rule |
|---|--------|------|
| 1 | Full name | Required |
| 2 | Phone | Required, **exactly 10 digits** |
| 3 | Email | Required, valid email |
| 4 | Send OTP / 6-digit OTP | Required. Auto-verifies at 6 digits |
| 5 | Password | Min 6 chars, **number** + **special character** |
| 6 | Confirm password | Must match |
| 7 | Terms | Must be accepted |

**Expected:** invalid email blocks OTP; 60s resend; wrong OTP fails; duplicate email fails; success lands on Complete Profile.

**Out of scope:** website `/entrepreneur/login`, `/investor/login`, `/funding/*`.

---

## 5. Entrepreneur Complete Profile (numbered 1–11)

Profile % is based on **16** mandatory items. Submit only when **missingItems is empty**. Sections 10–11 optional.

### Required-to-submit checklist

| Missing item | Field |
|--------------|--------|
| 1.1 Full name | Name |
| 1.2 Role | Founder / Co-founder / CEO / … |
| 1.3 Business name | Startup name |
| 1.5 Official phone | 10 digits |
| 1.8 GST / Udyam / CIN number | Typed credential |
| 2.1 Address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Categories | ≥1 FundingCatalog chip |
| 4.1 Who I serve | ≥1 audience |
| 6.1 Open days | ≥1 day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio / pitch |
| 8. First raise | Raise type + funding needed ₹ |

UPI (9.1) is **not** required to submit. It **is** required to withdraw (min ₹100).

### Catalogs

**3.1:** Food, Fashion, Technology, Education, Healthcare, Beauty, Handicrafts, Retail, Services.  
**8.1 Raise type:** Equity, Debt, Grant, Revenue share.

### Save vs Submit

**Save Profile** persists and refreshes %. **Submit for Verification** only when missing is empty → PENDING_ADMIN_APPROVAL.

---

## 6. Investor Complete Profile (numbered 1–11)

Same 16-item bar.

| Missing item | Field |
|--------------|--------|
| 1.1 Full name | Name |
| 1.2 Role | Angel / VC / Family office / … |
| 1.3 Company name | Firm or Independent |
| 1.5 Official phone | 10 digits |
| 1.8 PAN / SEBI / AIF number | Typed credential |
| 2.1–2.5 | Address, city, state, pincode |
| 3.1 Sectors | Same FundingCatalog ≥1 |
| 4.1 Who I fund | Stage chips ≥1 |
| 6.1–6.3 | Meeting days + open/close pickers |
| 7.1 About | Bio |
| 8. Ticket | Cheque type + typical cheque ₹ |

Photos (10–11) optional. UPI optional to submit.

---

## 7. Admin approval

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Pending proposals** (`/admin/pending-proposals`).  
3. Approve **entrepreneur**, **investor**, and each **pitch**.

| Case | Expected |
|------|----------|
| Entrepreneur pending | Pitches never on Market |
| Entrepreneur approved, pitch pending | Pitch not on Market |
| Entrepreneur + pitch approved | Pitch listed |
| Investor pending | Express interest forbidden |
| Investor approved + subscribed | Can interest |
| Reject | Stays off Market / cannot interest |

Admin **Release** on a PENDING investment → COMPLETED, amountRaised increases, entrepreneur **payoutBalance** credited.

---

## 8. Entrepreneur dashboard (after approval)

### Proposals

Create: title *, category chip *, funding needed ₹ > 0, expected monthly income ≥ 0, description. Status PENDING until admin verifies. Edit until cancelled. Cancel if not COMPLETED-released.

Pitch deck PDF/video **optional**.

### Interests file

Notes persist on each interest. Chat after pending interest exists.

### Meetings

Investor requests; entrepreneur Accept / Reject; either side **Cancel** until 2 hours before.

### Funding

Released total, pending interest, payout balance, **Request UPI payout** (fails without UPI; fails if &lt; ₹100). **2% commission** on released rows via Pay commission (`FUNDING_COMMISSION`). Policy copy on screen.

### Profile

Edit opens numbered 1–11.

---

## 9. Investor Market & Portfolio

### Filters

| Filter | Expected |
|--------|----------|
| Category chips | FundingCatalog + All |
| City | Contains match on pitch / founder city |
| Sort: rating | Highest founder rating first |
| Sort: funding | Lowest funding needed first |

Unapproved founders / unverified pitches hidden.

### Pitch card / detail

Category, city, funding needed, raised, remaining, rating, cancel policy. **Express interest** amount &gt; 0 and ≤ remaining. Duplicate PENDING updates amount. Subscribe required.

Interest is a **commitment**, not live Razorpay.

### Portfolio

| Action | When |
|--------|------|
| Withdraw | PENDING only (anytime) |
| Review | COMPLETED and no rating yet (1–5★, once) |
| Chat / Meetings | After interest |

Completed cannot be withdrawn.

---

## 10. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unverified entrepreneurs never appear on Market. |
| BR-02 | Submit requires all numbered mandatory items including typed credential. |
| BR-03 | Documents and gallery optional. Credential is typed. |
| BR-04 | Open/close are time pickers. |
| BR-05 | Interest is not live money. Admin release credits entrepreneur wallet. |
| BR-06 | Pending interest withdraw anytime. Completed locked. |
| BR-07 | Meetings free cancel until **2 hours** before. |
| BR-08 | FCM log-only. |
| BR-09 | 2% commission on released funds (`FUNDING_COMMISSION`). |
| BR-10 | Withdraw requires UPI and balance ≥ ₹100. |
| BR-11 | Website entrepreneur/investor/funding JSPs unchanged. |
| BR-12 | Amount cannot exceed remaining raise. |
| BR-13 | One active PENDING per investor+pitch (update amount). |
| BR-14 | Review only after COMPLETED. |
| BR-15 | Investor must be approved **and** subscribed to interest. |

### Interest status machine

| Actor | From | To |
|-------|------|-----|
| Investor express | — | PENDING |
| Investor | PENDING | WITHDRAWN |
| Admin release | PENDING | COMPLETED (payout credited) |
| Investor review | COMPLETED | rating set (once) |

---

## 11. Suggested test data

**Entrepreneur A (Technology, approved)**  
- Role: Founder  
- GST/Udyam: `UDYAM-MH-12-1234567`  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Categories: Technology, Education  
- Audience: Women, Small business owners  
- Open Mon–Sat 10:00–18:00  
- Raise: Equity, funding needed ₹5,00,000  
- UPI: `qa.founder@upi`  
- Pitch: “LearnLocal” ₹2,00,000 (admin-approve)

**Entrepreneur B (pending)**  
- Complete profile; do **not** approve. Pitch must not list.

**Investor I1**  
- Role: Angel  
- PAN/SEBI: `ABCDE1234F`  
- Ticket: Angel, typical cheque ₹50,000  
- Subscribe after approval  
- Interest on LearnLocal ₹50,000 (&gt;2h meeting) → withdraw allowed  
- After admin release → Review 5★  
- Payout: founder requests ≥ ₹100 with UPI

---

## 12. Test cases

Use Pass / Fail / Blocked.

### A. Entrepreneur onboarding

| ID | Title | Expected |
|----|--------|----------|
| E-01 | Register validation | Field errors; no account |
| E-02 | OTP happy path | Auto-verify; Create Account works |
| E-03 | Complete Profile 1–11 | Numbered form |
| E-04 | GST required | Submit blocked without 1.8 |
| E-05 | Time pickers | Clock UI, not typed hours only |
| E-06 | Optional photos | Save succeeds if skipped |
| E-07 | Submit | PENDING_ADMIN_APPROVAL |

### B. Investor onboarding

| ID | Title | Expected |
|----|--------|----------|
| I-01 | Register + OTP | Same as entrepreneur |
| I-02 | PAN required | Submit blocked without 1.8 |
| I-03 | Ticket required | Blocked without cheque type + ₹ |
| I-04 | Submit | Pending admin |

### C. Admin

| ID | Title | Expected |
|----|--------|----------|
| A-01 | Pending queue | New founder + investor + pitch listed |
| A-02 | Approve founder | Can create pitch |
| A-03 | Approve pitch | Appears on Market |
| A-04 | Unapproved hidden | B not on Market |
| A-05 | Release | PENDING → COMPLETED; founder wallet up |
| A-06 | Web logins untouched | `/entrepreneur/login` and `/investor/login` still work |

### D. Ops

| ID | Title | Expected |
|----|--------|----------|
| O-01 | Create pitch | Pending admin |
| O-02 | Interest + chat | Messages send |
| O-03 | Meeting accept/cancel | 2h policy |
| O-04 | Payout no UPI | Error |
| O-05 | Payout with UPI ≥ ₹100 | Success |
| O-06 | Commission pay | 2% marked paid |

### E. Investor Market

| ID | Title | Expected |
|----|--------|----------|
| M-01 | Filters | City + category + sort; unapproved hidden |
| M-02 | Interest cap | Over remaining rejected |
| M-03 | Duplicate PENDING | Amount updates |
| M-04 | Withdraw pending | WITHDRAWN |
| M-05 | Withdraw completed | Policy error |
| M-06 | Review | Once after COMPLETED |
| M-07 | Subscribe gate | Interest blocked until subscribe |
| M-08 | Join Us | Entrepreneur + Investor present |

### F. Regression

| ID | Title | Expected |
|----|--------|----------|
| R-01 | Website JSPs | Unchanged |
| R-02 | Other modules | Doctor / Glow / Jobs / Lawyer / Products / Financial still work |

---

## 13. Known limitations this cycle

- FCM is **log-only**.  
- Photos optional. Credentials required as text.  
- Investment interest is a **commitment**; admin releases funds.  
- Payout is a **request**, not a live bank transfer.  
- Commission mock-pay is via entrepreneur API (`FUNDING_COMMISSION`), not member Razorpay User session.  
- Website entrepreneur/investor/funding pages are intentionally unchanged.

---

## 14. Sign-off

| Area | Tester | Date | Result |
|------|--------|------|--------|
| Entrepreneur onboarding 1–11 (GST / Udyam / CIN) | | | |
| Investor onboarding 1–11 (PAN / SEBI / AIF) | | | |
| Admin approve people + pitches + release | | | |
| Market filters / interest / withdraw / review | | | |
| Funding payout + 2% commission | | | |
| Website logins untouched | | | |
