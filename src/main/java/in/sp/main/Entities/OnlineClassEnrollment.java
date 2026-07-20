package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "online_class_enrollments", uniqueConstraints = {@UniqueConstraint(columnNames = {"trainee_id", "online_class_id"})})
public class OnlineClassEnrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trainee_id")
    private User trainee;

    @ManyToOne
    @JoinColumn(name = "online_class_id")
    private OnlineClass onlineClass;

    @Enumerated(EnumType.STRING)
    private TrainingStatus status = TrainingStatus.PENDING;

    public OnlineClassEnrollment() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getTrainee() { return trainee; }
    public void setTrainee(User trainee) { this.trainee = trainee; }

    public OnlineClass getOnlineClass() { return onlineClass; }
    public void setOnlineClass(OnlineClass onlineClass) { this.onlineClass = onlineClass; }

    public TrainingStatus getStatus() { return status; }
    public void setStatus(TrainingStatus status) { this.status = status; }
}
