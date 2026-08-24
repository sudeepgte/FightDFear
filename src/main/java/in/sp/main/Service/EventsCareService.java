package in.sp.main.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.EventHost;
import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Entities.WomenEventReview;
import in.sp.main.Repository.EventHostRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventReviewRepository;

@Service
public class EventsCareService {

    public static final String CANCEL_POLICY =
            "Unpaid tickets can be cancelled anytime. Paid tickets can be cancelled until 2 hours before start. Checked-in tickets cannot be cancelled.";

    @Autowired private WomenEventRegistrationRepository registrationRepository;
    @Autowired private EventHostRepository hostRepository;
    @Autowired private WomenEventReviewRepository reviewRepository;
    @Autowired private PushNotificationService pushNotificationService;

    public LocalDateTime eventStart(WomenEvent e) {
        if (e == null || e.getEventDate() == null) return null;
        LocalTime t = e.getEventTime() == null ? LocalTime.of(10, 0) : e.getEventTime();
        return LocalDateTime.of(e.getEventDate(), t);
    }

    public boolean canCancel(WomenEventRegistration r) {
        if (r == null) return false;
        String st = r.getStatus() == null ? "" : r.getStatus().toUpperCase(Locale.ROOT);
        if ("CANCELLED".equals(st) || "ATTENDED".equals(st) || r.isCheckedIn()) return false;
        if (!r.isPaid()) return true;
        LocalDateTime start = eventStart(r.getEvent());
        if (start == null) return true;
        return LocalDateTime.now().plusHours(2).isBefore(start);
    }

    public boolean canCancelHostEvent(WomenEvent e) {
        if (e == null) return false;
        String st = e.getStatus() == null ? "" : e.getStatus().toUpperCase(Locale.ROOT);
        if ("CANCELLED".equals(st) || "CANCELLED_BY_HOST".equals(st)) return false;
        LocalDateTime start = eventStart(e);
        if (start == null) return true;
        return LocalDateTime.now().plusHours(2).isBefore(start);
    }

    @Transactional
    public WomenEventRegistration cancel(WomenEventRegistration r) {
        if (r == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Registration not found");
        if (!canCancel(r)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        r.setStatus("CANCELLED");
        return registrationRepository.save(r);
    }

    @Transactional
    public void creditPayout(WomenEventRegistration r) {
        if (r == null || Boolean.TRUE.equals(r.getPayoutCredited())) return;
        EventHost host = hostOf(r);
        if (host == null) return;
        double amount = r.getAmountPaid() == null ? 0 : r.getAmountPaid();
        if (amount <= 0 && r.getEvent() != null && r.getEvent().getEntryFee() != null) {
            amount = r.getEvent().getEntryFee();
        }
        if (amount <= 0) return;
        host.setPayoutBalance(host.getPayoutBalance() + amount);
        hostRepository.save(host);
        r.setPayoutCredited(true);
        registrationRepository.save(r);
    }

    @Transactional
    public Map<String, Object> requestPayout(EventHost host) {
        if (host == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Host profile required");
        if (PartnerLifecycleSupport.blank(host.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = host.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        host.setPayoutRequestedAt(LocalDateTime.now());
        hostRepository.save(host);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + host.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", host.getUpiId());
        return m;
    }

    public boolean canReview(WomenEventRegistration r) {
        if (r == null || r.getEvent() == null || r.getUser() == null) return false;
        String st = r.getStatus() == null ? "" : r.getStatus().toUpperCase(Locale.ROOT);
        if ("CANCELLED".equals(st)) return false;
        if (reviewRepository.existsByEventAndUser(r.getEvent(), r.getUser())) return false;
        if ("ATTENDED".equals(st) || r.isCheckedIn()) return true;
        LocalDateTime start = eventStart(r.getEvent());
        return start != null && !LocalDateTime.now().isBefore(start);
    }

    @Transactional
    public WomenEventReview rate(WomenEventRegistration r, int rating, String reviewText) {
        if (r == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Registration not found");
        if (!canReview(r)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Review after you attend or after the event start time.");
        }
        User user = r.getUser();
        WomenEvent event = r.getEvent();
        if (reviewRepository.existsByEventAndUser(event, user)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already reviewed");
        }
        int stars = Math.max(1, Math.min(5, rating));
        WomenEventReview review = new WomenEventReview();
        review.setEvent(event);
        review.setUser(user);
        review.setRating(stars);
        review.setReviewText(reviewText);
        reviewRepository.save(review);
        EventHost host = hostOf(r);
        if (host != null) {
            List<WomenEventReview> all = reviewRepository.findAll().stream()
                    .filter(x -> x.getEvent() != null && x.getEvent().getOrganizer() != null
                            && host.getId().equals(x.getEvent().getOrganizer().getId())
                            && x.getRating() != null)
                    .toList();
            double avg = all.stream().mapToInt(WomenEventReview::getRating).average().orElse(stars);
            host.setRating(avg);
            host.setReviewCount(all.size());
            hostRepository.save(host);
        }
        return review;
    }

    public EventHost hostOf(WomenEventRegistration r) {
        if (r == null || r.getEvent() == null) return null;
        return r.getEvent().getOrganizer();
    }

    public double feeOf(WomenEvent e) {
        return e == null || e.getEntryFee() == null ? 0 : Math.max(0, e.getEntryFee());
    }

    public void notifyRegistered(WomenEventRegistration r) {
        if (r == null || r.getUser() == null) return;
        pushNotificationService.notifyUser(
                r.getUser().getId(),
                "Women Events",
                "You're registered. " + CANCEL_POLICY,
                Map.of("type", "WOMEN_EVENT", "registrationId", String.valueOf(r.getId())));
    }
}
