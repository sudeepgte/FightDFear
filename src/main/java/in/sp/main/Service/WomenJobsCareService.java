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

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.JobWorkerFavorite;
import in.sp.main.Entities.JobWorkerReview;
import in.sp.main.Entities.User;
import in.sp.main.Entities.WorkerBooking;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Repository.JobWorkerFavoriteRepository;
import in.sp.main.Repository.JobWorkerReviewRepository;
import in.sp.main.Repository.WorkerBookingRepository;

@Service
public class WomenJobsCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 2 hours before the visit. After that the fee is not refunded.";

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private WorkerBookingRepository bookingRepository;
    @Autowired
    private JobApplicationRepository jobAppRepository;
    @Autowired
    private JobWorkerFavoriteRepository favoriteRepository;
    @Autowired
    private JobWorkerReviewRepository reviewRepository;
    @Autowired
    private PushNotificationService pushNotificationService;

    @Scheduled(fixedDelay = 300000)
    @SchedulerLock(name = "WomenJobsCareService_sendVisitReminders", lockAtLeastFor = "4m", lockAtMostFor = "10m")
    @Transactional
    public void sendVisitReminders() {
        LocalDateTime now = LocalDateTime.now();
        for (WorkerBooking b : bookingRepository.findByBookingDateBetween(
                now.plusMinutes(45), now.plusMinutes(75))) {
            if (Boolean.TRUE.equals(b.getReminder1hSent())) continue;
            String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
            if (!status.equals("PENDING") && !status.equals("ACCEPTED") && !status.equals("PAID") && !status.equals("CONFIRMED")) {
                continue;
            }
            LocalDateTime start = b.getBookingDate();
            if (start == null) continue;
            if (start.isAfter(now.plusMinutes(45)) && start.isBefore(now.plusMinutes(75))) {
                b.setReminder1hSent(true);
                bookingRepository.save(b);
                if (b.getClient() != null) {
                    pushNotificationService.notifyUser(
                            b.getClient().getId(),
                            "Women Jobs visit in 1 hour",
                            reminderBody(b),
                            Map.of("type", "JOB_REMINDER", "bookingId", String.valueOf(b.getId())));
                }
            }
        }
    }

    public boolean canCancelFree(WorkerBooking b) {
        if (b == null || b.getBookingDate() == null) return false;
        String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
        if (status.equals("COMPLETED") || status.equals("CANCELLED") || status.equals("REJECTED")) return false;
        return LocalDateTime.now().isBefore(b.getBookingDate().minusHours(2));
    }

    public boolean joinWindowOpen(WorkerBooking b) {
        if (b == null || b.getBookingDate() == null) return false;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start = b.getBookingDate();
        return !now.isBefore(start.minusMinutes(15)) && !now.isAfter(start.plusMinutes(15));
    }

    public boolean isOpenOn(JobApplication app, LocalDate date) {
        if (app == null || date == null) return true;
        if (isBlocked(app, date)) return false;
        String days = app.getOpenDays();
        if (days == null || days.isBlank()) return true;
        String wanted = date.getDayOfWeek().name().substring(0, 3);
        return days.toUpperCase(Locale.ROOT).contains(wanted);
    }

    public boolean isBlocked(JobApplication app, LocalDate date) {
        if (app == null || date == null || app.getBlockedDates() == null) return false;
        String key = date.toString();
        for (String part : app.getBlockedDates().split("[,|]")) {
            if (key.equals(part.trim())) return true;
        }
        return false;
    }

    public List<String> slotsFor(JobApplication app, LocalDate date, int durationMinutes) {
        List<String> out = new ArrayList<>();
        if (app == null || date == null || !isOpenOn(app, date)) return out;
        LocalTime open = app.getOpenTime() == null ? LocalTime.of(9, 0) : app.getOpenTime();
        LocalTime close = app.getCloseTime() == null ? LocalTime.of(18, 0) : app.getCloseTime();
        int step = Math.max(30, durationMinutes <= 0 ? 60 : durationMinutes);
        LocalTime t = open;
        List<WorkerBooking> booked = bookingRepository.findByJobApplication_Id(app.getId());
        while (!t.plusMinutes(step).isAfter(close)) {
            if (!inBreak(app, t) && !timeBooked(booked, date, t)) {
                if (!(date.equals(LocalDate.now()) && t.isBefore(LocalTime.now()))) {
                    out.add(t.format(TIME_FMT));
                }
            }
            t = t.plusMinutes(step);
            if (out.size() >= 24) break;
        }
        return out;
    }

    public Map<String, Object> nextSlot(JobApplication app) {
        LocalDate d = LocalDate.now();
        int dur = app.getDurationMinutes() == null ? 60 : app.getDurationMinutes();
        for (int i = 0; i < 14; i++) {
            LocalDate day = d.plusDays(i);
            List<String> slots = slotsFor(app, day, dur);
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

    public boolean availableToday(JobApplication app) {
        Map<String, Object> next = nextSlot(app);
        return next != null && LocalDate.now().toString().equals(String.valueOf(next.get("date")));
    }

    private boolean inBreak(JobApplication app, LocalTime t) {
        if (app.getBreakStart() == null || app.getBreakEnd() == null) return false;
        return !t.isBefore(app.getBreakStart()) && t.isBefore(app.getBreakEnd());
    }

    private boolean timeBooked(List<WorkerBooking> booked, LocalDate date, LocalTime t) {
        LocalDateTime slot = LocalDateTime.of(date, t);
        for (WorkerBooking b : booked) {
            String st = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
            if (st.equals("CANCELLED") || st.equals("REJECTED")) continue;
            if (b.getBookingDate() != null && Math.abs(java.time.Duration.between(b.getBookingDate(), slot).toMinutes()) < 60) {
                return true;
            }
        }
        return false;
    }

    @Transactional
    public void creditPayout(JobApplication app, double amount) {
        if (app == null || amount <= 0) return;
        app.setPayoutBalance(app.getPayoutBalance() + amount);
        jobAppRepository.save(app);
    }

    @Transactional
    public Map<String, Object> requestPayout(JobApplication app) {
        if (app == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Worker profile required");
        if (PartnerLifecycleSupport.blank(app.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = app.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        app.setPayoutRequestedAt(LocalDateTime.now());
        jobAppRepository.save(app);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + app.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", app.getUpiId());
        return m;
    }

    @Transactional
    public boolean toggleFavorite(User user, Long jobApplicationId) {
        if (user == null || jobApplicationId == null) return false;
        var existing = favoriteRepository.findByUserIdAndJobApplicationId(user.getId(), jobApplicationId);
        if (existing.isPresent()) {
            favoriteRepository.delete(existing.get());
            return false;
        }
        JobWorkerFavorite f = new JobWorkerFavorite();
        f.setUserId(user.getId());
        f.setJobApplicationId(jobApplicationId);
        f.setCreatedAt(LocalDateTime.now());
        favoriteRepository.save(f);
        return true;
    }

    public boolean isFavorite(User user, Long jobApplicationId) {
        if (user == null || jobApplicationId == null) return false;
        return favoriteRepository.existsByUserIdAndJobApplicationId(user.getId(), jobApplicationId);
    }

    public List<JobWorkerFavorite> favoritesFor(User user) {
        if (user == null) return List.of();
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(user.getId());
    }

    @Transactional
    public JobWorkerReview addReview(User user, JobApplication app, int rating, String comment) {
        if (user == null || app == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Login required");
        }
        if (rating < 1 || rating > 5) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rating must be 1–5");
        }
        JobWorkerReview r = new JobWorkerReview();
        r.setJobApplicationId(app.getId());
        r.setUserId(user.getId());
        r.setUserName(user.getFullName() == null || user.getFullName().isBlank() ? "Member" : user.getFullName());
        r.setRating(rating);
        r.setComment(comment == null ? "" : comment.trim());
        r.setCreatedAt(LocalDateTime.now());
        reviewRepository.save(r);
        List<JobWorkerReview> all = reviewRepository.findByJobApplicationIdOrderByCreatedAtDesc(app.getId());
        double avg = all.stream().mapToInt(JobWorkerReview::getRating).average().orElse(0);
        app.setRating(Math.round(avg * 10.0) / 10.0);
        jobAppRepository.save(app);
        return r;
    }

    public List<Map<String, Object>> reviewsFor(Long jobApplicationId) {
        if (jobApplicationId == null) return List.of();
        return reviewRepository.findByJobApplicationIdOrderByCreatedAtDesc(jobApplicationId)
                .stream().map(this::reviewDto).toList();
    }

    @Transactional
    public WorkerBooking cancelBooking(User user, Long bookingId, String reason) {
        WorkerBooking b = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Booking not found"));
        boolean client = b.getClient() != null && user != null && b.getClient().getId().equals(user.getId());
        boolean worker = b.getJobApplication() != null && b.getJobApplication().getUser() != null
                && user != null && b.getJobApplication().getUser().getId().equals(user.getId());
        if (!client && !worker) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your booking");
        }
        String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
        if (status.equals("COMPLETED") || status.equals("CANCELLED") || status.equals("REJECTED")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This booking cannot be cancelled.");
        }
        if (client && !canCancelFree(b) && (status.equals("ACCEPTED") || status.equals("PAID") || status.equals("CONFIRMED"))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        b.setStatus("CANCELLED");
        b.setCancelReason(reason == null ? "" : reason.trim());
        return bookingRepository.save(b);
    }

    public Map<String, Object> reviewDto(JobWorkerReview r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.getId());
        m.put("userName", r.getUserName());
        m.put("rating", r.getRating());
        m.put("comment", r.getComment());
        m.put("createdAt", r.getCreatedAt() == null ? null : r.getCreatedAt().toString());
        return m;
    }

    private String reminderBody(WorkerBooking b) {
        String worker = b.getJobApplication() == null || b.getJobApplication().getUser() == null
                ? "your worker" : b.getJobApplication().getUser().getFullName();
        return "Visit with " + worker;
    }
}
