package in.sp.main.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.FitnessBooking;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Repository.FitnessBookingRepository;
import in.sp.main.Repository.FitnessTrainerRepository;

@Service
public class FitnessCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 2 hours before the session. After that the fee is not refunded. Completed sessions cannot be cancelled.";

    @Autowired private FitnessBookingRepository bookingRepository;
    @Autowired private FitnessTrainerRepository trainerRepository;
    @Autowired private PushNotificationService pushNotificationService;

    public LocalDateTime sessionStart(FitnessBooking b) {
        if (b == null || b.getBookingDate() == null) return null;
        LocalTime t = LocalTime.of(10, 0);
        String raw = b.getBookingTime();
        if (raw != null && !raw.isBlank()) {
            String first = raw.split("[-–]")[0].trim();
            try {
                if (first.length() >= 5) t = LocalTime.parse(first.substring(0, 5));
            } catch (Exception ignored) {}
        }
        return LocalDateTime.of(b.getBookingDate(), t);
    }

    public boolean canCancel(FitnessBooking b) {
        if (b == null) return false;
        String st = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
        if ("CANCELLED".equals(st) || "COMPLETED".equals(st) || "REJECTED".equals(st)) return false;
        if ("PENDING".equals(st) && !"PAID".equalsIgnoreCase(b.getPaymentStatus())) return true;
        LocalDateTime start = sessionStart(b);
        if (start == null) return true;
        return LocalDateTime.now().plusHours(2).isBefore(start);
    }

    @Transactional
    public FitnessBooking cancel(FitnessBooking b) {
        if (b == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Booking not found");
        if (!canCancel(b)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        b.setStatus("CANCELLED");
        return bookingRepository.save(b);
    }

    @Transactional
    public void creditPayout(FitnessBooking b) {
        if (b == null || Boolean.TRUE.equals(b.getPayoutCredited())) return;
        FitnessTrainer trainer = b.getTrainer();
        if (trainer == null) return;
        double amount = b.getPaymentAmount() == null ? 0 : b.getPaymentAmount();
        if (amount <= 0) return;
        trainer.setPayoutBalance(trainer.getPayoutBalance() + amount);
        trainerRepository.save(trainer);
        b.setPayoutCredited(true);
        bookingRepository.save(b);
    }

    @Transactional
    public Map<String, Object> requestPayout(FitnessTrainer trainer) {
        if (trainer == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Trainer profile required");
        if (PartnerLifecycleSupport.blank(trainer.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = trainer.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        trainer.setPayoutRequestedAt(LocalDateTime.now());
        trainerRepository.save(trainer);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + trainer.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", trainer.getUpiId());
        return m;
    }

    public void notifyBooked(FitnessBooking b) {
        if (b == null || b.getUser() == null) return;
        try {
            pushNotificationService.notifyUser(
                    b.getUser().getId(),
                    "Fitness",
                    "Session booked. " + CANCEL_POLICY,
                    Map.of("type", "FITNESS", "bookingId", String.valueOf(b.getId())));
        } catch (Exception ignored) {}
    }
}
