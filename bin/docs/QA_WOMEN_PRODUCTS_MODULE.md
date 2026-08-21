# Women Products Module — QA / Testing Handbook

**Product:** Fight D Fear (KishorDfire)  
**Module:** Women Products (Product Seller + member shop + Delivery Guy)  
**Audience:** Testing team  
**Build under test:** Current mobile app + Spring Boot API on port **8084**  
**Admin:** Web only for approval  

This document is the handoff for functional, regression, and UAT testing. Test **mobile** seller, delivery partner, and member shop flows. Do **not** treat website seller-login / shop JSPs as the primary portal for this cycle (existing web logins must remain unchanged).

---

## 1. What this module does

**Product Sellers** register on the **mobile app**, complete a numbered 11-section shop profile, wait for **admin approval**, then list products, manage orders, and request UPI payouts.

**Delivery Guys** register separately (Join Us tile **Delivery Guy**), complete a numbered 11-section profile, wait for **admin approval**, then accept packed orders, live-track, mark delivered, and request UPI payouts. Driving **licence number is required** for Bike / Scooter / Van (typed, not upload). **Cycle can skip** licence.

Logged-in **members** browse products from **approved sellers only**, filter/sort, add to cart, checkout **COD or online** (`type=WOMEN_PRODUCT`), cancel until packed/assigned, live-track, and review after delivery.

Unapproved sellers’ products **must not** appear in the member shop.

---

## 2. Test environment

| Item | Value |
|------|--------|
| Backend | `http://localhost:8084` (emulator: `http://10.0.2.2:8084`) |
| Admin — sellers | `http://localhost:8084/admin/loginAdmin` then **Pending sellers** (`/admin/pending-sellers`) |
| Admin — delivery | `/admin/pending-delivery-partners` |
| Member shop | App landing → **Women Products** (member login required) |
| Seller portal | App landing → Login sheet → **Product Seller Login** **or** Join Us → **Product Seller** |
| Delivery portal | App landing → Login sheet → **Delivery Guy Login** **or** Join Us → **Delivery Guy** |
| Payments | Mock enabled by default (`PAYMENT_MOCK=true`). Online orders complete without a real Razorpay card. Type = `WOMEN_PRODUCT`. |
| OTP | 6-digit email OTP, expires in **10 minutes**, resend cooldown **60 seconds** |
| Documents | **Optional** for this test cycle (do not block testers on photo uploads). **Licence number is required** for Bike / Scooter / Van (typed). Cycle may skip. |
| Push (FCM) | Hooked in backend; **log-only** until FCM credentials are configured. Do not fail tests if the phone does not show a system notification. Check order state instead. |
| Flyway | Confirm **V33** (`women_products_module_10`) applied |

### Start services

```text
1. Start Spring Boot (port 8084). Confirm Flyway includes V33.
2. flutter run on Android emulator or device.
3. Keep three app accounts ready: Member, Product Seller, Delivery Guy (or three devices / emulators).
```

### Accounts needed

| Role | How to create | Notes |
|------|----------------|-------|
| Member (shopper) | App Join Us → Member / existing user register | Required to browse shop |
| Product Seller | App Join Us → Product Seller | Email OTP required |
| Delivery Guy | App Join Us → Delivery Guy | Separate portal from seller |
| Admin | Existing web admin | Approves sellers at `/admin/pending-sellers` and couriers at `/admin/pending-delivery-partners` |

Use unique emails each run (e.g. `qa.seller.<date>@gmail.com`, `qa.delivery.<date>@gmail.com`).

---

## 3. Entry points (mobile)

### Product Seller

1. Landing → **Join Us** → **Product Seller** → Register.  
2. Landing → **Login** → **Product Seller Login**.  
3. After login, if profile is incomplete, **Complete Shop Profile** opens (or from the dashboard completion card).

### Delivery Guy

1. Landing → **Join Us** → **Delivery Guy** → Register.  
2. Landing → **Login** → **Delivery Guy Login**.  
3. After login, incomplete partners land on **Complete Delivery Profile**.

Delivery Guy remains a **separate** Join Us / Login tile. Do not merge it into Product Seller.

### Member

1. Landing → **Women Products** (login wall if guest).  
2. Member dashboard → Women Products.  
3. Screen tabs: **Shop | Cart | Orders**.

---

## 4. Quick registration (seller and delivery)

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
| Success | Account created; portal logs in; Complete Profile is available |

**Negative:** Duplicate email should fail with a clear API error.

