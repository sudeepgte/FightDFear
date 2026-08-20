package in.sp.main.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.*;

@Service
public class BeltGradingService {

    private static final Logger log = LoggerFactory.getLogger(BeltGradingService.class);

    @Autowired
    private BeltGradingAssessmentRepository gradingRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MartialArtsCenterRepository centreRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private CertificateService certificateService;

    @Autowired
    private ObjectMapper objectMapper;

    // Standard Belt progression
    private static final List<String> DEFAULT_BELTS = List.of(
            "White", "Yellow", "Orange", "Green", "Blue", "Purple", "Brown", "Red", "Black"
    );

    /**
     * Discipline-specific grading criteria configuration.
     */
    public List<String> getDisciplineCriteria(String discipline) {
        if (discipline == null) return List.of("Stance", "Technique", "Execution", "Conditioning", "Discipline");
        String d = discipline.trim().toLowerCase(Locale.ROOT);
        if (d.contains("karate")) {
            return List.of("Stance & Balance", "Kihon (Fundamentals)", "Kata (Forms)", "Kumite (Sparring)", "Kicking Power", "Discipline & Etiquette");
        } else if (d.contains("taekwondo")) {
            return List.of("Stance", "High & Spinning Kicks", "Poomsae (Forms)", "Sparring (Kyorigi)", "Flexibility", "Board Breaking", "Discipline");
        } else if (d.contains("judo")) {
            return List.of("Ukemi (Breakfalls)", "Nage-waza (Throws)", "Kumi-kata (Grips)", "Ne-waza (Groundwork)", "Osaekomi (Pins)", "Control & Respect");
        } else if (d.contains("boxing")) {
            return List.of("Stance & Guard", "Footwork & Movement", "Jab & Cross Combos", "Hooks & Uppercuts", "Slip & Counter Defense", "Conditioning & Stamina");
        } else if (d.contains("mma")) {
            return List.of("Stand-up Striking", "Clinch Work", "Takedowns & Defense", "Ground & Pound", "Submissions & Escapes", "Cardio Conditioning");
        } else if (d.contains("kickboxing") || d.contains("muay thai")) {
            return List.of("Stance & Balance", "Punch Combos", "Roundhouse & Push Kicks", "Knees & Elbows", "Clinch & Defense", "Endurance");
        } else if (d.contains("krav maga") || d.contains("self-defence") || d.contains("self defense")) {
            return List.of("Situational Awareness", "Escape from Holds", "Vulnerable Strike Defense", "Ground Recovery", "Weapon Threat Reaction", "Stress Conditioning");
        } else if (d.contains("jiu-jitsu") || d.contains("bjj") || d.contains("wrestling")) {
            return List.of("Positioning & Guard", "Passing & Control", "Sweeps & Reversals", "Submissions", "Defensive Escapes", "Rolling Stamina");
        } else if (d.contains("kung fu") || d.contains("kalaripayattu")) {
            return List.of("Stances & Posture", "Traditional Forms", "Weapon/Flow Techniques", "Agility & Flexibility", "Balance & Focus", "Discipline");
        }
        return List.of("Stance & Form", "Core Techniques", "Defensive Skills", "Sparring / Execution", "Conditioning", "Discipline");
    }

    public List<String> getBeltHierarchy(String discipline) {
        return DEFAULT_BELTS;
    }

