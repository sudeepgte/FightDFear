package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "martial_arts_belt_grading")
public class BeltGradingAssessment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "center_id", nullable = false)
    private MartialArtsCenter center;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "batch_id")
    private MartialArtsBatch batch;

    private String studentName;
    private String trainerName;
    private String discipline; // Karate, Taekwondo, Boxing, Judo, MMA, etc.
    private String previousBelt;
    private String targetBelt;

    @Enumerated(EnumType.STRING)
    private GradingStatus status = GradingStatus.SCHEDULED;

    private LocalDate scheduledDate;
    private LocalDate assessmentDate;
    private LocalDate promotionDate;

    private Double overallScore;
    private Boolean passed;

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @Column(columnDefinition = "TEXT")
    private String examinerNotes;

    private String certificatePath;

    @Column(columnDefinition = "TEXT")
    private String scoresJson; // JSON key-value of criteria and scores (e.g. {"Stance":85,"Kata":90})

    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    public void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public BeltGradingAssessment() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }

    public MartialArtsBatch getBatch() { return batch; }
    public void setBatch(MartialArtsBatch batch) { this.batch = batch; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getTrainerName() { return trainerName; }
    public void setTrainerName(String trainerName) { this.trainerName = trainerName; }

    public String getDiscipline() { return discipline; }
    public void setDiscipline(String discipline) { this.discipline = discipline; }

    public String getPreviousBelt() { return previousBelt; }
    public void setPreviousBelt(String previousBelt) { this.previousBelt = previousBelt; }

    public String getTargetBelt() { return targetBelt; }
    public void setTargetBelt(String targetBelt) { this.targetBelt = targetBelt; }

    public GradingStatus getStatus() { return status; }
    public void setStatus(GradingStatus status) { this.status = status; }

    public LocalDate getScheduledDate() { return scheduledDate; }
    public void setScheduledDate(LocalDate scheduledDate) { this.scheduledDate = scheduledDate; }

    public LocalDate getAssessmentDate() { return assessmentDate; }
    public void setAssessmentDate(LocalDate assessmentDate) { this.assessmentDate = assessmentDate; }

    public LocalDate getPromotionDate() { return promotionDate; }
    public void setPromotionDate(LocalDate promotionDate) { this.promotionDate = promotionDate; }

    public Double getOverallScore() { return overallScore; }
    public void setOverallScore(Double overallScore) { this.overallScore = overallScore; }

    public Boolean getPassed() { return passed; }
    public void setPassed(Boolean passed) { this.passed = passed; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getExaminerNotes() { return examinerNotes; }
    public void setExaminerNotes(String examinerNotes) { this.examinerNotes = examinerNotes; }

    public String getCertificatePath() { return certificatePath; }
    public void setCertificatePath(String certificatePath) { this.certificatePath = certificatePath; }

    public String getScoresJson() { return scoresJson; }
    public void setScoresJson(String scoresJson) { this.scoresJson = scoresJson; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