**Out of scope:** Do not test or “fix” website seller-login / shop JSPs. Mobile portals are the source of truth this cycle.

---

## 5. Seller Complete Profile (numbered UX — 11 sections)

After login, incomplete sellers land on Complete Profile. Profile % is based on **16** mandatory items. Submit is enabled only when **missingItems is empty**.

Documents (10) and shop photos (11) are **optional**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Full name | Name |
| 1.2 Role | Shop owner / Brand seller / … |
| 1. Shop name | Business name |
| 1.5 Official phone | 10-digit phone |
| 2.1 Shop address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Categories you sell | At least one SellerCatalog category |
| 4.1 Brand type | Own Brand or Reseller |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio |
| 8. First listing defaults | Primary category + dispatch hours + typical price |

UPI (9.1) is **not** required to submit. It **is** required to withdraw from Finance. GSTIN (9.3) is optional.

### 1. Seller identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Full name | Text | Yes |
| 1.2 | Role | Dropdown: Shop owner, Brand seller, Reseller, Homemaker seller, Other | Yes |
| 1.3 | Shop name | Text | Yes |
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
| 2.7 | Pin shop on map | Tap map **or** Use current location | No |

City, state, and pincode are separate. Open/close times are pickers, not a typed hours string as the only input.

### 3. Categories you sell

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 3.1 | Categories | Multi-select chips from SellerCatalog | Yes (at least one) |

### 4. Who I serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Audience | Chips | Yes on the form (at least one) |
| 4.2 | Local pickup | Toggle | No |

Brand type is collected in section **8**.

### 5. Shop facilities

Optional chips: Packed ready, Returns accepted, COD available, UPI / card, Gift wrap, Same-day dispatch.

### 6. Hours & calendar

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 6.1 | Open days | Day chips MON–SUN | Yes (at least one) |
| 6.2 | Open time | **Time picker** | Yes |
| 6.3 | Close time | Time picker | Yes |
| 6.4 | Break start | Time picker | No |
| 6.5 | Break end | Time picker | No |
| 6.6 | Leave / blocked dates | Date picker chips | No |

### 7. About the shop

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 7.1 | About | Text | Yes |

### 8. First listing defaults

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 8.1 | Primary category | Dropdown (SellerCatalog) | Yes |
| 8.2 | Brand type | Own Brand / Reseller | Yes |
| 8.3 | Dispatch hours | 6 / 12 / 24 / 48 / 72 | Yes |
| 8.4 | Typical price (₹) | Number | Yes |

### 9. Payout

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 9.1 | UPI ID | Text (`name@upi`) | No to submit; **Yes to withdraw** |
| 9.2 | Bank details | Text | No |
| 9.3 | GSTIN | Text | No |

Earnings stay in the seller wallet until Finance → Request UPI payout. Minimum payout **₹100**.

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
| **Submit for Verification** | Enabled only when missingItems is empty. Status → PENDING_ADMIN_APPROVAL |

---

## 6. Delivery Complete Profile (numbered UX — 11 sections)

Profile % is based on **15** mandatory items. Submit is enabled only when **missingItems is empty**.

### Required-to-submit checklist

| Missing item shown | Field |
|--------------------|--------|
| 1.1 Full name | Name |
| 1.2 Vehicle | Bike / Scooter / Van / Cycle |
| 1.5 Official phone | 10-digit phone |
| 1.8 Driving licence number | Required unless vehicle is **Cycle** |
| 2.1 Base address | Address |
| 2.3 City | City |
| 2.4 State | State |
| 2.5 Pincode | 6 digits |
| 3.1 Service areas | At least one area chip |
| 4.1 Capabilities | At least one capability |
| 6.1 Open days | At least one day |
| 6.2 Open time | Time picker |
| 6.3 Close time | Time picker |
| 7.1 About | Bio |
| 8. First offering | Typical radius (km) |

### 1. Rider identity

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 1.1 | Full name | Text | Yes |
| 1.2 | Vehicle | Bike, Scooter, Van, Cycle | Yes |
| 1.5 | Official phone | 10 digits | Yes |
| 1.6 | WhatsApp | 10 digits | No |
| 1.7 | Years of experience | Number | No |
| 1.8 | Driving licence number | Text | **Yes** unless Cycle |

### 2. Location

Same split as seller: address, city, state, pincode, optional Maps link, optional map pin.

### 3. Service areas

Chips: City centre, Suburbs, Nearby towns, Apartments, Markets. At least one required.

