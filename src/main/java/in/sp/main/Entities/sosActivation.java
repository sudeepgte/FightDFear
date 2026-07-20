package in.sp.main.Entities;


import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "sos_activation")
public class sosActivation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String activationMethod;  // Button Press, Shake-to-Alert, etc.
    private double latitude;
    private double longitude;
    private String sosMessage;
    private LocalDateTime activationTime;
    private String status;  // Pending, Triggered, Responded, Resolved, Cancelled
    private boolean emergencyContactNotified;
    private boolean authoritiesNotified;
    private Long userId;
    private String userName;

    // New SOS lifecycle fields
    private boolean autoCallTriggered;
    private boolean cancelledByUser;
    private Long respondedVolunteerId;
    private int countdownSeconds = 15;  // Default 15 seconds grace period

    // Default Constructor
    public sosActivation() {
        this.activationTime = LocalDateTime.now();
        this.status = "Pending";
        this.autoCallTriggered = false;
        this.cancelledByUser = false;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getActivationMethod() { return activationMethod; }
    public void setActivationMethod(String activationMethod) { this.activationMethod = activationMethod; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    public String getSosMessage() { return sosMessage; }
    public void setSosMessage(String sosMessage) { this.sosMessage = sosMessage; }

    public LocalDateTime getActivationTime() { return activationTime; }
    public void setActivationTime(LocalDateTime activationTime) { this.activationTime = activationTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isEmergencyContactNotified() { return emergencyContactNotified; }
    public void setEmergencyContactNotified(boolean emergencyContactNotified) { this.emergencyContactNotified = emergencyContactNotified; }

    public boolean isAuthoritiesNotified() { return authoritiesNotified; }
    public void setAuthoritiesNotified(boolean authoritiesNotified) { this.authoritiesNotified = authoritiesNotified; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public boolean isAutoCallTriggered() { return autoCallTriggered; }
    public void setAutoCallTriggered(boolean autoCallTriggered) { this.autoCallTriggered = autoCallTriggered; }

    public boolean isCancelledByUser() { return cancelledByUser; }
    public void setCancelledByUser(boolean cancelledByUser) { this.cancelledByUser = cancelledByUser; }

    public Long getRespondedVolunteerId() { return respondedVolunteerId; }
    public void setRespondedVolunteerId(Long respondedVolunteerId) { this.respondedVolunteerId = respondedVolunteerId; }

    public int getCountdownSeconds() { return countdownSeconds; }
    public void setCountdownSeconds(int countdownSeconds) { this.countdownSeconds = countdownSeconds; }
}
