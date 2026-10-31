# Fitness & Wellness Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Trainer + Fitness & Wellness (trainer portal + member hub — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for trainer approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** trainer + member flows. Do **not** treat website `/fitness*` JSPs as the primary portal for this cycle (existing web pages must remain unchanged).

---

## 1. What this module does

**Fitness trainers** register on the **mobile app**, complete a numbered 11-section profile (**ACE / NASM / Yoga Alliance / cert number** required), wait for **admin approval**, then accept session bookings and request UPI payouts on paid sessions.

Logged-in **members** browse **Fitness & Wellness**: category / city / sort, book a trainer, pay when fee &gt; ₹0 (`type=FITNESS`), cancel under policy, and review after the session is **COMPLETED**.

Unapproved trainers **must not** appear in the member hub.

Fee **₹0 = free**. Otherwise Razorpay / mock pay. Photos/docs are **optional**. Credential is **typed**, not an upload. UPI is required only to withdraw.

Landing **Fitness** tile opens Fitness & Wellness (not Martial Arts).

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending trainers** (`/admin/pending-trainers`) |
| Member browse | App landing → **Fitness** tile **or** dashboard **Fitness & Wellness** (member login required) |
| Trainer portal | App landing → Login sheet → **Fitness Trainer Login** **or** Join Us → **Fitness Trainer** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Type = `FITNESS` |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional**. **ACE / NASM / Yoga Alliance / cert number is required** (typed, not an upload). |
| Push (FCM) | **Log-only**. Do not fail tests if the phone does not show a system notification. |
| Flyway | Confirm **V38** (`fitness_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V38.
2. flutter run on Android emulator or device.
3. Keep two app accounts: one Member, one Fitness Trainer.
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Trainer | Join Us → Fitness Trainer | Email OTP required |
| Member | Normal user register / login | Browses Fitness & Wellness |
| Admin | Existing web admin | Approves at `/admin/pending-trainers` |

Use unique emails each run (e.g. `qa.trainer.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Trainer

1. Landing → **Join Us** → **Fitness Trainer** → Register.  
2. Landing → **Login** → **Fitness Trainer Login**.  
3. Incomplete profile opens **Complete Trainer Profile** (or from dashboard).

Bottom nav: **Home | Bookings | Earnings | Profile**. Finance / payout lives on **Earnings**.

### Member

1. Landing → **Fitness** (Tips & categories) → Fitness & Wellness.  
2. User dashboard → **Fitness & Wellness**.  
3. Tabs: **Browse Trainers | My Bookings**.  
4. Filters: category chips, city, sort (rating / price / experience).

Website fitness JSPs are **out of scope**. Do not regress them; do not use them as the test portal.

---

## 4. Trainer Complete Profile (1–11)

All numbered sections must be present. Submit is blocked until required items are filled.

| # | Section | Required | Notes |
|---|---------|----------|-------|
| 1 | Trainer identity | Yes | 1.1 Full name, 1.2 Designation, 1.5 10-digit phone, 1.7 Years of experience, **1.8 ACE / NASM / Yoga Alliance / cert number** |
| 2 | Location | Yes | 2.1 Address, 2.3 City, 2.4 State, 2.5 6-digit pincode. Map pin optional |
| 3 | Specializations | Yes | At least one fitness category |
| 4 | Who I serve | Yes | Audience chips. Home / doorstep optional |
| 5 | Facilities | Optional | Studio amenities |
| 6 | Hours & calendar | Yes | Open days, open time, close time. Break / blocked dates optional |
| 7 | About | Yes | Trainer bio |
| 8 | Typical session | Yes | Session mode (Offline / Online / Hybrid) + typical fee (₹0 allowed) |
| 9 | Finance / UPI | Optional for submit | UPI required **only to withdraw** |
| 10 | Documents | Optional | Profile photo, certificate scan |
| 11 | Studio photos | Optional | Gallery |

**Completion %** is based on 16 required items. Missing chips show on the profile card.

**Save** stores draft. **Submit for Verification** only when `canSubmitForVerification` is true.

---

## 5. Trainer lifecycle

| Status | What tester sees |
|--------|------------------|
| PROFILE_INCOMPLETE | Complete Profile required |
| READY_FOR_VERIFICATION | Submit enabled |
| PENDING_ADMIN_APPROVAL | Waiting; hidden from member hub |
| APPROVED / VERIFIED | Visible in Fitness & Wellness |
| CHANGES_REQUESTED / REJECTED | Update + resubmit |
| SUSPENDED | Login blocked / hidden from hub |

Admin queue: `/admin/pending-trainers`.

Unapproved trainers must not appear in the member hub.

---

## 6. Trainer dashboard

| Tab | Checks |
|-----|--------|
| Home | Status badge, completion CTA, totals, online toggle |
| Bookings | PENDING / APPROVED / REJECTED / COMPLETED / CANCELLED. Trainer can update status. Notes optional |
| Earnings | Wallet / payout balance, **Request payout (min ₹100)** |
| Profile | Required details, Complete Profile |

Create class / messages remain “coming soon” if shown — not in this wrap.

---

## 7. Member hub

| Check | Expected |
|-------|----------|
| Unapproved / suspended trainer | Hidden |
| Category chips | Yoga, HIIT, Zumba, Strength, Personal, Pilates, CrossFit |
| City | Substring match (Filters sheet) |
| Sort | Top rated / Price low–high / Price high–low / Experience |
| Available only | Hides offline trainers |
| Book | Date + slot + package (single / monthly / …) |
| Free session (₹0) | Booking with `paymentStatus=NOT_REQUIRED`, no Razorpay |
| Paid session | Pay now from My Bookings (`type=FITNESS`) |

Landing **Fitness** must open this hub, **not** Martial Arts / Self Defence.

---

## 8. Pay, cancel, reviews, payout

### Pay

- Fee ₹0 → `paymentStatus=NOT_REQUIRED`. No checkout.  
- Fee &gt; 0 → Razorpay / mock `type=FITNESS` + `bookingId`.  
- On verify, trainer **payout balance** increases by amount paid.

### Cancel (member)

Policy text:

> Pending unpaid bookings can be cancelled anytime. Paid sessions can be cancelled until 2 hours before start. Completed sessions cannot be cancelled.

| Case | Allowed? |
|------|----------|
| PENDING and not PAID | Yes, anytime |
| PAID / APPROVED, ≥ 2 hours before session start | Yes |
| PAID, &lt; 2 hours before start | No |
| COMPLETED | No |
| REJECTED / already CANCELLED | No |

### Reviews

Member can rate after trainer marks booking **COMPLETED**. One review per booking. Trainer rating + review count roll up for Top rated sort.

### Payout

- Min **₹100**.  
- UPI ID required.  
- Request from Earnings → **Request payout (min ₹100)**.

---

## 9. API smoke (optional)

| Method | Path | Notes |
|--------|------|-------|
| PUT | `/api/fitness/trainer/profile` | Extra fields + completion |
| POST | `/api/fitness/trainer/submit-verification` | Ready only |
| POST | `/api/fitness/trainer/photos` | Optional profile / gallery / certificate |
| POST | `/api/fitness/trainer/payout/request` | Min ₹100 |
| POST | `/api/fitness/trainer/bookings/{id}/status` | PENDING / APPROVED / REJECTED / COMPLETED / CANCELLED |
| GET | `/api/fitness/trainers?city=&sort=` | Approved only |
| POST | `/api/fitness/trainers/{id}/bookings` | Creates PENDING |
| POST | `/api/fitness/bookings/{id}/cancel` | 2h policy |
| POST | `/api/fitness/bookings/{id}/review` | After COMPLETED |
| POST | `/payment/verify` | `type=FITNESS` |

---

## 10. Regression (must not break)

- Website `/fitness*` JSPs and trainer web portal unchanged.  
- Landing **Self Defence / Martial Arts** still opens Martial Arts (only the Fitness tile was rewired).  
- Other wrapped modules still compile.  
- Admin `/admin/pending-trainers` still works.  
- Mock payment still works when `PAYMENT_MOCK=true`.

---

## 11. Suggested test run (happy path)

1. Register trainer with OTP.  
2. Fill Complete Profile 1–11 including ACE/NASM/Yoga Alliance cert number. Submit.  
3. Confirm trainer is **hidden** from member hub until admin approves.  
4. Admin approves at `/admin/pending-trainers`.  
5. Member sees trainer in Fitness & Wellness; filter by city and sort by rating.  
6. Book a **₹0** session → My Bookings, no Pay now.  
7. Book a **₹300** session → Pay now → mock success → `PAID`; trainer wallet +300.  
8. Cancel unpaid pending anytime. Cancel paid only until 2h before. COMPLETED locked.  
9. Trainer marks session COMPLETED. Member rates. Top rated updates.  
10. Trainer requests payout after balance ≥ 100 with UPI set.  
11. Landing **Fitness** tile opens Fitness & Wellness, not Martial Arts.

---

## 12. Fail conditions (file bugs)

- Submit allowed without ACE / NASM / Yoga Alliance / cert number.  
- Unapproved trainer visible to members.  
- ₹0 session asks for Razorpay.  
- Paid cancel allowed after 2h or after COMPLETED.  
- Payout under ₹100 or without UPI succeeds.  
- Landing Fitness opens Martial Arts.  
- Website fitness JSP login/register changed.  
- Flyway V38 missing columns (`credential_number`, `payout_balance`, `payout_credited`).

---

## 13. Out of scope

- Live bank settlement of UPI payout (request is recorded).  
- FCM device delivery.  
- Website fitness JSP redesign.  
- Changing admin JSP layout (queue URL stays `/admin/pending-trainers`).  
- User / SOS / Danger Map / Contacts (not part of Join Us partner wraps).
