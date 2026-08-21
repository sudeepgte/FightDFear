package in.sp.main.Service;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class FitnessService {

    @Autowired
    private FitnessPackageRepository packageRepository;

    @Autowired
    private FitnessAttendanceRepository attendanceRepository;

    @Autowired
    private FitnessProgressLogRepository progressLogRepository;

    @Autowired
    private FitnessBookingRepository bookingRepository;

    @Autowired
    private FitnessTrainerRepository trainerRepository;

    @Autowired
    private UserRepository userRepository;

    // --- PACKAGE MANAGEMENT ---

    @Transactional
    public FitnessPackage createOrUpdatePackage(FitnessTrainer trainer, Long packageId, String name, String category,
                                               String description, Integer sessionCount, Integer durationDays,
                                               Double price, String sessionType) {
        if (trainer == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Trainer not authenticated");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Package name is required");
        }

        FitnessPackage pkg;
        if (packageId != null) {
            pkg = packageRepository.findById(packageId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Package not found"));
            if (!pkg.getTrainer().getId().equals(trainer.getId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Unauthorized access to package");
            }
        } else {
            pkg = new FitnessPackage();
            pkg.setTrainer(trainer);
        }

        pkg.setPackageName(name.trim());
        pkg.setCategory(category != null ? category.trim() : "General Fitness");
        pkg.setDescription(description != null ? description.trim() : "");
        pkg.setSessionCount(sessionCount != null && sessionCount >= 0 ? sessionCount : 1);
        pkg.setDurationDays(durationDays != null && durationDays > 0 ? durationDays : 30);
        pkg.setPrice(price != null && price >= 0 ? price : 0.0);
        pkg.setSessionType(sessionType != null ? sessionType : "OFFLINE");
        pkg.setActive(true);

        return packageRepository.save(pkg);
    }

    @Transactional
    public boolean togglePackageActive(FitnessTrainer trainer, Long packageId) {
        FitnessPackage pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Package not found"));
        if (!pkg.getTrainer().getId().equals(trainer.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Unauthorized access to package");
        }
        pkg.setActive(!pkg.isActive());
        packageRepository.save(pkg);
        return pkg.isActive();
    }

    @Transactional
    public void deletePackage(FitnessTrainer trainer, Long packageId) {
        FitnessPackage pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Package not found"));
        if (!pkg.getTrainer().getId().equals(trainer.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Unauthorized access to package");
        }
        packageRepository.delete(pkg);
    }

    public List<FitnessPackage> getTrainerPackages(Long trainerId) {
        return packageRepository.findByTrainer_Id(trainerId);
    }

    public List<FitnessPackage> getActiveTrainerPackages(Long trainerId) {
        return packageRepository.findByTrainer_IdAndActiveTrue(trainerId);
    }

    // --- ATTENDANCE MANAGEMENT ---

    @Transactional
    public FitnessAttendance markAttendance(FitnessTrainer trainer, Long bookingId, LocalDate sessionDate,
                                           String sessionTime, String status, String notes) {
        FitnessBooking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));

        if (!booking.getTrainer().getId().equals(trainer.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Unauthorized access to booking");
        }

        LocalDate date = (sessionDate != null) ? sessionDate : LocalDate.now();

        if (attendanceRepository.existsByBooking_IdAndSessionDate(bookingId, date)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Attendance already recorded for this session date");
        }

        FitnessAttendance attendance = new FitnessAttendance();
        attendance.setBooking(booking);
        attendance.setTrainer(trainer);
        attendance.setUser(booking.getUser());
        attendance.setSessionDate(date);
        attendance.setSessionTime(sessionTime != null ? sessionTime : booking.getBookingTime());
        attendance.setStatus(status != null ? status : "PRESENT");
        attendance.setNotes(notes);
        attendance.setCheckInTime(LocalDateTime.now());

        FitnessAttendance saved = attendanceRepository.save(attendance);

        if ("PRESENT".equalsIgnoreCase(status) || "LATE".equalsIgnoreCase(status)) {
            int completed = booking.getCompletedSessions() != null ? booking.getCompletedSessions() : 0;
            booking.setCompletedSessions(completed + 1);
            if (booking.getRemainingSessions() != null && booking.getRemainingSessions() > 0) {
                booking.setRemainingSessions(booking.getRemainingSessions() - 1);
            }
            if (booking.getTotalSessions() != null && booking.getTotalSessions() > 0
                    && booking.getCompletedSessions() >= booking.getTotalSessions()) {
                booking.setStatus("COMPLETED");
            }
            bookingRepository.save(booking);
        }

        return saved;
    }

    public List<FitnessAttendance> getBookingAttendance(Long bookingId) {
        return attendanceRepository.findByBooking_IdOrderBySessionDateDesc(bookingId);
    }

    public List<FitnessAttendance> getUserAttendanceHistory(Long userId) {
        return attendanceRepository.findByUser_IdOrderBySessionDateDesc(userId);
    }

    // --- PROGRESS LOGGING ---

    @Transactional
    public FitnessProgressLog logClientProgress(Long userId, FitnessTrainer trainer, LocalDate logDate,
                                               Double weightKg, Double bodyFatPct, Integer workoutsCompleted,
                                               String metricsJson, String workoutNotes) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        FitnessProgressLog log = new FitnessProgressLog();
        log.setUser(user);
        log.setTrainer(trainer);
        log.setLogDate(logDate != null ? logDate : LocalDate.now());
        log.setWeightKg(weightKg);
        log.setBodyFatPct(bodyFatPct);
        log.setWorkoutsCompleted(workoutsCompleted != null ? workoutsCompleted : 1);
        log.setMetricsJson(metricsJson);
        log.setWorkoutNotes(workoutNotes);

        return progressLogRepository.save(log);
    }

    public Map<String, Object> getUserFitnessProgressSummary(Long userId) {
        Map<String, Object> summary = new HashMap<>();
        List<FitnessProgressLog> logs = progressLogRepository.findByUser_IdOrderByLogDateDesc(userId);
        long totalAttended = attendanceRepository.countByUser_IdAndStatus(userId, "PRESENT");

        summary.put("totalWorkoutsAttended", totalAttended);
        summary.put("progressLogs", logs);

        if (!logs.isEmpty()) {
            FitnessProgressLog latest = logs.get(0);
            summary.put("latestWeight", latest.getWeightKg());
            summary.put("latestBodyFat", latest.getBodyFatPct());
            summary.put("latestMetrics", latest.getMetricsJson());
            summary.put("lastLogDate", latest.getLogDate());
        } else {
            summary.put("latestWeight", null);
            summary.put("latestBodyFat", null);
            summary.put("latestMetrics", null);
            summary.put("lastLogDate", null);
        }

        // Compute streak based on distinct attendance dates in the past 30 days
        List<FitnessAttendance> history = attendanceRepository.findByUser_IdOrderBySessionDateDesc(userId);
        int streak = 0;
        if (!history.isEmpty()) {
            LocalDate prev = LocalDate.now();
            for (FitnessAttendance att : history) {
                if ("PRESENT".equalsIgnoreCase(att.getStatus())) {
                    if (att.getSessionDate().isEqual(prev) || att.getSessionDate().isEqual(prev.minusDays(1))) {
                        streak++;
                        prev = att.getSessionDate();
                    } else if (att.getSessionDate().isBefore(prev.minusDays(1))) {
                        break;
                    }
                }
            }
        }
        summary.put("currentStreakDays", streak);

        return summary;
    }
}