### 4. Who I serve

| Serial | Field | Type | Mandatory |
|--------|--------|------|-----------|
| 4.1 | Capabilities | COD collect, Large parcels, Night delivery, Same-day, Apartment access | Yes (at least one) |
| 4.2 | COD collect | Toggle | No |

### 5. Readiness

Optional chips: Helmet, Delivery bag, Phone GPS, Rain cover.

### 6–11

Hours/calendar, About, typical radius (3–20 km), UPI/bank, optional photo, optional gallery — same pattern as seller.

---

## 7. Admin approval

### Sellers

1. Open `http://localhost:8084/admin/loginAdmin`.  
2. Go to **Pending sellers** (`/admin/pending-sellers`).  
3. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Seller products **not** listed in member shop |
| Approved | Seller can add products; products appear in shop |
| Reject | Seller stays off shop; dashboard shows Rejected |

### Delivery partners

1. Go to **Pending delivery partners** (`/admin/pending-delivery-partners`).  
2. **Approve**.

| Case | Expected |
|------|----------|
| Pending | Cannot accept packed orders |
| Approved | Can accept READY_FOR_PICKUP orders |

Do **not** use website seller login for this cycle.

---

## 8. Seller dashboard (after approval)

Bottom nav: **Home | Products | Orders | Finance** (FAB = Add Product).

### Home

KPIs, inventory, recent orders, complete-profile card until verified. Cannot list products until **APPROVED**.

### Products

Add / edit / delete products (name, brand, category, price, stock, description, optional photo). Stock must be > 0 for the item to sell.

### Orders

| Action | From status | To |
|--------|-------------|-----|
| Confirm | PLACED | CONFIRMED |
| Ready for pickup | CONFIRMED | READY_FOR_PICKUP |
| Cancel | PLACED / CONFIRMED | CANCELLED (stock restored) |
| Notes | Any | Internal packing notes (`coachNotes`) |
| Live track | ASSIGNED / OUT_FOR_DELIVERY / DELIVERED | Map |

Seller cannot assign a courier. Delivery partners pick up from the **Ready** pool after READY_FOR_PICKUP.

### Finance

| Field | Expected |
|-------|----------|
| Payout balance | Online: credits when member **pays** (`type=WOMEN_PRODUCT`). COD: credits when order is **DELIVERED**. |
| Confirmed earnings | Sum of delivered / paid order totals |
| Request UPI payout | Fails without UPI; fails if balance &lt; ₹100; succeeds with UPI + ≥ ₹100 |

---

## 9. Delivery dashboard

Bottom nav: **Ready | Active | Done | Finance**.

| Tab | Expected |
|-----|----------|
| Ready | Packed orders with no courier (`READY_FOR_PICKUP`). **Accept pickup** assigns this partner. |
| Active | ASSIGNED → **Mark picked up** → OUT_FOR_DELIVERY → **Mark delivered** → DELIVERED. GPS ping while live. |
| Done | DELIVERED orders |
| Finance | Wallet + Request UPI payout. Courier fee = **max(₹30, 10% of order)**, credited on DELIVERED. |

Delivery notes persist on the order. Open map for live tracking.

Unapproved partners see the Complete Profile card and cannot accept.

---

## 10. Member shop, pay, cancel, reviews

### Shop filters

| Filter | Expected |
|--------|----------|
| Category chips | Fashion, Beauty, Home Decor, Organic, Baby, Jewellery, Books, Fitness, All |
| City | Contains match on seller city |
| In stock | Stock &gt; 0 only |
| Sort: newest | Latest listings first |
| Sort: rating | Highest rating first |
| Sort: price | Lowest price first |
| Under ₹500 | `maxPrice=500` |

Unapproved sellers’ products must **not** appear. Copy: “from approved shops”.

### Cart & checkout

1. Add to cart / wishlist from listing or product detail.  
2. Checkout asks for **shipping address** (min 8 chars) and **COD or Pay online**.  
3. Policy copy is shown.  
4. COD: order PLACED, `paymentStatus=COD`.  
5. ONLINE: order PLACED, `paymentStatus=PENDING`, then Razorpay/mock pay (`type=WOMEN_PRODUCT`, `orderId` / `targetId` = order id). Amount must match order total. Mock pay marks PAID and credits **seller** payout immediately.

### Orders tab

