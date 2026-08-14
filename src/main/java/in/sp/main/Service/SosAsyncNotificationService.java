package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.SOSContactResponse;
import in.sp.main.Entities.SOSRequest;
import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.SOSContactResponseRepository;
import in.sp.main.Repository.SOSRequestRepository;
import in.sp.main.Repository.TrustedContactRepository;
import in.sp.main.Repository.UserRepository;

/**
 * Sends SOS SMS/email after the SOS record and contact responses are persisted.
 */
@Service
public class SosAsyncNotificationService {

    private static final Logger log = LoggerFactory.getLogger(SosAsyncNotificationService.class);

    @Autowired
    private SOSRequestRepository sosRequestRepository;

    @Autowired
    private SOSContactResponseRepository sosContactResponseRepository;

    @Autowired
    private TrustedContactRepository trustedContactRepository;

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SMSService smsService;

    @Autowired
    private EmailAsyncService emailAsyncService;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    @Async
    @Transactional
    public void notifyContactsAsync(Long sosRequestId) {
        SOSRequest sosRequest = sosRequestRepository.findById(sosRequestId).orElse(null);
        if (sosRequest == null || sosRequest.getUser() == null) {
            log.warn("SOS async notify skipped: request {} not found", sosRequestId);
            return;
        }

        User user = userRepository.findById(sosRequest.getUser().getId()).orElse(sosRequest.getUser());
        Long userId = user.getId();
        String userName = user.getFullName();
        if (userName == null || userName.isEmpty()) {
            userName = user.getEmail();
        }
        if (userName == null || userName.isEmpty()) {
            userName = "User #" + userId;
        }
        String userPhone = user.getPhoneNumber() != null ? user.getPhoneNumber() : "Unknown Number";

        List<SOSContactResponse> existing = sosContactResponseRepository.findBySosRequestId(sosRequestId);
        List<TrustedContact> trustedContacts = trustedContactRepository.findByUserId(userId);
        List<EmergencyContact> emergencyContacts = emergencyContactRepository.findByUserId(userId);

        if (!existing.isEmpty()) {
            for (SOSContactResponse response : existing) {
                if (response.isNotificationSent()) {
                    continue;
                }
                TrustedContact trusted = trustedContacts.stream()
                        .filter(c -> matchesContact(c.getPhone(), c.getEmail(), response))
                        .findFirst()
                        .orElse(null);
                if (trusted != null) {
                    deliverTrustedContact(sosRequest, response, trusted, userName, userPhone);
                } else {
                    EmergencyContact emergency = emergencyContacts.stream()
                            .filter(c -> matchesContact(c.getPhone(), c.getEmail(), response))
                            .findFirst()
                            .orElse(null);
                    if (emergency != null) {
                        deliverEmergencyContact(sosRequest, response, emergency, userName, userPhone);
                    } else {
                        deliverContactNotification(sosRequest, response, userName, userPhone);
                    }
                }
                sosContactResponseRepository.save(response);
            }
            return;
        }

        for (TrustedContact contact : trustedContacts) {
            SOSContactResponse response = buildResponse(sosRequest, contact.getName(), contact.getPhone(),
                    contact.getEmail(), contact.getRelation());
            deliverTrustedContact(sosRequest, response, contact, userName, userPhone);
            sosContactResponseRepository.save(response);
        }

        for (EmergencyContact contact : emergencyContacts) {
            SOSContactResponse response = buildResponse(sosRequest, contact.getName(), contact.getPhone(),
                    contact.getEmail(), contact.getRelation());
            deliverEmergencyContact(sosRequest, response, contact, userName, userPhone);
            sosContactResponseRepository.save(response);
        }
    }

    private SOSContactResponse buildResponse(SOSRequest sosRequest, String name, String phone, String email,
                                             String relation) {
        SOSContactResponse response = new SOSContactResponse();
        response.setSosRequest(sosRequest);
        response.setContactName(name);
        response.setContactPhone(phone);
        response.setContactEmail(email);
        response.setRelation(relation);
        response.setUniqueToken(UUID.randomUUID().toString());
        response.setNotifiedAt(LocalDateTime.now());
        response.setResponseStatus(SOSContactResponse.ResponseStatus.PENDING);
        return response;
    }

