# Women Events Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Women Events (host portal + member hub — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for host + event approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** event-host + member flows. Do **not** treat website `/women-events/host/login` or women-events JSPs as the primary portal for this cycle (existing web pages must remain unchanged).

---

## 1. What this module does

**Event hosts** register on the **mobile app**, complete a numbered 11-section profile (**GST / NGO / CIN number** required), wait for **admin approval**, then create events (submitted for admin approval), check in attendees, and request UPI payouts on paid tickets.

Logged-in **members** browse **Women Events**: category / city / sort, register, pay when fee &gt; ₹0 (`type=WOMEN_EVENT`), cancel under policy, and review after attending or after start time.

Unapproved hosts’ events **must not** appear in the member hub. Events stay hidden until status is **APPROVED**.

Fee **₹0 = free**. Otherwise Razorpay / mock pay. Photos/docs are **optional**. Credential is **typed**, not an upload. UPI is required only to withdraw.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending event hosts** (`/admin/pending-event-hosts`) and pending women events |
| Member browse | App landing → **Women Events** (member login required) |
| Host portal | App landing → Login sheet → **Event Host Login** **or** Join Us → **Event Host** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Paid tickets complete without a real Razorpay card. Type = `WOMEN_EVENT`. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional**. **GST / NGO / CIN number is required** (typed credential, not an upload). |
| Push (FCM) | Hooked in backend; **log-only**. Do not fail tests if the phone does not show a system notification. |
| Flyway | Confirm **V36** (`events_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V36.
2. flutter run on Android emulator or device.
3. Keep two app accounts ready: one Member, one Event Host (or two devices / two emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Event host | Join Us → Event Host | Email OTP required |
| Member | Normal user register / login | Browses Women Events hub |
| Admin | Existing web admin | Approves hosts at `/admin/pending-event-hosts` and events |

Use unique emails each run (e.g. `qa.host.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Event host

1. Landing → **Join Us** → **Event Host** → Register.  
2. Landing → **Login** → **Event Host Login**.  
3. Incomplete profile opens **Complete Host Profile** (or from dashboard).

Bottom nav: **Home | Events | Attendees | Profile** (Finance / payout lives on Profile). FAB creates an event (approved hosts only).

### Member

1. Landing → **Women Events**.  
2. Tabs: **Events | My Tickets**.  
3. Filters: category chips, city, Newest / Top rated.

Website host login JSPs are **out of scope**. Do not regress them; do not use them as the test portal.

---

## 4. Host Complete Profile (1–11)

All numbered sections must be present. Submit is blocked until required items are filled.

| # | Section | Required | Notes |
|---|---------|----------|-------|
| 1 | Host identity | Yes | 1.1 Full name, 1.2 Organizer type, 1.3 Organizer name, 1.5 10-digit phone, **1.8 GST / NGO / CIN number** |
| 2 | Location | Yes | 2.1 Address, 2.3 City, 2.4 State, 2.5 6-digit pincode. Map pin optional |
| 3 | Event categories | Yes | At least one Women Events category |
| 4 | Who I serve | Yes | Audience chips. Door / on-site optional |
| 5 | Facilities | Optional | Venue amenities |
| 6 | Hours & calendar | Yes | Open days, open time, close time. Break / blocked dates optional |
| 7 | About | Yes | Host bio |
| 8 | Typical event offering | Yes | Event mode (Offline / Online / Hybrid) + typical ticket (₹0 allowed) |
| 9 | Finance / UPI | Optional for submit | UPI required **only to withdraw** |
| 10 | Documents | Optional | Profile photo |
| 11 | Event photos | Optional | Gallery |

**Completion %** is based on 16 required items. Missing chips show on the profile card.

**Save** stores draft. **Submit for Verification** only when `canSubmitForVerification` is true.

---

## 5. Host lifecycle

| Status | What tester sees |
|--------|------------------|
| PROFILE_INCOMPLETE | Complete Profile required |
| READY_FOR_VERIFICATION | Submit enabled |
| PENDING_ADMIN_APPROVAL | Waiting; cannot create public events |
| APPROVED / VERIFIED | Can create events |
| CHANGES_REQUESTED / REJECTED | Update + resubmit |
| SUSPENDED | Login blocked |

Admin queue: `/admin/pending-event-hosts`.

Created events start as **PENDING** until admin approves the event itself. Unapproved events must not appear in the member hub.

---

## 6. Host dashboard

| Tab | Checks |
|-----|--------|
| Home | Status badge, completion CTA, totals |
| Events | List / create / edit / cancel. Create blocked until host approved. Cancel host event only until **2 hours before start** |
| Attendees | Select event, ticket check-in, tap attendee to save notes |
| Profile | Payout balance, Request UPI payout (min ₹100 + UPI ID), edit profile, logout |

**Create event:** name, category, date, venue, city required. `entryFee` 0 = free. Event goes to admin pending.

**Check-in:** paid tickets only (if fee &gt; 0). Sets status **ATTENDED**. Cannot check in cancelled tickets.

---

## 7. Member hub

| Check | Expected |
|-------|----------|
| Unapproved host / pending event | Hidden |
| Category chips | Filter by Women Event category |
| City | Substring match |
| Newest / Top rated | Sort |
| Free event | Register without pay |
| Paid event | Register → pay from detail or My Tickets (`type=WOMEN_EVENT`) |
| Capacity | Full when seats taken |
| Already registered | CTA “View ticket” or “Complete payment” |

---

## 8. Pay, cancel, reviews, payout

### Pay

- Fee ₹0 → `paid=true` immediately.  
- Fee &gt; 0 → Razorpay / mock `type=WOMEN_EVENT` + `registrationId`.  
- On verify, host **payout balance** increases by amount paid.

### Cancel (member)

Policy text:

> Unpaid tickets can be cancelled anytime. Paid tickets can be cancelled until 2 hours before start. Checked-in tickets cannot be cancelled.

| Case | Allowed? |
|------|----------|
| Unpaid, not checked in | Yes, anytime |
| Paid, ≥ 2 hours before start | Yes |
| Paid, &lt; 2 hours before start | No |
| Checked in / ATTENDED | No |
| Already CANCELLED | No |

### Reviews

Member can rate after **ATTENDED / checked-in** or after event start time. One review per user per event. Host rating rolls up for Top rated sort.

### Payout

- Min **₹100**.  
- UPI ID required.  
- Request from Profile → **Request UPI payout**.

---

## 9. API smoke (optional)

| Method | Path | Notes |
|--------|------|-------|
| PUT | `/api/women-events/host/profile` | Extra fields + completion |
| POST | `/api/women-events/host/submit-verification` | Ready only |
| POST | `/api/women-events/host/events` | Approved host |
| POST | `/api/women-events/host/payout/request` | Min ₹100 |
| GET | `/api/women-events?category=&city=&sort=` | Member list |
| POST | `/api/women-events/{id}/register` | Seat + ticket |
| POST | `/api/women-events/registrations/{id}/cancel` | 2h policy |
| POST | `/api/women-events/registrations/{id}/rate` | After attend / start |
| POST | `/payment/verify` | `type=WOMEN_EVENT` |

---

## 10. Regression (must not break)

- Website `/women-events` JSPs and `/women-events/host/login` unchanged.  
- Other modules (Doctor, Glow, Jobs, Lawyer, Products, Financial, Entrepreneur/Investor) still compile.  
- Admin pending-event-hosts still works.  
- Mock payment still works when `PAYMENT_MOCK=true`.

---

## 11. Suggested test run (happy path)

1. Register host with OTP.  
2. Fill Complete Profile 1–11 including GST/NGO/CIN. Submit.  
3. Admin approves host.  
4. Host creates a **₹0** event and a **₹199** event.  
5. Admin approves both events.  
6. Member sees both in hub; unapproved host’s events never appear.  
7. Member registers free event → ticket in My Tickets, no pay.  
8. Member registers paid event → Pay now → mock success → ticket paid; host payout balance +199.  
9. Cancel unpaid anytime. Cancel paid only until 2h before. Check-in locks cancel.  
10. Host checks in paid ticket. Member can review.  
11. Host requests payout after balance ≥ 100 with UPI set.  
12. Sort Top rated after a review.

---

## 12. Fail conditions (file bugs)

- Submit allowed without GST / NGO / CIN.  
- Unapproved host events visible to members.  
- ₹0 event asks for Razorpay.  
- Paid cancel allowed after 2h or after check-in.  
- Payout under ₹100 or without UPI succeeds.  
- Website host JSP login/register changed.  
- Flyway V36 missing columns (`credential_number`, `payout_balance`, `payout_credited`).

---

## 13. Out of scope

- Live bank settlement of UPI payout (request is recorded).  
- FCM device delivery.  
- Website member/host JSP redesign.  
- Changing admin JSP layout (queue URLs stay).
