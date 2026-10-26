# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 10. PAYMENTS, MARKETPLACE AND FINANCIAL SECURITY AUDIT

**Gateway Integration:** Razorpay Java SDK 1.4.3 (`RazorpayClient`)  
**Currency:** Indian Rupee (INR)  
**Supported Payment Workflows:** Telemedicine consultations, Salon & Beauty bookings, Martial arts training fees, Marketplace multi-item orders, Event registrations, Financial literacy enrollments, Creator tips & unlocks, Wallet coin purchases  

---

### 10.1 Payment Architecture & Lifecycle

Payment processing follows a hardened four-step protocol:
1. **Order Creation (`POST /payment/create-order`):**
   - User initiates checkout with payment `type` and identifiers.
   - For recognized types (DOCTOR, FINANCIAL_BOOKING, WOMEN_EVENT, GLOW_BOOKING, MARTIAL_ARTS, WOMEN_PRODUCT), server calculates fee directly from database records.
   - Razorpay API creates an order with `amountPaise = (int) Math.round(amount * 100)`.
   - Record created in `payment_pending_orders` table with state `PENDING` and a 30-minute expiration TTL.
2. **Client Checkout:**
   - Flutter / Web launches Razorpay Checkout modal with `order_id` and public `key_id`.
   - User completes payment via UPI, Credit Card, Netbanking, or Wallet.
3. **Server-Side Verification (`POST /payment/verify`):**
   - Client sends `razorpay_order_id`, `razorpay_payment_id`, and `razorpay_signature`.
   - Server resolves `PaymentPendingOrder` record from database using `orderId` and verifies ownership (`p.getUserId().equals(user.getId())`).
   - Server re-computes HMAC-SHA256 signature using `Utils.verifyPaymentSignature(options, razorpayKeySecret)`.
   - If signature matches, transaction is marked `FULFILLED` in `payment_pending_orders`, fulfillment record logged in `payment_fulfillments`, and service logic executes (e.g. appointment confirmed).
4. **Asynchronous Webhook Reconciliation (`POST /payment/webhook/razorpay`):**
   - Razorpay sends event `payment.captured` with signature header `X-Razorpay-Signature`.
   - Server validates webhook signature with `razorpay.webhook.secret`.
   - Event logged in `payment_webhook_events` to prevent duplicate processing.

---

### 10.2 Financial Vulnerabilities & Defects

#### 1. FF-FIN-001 (High): Price Tampering Vulnerability on Unrecognized / Fallback Payment Types
- **Location:** `PaymentController.java` lines 617–630 and 795–815.
- **Code Inspection:**
  ```java
  // In createOrder:
  } else {
      Object amountRaw = data.get("amount");
      if (amountRaw == null) {
          errorBody.put("error", "Amount is required");
          return ResponseEntity.badRequest().body(errorBody);
      }
      String amountStr = amountRaw.toString().replaceAll("[^0-9.]", "");
      amount = Double.parseDouble(amountStr);
  }
  ```
  ```java
  // In verify:
  } else if ("BEAUTY".equals(type)) {
      ...
      Booking booking = new Booking();
      booking.setUser(user);
      booking.setStylist(stylist);
      booking.setService(service);
      booking.setBookingTime(...);
      booking.setStatus(BookingStatus.CONFIRMED);
      booking.setPricePaid(amountPaid);
      bookingRepository.save(booking);
  }
  ```
- **Exploitation Scenario:**
  - An attacker selects a luxury bridal beauty package costing ₹10,000.
  - The attacker intercepts the network request to `POST /payment/create-order` with payload:
    `{"type": "BEAUTY", "amount": "1.00", "targetId": 45, "stylistId": 12}`.
  - The backend accepts `amount: 1.00` and creates a valid Razorpay order for ₹1.00 (100 paise).
  - The attacker pays ₹1.00 through UPI. Razorpay returns valid payment ID and signature.
  - The attacker calls `POST /payment/verify`. The signature is mathematically authentic.
  - The server marks the ₹10,000 booking as `CONFIRMED` having received only ₹1.00!
- **Remediation:**
  - Remove the client-fallback `else` clause in `createOrder`. Every payment type MUST resolve its price authoritatively from database entities (`service.getPrice()`, `product.getPrice()`, etc.).
  - In `verify`, assert: `if (Math.abs(service.getPrice() - amountPaid) > 0.05) throw new PaymentMismatchException();`.

---

#### 2. FF-FIN-002 (Medium): Test Secret Key in Production Configuration
- In `src/main/resources/application.properties`:
  `razorpay.key.id=rzp_test_RIlD5bEKRjyn3h`
  `razorpay.key.secret=Ltg6uo9vI8TiFMVfj2cGm4I8`
- If the application is started without setting `SPRING_PROFILES_ACTIVE=prod`, it will interact with Razorpay test accounts rather than real merchant settlement accounts, preventing real revenue collection.

---

### 10.3 Wallet, Coin & Payout Security

- **Coin Balances:** Handled via `AtomicCoinService.java` with atomic updates to avoid race conditions.
- **Transactions:** Handled via `WalletTransaction.java` with indexed lookups (`idx_wallet_tx_user_date`).
- **Partner Payouts:**
  - Partner payouts (`glowCareService.creditPayout`, `fitnessCareService.creditPayout`) are calculated server-side based on platform commission percentages (`DOCTOR_COMMISSION_PERCENT: 15`).
  - Cash-out requests require admin review before fulfillment (`CreatorCashout.status = PENDING`).
