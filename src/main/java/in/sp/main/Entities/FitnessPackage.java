package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "fitness_packages")
public class FitnessPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trainer_id", nullable = false)
    private FitnessTrainer trainer;

    @Column(nullable = false)
    private String packageName;

    private String category; // e.g., Yoga, HIIT, Strength Training, Personal Training

    @Column(columnDefinition = "TEXT")
    private String description;

    private Integer sessionCount = 1; // 0 = Unlimited sessions within validity

    private Integer durationDays = 30; // e.g. 30, 90, 365 days

    private Double price = 0.0;

    private String sessionType = "OFFLINE"; // OFFLINE, ONLINE, HYBRID

    private boolean active = true;

    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getSessionCount() { return sessionCount; }
    public void setSessionCount(Integer sessionCount) { this.sessionCount = sessionCount; }

    public Integer getDurationDays() { return durationDays; }
    public void setDurationDays(Integer durationDays) { this.durationDays = durationDays; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
