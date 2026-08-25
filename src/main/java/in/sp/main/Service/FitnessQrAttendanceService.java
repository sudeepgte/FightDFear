package in.sp.main.Service;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class FitnessQrAttendanceService {

    private static final Logger log = LoggerFactory.getLogger(FitnessQrAttendanceService.class);
    private static final SecureRandom RANDOM = new SecureRandom();

    @Autowired
    private FitnessQrAttendanceSessionRepository qrSessionRepository;

    @Autowired
    private FitnessBookingRepository bookingRepository;

    @Autowired
    private FitnessAttendanceRepository attendanceRepository;

    @Autowired
    private FitnessClassRepository classRepository;

    private String generateSecureToken() {
        byte[] bytes = new byte[24];
        RANDOM.nextBytes(bytes);
        return "FIT-" + Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    @Transactional
    public FitnessQrAttendanceSession createOrRefreshSession(FitnessTrainer trainer, Long classId, LocalDate date, int durationMinutes, Double lat, Double lng) {
        if (trainer == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Trainer required");

        LocalDate sessionDate = (date != null) ? date : LocalDate.now();

        // Check for existing active session today
        Optional<FitnessQrAttendanceSession> existing = qrSessionRepository
                .findFirstByTrainerAndSessionDateAndActiveTrueOrderByCreatedAtDesc(trainer, sessionDate);

        if (existing.isPresent() && !existing.get().isExpired()) {
            return existing.get();
        }

        existing.ifPresent(s -> {
            s.setActive(false);
            s.setClosedAt(LocalDateTime.now());
            qrSessionRepository.save(s);
        });

        int duration = (durationMinutes > 0) ? durationMinutes : 15;
        FitnessQrAttendanceSession session = new FitnessQrAttendanceSession();
        session.setTrainer(trainer);
        if (classId != null) {
            classRepository.findById(classId).ifPresent(session::setFitnessClass);
        }
        session.setSessionDate(sessionDate);
        session.setToken(generateSecureToken());
        session.setCreatedAt(LocalDateTime.now());
        session.setExpiresAt(LocalDateTime.now().plusMinutes(duration));
        session.setActive(true);
        session.setLatitude(lat);
        session.setLongitude(lng);

        return qrSessionRepository.save(session);
    }

    @Transactional(readOnly = true)
    public Optional<FitnessQrAttendanceSession> getActiveSession(FitnessTrainer trainer, LocalDate date) {
        if (trainer == null) return Optional.empty();
        LocalDate sessionDate = (date != null) ? date : LocalDate.now();
        return qrSessionRepository.findFirstByTrainerAndSessionDateAndActiveTrueOrderByCreatedAtDesc(trainer, sessionDate)
                .filter(s -> !s.isExpired());
    }

    @Transactional
    public void closeSession(Long sessionId, FitnessTrainer trainer) {
        FitnessQrAttendanceSession s = qrSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "QR session not found"));
        if (!s.getTrainer().getId().equals(trainer.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        s.setActive(false);
        s.setClosedAt(LocalDateTime.now());
        qrSessionRepository.save(s);
    }

    @Transactional
    public Map<String, Object> checkInClient(User client, String token, Double clientLat, Double clientLng) {
        if (client == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Please sign in to check in");
        }
        if (token == null || token.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "QR token is required");
        }

        FitnessQrAttendanceSession session = qrSessionRepository.findByToken(token.trim())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Fitness QR code"));

        if (!session.isActive() || session.isExpired()) {
            throw new ResponseStatusException(HttpStatus.GONE, "This QR attendance session has expired. Please ask your trainer to refresh the QR code.");
        }

        FitnessTrainer trainer = session.getTrainer();
        LocalDate attendanceDate = session.getSessionDate();

        // 1. Find client's active booking with this trainer
        List<FitnessBooking> bookings = bookingRepository.findByUser_IdAndTrainer_Id(client.getId(), trainer.getId());
        FitnessBooking activeBooking = bookings.stream()
                .filter(b -> !"CANCELLED".equalsIgnoreCase(b.getStatus()) && !"REJECTED".equalsIgnoreCase(b.getStatus()))
                .findFirst()
                .orElse(null);

        if (activeBooking == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "No active booking found with trainer " + trainer.getFullName() + ". Please book a session or package first.");
        }

        // 2. Prevent duplicate check-ins for the same day on this booking
        if (attendanceRepository.existsByBooking_IdAndSessionDate(activeBooking.getId(), attendanceDate)) {
            Map<String, Object> already = new LinkedHashMap<>();
            already.put("success", true);
            already.put("alreadyCheckedIn", true);
            already.put("message", "You have already checked in for today's session with " + trainer.getFullName() + "!");
            already.put("trainerName", trainer.getFullName());
            already.put("sessionDate", attendanceDate.toString());
            return already;
        }

        // 3. Create FitnessAttendance record
        FitnessAttendance attendance = new FitnessAttendance();
        attendance.setBooking(activeBooking);
        attendance.setTrainer(trainer);
        attendance.setUser(client);
        attendance.setSessionDate(attendanceDate);
        attendance.setSessionTime(session.getSessionTime() != null ? session.getSessionTime() : activeBooking.getBookingTime());
        attendance.setStatus("PRESENT");
        attendance.setNotes("QR Check-in (Session #" + session.getId() + ")");
        attendance.setCheckInTime(LocalDateTime.now());
        attendanceRepository.save(attendance);

        // 4. Update session package deduction counters
        int completed = activeBooking.getCompletedSessions() != null ? activeBooking.getCompletedSessions() : 0;
        activeBooking.setCompletedSessions(completed + 1);
        if (activeBooking.getRemainingSessions() != null && activeBooking.getRemainingSessions() > 0) {
            activeBooking.setRemainingSessions(activeBooking.getRemainingSessions() - 1);
        }
        if (activeBooking.getTotalSessions() != null && activeBooking.getTotalSessions() > 0
                && activeBooking.getCompletedSessions() >= activeBooking.getTotalSessions()) {
            activeBooking.setStatus("COMPLETED");
        }
        bookingRepository.save(activeBooking);

        log.info("Client {} successfully checked into Fitness session {} with Trainer {}", client.getId(), session.getId(), trainer.getId());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Attendance confirmed! Workout session started.");
        res.put("trainerName", trainer.getFullName());
        res.put("sessionDate", attendanceDate.toString());
        res.put("checkInTime", attendance.getCheckInTime().toString());
        res.put("completedSessions", activeBooking.getCompletedSessions());
        res.put("remainingSessions", activeBooking.getRemainingSessions());
        return res;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getSessionAttendees(FitnessTrainer trainer, Long sessionId) {
        FitnessQrAttendanceSession session = qrSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));

        if (!session.getTrainer().getId().equals(trainer.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }

        List<FitnessAttendance> attendances = attendanceRepository.findByTrainer_IdAndSessionDate(trainer.getId(), session.getSessionDate());
        List<Map<String, Object>> list = new ArrayList<>();
        for (FitnessAttendance att : attendances) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", att.getId());
            item.put("clientName", att.getUser() != null ? att.getUser().getFullName() : "Client");
            item.put("clientEmail", att.getUser() != null ? att.getUser().getEmail() : "");
            item.put("status", att.getStatus());
            item.put("checkInTime", att.getCheckInTime() != null ? att.getCheckInTime().toString() : "");
            item.put("notes", att.getNotes());
            list.add(item);
        }
        return list;
    }
}