    private void deliverTrustedContact(SOSRequest sosRequest, SOSContactResponse response, TrustedContact contact,
                                       String userName, String userPhone) {
        String notificationMethods = "";
        if (contact.isCanReceiveSMS() && contact.getPhone() != null) {
            boolean smsSent = smsService.sendSOSSMS(
                    contact.getPhone(),
                    userName,
                    sosRequest.getGoogleMapsLink(),
                    response.getUniqueToken(),
                    response.getUniqueToken(),
                    baseUrl);
            response.setSMSDelivered(smsSent);
            response.setNotificationSent(smsSent);
            notificationMethods += "SMS ";
        }
        if (contact.isCanReceiveEmail() && contact.getEmail() != null) {
            queueSosEmail(contact.getEmail(), userName, userPhone, sosRequest, response);
            response.setEmailDelivered(true);
            response.setNotificationSent(true);
            notificationMethods += "Email ";
        }
        response.setNotificationMethod(notificationMethods.trim());
    }

    private void deliverEmergencyContact(SOSRequest sosRequest, SOSContactResponse response,
                                         EmergencyContact contact, String userName, String userPhone) {
        String notificationMethods = "";
        if (contact.getPhone() != null && !contact.getPhone().isEmpty()) {
            boolean smsSent = smsService.sendSOSSMS(
                    contact.getPhone(),
                    userName,
                    sosRequest.getGoogleMapsLink(),
                    response.getUniqueToken(),
                    response.getUniqueToken(),
                    baseUrl);
            response.setSMSDelivered(smsSent);
            response.setNotificationSent(smsSent);
            notificationMethods += "SMS ";
        }
        if (contact.getEmail() != null && !contact.getEmail().isEmpty()) {
            queueSosEmail(contact.getEmail(), userName, userPhone, sosRequest, response);
            response.setEmailDelivered(true);
            response.setNotificationSent(true);
            notificationMethods += "Email ";
        }
        response.setNotificationMethod(notificationMethods.trim());
    }

    private void queueSosEmail(String email, String userName, String userPhone, SOSRequest sosRequest,
                               SOSContactResponse response) {
        String acceptLink = baseUrl + "/sos/respond?token=" + response.getUniqueToken() + "&action=accept";
        String rejectLink = baseUrl + "/sos/respond?token=" + response.getUniqueToken() + "&action=reject";
        String emailBody = "🚨 EMERGENCY SOS ALERT 🚨\n\n"
                + userName + " has triggered an emergency SOS!\n\n"
                + "📍 Live Location: " + sosRequest.getGoogleMapsLink() + "\n\n"
                + "📞 Contact: " + userPhone + "\n\n"
                + "⏰ Time: " + LocalDateTime.now() + "\n\n"
                + "═══════════════════════════════\n"
                + "Please respond immediately:\n\n"
                + "✅ ACCEPT HELP: " + acceptLink + "\n\n"
                + "❌ DECLINE: " + rejectLink + "\n\n"
                + "═══════════════════════════════\n\n"
                + "This is an automated emergency alert from the Women Safety App.";
        emailAsyncService.sendEmailAsync(
                email,
                "🚨 EMERGENCY SOS - " + userName + " needs your help!",
                emailBody);
    }

    private void deliverContactNotification(SOSRequest sosRequest, SOSContactResponse response,
                                            String userName, String userPhone) {
        String notificationMethods = "";
        if (response.getContactPhone() != null && !response.getContactPhone().isBlank()) {
            boolean smsSent = smsService.sendSOSSMS(
                    response.getContactPhone(),
                    userName,
                    sosRequest.getGoogleMapsLink(),
                    response.getUniqueToken(),
                    response.getUniqueToken(),
                    baseUrl);
            response.setSMSDelivered(smsSent);
            response.setNotificationSent(smsSent);
            notificationMethods += "SMS ";
        }
        if (response.getContactEmail() != null && !response.getContactEmail().isBlank()) {
            queueSosEmail(response.getContactEmail(), userName, userPhone, sosRequest, response);
            response.setEmailDelivered(true);
            response.setNotificationSent(true);
            notificationMethods += "Email ";
        }
        response.setNotificationMethod(notificationMethods.trim());
    }

    private boolean matchesContact(String phone, String email, SOSContactResponse response) {
        if (phone != null && phone.equals(response.getContactPhone())) {
            return true;
        }
        return email != null && email.equalsIgnoreCase(response.getContactEmail());
    }
}
