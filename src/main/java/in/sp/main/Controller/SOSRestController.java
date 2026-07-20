package in.sp.main.Controller;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.User;
import in.sp.main.Entities.sosAlert;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.SOSAlertRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.EmailService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/sos")
public class SOSRestController {

    @Autowired
    private SOSAlertRepository sosAlertRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private in.sp.main.Service.SosService sosService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @PostMapping("/trigger")
    public Map<String, Object> triggerSOS(@RequestBody Map<String, String> payload, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            sosAlert alert = new sosAlert();
            User loggedInUser = null;
            
            // Try to get user from session or payload
            loggedInUser = (User) session.getAttribute("user");
            if (loggedInUser != null) {
                alert.setUserId(loggedInUser.getId());
                alert.setUserName(loggedInUser.getFullName());
                alert.setUserPhone(loggedInUser.getPhoneNumber());
            } else if (payload.containsKey("userId")) {
                Long uid = Long.parseLong(payload.get("userId"));
                loggedInUser = userRepository.findById(uid).orElse(null);
                if (loggedInUser != null) {
                    alert.setUserId(loggedInUser.getId());
                    alert.setUserName(loggedInUser.getFullName());
                    alert.setUserPhone(loggedInUser.getPhoneNumber());
                } else {
                    alert.setUserId(uid);
                    alert.setUserName("User #" + uid);
                    alert.setUserPhone("N/A");
                }
            } else {
                alert.setUserName("Guest User");
                alert.setUserPhone("N/A");
            }

            alert.setLatitude(payload.get("latitude"));
            alert.setLongitude(payload.get("longitude"));
            alert.setMessage(payload.getOrDefault("message", "SOS Alert Triggered!"));
            alert.setTimeOfActivation(LocalDateTime.now());
            alert.setStatus("ACTIVE");
            
            sosAlertRepository.save(alert);

            // === Send email to Emergency Contacts ===
            int emailsSent = 0;
            if (loggedInUser != null) {
                String mapsLink = "https://www.google.com/maps?q=" + alert.getLatitude() + "," + alert.getLongitude();
                List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(loggedInUser.getId());
                
                for (EmergencyContact contact : contacts) {
                    if (contact.getEmail() != null && !contact.getEmail().isEmpty()) {
                        try {
                            String emailBody = "🚨 EMERGENCY SOS ALERT 🚨\n\n"
                                + (alert.getUserName() != null ? alert.getUserName() : "A user") + " has triggered an emergency SOS!\n\n"
                                + "📍 Live Location: " + mapsLink + "\n\n"
                                + "📞 Contact: " + (alert.getUserPhone() != null ? alert.getUserPhone() : "N/A") + "\n\n"
                                + "⏰ Time: " + LocalDateTime.now() + "\n\n"
                                + "Please respond immediately and check on their safety.\n\n"
                                + "This is an automated emergency alert from the Women Safety App.";
                            
                            emailService.sendEmail(
                                contact.getEmail(),
                                "🚨 EMERGENCY SOS - " + (alert.getUserName() != null ? alert.getUserName() : "Someone") + " needs your help!",
                                emailBody
                            );
                            emailsSent++;
                        } catch (Exception e) {
                            System.err.println("Failed to email emergency contact: " + contact.getEmail() + " - " + e.getMessage());
                        }
                    }
                }
                alert.setEmergencyContactNotified(emailsSent > 0);
                sosAlertRepository.save(alert);
            }

            // === Push real-time WebSocket notification to Admin ===
            Map<String, Object> adminNotification = new HashMap<>();
            adminNotification.put("type", "NEW_SOS_ALERT");
            adminNotification.put("alertId", alert.getId());
            adminNotification.put("userName", alert.getUserName());
            adminNotification.put("userPhone", alert.getUserPhone());
            adminNotification.put("lat", alert.getLatitude());
            adminNotification.put("lng", alert.getLongitude());
            adminNotification.put("status", alert.getStatus());
            adminNotification.put("time", alert.getTimeOfActivation().toString());
            adminNotification.put("mapsLink", "https://www.google.com/maps?q=" + alert.getLatitude() + "," + alert.getLongitude());
            messagingTemplate.convertAndSend("/topic/admin-sos", adminNotification);

            // === Notify Nearby Volunteers ===
            double lat = Double.parseDouble(alert.getLatitude());
            double lng = Double.parseDouble(alert.getLongitude());
            List<User> nearbyVolunteers = sosService.findNearbyVolunteers(lat, lng, 5.0);
            int volunteersAlerted = 0;
            for (User volunteer : nearbyVolunteers) {
                if (loggedInUser != null && volunteer.getId().equals(loggedInUser.getId())) continue;
                
                Map<String, Object> volunteerPayload = new HashMap<>();
                volunteerPayload.put("type", "NEARBY_SOS");
                volunteerPayload.put("sosId", alert.getId());
                volunteerPayload.put("victimName", alert.getUserName());
                volunteerPayload.put("lat", lat);
                volunteerPayload.put("lng", lng);
                volunteerPayload.put("mapsLink", "https://www.google.com/maps?q=" + lat + "," + lng);
                
                messagingTemplate.convertAndSend("/topic/volunteer-alerts", volunteerPayload);
                volunteersAlerted++;
            }

            response.put("success", true);
            response.put("message", "SOS Alert triggered! " + emailsSent + " contact(s) emailed and " + volunteersAlerted + " volunteers notified.");
            response.put("alertId", alert.getId());
            response.put("emailsSent", emailsSent);
            response.put("volunteersAlerted", volunteersAlerted);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
}
