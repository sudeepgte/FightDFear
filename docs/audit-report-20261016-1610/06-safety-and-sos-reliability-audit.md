# FIGHTDFEAR — PRE-DEPLOYMENT AUDIT
## 06. SAFETY AND EMERGENCY RESPONSE AUDIT

**Target Subsystem:** FightDFear Emergency SOS, Live Location Tracking, Buddy System, Volunteer Dispatch  
**Domain Significance:** Mission-Critical / Life-Safety Reliability  
**Audit Finding Summary:** 2 Critical Findings, 3 High Risks, 4 Unverified Delivery Paths  

---

### 6.1 Emergency Workflow Evaluation

The emergency response system follows a two-tier architectural lifecycle:
1. **Tier 1 (0–30 seconds):**
   - User triggers SOS via Flutter button (`home_screen.dart`) or web button (`panic-button.jsp`).
   - Device acquires GPS position via `Geolocator.getCurrentPosition(accuracy: LocationAccuracy.high)`.
   - Post request made to `/api/sos/trigger` with latitude, longitude.
   - Server creates an `SOSRequest` record in status `ACTIVE`.
   - System fetches trusted contacts from `trusted_contacts` and emergency contacts from `emergency_contacts`.
   - System creates `SOSContactResponse` records with unique cryptographic tokens for each contact.
   - Outbound SMS and Email are queued asynchronously via `SosAsyncNotificationService`.
   - STOMP WebSocket messages are pushed to user topic `/topic/sos-updates/user-{id}` and admin monitor `/topic/admin-sos`.
   - Mobile app auto-dials primary contact or emergency 100, then launches WhatsApp share intent.
2. **Tier 2 (30–60 seconds):**
   - Contacts receive SMS/email containing accept/reject links (`/sos/respond?token=...&action=accept`).
   - Contact responses update `contactsAccepted`, `contactsRejected`, and `contactsPending` in real time.
   - System evaluates whether escalation to nearby volunteers or authorities is required.

---

### 6.2 Critical Safety Defects & Vulnerabilities

#### 1. FF-SOS-001 (Critical): Public Exposure of Victim Coordinates via `/topic/volunteer-alerts`
- **Location:** `in.sp.main.Config.StompAuthChannelInterceptor.java` (lines 102–105) & `SosService.java` (lines 240–255).
- **Vulnerability Mechanism:**
  ```java
  // StompAuthChannelInterceptor.java
  if (destination.startsWith("/topic/reels")
          || destination.startsWith("/topic/volunteer-alerts")) {
      return true; // Any authenticated user can subscribe!
  }
  ```
  ```java
  // SosService.java
  for (User volunteer : nearbyVolunteers) {
      ...
      volunteerPayload.put("victimName", userName);
      volunteerPayload.put("lat", userLat);
      volunteerPayload.put("lng", userLon);
      volunteerPayload.put("mapsLink", savedRequest.getGoogleMapsLink());
      messagingTemplate.convertAndSend("/topic/volunteer-alerts", volunteerPayload);
      volunteersAlerted++;
  }
  ```
- **Catastrophic Impact:**
  - ANY registered user (including malicious actors or abusers) who connects to the WebSocket can subscribe to `/topic/volunteer-alerts`.
  - The moment a woman triggers SOS, her exact real-time GPS coordinates, name, and Google Maps pin are broadcast over this topic.
  - Furthermore, because `convertAndSend` is executed inside a loop over `nearbyVolunteers`, if 5 nearby volunteers exist, the exact same alert is broadcast 5 times to every subscriber on the topic.
- **Required Remediation:**
  1. Enforce strict authorization in `StompAuthChannelInterceptor`: allow subscribing to `/topic/volunteer-alerts` ONLY if `user.isVolunteer() == true` AND `user.getVerificationStatus() == VerificationStatus.VERIFIED`.
  2. Deprecate public topic broadcast. Replace with user-specific queues: `messagingTemplate.convertAndSendToUser(volunteer.getEmail(), "/queue/sos-alerts", payload)`.
  3. Ensure coordinates are dispatched only to vetted volunteers within the 5 km bounding box.

---

#### 2. FF-SOS-002 (High): Silent Failure of Outbound SMS & Automated Telephony
- **Location:** `src/main/resources/application.properties` & `SMSService.java`.
- **Finding:**
  - In `application.properties`: `sms.enabled=${SMS_ENABLED:false}` and `sms.provider=${SMS_PROVIDER:}`.
  - In `SMSService.java`:
    ```java
    if (!smsEnabled) {
        logger.warn("SMS disabled (sms.enabled=false). Not sending to {}", maskPhone(phoneNumber));
        return false;
    }
    ```
  - When SOS is activated, the API returns:
    `"SOS activated! 3 contacts queued and 0 nearby volunteers alerted."`
  - The UI displays green confirmation text: `"SOS activated · 3 contacts notified"`.
  - **In reality, NO SMS is sent to the contacts** because SMS is disabled by default and neither Twilio nor Msg91 credentials are provisioned in the base configuration!
- **User Impact:** A user in mortal danger believes emergency contacts have received SMS alerts with her location, when in fact no message was delivered.

---

### 6.3 Emergency Failure Scenario Matrix

| Failure Scenario | Designed Behavior | Actual Code Implementation | Risk Rating | Remediation |
|---|---|---|:---:|---|
| **No Internet Connectivity** | Cache SOS offline; send SMS via device cellular modem | Fails with HTTP network exception; no native SMS fallback triggered | **HIGH** | Add SMS fallback intent via Flutter telephony plugin |
| **GPS / Location Services Disabled** | Warn user; prompt device location dialog; send cell-tower/last-known fix | `home_screen.dart` detects `!isLocationServiceEnabled()`, sets banner, and aborts SOS | **MEDIUM** | Offer fallback option to send SOS with last-known cached GPS coordinates |
| **Location Permission Permanently Denied** | Deep link user directly to OS App Settings | Sets banner string; does not open device settings | **MEDIUM** | Call `Geolocator.openAppSettings()` on deniedForever |
| **Server Offline / HTTP 500** | Client falls back to local siren and emergency 100 auto-dial | Catch block sets banner `"Network error"`; does not auto-dial 100 | **HIGH** | If `/api/sos/trigger` fails, immediately trigger emergency dialer `tel:100` |
| **Duplicate Rapid SOS Button Clicks** | De-duplicate requests; prevent flooding contacts | `getActiveSOSForUser` checks active request and returns `alreadyActive: true` | **PASSED** | Correctly implemented; prevents contact spamming |
| **Unresponsive / Rejecting Contacts** | Auto-escalate to emergency services after 60 seconds | `JourneyEscalationJob` checks journeys, but SOS escalation relies on manual admin action | **HIGH** | Implement automated escalation cron job for SOS requests with 0 accepts after 3 minutes |

---

### 6.4 Verification Verdict & Production Readiness

Because real outbound SMS, carrier emergency telephony, and volunteer push dispatch cannot be safely verified without live carrier integrations and real volunteer devices, the end-to-end SOS reliability is classified as **UNVERIFIED IN PRODUCTION ENVIRONMENT**.

**Safety Release Blocker:** The platform must NOT be promoted as a reliable life-saving emergency device until FF-SOS-001 (privacy leak) and FF-SOS-002 (silent SMS failure) are resolved and verified on physical devices across Airtel, Jio, and Vi networks.
