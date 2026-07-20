package in.sp.main.Entities;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "fitness_chat_messages")
public class FitnessChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private FitnessTrainer trainer;

    @Column(length = 1000)
    private String message;
    
    private String senderType; // "USER" or "TRAINER"
    
    private LocalDateTime timestamp;

    @PrePersist
    protected void onCreate() {
        this.timestamp = LocalDateTime.now();
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public FitnessTrainer getTrainer() {
        return trainer;
    }

    public void setTrainer(FitnessTrainer trainer) {
        this.trainer = trainer;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}
