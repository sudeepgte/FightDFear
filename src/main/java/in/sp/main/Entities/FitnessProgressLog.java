package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fitness_progress_logs")
public class FitnessProgressLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trainer_id", nullable = true)
    private FitnessTrainer trainer;

    @Column(nullable = false)
    private LocalDate logDate = LocalDate.now();

    private Double weightKg;

    private Double bodyFatPct;

    private Integer workoutsCompleted = 1;

    @Column(columnDefinition = "TEXT")
    private String metricsJson; // {"Endurance": 85, "Strength": 80, "Flexibility": 75, "Core": 82, "Stamina": 88}

    @Column(columnDefinition = "TEXT")
    private String workoutNotes;

    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public LocalDate getLogDate() { return logDate; }
    public void setLogDate(LocalDate logDate) { this.logDate = logDate; }

    public Double getWeightKg() { return weightKg; }
    public void setWeightKg(Double weightKg) { this.weightKg = weightKg; }

    public Double getBodyFatPct() { return bodyFatPct; }
    public void setBodyFatPct(Double bodyFatPct) { this.bodyFatPct = bodyFatPct; }

    public Integer getWorkoutsCompleted() { return workoutsCompleted; }
    public void setWorkoutsCompleted(Integer workoutsCompleted) { this.workoutsCompleted = workoutsCompleted; }

    public String getMetricsJson() { return metricsJson; }
    public void setMetricsJson(String metricsJson) { this.metricsJson = metricsJson; }

    public String getWorkoutNotes() { return workoutNotes; }
    public void setWorkoutNotes(String workoutNotes) { this.workoutNotes = workoutNotes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
