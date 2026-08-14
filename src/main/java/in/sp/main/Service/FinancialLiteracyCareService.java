package in.sp.main.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.FinancialEnrollment;
import in.sp.main.Entities.FinancialLiveSession;
import in.sp.main.Entities.FinancialWorkshop;
import in.sp.main.Repository.FinancialEducatorRepository;
import in.sp.main.Repository.FinancialEnrollmentRepository;

@Service
public class FinancialLiteracyCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 2 hours before the session. After that the fee is not refunded.";

    @Autowired private FinancialEnrollmentRepository enrollmentRepository;
    @Autowired private FinancialEducatorRepository educatorRepository;
    @Autowired private PushNotificationService pushNotificationService;

    public LocalDateTime sessionStart(FinancialEnrollment e) {
        if (e == null) return null;
        String date = null;
        String time = null;
        if (e.getLiveSession() != null) {
            date = e.getLiveSession().getDate();
            time = e.getLiveSession().getTime();
        } else if (e.getWorkshop() != null) {
            date = e.getWorkshop().getDate();
            time = e.getWorkshop().getTime();
        }
        return parseStart(date, time);
    }

    public boolean canCancel(FinancialEnrollment e) {
        if (e == null) return false;
        String st = e.getStatus() == null ? "" : e.getStatus().toLowerCase(Locale.ROOT);
        if ("cancelled".equals(st) || "completed".equals(st) || "rejected".equals(st)) return false;
        if ("pending".equals(st)) return true;
        LocalDateTime start = sessionStart(e);
        if (start == null) return true;
        return LocalDateTime.now().plusHours(2).isBefore(start);
    }

    @Transactional
    public FinancialEnrollment cancel(FinancialEnrollment e) {
        if (e == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Registration not found");
        if (!canCancel(e)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        e.setStatus("cancelled");
        return enrollmentRepository.save(e);
    }

    @Transactional
    public void creditPayout(FinancialEnrollment e) {
        if (e == null || Boolean.TRUE.equals(e.getPayoutCredited())) return;
        FinancialEducator educator = educatorOf(e);
        if (educator == null) return;
        double amount = e.getAmount() == null ? 0 : e.getAmount();
        if (amount <= 0) return;
        educator.setPayoutBalance(educator.getPayoutBalance() + amount);
        educatorRepository.save(educator);
        e.setPayoutCredited(true);
        e.setPaymentStatus("PAID");
        enrollmentRepository.save(e);
    }

    @Transactional
    public Map<String, Object> requestPayout(FinancialEducator educator) {
        if (educator == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Educator profile required");
        if (PartnerLifecycleSupport.blank(educator.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = educator.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        educator.setPayoutRequestedAt(LocalDateTime.now());
        educatorRepository.save(educator);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + educator.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", educator.getUpiId());
        return m;
    }

    @Transactional
    public FinancialEnrollment rate(FinancialEnrollment e, int rating, String review) {
        if (e == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Registration not found");
        if (!"completed".equalsIgnoreCase(e.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Review after the session is completed.");
        }
        if (e.getRating() != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already reviewed");
        }
        int stars = Math.max(1, Math.min(5, rating));
        e.setRating(stars);
        e.setReview(review);
        enrollmentRepository.save(e);
        FinancialEducator educator = educatorOf(e);
        if (educator != null) {
            Long eid = educator.getId();
            List<FinancialEnrollment> all = enrollmentRepository.findAll().stream()
                    .filter(x -> {
                        FinancialEducator ed = educatorOf(x);
                        return ed != null && eid.equals(ed.getId()) && x.getRating() != null;
                    })
                    .toList();
            double avg = all.stream().mapToInt(FinancialEnrollment::getRating).average().orElse(stars);
            educator.setRating(avg);
            educator.setReviewCount(all.size());
            educatorRepository.save(educator);
        }
        return e;
    }

    public FinancialEducator educatorOf(FinancialEnrollment e) {
        if (e == null) return null;
        if (e.getLiveSession() != null) return e.getLiveSession().getEducator();
        if (e.getWorkshop() != null) return e.getWorkshop().getEducator();
        return null;
    }

    public double feeOf(FinancialEnrollment e) {
        if (e == null) return 0;
        if (e.getAmount() != null && e.getAmount() > 0) return e.getAmount();
        if (e.getLiveSession() != null) return e.getLiveSession().getFee();
        if (e.getWorkshop() != null) return e.getWorkshop().getFee();
        return 0;
    }

    public double feeOf(FinancialLiveSession s) {
        return s == null || s.getFee() == null ? 0 : Math.max(0, s.getFee());
    }

    public double feeOf(FinancialWorkshop w) {
        return w == null || w.getFee() == null ? 0 : Math.max(0, w.getFee());
    }

    public void notifyRegistered(FinancialEnrollment e) {
        if (e == null || e.getUser() == null) return;
        pushNotificationService.notifyUser(
                e.getUser().getId(),
                "Financial Literacy",
                "You're registered. " + CANCEL_POLICY,
                Map.of("type", "FINANCIAL_ENROLL", "enrollmentId", String.valueOf(e.getId())));
    }

    private static LocalDateTime parseStart(String date, String time) {
        if (date == null || date.isBlank()) return null;
        LocalDate d = null;
        for (DateTimeFormatter f : List.of(
                DateTimeFormatter.ISO_LOCAL_DATE,
                DateTimeFormatter.ofPattern("dd-MM-yyyy"),
                DateTimeFormatter.ofPattern("dd/MM/yyyy"))) {
            try { d = LocalDate.parse(date.trim(), f); break; } catch (Exception ignored) {}
        }
        if (d == null) return null;
        LocalTime t = LocalTime.of(10, 0);
        if (time != null && !time.isBlank()) {
            String raw = time.trim();
            try {
                if (raw.length() >= 5) t = LocalTime.parse(raw.substring(0, 5));
            } catch (Exception ignored) {}
        }
        return LocalDateTime.of(d, t);
    }
}
