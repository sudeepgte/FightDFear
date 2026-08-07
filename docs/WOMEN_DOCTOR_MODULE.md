# Women Doctor Module — Production Notes

## Scope
Doctor registration, profile completion, document verification, patient booking/payment, appointments, chat, video join, reviews, online presence, and admin verification.

## Lifecycle
- **Source of truth:** `DoctorProfileStatus`
- **Derived visibility:** `VerificationStatus` (synced in `DoctorProfileService`)

## Key APIs
### Patient
- `GET /api/doctors` — filters: `q`, `city`, `specialization`, `minFee`, `maxFee`, `online`, `emergency`, `instant`
- `GET /api/doctors/{id}`
- `POST /api/doctors/{id}/appointments` — unpaid only when fee is 0; otherwise payment required
- `POST /payment/create-order` + `/payment/verify` (`type=DOCTOR`) — server fee + auto-confirm
- `POST /api/doctors/appointments/{id}/cancel`
- `GET /api/doctors/appointments/{id}/join` — confirmed video/online only
- `GET/POST /api/doctors/{id}/chat` — appointment relationship required
- `GET/POST /api/doctors/{id}/reviews` — completed appointment required to post

### Doctor provider
- Auth: OTP, register-quick, login/logout
- Profile/docs/submit-verification
- `POST /api/doctors/provider/online`
- `GET /api/doctors/provider/analytics`
- Appointment status transitions via state machine

### Admin
- `/admin/pending-doctors` queues + profile approve/reject/request-changes + history

## Migrations
- `V13` — lifecycle + OTP
- `V14` — profile completion fields
- `V15` — verification history/drafts/notifications
- `V16` — online presence (`is_online`, `last_seen_at`)

## Appointment transitions
Doctor: `PENDING → CONFIRMED|CANCELLED`, `CONFIRMED → COMPLETED|CANCELLED`  
Patient: `PENDING|CONFIRMED → CANCELLED`

## Instant consult
Patients discover doctors with `instant=true` (`isOnline && emergencyAvailable`).  
Doctor FAB joins the next confirmed video/online appointment.

## Local test
```powershell
# Backend
mvn spring-boot:run

# Flutter against local API
cd mobile
flutter run --dart-define=API_BASE=http://192.168.x.x:8084
```

Do not commit real mail credentials in `application.properties`.
