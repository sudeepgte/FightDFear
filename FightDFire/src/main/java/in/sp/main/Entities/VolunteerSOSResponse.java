package in.sp.main.Entities;

import java.time.LocalDateTime;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "volunteer_sos_response")
@Data
public class VolunteerSOSResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "sos_request_id", nullable = false)
    private SOSRequest sosRequest;

    @ManyToOne
    @JoinColumn(name = "volunteer_id", nullable = false)
    private User volunteer;

    @Enumerated(EnumType.STRING)
    private ResponseStatus status;

    private LocalDateTime respondedAt;
    
    private String message;

    public enum ResponseStatus {
        ACCEPTED, DECLINED
    }

    // Getters and Setters manually since we are not using Lombok @Data fully in other files
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public SOSRequest getSosRequest() { return sosRequest; }
    public void setSosRequest(SOSRequest sosRequest) { this.sosRequest = sosRequest; }
    public User getVolunteer() { return volunteer; }
    public void setVolunteer(User volunteer) { this.volunteer = volunteer; }
    public ResponseStatus getStatus() { return status; }
    public void setStatus(ResponseStatus status) { this.status = status; }
    public LocalDateTime getRespondedAt() { return respondedAt; }
    public void setRespondedAt(LocalDateTime respondedAt) { this.respondedAt = respondedAt; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}