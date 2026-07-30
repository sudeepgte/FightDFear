package in.sp.main.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.JourneySession;
import in.sp.main.Entities.JourneyStatus;
import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.JourneySessionRepository;
import in.sp.main.Repository.TrustedContactRepository;

@Service
public class JourneyService {

    @Autowired
    private JourneySessionRepository journeyRepo;

    @Autowired
    private EmergencyContactRepository emergencyContactRepo;

    @Autowired
    private TrustedContactRepository trustedContactRepository;

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

        // Return quickly — emails go out in the background.
        final JourneySession saved = js;
        java.util.concurrent.CompletableFuture.runAsync(() ->
                sendJourneyEmail(saved, "Journey Started", "A Journey Safety Timer has been started."));

        return js;
    }

    public JourneySession active(User user) {
        return journeyRepo.findTop1ByUserAndStatusOrderByCreatedAtDesc(user, JourneyStatus.ACTIVE);
    }

    /** Active or recently alerted (overdue) session — useful for mobile restore UI. */
    public JourneySession activeOrAlerted(User user) {
        JourneySession active = active(user);
        if (active != null) return active;
        return journeyRepo.findTop1ByUserAndStatusOrderByCreatedAtDesc(user, JourneyStatus.ALERTED);
    }

    public JourneySession markSafe(User user) {
        JourneySession js = activeOrAlerted(user);
        if (js == null) return null;
        if (js.getStatus() != JourneyStatus.ACTIVE && js.getStatus() != JourneyStatus.ALERTED) {
            return null;
        }
        js.setStatus(JourneyStatus.SAFE);
        js = journeyRepo.save(js);

        final JourneySession saved = js;
        java.util.concurrent.CompletableFuture.runAsync(() ->
                sendJourneyEmail(saved, "User Reached Safely", "The user has checked-in and reached safely."));

        return js;
    }

    private void sendJourneyEmail(JourneySession js, String subject, String messagePrefix) {
        if (js.getUser() == null || js.getUser().getId() == null) return;

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

        Set<String> sent = new HashSet<>();
        List<EmergencyContact> emergency = emergencyContactRepo.findByUserId(js.getUser().getId());
        if (emergency != null) {
            for (EmergencyContact c : emergency) {
                sendIfNeeded(c.getEmail(), subject, sb.toString(), sent);
            }
        }
        List<TrustedContact> trusted = trustedContactRepository.findByUserId(js.getUser().getId());
        if (trusted != null) {
            for (TrustedContact c : trusted) {
                if (c.isCanReceiveEmail()) {
                    sendIfNeeded(c.getEmail(), subject, sb.toString(), sent);
                }
            }
        }
    }

    private void sendIfNeeded(String email, String subject, String body, Set<String> sent) {
        if (email == null || email.trim().isEmpty()) return;
        String key = email.trim().toLowerCase();
        if (!sent.add(key)) return;
        try {
            emailService.sendEmail(email.trim(), subject, body);
        } catch (Exception ignored) {
        }
    }

    public JourneySession cancel(User user) {
        JourneySession js = activeOrAlerted(user);
        if (js == null) return null;
        if (js.getStatus() != JourneyStatus.ACTIVE && js.getStatus() != JourneyStatus.ALERTED) {
            return null;
        }
        js.setStatus(JourneyStatus.CANCELLED);
        return journeyRepo.save(js);
    }

    public int alertOverdueJourneys() {
        Date now = new Date();
        List<JourneySession> overdue = journeyRepo.findByStatusAndExpectedArrivalAtBefore(JourneyStatus.ACTIVE, now);
        int alerted = 0;

        for (JourneySession js : overdue) {
            if (js.getAlertedAt() != null) continue;
            if (js.getUser() == null || js.getUser().getId() == null) continue;

            String subject = "Journey Safety Alert (No Check-in)";
            String body = buildEmailBody(js);
            Set<String> sent = new HashSet<>();

            List<EmergencyContact> contacts = emergencyContactRepo.findByUserId(js.getUser().getId());
            if (contacts != null) {
                for (EmergencyContact c : contacts) {
                    sendIfNeeded(c.getEmail(), subject, body, sent);
                }
            }
            List<TrustedContact> trusted = trustedContactRepository.findByUserId(js.getUser().getId());
            if (trusted != null) {
                for (TrustedContact c : trusted) {
                    if (c.isCanReceiveEmail()) {
                        sendIfNeeded(c.getEmail(), subject, body, sent);
                    }
                }
            }

            if (sent.isEmpty()) continue;

            js.setStatus(JourneyStatus.ALERTED);
            js.setAlertedAt(new Date());
            journeyRepo.save(js);
            alerted++;
        }

        return alerted;
    }

    private String buildEmailBody(JourneySession js) {
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
