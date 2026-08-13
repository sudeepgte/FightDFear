package in.sp.main.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import net.javacrumbs.shedlock.spring.annotation.SchedulerLock;

import in.sp.main.Entities.LawyerFavorite;
import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ProviderBookingStatus;
import in.sp.main.Entities.ProviderReview;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.User;
import in.sp.main.Repository.LawyerFavoriteRepository;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.ProviderReviewRepository;
import in.sp.main.Repository.ServiceProviderRepository;

@Service
public class WomenLawyerCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 2 hours before the consult. After that the fee is not refunded.";

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private ProviderBookingRepository bookingRepository;
    @Autowired
    private ServiceProviderRepository providerRepository;
    @Autowired
    private LawyerFavoriteRepository favoriteRepository;
    @Autowired
    private ProviderReviewRepository reviewRepository;
    @Autowired
    private PushNotificationService pushNotificationService;

    @Scheduled(fixedDelay = 300000)
    @SchedulerLock(name = "WomenLawyerCareService_sendConsultReminders", lockAtLeastFor = "4m", lockAtMostFor = "10m")
    @Transactional
    public void sendConsultReminders() {
        LocalDateTime now = LocalDateTime.now();
        List<ProviderBookingStatus> statuses = List.of(
                ProviderBookingStatus.PENDING, ProviderBookingStatus.CONFIRMED, ProviderBookingStatus.PAID);
        for (ProviderBooking b : bookingRepository.findByStatusInAndRequestedTimeBetween(
                statuses, now.plusMinutes(45), now.plusMinutes(75))) {
            if (Boolean.TRUE.equals(b.getReminder1hSent())) continue;
            LocalDateTime start = b.getRequestedTime();
            if (start == null) continue;
            if (start.isAfter(now.plusMinutes(45)) && start.isBefore(now.plusMinutes(75))) {
                b.setReminder1hSent(true);
                bookingRepository.save(b);
                if (b.getUser() != null) {
                    String lawyer = b.getProvider() == null ? "your lawyer" : b.getProvider().getFullName();
                    pushNotificationService.notifyUser(
                            b.getUser().getId(),
                            "Legal consult in 1 hour",
                            "Consult with " + lawyer,
                            Map.of("type", "LAWYER_REMINDER", "bookingId", String.valueOf(b.getId())));
                }
            }
        }
    }

    public boolean canCancelFree(ProviderBooking b) {
        if (b == null || b.getRequestedTime() == null) return false;
        ProviderBookingStatus st = b.getStatus();
        if (st == ProviderBookingStatus.COMPLETED || st == ProviderBookingStatus.CANCELLED) return false;
        return LocalDateTime.now().isBefore(b.getRequestedTime().minusHours(2));
    }

    public boolean isOpenOn(ServiceProvider p, LocalDate date) {
        if (p == null || date == null) return true;
        if (isBlocked(p, date)) return false;
        String days = p.getOpenDays();
        if (days == null || days.isBlank()) return true;
        String wanted = date.getDayOfWeek().name().substring(0, 3);
        return days.toUpperCase(Locale.ROOT).contains(wanted);
    }

    public boolean isBlocked(ServiceProvider p, LocalDate date) {
        if (p == null || date == null || p.getBlockedDates() == null) return false;
        String key = date.toString();
        for (String part : p.getBlockedDates().split("[,|]")) {
            if (key.equals(part.trim())) return true;
        }
        return false;
    }

    public List<String> slotsFor(ServiceProvider p, LocalDate date, int durationMinutes) {
        List<String> out = new ArrayList<>();
        if (p == null || date == null || !isOpenOn(p, date)) return out;
        LocalTime open = p.getOpenTime() == null ? LocalTime.of(10, 0) : p.getOpenTime();
        LocalTime close = p.getCloseTime() == null ? LocalTime.of(18, 0) : p.getCloseTime();
        int step = Math.max(30, durationMinutes <= 0 ? 60 : durationMinutes);
        LocalTime t = open;
        List<ProviderBooking> booked = bookingRepository.findByProviderOrderByRequestedTimeDesc(p);
        while (!t.plusMinutes(step).isAfter(close)) {
            if (!inBreak(p, t) && !timeBooked(booked, date, t)) {
                if (!(date.equals(LocalDate.now()) && t.isBefore(LocalTime.now()))) {
                    out.add(t.format(TIME_FMT));
                }
            }
            t = t.plusMinutes(step);
            if (out.size() >= 24) break;
        }
        return out;
    }

    public Map<String, Object> nextSlot(ServiceProvider p) {
        LocalDate d = LocalDate.now();
        int dur = p.getDurationMinutes() == null ? 60 : p.getDurationMinutes();
        for (int i = 0; i < 14; i++) {
            LocalDate day = d.plusDays(i);
            List<String> slots = slotsFor(p, day, dur);
            if (!slots.isEmpty()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("date", day.toString());
                m.put("time", slots.get(0));
                m.put("label", day.equals(LocalDate.now()) ? "Today " + slots.get(0) : day + " " + slots.get(0));
                return m;
            }
        }
        return null;
    }

    public boolean availableToday(ServiceProvider p) {
        Map<String, Object> next = nextSlot(p);
        return next != null && LocalDate.now().toString().equals(String.valueOf(next.get("date")));
    }

    private boolean inBreak(ServiceProvider p, LocalTime t) {
        if (p.getBreakStart() == null || p.getBreakEnd() == null) return false;
        return !t.isBefore(p.getBreakStart()) && t.isBefore(p.getBreakEnd());
    }

    private boolean timeBooked(List<ProviderBooking> booked, LocalDate date, LocalTime t) {
        LocalDateTime slot = LocalDateTime.of(date, t);
        for (ProviderBooking b : booked) {
            if (b.getStatus() == ProviderBookingStatus.CANCELLED) continue;
            if (b.getRequestedTime() != null
                    && Math.abs(java.time.Duration.between(b.getRequestedTime(), slot).toMinutes()) < 60) {
                return true;
            }
        }
        return false;
    }

    @Transactional
    public void creditPayout(ServiceProvider p, double amount) {
        if (p == null || amount <= 0) return;
        p.setPayoutBalance(p.getPayoutBalance() + amount);
        providerRepository.save(p);
    }

    @Transactional
    public Map<String, Object> requestPayout(ServiceProvider p) {
        if (p == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Lawyer profile required");
        if (PartnerLifecycleSupport.blank(p.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = p.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        p.setPayoutRequestedAt(LocalDateTime.now());
        providerRepository.save(p);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + p.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", p.getUpiId());
        return m;
    }

    @Transactional
    public boolean toggleFavorite(User user, Long providerId) {
        if (user == null || providerId == null) return false;
        var existing = favoriteRepository.findByUserIdAndProviderId(user.getId(), providerId);
        if (existing.isPresent()) {
            favoriteRepository.delete(existing.get());
            return false;
        }
        LawyerFavorite f = new LawyerFavorite();
        f.setUserId(user.getId());
        f.setProviderId(providerId);
        f.setCreatedAt(LocalDateTime.now());
        favoriteRepository.save(f);
        return true;
    }

    public boolean isFavorite(User user, Long providerId) {
        if (user == null || providerId == null) return false;
        return favoriteRepository.existsByUserIdAndProviderId(user.getId(), providerId);
    }

    public List<LawyerFavorite> favoritesFor(User user) {
        if (user == null) return List.of();
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(user.getId());
    }

    @Transactional
    public ProviderReview addReview(User user, ServiceProvider p, int rating, String comment) {
        if (user == null || p == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Login required");
        }
        if (rating < 1 || rating > 5) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rating must be 1–5");
        }
        ProviderReview r = new ProviderReview();
        r.setProvider(p);
        r.setUser(user);
        r.setRating(rating);
        r.setComment(comment == null ? "" : comment.trim());
        r.setCreatedAt(LocalDateTime.now());
        reviewRepository.save(r);
        List<ProviderReview> all = reviewRepository.findByProviderIdOrderByCreatedAtDesc(p.getId());
        double avg = all.stream().mapToInt(x -> x.getRating() == null ? 0 : x.getRating()).average().orElse(0);
        p.setRating(Math.round(avg * 10.0) / 10.0);
        providerRepository.save(p);
        return r;
    }

    @Transactional
    public ProviderBooking cancelBooking(User user, Long bookingId, String reason) {
        ProviderBooking b = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Booking not found"));
        boolean client = b.getUser() != null && user != null && b.getUser().getId().equals(user.getId());
        boolean lawyer = b.getProvider() != null && user != null
                && b.getProvider().getEmail() != null
                && b.getProvider().getEmail().equalsIgnoreCase(user.getEmail());
        if (!client && !lawyer) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your booking");
        }
        ProviderBookingStatus st = b.getStatus() == null ? ProviderBookingStatus.PENDING : b.getStatus();
        if (st == ProviderBookingStatus.COMPLETED || st == ProviderBookingStatus.CANCELLED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This consult cannot be cancelled.");
        }
        if (client && !canCancelFree(b) && (st == ProviderBookingStatus.CONFIRMED || st == ProviderBookingStatus.PAID)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        b.setStatus(ProviderBookingStatus.CANCELLED);
        b.setCancelReason(reason == null ? "" : reason.trim());
        return bookingRepository.save(b);
    }
}
