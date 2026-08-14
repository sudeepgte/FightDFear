package in.sp.main.Entities;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "job_worker_favorites", uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "job_application_id"}))
public class JobWorkerFavorite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "job_application_id", nullable = false)
    private Long jobApplicationId;

    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getJobApplicationId() { return jobApplicationId; }
    public void setJobApplicationId(Long jobApplicationId) { this.jobApplicationId = jobApplicationId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
