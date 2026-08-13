package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.UserDeviceToken;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.UserDeviceTokenRepository;

/**
 * Push notification hooks. Stores FCM tokens and logs payloads.
 * Wire a real FCM HTTP v1 client when cloud credentials are available.
 */
@Service
public class PushNotificationService {

    private static final Logger log = LoggerFactory.getLogger(PushNotificationService.class);

    @Autowired
    private UserDeviceTokenRepository userDeviceTokenRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Transactional
    public void registerUserToken(Long userId, String token, String platform) {
        if (userId == null || token == null || token.isBlank()) {
            return;
        }
        Optional<UserDeviceToken> existing = userDeviceTokenRepository.findByUserIdAndFcmToken(userId, token.trim());
        UserDeviceToken row = existing.orElseGet(UserDeviceToken::new);
        row.setUserId(userId);
        row.setFcmToken(token.trim());
        row.setPlatform(platform == null || platform.isBlank() ? "android" : platform.trim());
        row.setUpdatedAt(LocalDateTime.now());
        userDeviceTokenRepository.save(row);
    }

    @Transactional
    public void registerDoctorToken(Doctor doctor, String token) {
        if (doctor == null || token == null || token.isBlank()) {
            return;
        }
        doctor.setFcmToken(token.trim());
        doctorRepository.save(doctor);
    }

    public void notifyUser(Long userId, String title, String body, Map<String, String> data) {
        if (userId == null) {
            return;
        }
        List<UserDeviceToken> tokens = userDeviceTokenRepository.findByUserId(userId);
        if (tokens.isEmpty()) {
            log.info("Push(user {}) skipped — no device token. title={}", userId, title);
            return;
        }
        for (UserDeviceToken t : tokens) {
            log.info("Push(user {} token…{}) title={} body={} data={}",
                    userId, abbreviate(t.getFcmToken()), title, body, data);
            // Production: send via FCM HTTP v1 using t.getFcmToken()
        }
    }

    public void notifyDoctor(Doctor doctor, String title, String body, Map<String, String> data) {
        if (doctor == null || doctor.getFcmToken() == null || doctor.getFcmToken().isBlank()) {
            log.info("Push(doctor {}) skipped — no FCM token. title={}",
                    doctor == null ? null : doctor.getId(), title);
            return;
        }
        log.info("Push(doctor {} token…{}) title={} body={} data={}",
                doctor.getId(), abbreviate(doctor.getFcmToken()), title, body, data);
    }

    private static String abbreviate(String token) {
        if (token == null || token.length() < 8) {
            return "****";
        }
        return token.substring(0, 4) + "…" + token.substring(token.length() - 4);
    }
}
