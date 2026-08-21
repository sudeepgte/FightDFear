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
import java.time.LocalTime;
import java.util.*;

@Service
public class QrAttendanceService {

    private static final Logger log = LoggerFactory.getLogger(QrAttendanceService.class);
    private static final SecureRandom RANDOM = new SecureRandom();

    @Autowired
    private QrAttendanceSessionRepository qrSessionRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    private String generateSecureToken() {
        byte[] bytes = new byte[24];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    @Transactional
    public QrAttendanceSession createOrRefreshSession(MartialArtsCenter centre, Long batchId, LocalDate date, int durationMinutes) {
        if (centre == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Centre required");
        MartialArtsBatch batch = batchRepository.findById(batchId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Batch not found"));

        if (batch.getCenter() == null || !batch.getCenter().getId().equals(centre.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your batch");
        }

        LocalDate sessionDate = (date != null) ? date : LocalDate.now();

        // Check if active session already exists for this batch today
        Optional<QrAttendanceSession> existing = qrSessionRepository
                .findFirstByBatchAndSessionDateAndActiveTrueOrderByCreatedAtDesc(batch, sessionDate);

        if (existing.isPresent() && !existing.get().isExpired()) {
            return existing.get();
        }

        // Close any expired sessions
        existing.ifPresent(s -> {
            s.setActive(false);
            s.setClosedAt(LocalDateTime.now());
            qrSessionRepository.save(s);
        });

        int duration = (durationMinutes > 0) ? durationMinutes : 15; // default 15 minutes
        QrAttendanceSession session = new QrAttendanceSession();
        session.setCenter(centre);
        session.setBatch(batch);
        session.setSessionDate(sessionDate);
        session.setToken(generateSecureToken());
        session.setCreatedAt(LocalDateTime.now());
        session.setExpiresAt(LocalDateTime.now().plusMinutes(duration));
        session.setActive(true);

        return qrSessionRepository.save(session);
    }

    @Transactional(readOnly = true)
    public Optional<QrAttendanceSession> getActiveSession(Long batchId, LocalDate date) {
        MartialArtsBatch batch = batchRepository.findById(batchId).orElse(null);
        if (batch == null) return Optional.empty();
        LocalDate sessionDate = (date != null) ? date : LocalDate.now();
        return qrSessionRepository.findFirstByBatchAndSessionDateAndActiveTrueOrderByCreatedAtDesc(batch, sessionDate)
                .filter(s -> !s.isExpired());
    }

    @Transactional
    public void closeSession(Long sessionId, MartialArtsCenter centre) {
        QrAttendanceSession s = qrSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));
        if (!s.getCenter().getId().equals(centre.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        s.setActive(false);
        s.setClosedAt(LocalDateTime.now());
        qrSessionRepository.save(s);
    }

    @Transactional
    public Map<String, Object> checkInStudent(User student, String token) {
        if (student == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Please sign in to check in");
        }
        if (token == null || token.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "QR token is required");
        }

        QrAttendanceSession session = qrSessionRepository.findByToken(token.trim())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid QR code"));

        if (!session.isActive() || session.isExpired()) {
            throw new ResponseStatusException(HttpStatus.GONE, "This QR attendance session has expired or closed. Please ask your trainer for a refreshed QR.");
        }

        MartialArtsBatch batch = session.getBatch();
        MartialArtsCenter centre = session.getCenter();
        LocalDate attendanceDate = session.getSessionDate();

        // 1. Verify student is actively enrolled in this batch
        List<Enrollment> enrollments = enrollmentRepository.findByUser(student);
        boolean isEnrolled = enrollments.stream().anyMatch(e ->
                e.getBatch() != null && e.getBatch().getId().equals(batch.getId())
                        && "PAID".equalsIgnoreCase(e.getPaymentStatus())
                        && (e.getStatus() == TrainingStatus.APPROVED || e.getStatus() == TrainingStatus.IN_PROGRESS)
        );

        if (!isEnrolled) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "You are not actively enrolled in the batch '" + batch.getName() + "'. Please check your enrollments.");
        }

        // 2. Prevent duplicate check-in for the same day
        List<Attendance> existing = attendanceRepository.findByUserAndBatchAndAttendanceDate(student, batch, attendanceDate);
        if (!existing.isEmpty()) {
            Attendance att = existing.get(0);
            if (att.getStatus() == AttendanceStatus.PRESENT) {
                Map<String, Object> already = new LinkedHashMap<>();
                already.put("success", true);
                already.put("alreadyCheckedIn", true);
                already.put("message", "You are already checked in for today's session (" + batch.getName() + ")!");
                already.put("batchName", batch.getName());
                already.put("sessionDate", attendanceDate.toString());
                already.put("checkInTime", att.getJoinTime() != null ? att.getJoinTime().toString() : "Earlier");
                return already;
            }
        }

        // 3. Record attendance
        Attendance attendance = existing.isEmpty() ? new Attendance() : existing.get(0);
        attendance.setUser(student);
        attendance.setCenter(centre);
        attendance.setBatch(batch);
        attendance.setAttendanceDate(attendanceDate);
        attendance.setJoinTime(LocalTime.now());
        attendance.setMode("OFFLINE");
        attendance.setStatus(AttendanceStatus.PRESENT);
        attendance.setNotes("QR Check-in (Session #" + session.getId() + ")");
        attendanceRepository.save(attendance);

        log.info("Student {} successfully checked into batch {} via QR session {}", student.getId(), batch.getId(), session.getId());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Attendance marked successfully! Welcome to class.");
        res.put("batchName", batch.getName());
        res.put("style", batch.getStyle());
        res.put("centreName", centre.getName());
        res.put("sessionDate", attendanceDate.toString());
        res.put("checkInTime", attendance.getJoinTime().toString());
        return res;
    }
}
