package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "creator_cashouts")
public class CreatorCashout {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "creator_id", nullable = false)
    private User creator;

    private int points = 0;
    private Double amount = 0.0;
    private String status = "PENDING"; // PENDING, APPROVED, REJECTED
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime processedAt;

    public CreatorCashout() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getCreator() { return creator; }
    public void setCreator(User creator) { this.creator = creator; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getProcessedAt() { return processedAt; }
    public void setProcessedAt(LocalDateTime processedAt) { this.processedAt = processedAt; }
}
