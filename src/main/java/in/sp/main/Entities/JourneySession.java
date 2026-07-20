package in.sp.main.Entities;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "journey_sessions")
public class JourneySession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: journey timer belongs to a registered user.
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Purpose: v1 destination is text; can be upgraded later to map-picked coordinates.
    private String destinationText;

    // Purpose: approximate starting coordinates captured from browser (optional).
    private Double startLat;
    private Double startLng;

    // Purpose: track where the journey started (e.g. "College", "Office").
    private String startFromText;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt = new Date();

    // Purpose: expected arrival / deadline for check-in.
    @Temporal(TemporalType.TIMESTAMP)
    private Date expectedArrivalAt;

    @Enumerated(EnumType.STRING)
    private JourneyStatus status = JourneyStatus.ACTIVE;

    // Purpose: prevent repeated notifications when overdue.
    @Temporal(TemporalType.TIMESTAMP)
    private Date alertedAt;

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

    public String getDestinationText() {
        return destinationText;
    }

    public void setDestinationText(String destinationText) {
        this.destinationText = destinationText;
    }

    public Double getStartLat() {
        return startLat;
    }

    public void setStartLat(Double startLat) {
        this.startLat = startLat;
    }

    public Double getStartLng() {
        return startLng;
    }

    public void setStartLng(Double startLng) {
        this.startLng = startLng;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getExpectedArrivalAt() {
        return expectedArrivalAt;
    }

    public void setExpectedArrivalAt(Date expectedArrivalAt) {
        this.expectedArrivalAt = expectedArrivalAt;
    }

    public JourneyStatus getStatus() {
        return status;
    }

    public void setStatus(JourneyStatus status) {
        this.status = status;
    }

    public Date getAlertedAt() {
        return alertedAt;
    }

    public void setAlertedAt(Date alertedAt) {
        this.alertedAt = alertedAt;
    }

    public String getStartFromText() {
        return startFromText;
    }

    public void setStartFromText(String startFromText) {
        this.startFromText = startFromText;
    }
}

