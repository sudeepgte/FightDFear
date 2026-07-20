package in.sp.main.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.JourneySession;
import in.sp.main.Entities.JourneyStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.JourneySessionRepository;

@Service
public class JourneyService {

    @Autowired
    private JourneySessionRepository journeyRepo;

    @Autowired
    private EmergencyContactRepository emergencyContactRepo;

    @Autowired
    private EmailService emailService;

    public JourneySession start(User user, String destination, String startFrom, Date expectedArrivalAt, Double startLat, Double startLng) {
        // Purpose: prevent multiple active sessions; cancel old one if still active.
        JourneySession existing = journeyRepo.findTop1ByUserAndStatusOrderByCreatedAtDesc(user, JourneyStatus.ACTIVE);
        if (existing != null) {
            existing.setStatus(JourneyStatus.CANCELLED);
            journeyRepo.save(existing);
        }

        JourneySession js = new JourneySession();
        js.setUser(user);
        js.setDestinationText(destination == null ? "" : destination.trim());
        js.setStartFromText(startFrom == null ? "" : startFrom.trim());
        js.setExpectedArrivalAt(expectedArrivalAt);
        js.setStartLat(startLat);
        js.setStartLng(startLng);
        js.setStatus(JourneyStatus.ACTIVE);
        js.setCreatedAt(new Date());
        js = journeyRepo.save(js);

        // Send start email to emergency contacts
        sendJourneyEmail(js, "Journey Started", "A Journey Safety Timer has been started.");

        return js;
    }

    public JourneySession active(User user) {
        return journeyRepo.findTop1ByUserAndStatusOrderByCreatedAtDesc(user, JourneyStatus.ACTIVE);
    }

    public JourneySession markSafe(User user) {
        JourneySession js = active(user);
        if (js == null) return null;
        js.setStatus(JourneyStatus.SAFE);
        js = journeyRepo.save(js);

        // Send safe email to emergency contacts
        sendJourneyEmail(js, "User Reached Safely", "The user has checked-in and reached safely.");

        return js;
    }

    private void sendJourneyEmail(JourneySession js, String subject, String messagePrefix) {
        if (js.getUser() == null || js.getUser().getId() == null) return;
        List<EmergencyContact> contacts = emergencyContactRepo.findByUserId(js.getUser().getId());
        if (contacts == null || contacts.isEmpty()) return;

        SimpleDateFormat fmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
        String expected = (js.getExpectedArrivalAt() == null) ? "-" : fmt.format(js.getExpectedArrivalAt());

        StringBuilder sb = new StringBuilder();
        sb.append(messagePrefix).append("\n\n");
        sb.append("User: ").append(js.getUser().getFullName()).append("\n");
        sb.append("Start from: ").append(js.getStartFromText() == null ? "-" : js.getStartFromText()).append("\n");
        sb.append("Destination: ").append(js.getDestinationText()).append("\n");
        sb.append("Expected arrival: ").append(expected).append("\n");
        if (js.getStartLat() != null && js.getStartLng() != null) {
            sb.append("Start location: ").append(js.getStartLat()).append(", ").append(js.getStartLng()).append("\n");
        }

        for (EmergencyContact c : contacts) {
            if (c.getEmail() != null && !c.getEmail().trim().isEmpty()) {
                try {
                    emailService.sendEmail(c.getEmail().trim(), subject, sb.toString());
                } catch (Exception ignored) {}
            }
        }
    }

    public JourneySession cancel(User user) {
        JourneySession js = active(user);
        if (js == null) return null;
        js.setStatus(JourneyStatus.CANCELLED);
        return journeyRepo.save(js);
    }

    public int alertOverdueJourneys() {
        // Purpose: periodically alert emergency contacts for overdue journeys.
        Date now = new Date();
        List<JourneySession> overdue = journeyRepo.findByStatusAndExpectedArrivalAtBefore(JourneyStatus.ACTIVE, now);
        int alerted = 0;

        for (JourneySession js : overdue) {
            if (js.getAlertedAt() != null) continue; // Purpose: alert only once.
            if (js.getUser() == null || js.getUser().getId() == null) continue;

            List<EmergencyContact> contacts = emergencyContactRepo.findByUserId(js.getUser().getId());
            if (contacts == null || contacts.isEmpty()) continue;

            String subject = "Journey Safety Alert (No Check-in)";
            String body = buildEmailBody(js);

            for (EmergencyContact c : contacts) {
                // Purpose: send email alerts where email is available.
                if (c.getEmail() != null && !c.getEmail().trim().isEmpty()) {
                    try {
                        emailService.sendEmail(c.getEmail().trim(), subject, body);
                    } catch (Exception ignored) {
                        // Purpose: best-effort; don't block other recipients.
                    }
                }
            }

            js.setStatus(JourneyStatus.ALERTED);
            js.setAlertedAt(new Date());
            journeyRepo.save(js);
            alerted++;
        }

        return alerted;
    }

    private String buildEmailBody(JourneySession js) {
        // Purpose: provide enough info for emergency contact without exposing excessive detail.
        SimpleDateFormat fmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
        String expected = (js.getExpectedArrivalAt() == null) ? "-" : fmt.format(js.getExpectedArrivalAt());

        StringBuilder sb = new StringBuilder();
        sb.append("A Journey Safety Timer was started but not checked-in on time.\n\n");
        sb.append("User: ").append(js.getUser() != null ? js.getUser().getFullName() : "Unknown").append("\n");
        sb.append("Start from: ").append(js.getStartFromText() == null ? "-" : js.getStartFromText()).append("\n");
        sb.append("Destination: ").append(js.getDestinationText() == null ? "-" : js.getDestinationText()).append("\n");
        sb.append("Expected arrival: ").append(expected).append("\n");
        if (js.getStartLat() != null && js.getStartLng() != null) {
            sb.append("Last known start location (approx): ").append(js.getStartLat()).append(", ").append(js.getStartLng()).append("\n");
        }
        sb.append("\nPlease try contacting them immediately.\n");
        return sb.toString();
    }
}

