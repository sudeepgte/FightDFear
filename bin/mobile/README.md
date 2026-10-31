# Fight D Fear — Flutter Android MVP

Safety-first mobile client for the KishorDfire Spring Boot backend.

## Screens
- Login (`POST /api/auth/login`)
- Home SOS button (`POST /api/sos/trigger`)
- Trusted contacts CRUD (`/api/me/trusted-contacts`)

## Prerequisites
1. Flutter SDK at `C:\src\flutter` (already on your User PATH)
2. Android Studio + SDK + emulator or USB device
3. Backend running on port **8084** with `JWT_SECRET` set

## Run

```powershell
# Terminal 1 — Spring Boot (from repo root)
# set JWT_SECRET and start the app on :8084

# Terminal 2 — Flutter
cd mobile
flutter pub get
flutter devices
flutter run
```

### API base URL
| Target | Base URL |
|--------|----------|
| Android emulator | `http://10.0.2.2:8084` (default) |
| Chrome / Windows | `http://localhost:8084` |
| Physical phone | `flutter run --dart-define=API_BASE=http://YOUR_PC_LAN_IP:8084` |

Open the project in Android Studio: **File → Open → `KishorDfire/mobile`**.
