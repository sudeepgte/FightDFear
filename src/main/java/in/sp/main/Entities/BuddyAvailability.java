package in.sp.main.Entities;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "buddy_availability")
public class BuddyAvailability {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: link this availability to the registered user.
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Purpose: store approximate (rounded) start coordinates for privacy-safe matching.
    private double startLatRounded;
    private double startLngRounded;

    // Purpose: v1 destination matching (simple area text like "MG Road", "Hitech City").
    private String destinationText;

    // Purpose: allow time-window based matching and automatic expiry.
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    private Date expiresAt;

    // Purpose: user can stop Buddy Mode manually before expiry.
    private boolean active = true;

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

    public double getStartLatRounded() {
        return startLatRounded;
    }

    public void setStartLatRounded(double startLatRounded) {
        this.startLatRounded = startLatRounded;
    }

    public double getStartLngRounded() {
        return startLngRounded;
    }

    public void setStartLngRounded(double startLngRounded) {
        this.startLngRounded = startLngRounded;
    }

    public String getDestinationText() {
        return destinationText;
    }

    public void setDestinationText(String destinationText) {
        this.destinationText = destinationText;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Date expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}

