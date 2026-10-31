# Creator Hub Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Creator Hub (studio + member feed — mobile-first)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for creator approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** creator + member flows. Do **not** treat website creator JSPs as the primary portal for this cycle (existing web pages must remain unchanged).

---

## 1. What this module does

**Creators** register on the **mobile app**, complete a numbered 11-section profile (**PAN / GST / channel ID** required), wait for **admin approval**, then publish videos / reels / stories, set a subscription price, and request UPI payouts.

Logged-in **members** browse **Creator Hub**: category / city / sort, watch public content for free, tip, subscribe, unlock paid posts (`type=CREATOR_TIP` / `CREATOR_SUB` / `CREATOR_UNLOCK`), cancel a subscription anytime, and review after they engage.

Unapproved creators’ posts and stories **must not** appear in the member feed.

Public content is **free**. Subscriber-only or price &gt; ₹0 requires pay. Photos/docs are **optional**. Credential is **typed**. UPI is required only to withdraw.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin web | `http://localhost:8084/admin/loginAdmin` then **Pending creators** (`/admin/pending-creators`) |
| Member browse | App landing → **Creator Hub** (member login required) |
| Creator portal | App landing → Login sheet → **Creator Hub Login** **or** Join Us → **Creator Hub** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Types: `CREATOR_TIP`, `CREATOR_SUB`, `CREATOR_UNLOCK` |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional**. **PAN / GST / channel ID is required** (typed, not an upload). |
| Push (FCM) | **Log-only**. Do not fail tests if the phone does not show a system notification. |
| Flyway | Confirm **V37** (`creator_hub_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V37.
2. flutter run on Android emulator or device.
3. Keep two app accounts: one Member, one Creator.
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Creator | Join Us → Creator Hub | Email OTP required |
| Member | Normal user register / login | Browses Creator Hub |
| Admin | Existing web admin | Approves at `/admin/pending-creators` |

Use unique emails each run (e.g. `qa.creator.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Creator

1. Landing → **Join Us** → **Creator Hub** → Register.  
2. Landing → **Login** → **Creator Hub Login**.  
3. Incomplete profile opens **Complete Creator Profile**. Studio: **Content | Monetize | Safety**.

Upload FAB is blocked until approved.

### Member

1. Landing → **Creator Hub**.  
2. Filters: category chips, city, Newest / Top rated.  
3. Open a creator profile to Follow, Tip, Subscribe, Review.

Website creator JSPs are **out of scope**.

---

## 4. Creator Complete Profile (1–11)

| # | Section | Required | Notes |
|---|---------|----------|-------|
| 1 | Creator identity | Yes | 1.1 Full name, 1.2 Role, 1.5 10-digit phone, **1.8 PAN / GST / channel ID**. Handle optional |
| 2 | Location | Yes | Address, city, state, 6-digit pincode. Map pin optional |
| 3 | Categories | Yes | At least one content category |
| 4 | Who I serve | Yes | Audience. In-person optional |
| 5 | Facilities | Optional | Studio amenities |
| 6 | Hours | Yes | Open days + open/close time |
| 7 | About | Yes | Bio |
| 8 | First offering | Yes | Public / Subscriber / Paid + typical price (₹0 = free) |
| 9 | Finance / UPI | Optional for submit | UPI required **only to withdraw** |
| 10–11 | Photos | Optional | Profile + gallery |

**Completion %** is based on 16 required items. **Save** stores draft. **Submit for Verification** only when ready.

---

## 5. Creator lifecycle

| Status | What tester sees |
|--------|------------------|
| PROFILE_INCOMPLETE | Complete Profile required |
| READY_FOR_VERIFICATION | Submit enabled |
| PENDING_ADMIN_APPROVAL | Waiting; cannot upload publicly |
| APPROVED / verifiedCreator | Can upload |
| CHANGES_REQUESTED / REJECTED | Update + resubmit |
| SUSPENDED / banned | Login blocked |

Admin queue: `/admin/pending-creators`.

---

## 6. Studio

| Tab | Checks |
|-----|--------|
| Content | Drafts / published. Publish blocked until approved |
| Monetize | Subscription price, claim ad revenue, redeem points, **payout balance**, **Request UPI payout** (min ₹100 + UPI) |
| Safety | Blocked users / privacy |

---

## 7. Member hub

| Check | Expected |
|-------|----------|
| Unapproved creator | Hidden from feed and public profile |
| Category / city / Top rated | Filters work |
| Public post | Watch free |
| Subscriber-only | Pay `CREATOR_SUB` to unlock |
| Paid post | Pay `CREATOR_UNLOCK` |
| Tip | Pay `CREATOR_TIP` |
| Cancel subscription | Anytime; access until period end |
| Review | After like / tip / sub / unlock. One per member per creator |

---

## 8. Pay, cancel, reviews, payout

### Pay

- Public / ₹0 → free.  
- Tip / sub / unlock → Razorpay / mock.  
- On verify, creator **payout balance** increases.

### Cancel

> Public videos are free. Tips and paid unlocks are not refundable. Subscriptions can be cancelled anytime; access lasts until the period ends.

### Payout

- Min **₹100**.  
- UPI ID required.  
- Studio → Monetize → **Request UPI payout**.

---

## 9. API smoke (optional)

| Method | Path | Notes |
|--------|------|-------|
| PUT | `/api/creator-hub/creator-profile` | Extra fields + completion |
| POST | `/api/creator-hub/submit-verification` | Ready only |
| POST | `/api/creator-hub/payout/request` | Min ₹100 |
| GET | `/api/creator-hub/feed?category=&city=&sort=` | Member feed |
| POST | `/api/creator-hub/creators/{id}/unsubscribe` | Cancel sub |
| POST | `/api/creator-hub/creators/{id}/rate` | After engage |
| POST | `/payment/verify` | `CREATOR_TIP` / `CREATOR_SUB` / `CREATOR_UNLOCK` |

---

## 10. Regression (must not break)

- Website creator JSPs unchanged.  
- Other wrapped modules still compile.  
- Admin `/admin/pending-creators` still works.  
- Mock payment still works when `PAYMENT_MOCK=true`.

---

## 11. Suggested test run (happy path)

1. Register creator with OTP.  
2. Fill Complete Profile 1–11 including PAN/GST/channel ID. Submit.  
3. Admin approves creator.  
4. Creator uploads a **public** post and a **paid** post; sets subscription price ₹99.  
5. Member sees only approved creator content.  
6. Member watches public post free.  
7. Member tips ₹50 (mock `CREATOR_TIP`). Creator payout +50.  
8. Member subscribes (`CREATOR_SUB`) then cancels.  
9. Member unlocks paid post (`CREATOR_UNLOCK`).  
10. Member leaves a review. Top rated sort updates.  
11. Creator requests payout after balance ≥ 100 with UPI set.

---

## 12. Fail conditions (file bugs)

- Submit allowed without PAN / GST / channel ID.  
- Unapproved creator posts visible in feed.  
- Public post asks for Razorpay.  
- Tip/unlock refunded.  
- Payout under ₹100 or without UPI succeeds.  
- Website creator JSP login changed.  
- Flyway V37 missing columns (`creator_credential_number`, `creator_payout_balance`, `creator_reviews`).

---

## 13. Out of scope

- Live bank settlement of UPI payout (request is recorded).  
- FCM device delivery.  
- Website creator JSP redesign.  
- Fitness Trainer (next remaining Join Us module).
