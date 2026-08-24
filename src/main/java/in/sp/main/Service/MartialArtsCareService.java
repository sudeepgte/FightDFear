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

import in.sp.main.Entities.CentreFavorite;
import in.sp.main.Entities.CentreReview;
import in.sp.main.Entities.Enrollment;
import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.OnlineClass;
import in.sp.main.Entities.OnlineClassStatus;
import in.sp.main.Entities.TrainingStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.CentreFavoriteRepository;
import in.sp.main.Repository.CentreReviewRepository;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.OnlineClassRepository;

@Service
public class MartialArtsCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until 24 hours before the first class. After that the fee is not refunded. "
                    + "Batch transfer is allowed once if requested 48 hours in advance.";

    @Autowired
    private OnlineClassRepository onlineClassRepository;
    @Autowired
    private EnrollmentRepository enrollmentRepository;
    @Autowired
    private MartialArtsBatchRepository batchRepository;
    @Autowired
    private MartialArtsCenterRepository centreRepository;
    @Autowired
    private CentreFavoriteRepository favoriteRepository;
    @Autowired
    private CentreReviewRepository reviewRepository;
    @Autowired
    private PushNotificationService pushNotificationService;

    @Scheduled(fixedDelay = 300000)
    @SchedulerLock(name = "MartialArtsCareService_sendClassReminders", lockAtLeastFor = "4m", lockAtMostFor = "10m")
    @Transactional
    public void sendClassReminders() {
        LocalDateTime now = LocalDateTime.now();
        List<OnlineClass> classes = onlineClassRepository.findByDateAndStatusNotIn(
                LocalDate.now(), List.of(OnlineClassStatus.COMPLETED));
        for (OnlineClass oc : classes) {
            LocalDateTime start = classStart(oc);
            if (start == null) continue;
            if (start.isAfter(now.plusMinutes(45)) && start.isBefore(now.plusMinutes(75))) {
                remindEnrolled(oc, start);
            }
        }
        List<Enrollment> enrollments = enrollmentRepository.findByStatusInAndReminder1hSentFalse(
                List.of(TrainingStatus.APPROVED, TrainingStatus.IN_PROGRESS));
        for (Enrollment e : enrollments) {
            MartialArtsBatch batch = e.getBatch();
            if (batch == null || batch.getTimeSlot() == null) continue;
            if (!isBatchDayToday(batch)) continue;
            LocalTime startTime = parseStartTime(batch.getTimeSlot());
            if (startTime == null) continue;
            LocalDateTime start = LocalDateTime.of(LocalDate.now(), startTime);
            if (start.isAfter(now.plusMinutes(45)) && start.isBefore(now.plusMinutes(75))) {
                if (e.getUser() != null) {
                    pushNotificationService.notifyUser(
                            e.getUser().getId(),
                            "Class in 1 hour",
                            (batch.getName() == null ? "Your class" : batch.getName()) + " starts at " + startTime,
                            Map.of("type", "CLASS_REMINDER", "enrollmentId", String.valueOf(e.getId())));
                }
                e.setReminder1hSent(true);
                enrollmentRepository.save(e);
            }
        }
    }

    public boolean canJoin(OnlineClass oc) {
        if (oc == null) return false;
        if (oc.getStatus() == OnlineClassStatus.LIVE) return true;
        LocalDateTime start = classStart(oc);
        if (start == null) return false;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime from = start.minusMinutes(5);
        LocalDateTime to = start.plusMinutes(15);
        if (oc.getEndTime() != null) {
            LocalTime end = parseTime(oc.getEndTime());
            if (end != null && oc.getDate() != null) {
                to = LocalDateTime.of(oc.getDate(), end).plusMinutes(15);
            }
        }
        return !now.isBefore(from) && !now.isAfter(to);
    }

    public boolean canCentreStart(OnlineClass oc) {
        if (oc == null) return false;
        LocalDateTime start = classStart(oc);
        if (start == null) return true;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime from = start.minusMinutes(15);
        LocalDateTime to = start.plusHours(3);
        return !now.isBefore(from) && !now.isAfter(to);
    }

    public String joinWindowHint(OnlineClass oc) {
        LocalDateTime start = classStart(oc);
        if (start == null) return "Join opens 5 minutes before class.";
        return "Join window: 5 minutes before to 15 minutes after " + start.toLocalTime();
    }

    public Map<String, Object> nextBatchInfo(MartialArtsCenter centre, List<MartialArtsBatch> batches) {
        Map<String, Object> info = new LinkedHashMap<>();
        MartialArtsBatch next = null;
        long nextSeats = 0;
        for (MartialArtsBatch b : batches) {
            if (b.getStatus() != null && ("Closed".equalsIgnoreCase(b.getStatus()) || "Full".equalsIgnoreCase(b.getStatus()))) {
                continue;
            }
            long seats = seatsLeft(b);
            if (seats <= 0 && b.getCapacity() != null && b.getCapacity() > 0) continue;
            if (next == null) {
                next = b;
                nextSeats = seats;
            }
            if (isBatchDayToday(b) && seats > 0) {
                next = b;
                nextSeats = seats;
                break;
            }
        }
        if (next == null) {
            info.put("nextBatch", null);
            info.put("availabilityLabel", "No seats this week");
            info.put("hasSeatsThisWeek", false);
            return info;
        }
        info.put("nextBatch", next.getName());
        info.put("nextBatchTime", next.getTimeSlot());
        info.put("nextBatchDays", next.getAvailableDays());
        info.put("hasSeatsThisWeek", nextSeats > 0 || next.getCapacity() == null);
        info.put("availabilityLabel", isBatchDayToday(next)
                ? "Batch today · " + (nextSeats > 0 ? nextSeats + " seats left" : "open")
                : "Next batch: " + nullToDash(next.getName()) + (next.getTimeSlot() == null ? "" : " · " + next.getTimeSlot()));
        return info;
    }

    public long seatsLeft(MartialArtsBatch batch) {
        if (batch == null || batch.getId() == null) return 0;
        if (batch.getCapacity() == null || batch.getCapacity() <= 0) return 99;
        long paid = enrollmentRepository.countPaidByBatchId(batch.getId());
        return Math.max(0, batch.getCapacity() - paid);
    }

    public boolean isBatchDayToday(MartialArtsBatch batch) {
        if (batch == null || batch.getAvailableDays() == null || batch.getAvailableDays().isBlank()) return false;
        String today = LocalDate.now().getDayOfWeek().name();
        String days = batch.getAvailableDays().toUpperCase(Locale.ROOT);
        return days.contains(today) || days.contains(today.substring(0, 3));
    }

    public boolean isOnlineBatch(MartialArtsBatch batch) {
        if (batch == null || batch.getBatchType() == null) return false;
        String t = batch.getBatchType().toLowerCase(Locale.ROOT);
        return t.contains("online") || t.contains("hybrid");
    }

    @Transactional
    public Enrollment cancelEnrollment(User user, Long enrollmentId, String reason) {
        Enrollment e = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Enrollment not found"));
        if (e.getUser() == null || !e.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your enrollment");
        }
        if (e.getStatus() == TrainingStatus.CANCELLED || e.getStatus() == TrainingStatus.COMPLETED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This enrollment cannot be cancelled");
        }
        LocalDateTime firstClass = firstClassTime(e);
        if (firstClass != null && LocalDateTime.now().isAfter(firstClass.minusHours(24))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Free cancellation closed. Fee is not refunded within 24 hours of the first class.");
        }
        e.setStatus(TrainingStatus.CANCELLED);
        e.setCancelReason(reason == null || reason.isBlank() ? "Cancelled by member" : reason.trim());
        return enrollmentRepository.save(e);
    }

    @Transactional
    public Enrollment transferEnrollment(User user, Long enrollmentId, Long newBatchId) {
        Enrollment e = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Enrollment not found"));
        if (e.getUser() == null || !e.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your enrollment");
        }
        if (Boolean.TRUE.equals(e.getTransferUsed())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Batch transfer is allowed only once");
        }
        LocalDateTime firstClass = firstClassTime(e);
        if (firstClass != null && LocalDateTime.now().isAfter(firstClass.minusHours(48))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Transfer must be requested at least 48 hours before the first class.");
        }
        MartialArtsBatch target = batchRepository.findById(newBatchId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Target batch not found"));
        if (e.getCenter() == null || target.getCenter() == null
                || !e.getCenter().getId().equals(target.getCenter().getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Transfer is only allowed within the same centre");
        }
        if (seatsLeft(target) <= 0 && target.getCapacity() != null && target.getCapacity() > 0) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Target batch has no seats");
        }
        e.setBatch(target);
        e.setTransferUsed(true);
        e.setStatus(TrainingStatus.TRANSFERRED);
        e.setCancelReason("Transferred to " + target.getName());
        return enrollmentRepository.save(e);
    }

    @Transactional
    public void addFavorite(Long userId, Long centreId) {
        if (favoriteRepository.existsByUserIdAndCentreId(userId, centreId)) return;
        if (!centreRepository.existsById(centreId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Centre not found");
        }
        CentreFavorite fav = new CentreFavorite();
        fav.setUserId(userId);
        fav.setCentreId(centreId);
        favoriteRepository.save(fav);
    }

    @Transactional
    public void removeFavorite(Long userId, Long centreId) {
        favoriteRepository.deleteByUserIdAndCentreId(userId, centreId);
    }

    public boolean isFavorite(Long userId, Long centreId) {
        return favoriteRepository.existsByUserIdAndCentreId(userId, centreId);
    }

    @Transactional
    public CentreReview addReview(User user, MartialArtsCenter centre, int rating, String comment) {
        if (rating < 1 || rating > 5) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rating must be 1–5");
        }
        boolean trained = enrollmentRepository.findByUser(user).stream()
                .anyMatch(e -> e.getCenter() != null
                        && e.getCenter().getId().equals(centre.getId())
                        && (e.getStatus() == TrainingStatus.APPROVED
                        || e.getStatus() == TrainingStatus.IN_PROGRESS
                        || e.getStatus() == TrainingStatus.COMPLETED
                        || e.getStatus() == TrainingStatus.TRANSFERRED));
        if (!trained) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You can review a centre after enrolling");
        }
        CentreReview review = new CentreReview();
        review.setUser(user);
        review.setCentre(centre);
        review.setRating(rating);
        review.setComment(comment == null ? "" : comment.trim());
        review.setCreatedAt(LocalDateTime.now());
        CentreReview saved = reviewRepository.save(review);
        refreshRating(centre);
        return saved;
    }

    public List<Map<String, Object>> reviewDtos(Long centreId) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (CentreReview r : reviewRepository.findByCentre_IdOrderByCreatedAtDesc(centreId)) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("rating", r.getRating());
            m.put("comment", r.getComment());
            m.put("createdAt", r.getCreatedAt() == null ? null : r.getCreatedAt().toString());
            m.put("userName", r.getUser() == null ? "Member" : r.getUser().getFullName());
            out.add(m);
        }
        return out;
    }

    @Transactional
    public void creditPayout(MartialArtsCenter centre, double amount) {
        if (centre == null || amount <= 0) return;
        double bal = centre.getPayoutBalance() == null ? 0 : centre.getPayoutBalance();
        centre.setPayoutBalance(bal + amount);
        centreRepository.save(centre);
    }

    @Transactional
    public MartialArtsCenter requestPayout(MartialArtsCenter centre) {
        if (centre.getUpiId() == null || centre.getUpiId().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout");
        }
        double bal = centre.getPayoutBalance() == null ? 0 : centre.getPayoutBalance();
        if (bal <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No earnings available to withdraw");
        }
        centre.setPayoutRequestedAt(LocalDateTime.now());
        centre.setPayoutBalance(0.0);
        return centreRepository.save(centre);
    }

    public Map<String, Object> reviewSummary(Long centreId) {
        List<CentreReview> reviews = reviewRepository.findByCentre_IdOrderByCreatedAtDesc(centreId);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("count", reviews.size());
        double avg = reviews.stream().filter(r -> r.getRating() != null).mapToInt(CentreReview::getRating).average().orElse(0);
        m.put("average", Math.round(avg * 10.0) / 10.0);
        return m;
    }

    private void refreshRating(MartialArtsCenter centre) {
        List<CentreReview> reviews = reviewRepository.findByCentre_IdOrderByCreatedAtDesc(centre.getId());
        double avg = reviews.stream().filter(r -> r.getRating() != null).mapToInt(CentreReview::getRating).average().orElse(0);
        centre.setRating(Math.round(avg * 10.0) / 10.0);
        centreRepository.save(centre);
    }

    private void remindEnrolled(OnlineClass oc, LocalDateTime start) {
        if (oc.getBatch() == null) return;
        for (Enrollment e : enrollmentRepository.findByBatch(oc.getBatch())) {
            if (Boolean.TRUE.equals(e.getReminder1hSent())) continue;
            if (e.getUser() == null) continue;
            if (e.getStatus() != TrainingStatus.APPROVED && e.getStatus() != TrainingStatus.IN_PROGRESS) continue;
            pushNotificationService.notifyUser(
                    e.getUser().getId(),
                    "Class in 1 hour",
                    (oc.getTitle() == null ? "Live class" : oc.getTitle()) + " starts at " + start.toLocalTime(),
                    Map.of("type", "CLASS_REMINDER", "onlineClassId", String.valueOf(oc.getId())));
            e.setReminder1hSent(true);
            enrollmentRepository.save(e);
        }
    }

    private LocalDateTime firstClassTime(Enrollment e) {
        if (e.getProposedStartDate() != null) {
            LocalTime t = e.getBatch() == null ? LocalTime.of(6, 0) : parseStartTime(e.getBatch().getTimeSlot());
            return LocalDateTime.of(e.getProposedStartDate(), t == null ? LocalTime.of(6, 0) : t);
        }
        if (e.getBatch() != null && e.getBatch().getStartDate() != null) {
            LocalTime t = parseStartTime(e.getBatch().getTimeSlot());
            return LocalDateTime.of(e.getBatch().getStartDate(), t == null ? LocalTime.of(6, 0) : t);
        }
        return e.getEnrolledAt();
    }

    public LocalDateTime classStart(OnlineClass oc) {
        if (oc.getDate() == null) return null;
        LocalTime t = parseTime(oc.getStartTime());
        if (t == null) t = LocalTime.of(10, 0);
        return LocalDateTime.of(oc.getDate(), t);
    }

    public static LocalTime parseTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String v = raw.trim().toUpperCase(Locale.ROOT).replace('.', ':');
        try {
            if (v.contains("AM") || v.contains("PM")) {
                String compact = v.replace(" ", "");
                DateTimeFormatter fmt = compact.length() <= 6
                        ? DateTimeFormatter.ofPattern("ha", Locale.ENGLISH)
                        : DateTimeFormatter.ofPattern("h:mma", Locale.ENGLISH);
                return LocalTime.parse(compact, fmt);
            }
            String[] parts = v.split(":");
            int h = Integer.parseInt(parts[0].replaceAll("\\D", ""));
            int m = parts.length > 1 ? Integer.parseInt(parts[1].replaceAll("\\D", "").substring(0, Math.min(2, parts[1].replaceAll("\\D", "").length()))) : 0;
            return LocalTime.of(h, m);
        } catch (Exception ignored) {
            return null;
        }
    }

    public static LocalTime parseStartTime(String slot) {
        if (slot == null || slot.isBlank()) return null;
        String start = slot.split("[-–]| to ")[0].trim();
        return parseTime(start);
    }

    private static String nullToDash(String v) {
        return v == null || v.isBlank() ? "—" : v;
    }
}
