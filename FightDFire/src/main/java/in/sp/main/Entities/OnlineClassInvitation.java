package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "online_class_invitations", uniqueConstraints = {@UniqueConstraint(columnNames = {"trainee_id", "online_class_id"})})
public class OnlineClassInvitation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private OnlineClass onlineClass;

    @ManyToOne
    private User trainer;

    @ManyToOne
    private User trainee;

    @Enumerated(EnumType.STRING)
    private InviteStatus status = InviteStatus.PENDING;

    private LocalDateTime createdAt = LocalDateTime.now();

    public enum InviteStatus {
        PENDING, ACCEPTED, REJECTED
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public OnlineClass getOnlineClass() { return onlineClass; }
    public void setOnlineClass(OnlineClass onlineClass) { this.onlineClass = onlineClass; }
    public User getTrainer() { return trainer; }
    public void setTrainer(User trainer) { this.trainer = trainer; }
    public User getTrainee() { return trainee; }
    public void setTrainee(User trainee) { this.trainee = trainee; }
    public InviteStatus getStatus() { return status; }
    public void setStatus(InviteStatus status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
