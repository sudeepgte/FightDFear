package in.sp.main.Entities;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "doctor_chat_messages")
public class DoctorChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    private String message;
    private String senderType; // USER or DOCTOR
    private LocalDateTime timestamp;

    /** False until the doctor opens chats / that conversation (user→doctor messages). */
    @Column(nullable = false)
    private boolean readByDoctor = false;

    @PrePersist
    protected void onCreate() {
        this.timestamp = LocalDateTime.now();
        if ("DOCTOR".equalsIgnoreCase(this.senderType)) {
            this.readByDoctor = true;
        }
    }

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    public boolean isReadByDoctor() { return readByDoctor; }
    public void setReadByDoctor(boolean readByDoctor) { this.readByDoctor = readByDoctor; }
}
