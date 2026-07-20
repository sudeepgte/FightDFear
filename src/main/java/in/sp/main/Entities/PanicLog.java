package in.sp.main.Entities;


import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class PanicLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;
    private LocalDateTime timestamp;
    private String location;
    private String notifiedContacts;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getNotifiedContacts() { return notifiedContacts; }
    public void setNotifiedContacts(String notifiedContacts) { this.notifiedContacts = notifiedContacts; }
}
