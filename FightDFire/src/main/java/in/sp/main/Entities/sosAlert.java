package in.sp.main.Entities;


import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "sos_alerts")
public class sosAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;
    private String userName;
    private String userPhone;
    private String latitude;
    private String longitude;
    private String message;
    private LocalDateTime timeOfActivation;
    private String status; // ACTIVE, RESOLVED
    private boolean emergencyContactNotified;
    private boolean authoritiesNotified;

    // Getters and Setters
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getLatitude() { return latitude; }
    public void setLatitude(String latitude) { this.latitude = latitude; }

    public String getLongitude() { return longitude; }
    public void setLongitude(String longitude) { this.longitude = longitude; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public LocalDateTime getTimeOfActivation() { return timeOfActivation; }
    public void setTimeOfActivation(LocalDateTime timeOfActivation) { this.timeOfActivation = timeOfActivation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isEmergencyContactNotified() { return emergencyContactNotified; }
    public void setEmergencyContactNotified(boolean emergencyContactNotified) { this.emergencyContactNotified = emergencyContactNotified; }

    public boolean isAuthoritiesNotified() { return authoritiesNotified; }
    public void setAuthoritiesNotified(boolean authoritiesNotified) { this.authoritiesNotified = authoritiesNotified; }
}