| Control | When |
|---------|------|
| Pay now | ONLINE and not yet PAID |
| Write a review | DELIVERED and no rating yet |
| Cancel order | PLACED, CONFIRMED, or READY_FOR_PICKUP (until assigned) |
| Live track | ASSIGNED / OUT_FOR_DELIVERY / DELIVERED |

Cancel restores stock. After ASSIGNED, cancel API returns the policy error.

### Order status machine

| Actor | From | To |
|-------|------|-----|
| Member checkout | — | PLACED |
| Seller | PLACED | CONFIRMED / CANCELLED |
| Seller | CONFIRMED | READY_FOR_PICKUP / CANCELLED |
| Delivery | READY_FOR_PICKUP | ASSIGNED (accept) |
| Delivery | ASSIGNED | OUT_FOR_DELIVERY |
| Delivery | OUT_FOR_DELIVERY | DELIVERED |
| Member | PLACED / CONFIRMED / READY_FOR_PICKUP | CANCELLED |
| Member pay | ONLINE PENDING | PAID (seller payout credited) |

---

## 11. Business rules

| ID | Rule |
|----|------|
| BR-01 | Unapproved sellers never appear in member shop / product detail. |
| BR-02 | Submit verification requires all numbered mandatory items (seller 16 items, delivery 15 items). |
| BR-03 | Documents and gallery are optional. Licence number is a typed credential, not an upload. Cycle may skip licence. |
| BR-04 | Open/close times are pickers, not a typed hours string as the only input. |
| BR-05 | Free cancel until packed **and assigned** (PLACED / CONFIRMED / READY_FOR_PICKUP). After ASSIGNED, member cannot cancel. |
| BR-06 | Online pay uses `type=WOMEN_PRODUCT` and credits seller on verify. |
| BR-07 | COD seller credit happens on DELIVERED. |
| BR-08 | Delivery payout happens on DELIVERED: max(₹30, 10% of order total). |
| BR-09 | Withdraw requires UPI ID and balance ≥ ₹100 (seller and delivery). |
| BR-10 | Website seller-login / shop JSPs are out of scope and must not be changed. |
| BR-11 | Delivery Guy stays a separate Join Us / Login option from Product Seller. |
| BR-12 | Only approved delivery partners can accept packed orders. |
| BR-13 | Reviews are allowed only after DELIVERED and only once per order. |

---

## 12. Suggested test data

**Seller A (approved)**  
- Role: Shop owner  
- Shop: QA Handmade Pune  
- City: Pune, State: Maharashtra, Pincode: 411001  
- Categories: FASHION, BEAUTY  
- Brand type: Own Brand  
- Audience: Women, Families  
- Open Mon–Sat 10:00–18:00  
- Dispatch 24h, typical price ₹499  
- UPI: `qa.seller@upi`  
- Products: “Silk scarf” ₹399 stock 8; “Face oil” ₹249 stock 5

**Seller B (pending, should NOT list)**  
- Complete profile but **do not** admin-approve. Add a product if the UI allows after approval-only gate — expected: cannot list until approved; if a leftover product exists, it must not appear in member shop.

**Delivery D1 (Bike, approved)**  
- Licence: `MH12 20240001234`  
- City: Pune, radius 8 km  
- Capabilities: COD collect, Same-day  
- UPI: `qa.delivery@upi`

**Delivery D2 (Cycle, pending)**  
- No licence. Complete profile but **do not** approve.

**Member M1**  
- City filter Pune. COD order + cancel before assign.  
- ONLINE order → pay → seller confirms → ready → D1 accepts → deliver → review.

---

## 13. Test cases

Use Pass / Fail / Blocked. Attach screenshots for Fail.

### A. Seller onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| S-01 | Register validation | Empty submit; bad phone; weak password | Field errors; no account |
| S-02 | OTP happy path | Send OTP → enter 6 digits | Auto-verify; Create Account works |
| S-03 | OTP resend | Tap resend immediately | Disabled until 60s |
| S-04 | Login existing seller | Email + password | Dashboard or Complete Profile |
| S-05 | Complete Profile opens | New seller | Numbered 1–11 form |
| S-06 | Profile mandatory | Save with empty 1.1 / 1.3 / 2.5 / 3.1 / 6.2 / 7.1 / no section 8 | Numbered error |
| S-07 | Location split | City / state / pincode / map pin | All save |
| S-08 | Time picker only | Open/close | Clock UI |
| S-09 | Optional docs | Skip photo + gallery, save | Save succeeds |
| S-10 | Submit verification | Fill mandatory → submit | Status pending admin |

