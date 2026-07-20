package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "sos_requests")
public class SOSRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private Double latitude;
    private Double longitude;
    private String googleMapsLink;

    @Enumerated(EnumType.STRING)
    private SOSStatus status = SOSStatus.ACTIVE;

    private LocalDateTime activatedAt;
    private LocalDateTime resolvedAt;
    private LocalDateTime escalatedAt;

    private int totalContactsNotified;
    private int contactsAccepted;
    private int contactsRejected;
    private int contactsPending;
    private int volunteersAlerted;
    private String audioRecordingPath;

    private boolean isEscalated = false;
    private boolean isAutoCallTriggered = false;
    private String autoCallPhone;

    @OneToMany(mappedBy = "sosRequest", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<SOSContactResponse> contactResponses = new ArrayList<>();

    public enum SOSStatus {
        ACTIVE, ACCEPTED, REJECTED, ESCALATED, RESOLVED, CANCELLED
    }

    // Getters and Setters
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

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getGoogleMapsLink() {
        return googleMapsLink;
    }

    public void setGoogleMapsLink(String googleMapsLink) {
        this.googleMapsLink = googleMapsLink;
    }

    public SOSStatus getStatus() {
        return status;
    }

    public void setStatus(SOSStatus status) {
        this.status = status;
    }

    public LocalDateTime getActivatedAt() {
        return activatedAt;
    }

    public void setActivatedAt(LocalDateTime activatedAt) {
        this.activatedAt = activatedAt;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public LocalDateTime getEscalatedAt() {
        return escalatedAt;
    }

    public void setEscalatedAt(LocalDateTime escalatedAt) {
        this.escalatedAt = escalatedAt;
    }

    public int getTotalContactsNotified() {
        return totalContactsNotified;
    }

    public void setTotalContactsNotified(int totalContactsNotified) {
        this.totalContactsNotified = totalContactsNotified;
    }

    public int getContactsAccepted() {
        return contactsAccepted;
    }

    public void setContactsAccepted(int contactsAccepted) {
        this.contactsAccepted = contactsAccepted;
    }

    public int getContactsRejected() {
        return contactsRejected;
    }

    public void setContactsRejected(int contactsRejected) {
        this.contactsRejected = contactsRejected;
    }

    public int getContactsPending() {
        return contactsPending;
    }

    public void setContactsPending(int contactsPending) {
        this.contactsPending = contactsPending;
    }

    public int getVolunteersAlerted() {
        return volunteersAlerted;
    }

    public void setVolunteersAlerted(int volunteersAlerted) {
        this.volunteersAlerted = volunteersAlerted;
    }

    public String getAudioRecordingPath() {
        return audioRecordingPath;
    }

    public void setAudioRecordingPath(String audioRecordingPath) {
        this.audioRecordingPath = audioRecordingPath;
    }

    public boolean isEscalated() {
        return isEscalated;
    }

    public void setEscalated(boolean isEscalated) {
        this.isEscalated = isEscalated;
    }

    public boolean isAutoCallTriggered() {
        return isAutoCallTriggered;
    }

    public void setAutoCallTriggered(boolean isAutoCallTriggered) {
        this.isAutoCallTriggered = isAutoCallTriggered;
    }

    public String getAutoCallPhone() {
        return autoCallPhone;
    }

    public void setAutoCallPhone(String autoCallPhone) {
        this.autoCallPhone = autoCallPhone;
    }

    public List<SOSContactResponse> getContactResponses() {
        return contactResponses;
    }

    public void setContactResponses(List<SOSContactResponse> contactResponses) {
        if (this.contactResponses == null) {
            this.contactResponses = new ArrayList<>();
        }
        this.contactResponses.clear();
        if (contactResponses != null) {
            this.contactResponses.addAll(contactResponses);
        }
    }
}
