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

import in.sp.main.Entities.Booking1;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonFavorite;
import in.sp.main.Entities.SalonReview;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.User;
import in.sp.main.Repository.Booking1Repository;
import in.sp.main.Repository.SalonFavoriteRepository;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.SalonReviewRepository;

@Service
public class GlowCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 2 hours before the appointment. After that the fee is not refunded.";

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private Booking1Repository bookingRepository;
    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private SalonFavoriteRepository favoriteRepository;
    @Autowired
    private SalonReviewRepository reviewRepository;
    @Autowired
    private PushNotificationService pushNotificationService;

    @Scheduled(fixedDelay = 300000)
    @Transactional
    public void sendAppointmentReminders() {
        LocalDateTime now = LocalDateTime.now();
        for (Booking1 b : bookingRepository.findAll()) {
            if (Boolean.TRUE.equals(b.getReminder1hSent())) continue;
            String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
            if (!status.equals("PENDING") && !status.equals("CONFIRMED") && !status.equals("PAID")) continue;
            LocalDateTime start = appointmentStart(b);
            if (start == null) continue;
            if (start.isAfter(now.plusMinutes(45)) && start.isBefore(now.plusMinutes(75))) {
                b.setReminder1hSent(true);
                bookingRepository.save(b);
                if (b.getUser() != null) {
                    pushNotificationService.notifyUser(
                            b.getUser().getId(),
                            "Glow appointment in 1 hour",
                            reminderBody(b),
                            Map.of("type", "GLOW_REMINDER", "bookingId", String.valueOf(b.getId())));
                }
            }
        }
    }

    public LocalDateTime appointmentStart(Booking1 b) {
        if (b == null || b.getBookingDate() == null) return null;
        LocalTime t = b.getPreferredTime() == null ? LocalTime.of(10, 0) : b.getPreferredTime();
        return LocalDateTime.of(b.getBookingDate(), t);
    }

    public boolean canCancelFree(Booking1 b) {
        LocalDateTime start = appointmentStart(b);
        if (start == null) return false;
        String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
        if (status.equals("COMPLETED") || status.equals("CANCELLED") || status.equals("REJECTED")) return false;
        return LocalDateTime.now().isBefore(start.minusHours(2));
    }

    public boolean joinWindowOpen(Booking1 b) {
        LocalDateTime start = appointmentStart(b);
        if (start == null) return false;
        LocalDateTime now = LocalDateTime.now();
        return !now.isBefore(start.minusMinutes(15)) && !now.isAfter(start.plusMinutes(15));
    }

    public boolean slotTaken(Salon salon, LocalDate date, LocalTime time, Long excludeBookingId) {
        if (salon == null || date == null || time == null) return false;
        List<Booking1> sameDay = bookingRepository.findBySalonAndBookingDate(salon, date);
        for (Booking1 existing : sameDay) {
            if (excludeBookingId != null && existing.getId() != null && existing.getId().equals(excludeBookingId)) {
                continue;
            }
            String st = existing.getStatus() == null ? "" : existing.getStatus().toUpperCase(Locale.ROOT);
            if (st.equals("CANCELLED") || st.equals("REJECTED")) continue;
            if (existing.getPreferredTime() != null && existing.getPreferredTime().equals(time)) {
                return true;
            }
        }
        return false;
    }

    public boolean isOpenOn(Salon salon, LocalDate date) {
        if (salon == null || date == null) return false;
        if (isBlocked(salon, date)) return false;
        String days = salon.getOpenDays();
        if (days == null || days.isBlank()) return true;
        String wanted = date.getDayOfWeek().name().substring(0, 3);
        for (String part : days.split("[,|]")) {
            String p = part.trim().toUpperCase(Locale.ROOT);
            if (p.startsWith(wanted) || wanted.startsWith(p) || p.equals(date.getDayOfWeek().name())) {
                return true;
            }
        }
        return days.toUpperCase(Locale.ROOT).contains(wanted);
    }

    public boolean isBlocked(Salon salon, LocalDate date) {
        if (salon == null || date == null || salon.getBlockedDates() == null) return false;
        String key = date.toString();
        for (String part : salon.getBlockedDates().split("[,|]")) {
            if (key.equals(part.trim())) return true;
        }
        return false;
    }

    public boolean availableToday(Salon salon) {
        return nextSlot(salon) != null && LocalDate.now().equals(nextSlotDate(salon));
    }

    public LocalDate nextSlotDate(Salon salon) {
        LocalDate d = LocalDate.now();
        for (int i = 0; i < 14; i++) {
            LocalDate day = d.plusDays(i);
            if (isOpenOn(salon, day) && !slotsFor(salon, day, 30).isEmpty()) {
                return day;
            }
        }
        return null;
    }

    public Map<String, Object> nextSlot(Salon salon) {
        LocalDate day = nextSlotDate(salon);
        if (day == null) return null;
        List<String> slots = slotsFor(salon, day, 30);
        if (slots.isEmpty()) return null;
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("date", day.toString());
        m.put("time", slots.get(0));
        m.put("label", day.equals(LocalDate.now()) ? "Today " + slots.get(0) : day + " " + slots.get(0));
        return m;
    }

    public List<String> slotsFor(Salon salon, LocalDate date, int durationMinutes) {
        List<String> out = new ArrayList<>();
        if (salon == null || date == null || !isOpenOn(salon, date)) return out;
        LocalTime open = salon.getOpenTime() == null ? LocalTime.of(10, 0) : salon.getOpenTime();
        LocalTime close = salon.getCloseTime() == null ? LocalTime.of(19, 0) : salon.getCloseTime();
        int step = Math.max(15, durationMinutes);
        LocalTime t = open;
        List<Booking1> booked = bookingRepository.findBySalonAndBookingDate(salon, date);
        while (!t.plusMinutes(durationMinutes).isAfter(close)) {
            if (!inBreak(salon, t) && !timeBooked(booked, t)) {
                if (!(date.equals(LocalDate.now()) && t.isBefore(LocalTime.now()))) {
                    out.add(t.format(TIME_FMT));
                }
            }
            t = t.plusMinutes(step);
            if (out.size() >= 24) break;
        }
        return out;
    }

    private boolean inBreak(Salon salon, LocalTime t) {
        if (salon.getBreakStart() == null || salon.getBreakEnd() == null) return false;
        return !t.isBefore(salon.getBreakStart()) && t.isBefore(salon.getBreakEnd());
    }

    private boolean timeBooked(List<Booking1> booked, LocalTime t) {
        for (Booking1 b : booked) {
            String st = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
            if (st.equals("CANCELLED") || st.equals("REJECTED")) continue;
            if (b.getPreferredTime() != null && b.getPreferredTime().equals(t)) return true;
        }
        return false;
    }

    @Transactional
    public void creditPayout(Salon salon, double amount) {
        if (salon == null || amount <= 0) return;
        salon.setPayoutBalance(salon.getPayoutBalance() + amount);
        salonRepository.save(salon);
    }

    @Transactional
    public Map<String, Object> requestPayout(Salon salon) {
        if (salon == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Salon required");
        if (PartnerLifecycleSupport.blank(salon.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = salon.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        salon.setPayoutRequestedAt(LocalDateTime.now());
        salonRepository.save(salon);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + salon.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", salon.getUpiId());
        return m;
    }

    @Transactional
    public boolean toggleFavorite(User user, Long salonId) {
        if (user == null || salonId == null) return false;
        var existing = favoriteRepository.findByUserIdAndSalonId(user.getId(), salonId);
        if (existing.isPresent()) {
            favoriteRepository.delete(existing.get());
            return false;
        }
        SalonFavorite f = new SalonFavorite();
        f.setUserId(user.getId());
        f.setSalonId(salonId);
        f.setCreatedAt(LocalDateTime.now());
        favoriteRepository.save(f);
        return true;
    }

    public boolean isFavorite(User user, Long salonId) {
        if (user == null || salonId == null) return false;
        return favoriteRepository.existsByUserIdAndSalonId(user.getId(), salonId);
    }

    public List<SalonFavorite> favoritesFor(User user) {
        if (user == null) return List.of();
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(user.getId());
    }

    @Transactional
    public SalonReview addReview(User user, Salon salon, int rating, String comment) {
        if (user == null || salon == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Login required");
        }
        if (rating < 1 || rating > 5) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rating must be 1–5");
        }
        SalonReview r = new SalonReview();
        r.setSalon(salon);
        r.setUserId(user.getId());
        r.setUserName(user.getFullName() == null || user.getFullName().isBlank() ? "Member" : user.getFullName());
        r.setRating(rating);
        r.setComment(comment == null ? "" : comment.trim());
        r.setCreatedAt(LocalDateTime.now());
        reviewRepository.save(r);
        refreshSalonRating(salon);
        return r;
    }

    public List<SalonReview> reviewsFor(Long salonId) {
        return reviewRepository.findBySalonIdOrderByCreatedAtDesc(salonId);
    }

    private void refreshSalonRating(Salon salon) {
        List<SalonReview> all = reviewRepository.findBySalon(salon);
        if (all == null || all.isEmpty()) return;
        double avg = all.stream().mapToInt(SalonReview::getRating).average().orElse(0);
        salon.setRating(Math.round(avg * 10.0) / 10.0);
        salonRepository.save(salon);
    }

    public Map<String, Object> reviewDto(SalonReview r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.getId());
        m.put("userName", r.getUserName());
        m.put("rating", r.getRating());
        m.put("comment", r.getComment());
        m.put("createdAt", r.getCreatedAt() == null ? null : r.getCreatedAt().toString());
        m.put("reply", r.getReply());
        return m;
    }

    public int startingFee(Salon salon, List<Service1> services) {
        if (services == null || services.isEmpty()) return 0;
        return services.stream()
                .filter(s -> s.getPrice() != null)
                .mapToInt(s -> (int) Math.round(s.getPrice()))
                .min()
                .orElse(0);
    }

    private String reminderBody(Booking1 b) {
        String salon = b.getSalon() == null ? "your salon" : b.getSalon().getName();
        String item = b.getService() == null ? "appointment" : b.getService().getName();
        String time = b.getPreferredTime() == null ? "" : b.getPreferredTime().toString();
        return item + " at " + salon + (time.isBlank() ? "" : " at " + time);
    }
}