### B. Delivery onboarding

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| D-01 | Register + OTP | Same as seller | Account created |
| D-02 | Licence required | Vehicle Bike, empty 1.8, submit | Blocked; `1.8 Driving licence number is required` |
| D-03 | Cycle skip licence | Vehicle Cycle, empty 1.8, fill rest, submit | Allowed |
| D-04 | Radius | Section 8 pick 8 km | Saves `typicalRadiusKm` |
| D-05 | Submit | Missing empty → submit | Pending admin |

### C. Admin

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| A-01 | Seller queue | Open `/admin/pending-sellers` | New seller listed |
| A-02 | Approve seller | Approve | Status APPROVED; can list products |
| A-03 | Unapproved hidden | Seller B not approved | Products not in member shop |
| A-04 | Delivery queue | `/admin/pending-delivery-partners` | New partner listed |
| A-05 | Approve delivery | Approve D1 | Can accept packed orders |
| A-06 | Web login untouched | Open existing website seller-login / shop | Existing web page still works |

### D. Seller ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| O-01 | Add product before approve | Tap + | Blocked; Complete Profile / wait for approval |
| O-02 | Add product after approve | Name, brand, category, price, stock, photo | Product listed |
| O-03 | Confirm + pack | PLACED → CONFIRMED → READY_FOR_PICKUP | Appears in delivery Ready |
| O-04 | Packing notes | Save notes | Persist on reload |
| O-05 | Finance tab | Open Finance | Payout balance + Request UPI payout |
| O-06 | Payout no UPI | Request payout | Error: add UPI ID |
| O-07 | Online credit | Member pays ONLINE | Seller wallet increases by order total |
| O-08 | COD credit | Member COD, deliver | Seller wallet increases on DELIVERED, not at place |

### E. Delivery ops

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| C-01 | Accept packed | Ready → Accept | Status ASSIGNED; leaves Ready pool |
| C-02 | Pickup + deliver | Mark picked up → Mark delivered | OUT_FOR_DELIVERY then DELIVERED |
| C-03 | GPS | While ASSIGNED / OUT_FOR_DELIVERY | Member live track updates (or last ping) |
| C-04 | Delivery notes | Save notes | Persist |
| C-05 | Finance | After DELIVERED | Wallet += max(30, 10% of total) |
| C-06 | Unapproved accept | D2 tries Ready | Accept disabled / Complete Profile |

### F. Member shop

| ID | Title | Steps | Expected |
|----|--------|-------|----------|
| M-01 | Shop entry | Landing → Women Products | Approved products only |
| M-02 | Filters | City + in stock + price sort + Under ₹500 | List updates |
| M-03 | Wishlist + cart | Heart and Cart | Saved / in-cart chips |
| M-04 | COD checkout | Address + COD | PLACED; pay not required |
| M-05 | Online checkout | Address + Pay online + mock pay | PAID; seller payout up |
| M-06 | Pay now | Leave ONLINE unpaid; Pay on Orders | Same as M-05 |
| M-07 | Cancel free | Cancel PLACED / CONFIRMED | CANCELLED; stock restored |
| M-08 | Cancel blocked | After ASSIGNED | Policy error |
| M-09 | Review | After DELIVERED | 5★ review; rating updates |
| M-10 | Live track | After ASSIGNED | Map / route |
| M-11 | Join Us | Open Join Us and Login sheets | Product Seller **and** Delivery Guy present as separate tiles |

### G. Regression / out of scope

| ID | Title | Expected |
|----|--------|----------|
| R-01 | Website seller-login / shop JSPs | Unchanged |
| R-02 | Women Jobs / Lawyer | Separate portals still work |
| R-03 | Delivery vs seller | Delivery Guy is not merged into Product Seller |

---

## 14. Known limitations this cycle

- FCM is **log-only**. Pass if order state is correct; do not fail on missing OS notification.  
- Photos are optional. Licence number is required as text for motor vehicles.  
- Payout is a **request** (not a live bank transfer).  
- Website seller-login / shop JSPs are intentionally unchanged.  
- Courier fee is a simple max(₹30, 10%) — not a live distance tariff.

---

## 15. Sign-off

| Area | Tester | Date | Result |
|------|--------|------|--------|
| Seller onboarding | | | |
| Delivery onboarding | | | |
| Admin approval | | | |
| Member shop / pay / cancel / review | | | |
| Finance (seller + delivery) | | | |
| Website logins untouched | | | |