    @Transactional
    public BeltGradingAssessment scheduleGrading(
            MartialArtsCenter centre,
            Long userId,
            Long batchId,
            String discipline,
            String targetBelt,
            LocalDate date,
            String trainerName) {

        if (centre == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Centre required");
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Student not found"));

        MartialArtsBatch batch = null;
        if (batchId != null) {
            batch = batchRepository.findById(batchId).orElse(null);
        }

        // Determine current belt
        String previousBelt = "White";
        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        for (Enrollment e : enrollments) {
            if (e.getCurrentBelt() != null && !e.getCurrentBelt().isBlank()) {
                previousBelt = e.getCurrentBelt();
                break;
            }
        }

        BeltGradingAssessment assessment = new BeltGradingAssessment();
        assessment.setCenter(centre);
        assessment.setUser(user);
        assessment.setBatch(batch);
        assessment.setStudentName(user.getFullName() != null ? user.getFullName() : "Student");
        assessment.setTrainerName(trainerName != null && !trainerName.isBlank() ? trainerName : centre.getName());
        assessment.setDiscipline(discipline != null && !discipline.isBlank() ? discipline : (batch != null ? batch.getStyle() : "Martial Arts"));
        assessment.setPreviousBelt(previousBelt);
        assessment.setTargetBelt(targetBelt != null && !targetBelt.isBlank() ? targetBelt : "Yellow");
        assessment.setScheduledDate(date != null ? date : LocalDate.now());
        assessment.setStatus(GradingStatus.SCHEDULED);

        return gradingRepository.save(assessment);
    }

    @Transactional
    public BeltGradingAssessment conductAndScoreAssessment(
            MartialArtsCenter centre,
            Long assessmentId,
            Map<String, Integer> criteriaScores,
            String remarks,
            String examinerNotes,
            String trainerName,
            boolean autoPromote) {

        if (centre == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Centre required");
        BeltGradingAssessment assessment = gradingRepository.findById(assessmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Assessment not found"));

        if (!assessment.getCenter().getId().equals(centre.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your assessment");
        }

        if (criteriaScores == null || criteriaScores.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Assessment criteria scores are required");
        }

        // Calculate average score
        double sum = 0;
        int count = 0;
        for (Map.Entry<String, Integer> entry : criteriaScores.entrySet()) {
            int val = Math.max(0, Math.min(100, entry.getValue()));
            sum += val;
            count++;
        }
        double avgScore = count > 0 ? Math.round((sum / count) * 10.0) / 10.0 : 0.0;
        boolean passed = avgScore >= 60.0; // 60% passing benchmark

        try {
            assessment.setScoresJson(objectMapper.writeValueAsString(criteriaScores));
        } catch (Exception e) {
            log.error("Failed to serialize criteria scores", e);
        }

        assessment.setOverallScore(avgScore);
        assessment.setPassed(passed);
        assessment.setAssessmentDate(LocalDate.now());
        assessment.setRemarks(remarks);
        assessment.setExaminerNotes(examinerNotes);
        if (trainerName != null && !trainerName.isBlank()) {
            assessment.setTrainerName(trainerName);
        }

        if (passed) {
            assessment.setStatus(autoPromote ? GradingStatus.PROMOTED : GradingStatus.PASSED);
            if (autoPromote) {
                applyPromotion(assessment);
            }
        } else {
            assessment.setStatus(GradingStatus.FAILED);
        }

        return gradingRepository.save(assessment);
    }

    @Transactional
    public BeltGradingAssessment approveAndPromote(MartialArtsCenter centre, Long assessmentId) {
        if (centre == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Centre required");
        BeltGradingAssessment assessment = gradingRepository.findById(assessmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Assessment not found"));

        if (!assessment.getCenter().getId().equals(centre.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your assessment");
        }

        if (!Boolean.TRUE.equals(assessment.getPassed())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cannot promote a failed assessment");
        }

        assessment.setStatus(GradingStatus.PROMOTED);
        applyPromotion(assessment);
        return gradingRepository.save(assessment);
    }

    private void applyPromotion(BeltGradingAssessment assessment) {
        assessment.setPromotionDate(LocalDate.now());
        User user = assessment.getUser();

        // 1. Update user active enrollments with new belt
        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        for (Enrollment e : enrollments) {
            if (assessment.getBatch() == null || (e.getBatch() != null && e.getBatch().getId().equals(assessment.getBatch().getId()))) {
                e.setCurrentBelt(assessment.getTargetBelt());
                enrollmentRepository.save(e);
            }
        }

        // 2. Generate official Belt Promotion PDF certificate
        String certPath = certificateService.generateBeltCertificate(
                user.getFullName() != null ? user.getFullName() : "Student",
                assessment.getDiscipline(),
                assessment.getTargetBelt() + " Belt",
                assessment.getCenter() != null ? assessment.getCenter().getName() : "Martial Arts Academy",
                assessment.getTrainerName()
        );
        if (certPath != null) {
            assessment.setCertificatePath(certPath);
        }
        log.info("Student {} promoted to {} in {}", user.getId(), assessment.getTargetBelt(), assessment.getDiscipline());
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getStudentLatestSkillRadar(Long userId) {
        Map<String, Object> res = new LinkedHashMap<>();
        if (userId == null) {
            res.put("assessed", false);
            res.put("message", "Not yet assessed");
            return res;
        }

        Optional<BeltGradingAssessment> opt = gradingRepository.findFirstByUserIdOrderByCreatedAtDesc(userId);
        if (opt.isEmpty() || opt.get().getScoresJson() == null || opt.get().getScoresJson().isBlank()) {
            res.put("assessed", false);
            res.put("message", "Not yet assessed. Complete training sessions to be scheduled for belt grading.");
            res.put("currentBelt", "White");
            res.put("skills", Collections.emptyMap());
            return res;
        }

        BeltGradingAssessment latest = opt.get();
        Map<String, Integer> skills = new LinkedHashMap<>();
        try {
            skills = objectMapper.readValue(latest.getScoresJson(), new TypeReference<Map<String, Integer>>() {});
        } catch (Exception e) {
            log.error("Failed to parse scores JSON for student " + userId, e);
        }

        res.put("assessed", true);
        res.put("assessmentId", latest.getId());
        res.put("discipline", latest.getDiscipline());
        res.put("currentBelt", latest.getTargetBelt() != null && Boolean.TRUE.equals(latest.getPassed()) ? latest.getTargetBelt() : latest.getPreviousBelt());
        res.put("targetBelt", latest.getTargetBelt());
        res.put("overallScore", latest.getOverallScore());
        res.put("passed", latest.getPassed());
        res.put("status", latest.getStatus().name());
        res.put("assessmentDate", latest.getAssessmentDate() != null ? latest.getAssessmentDate().toString() : null);
        res.put("remarks", latest.getRemarks());
        res.put("skills", skills);
        res.put("certificatePath", latest.getCertificatePath());
        return res;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getStudentGradingHistory(Long userId) {
        List<BeltGradingAssessment> list = gradingRepository.findByUserIdOrderByCreatedAtDesc(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (BeltGradingAssessment a : list) {
            result.add(assessmentSummary(a));
        }
        return result;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getCentreGradingHistory(Long centreId) {
        List<BeltGradingAssessment> list = gradingRepository.findByCenter_IdOrderByCreatedAtDesc(centreId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (BeltGradingAssessment a : list) {
            result.add(assessmentSummary(a));
        }
        return result;
    }

    public Map<String, Object> assessmentSummary(BeltGradingAssessment a) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", a.getId());
        m.put("studentId", a.getUser() != null ? a.getUser().getId() : null);
        m.put("studentName", a.getStudentName());
        m.put("trainerName", a.getTrainerName());
        m.put("discipline", a.getDiscipline());
        m.put("previousBelt", a.getPreviousBelt());
        m.put("targetBelt", a.getTargetBelt());
        m.put("status", a.getStatus().name());
        m.put("scheduledDate", a.getScheduledDate() != null ? a.getScheduledDate().toString() : null);
        m.put("assessmentDate", a.getAssessmentDate() != null ? a.getAssessmentDate().toString() : null);
        m.put("promotionDate", a.getPromotionDate() != null ? a.getPromotionDate().toString() : null);
        m.put("overallScore", a.getOverallScore());
        m.put("passed", a.getPassed());
        m.put("remarks", a.getRemarks());
        m.put("certificatePath", a.getCertificatePath());
        if (a.getScoresJson() != null) {
            try {
                m.put("scores", objectMapper.readValue(a.getScoresJson(), Map.class));
            } catch (Exception ignored) {}
        }
        return m;
    }
}
