# Women Doctor Module — Production Notes

## Scope
Doctor registration, profile completion, document verification, patient booking/payment (Razorpay + local mock), appointments (cancel/refund/reschedule), chat, private-ish video join, reviews, online presence, instant consult queue, push-token hooks, admin verification, receipts & payout ledger.

## Lifecycle
- **Source of truth:** `DoctorProfileStatus`
- **Derived visibility:** `VerificationStatus` (synced in `DoctorProfileService`)

## Payments (P0+)
- `POST /payment/create-order` with `type=DOCTOR`, `targetId`, `consultationType`, `appointmentTime` — **server fee**
- `POST /payment/verify` — signature (or mock) → `createPaidBooking` (idempotent by payment id)
- `POST /payment/webhook/razorpay` — event log / reconcile
- Cancel (patient or doctor) → Razorpay refund when paid (`DoctorPaymentService`)
- Receipt: `GET /api/doctors/appointments/{id}/receipt`
- Commission: `app.doctor.commission-percent` (default 15%) → `platformFee` / `doctorEarning` / `payoutBalance`
- Local without keys: `app.payments.mock-enabled=true` (default) creates mock orders

### Configure live Razorpay
```
RAZORPAY_KEY_ID=rzp_live_xxx
RAZORPAY_KEY_SECRET=xxx
RAZORPAY_WEBHOOK_SECRET=xxx
PAYMENT_MOCK=false
```

## Key APIs
### Patient
- `GET /api/doctors` — filters + `page`/`size` pagination
- `POST /api/doctors/{id}/appointments` — unpaid only when fee is 0
- Payment flow above for fee > 0
- `POST /api/doctors/appointments/{id}/cancel` — refunds if paid
- `POST /api/doctors/appointments/{id}/reschedule`
- `GET /api/doctors/appointments/{id}/join` — room + password
- `POST /api/doctors/instant/request`
- `POST /api/doctors/device-token`
- Chat / reviews unchanged (relationship-gated)

### Doctor provider
- Instant: `GET /api/doctors/provider/instant/pending`, accept/decline
- `POST /api/doctors/provider/device-token`
- Online, analytics, appointments, docs

### Admin
- `/admin/pending-doctors`

## Migrations
- `V13`–`V16` prior
- `V17` — payment/refund/receipt/payout/FCM/instant queue tables

## Appointment transitions
Doctor: `PENDING → CONFIRMED|CANCELLED`, `CONFIRMED → COMPLETED|CANCELLED`  
Patient: `PENDING|CONFIRMED → CANCELLED` (+ reschedule in place)

## Instant consult
Queue offers to online + emergency-available doctors; doctor accept/decline; patient then books/pays.

## Local test
```powershell
mvn spring-boot:run
cd mobile
flutter run -d emulator-5554
# Debug builds use http://10.0.2.2:8084 by default
```

Do not commit real mail or Razorpay secrets in `application.properties`.
