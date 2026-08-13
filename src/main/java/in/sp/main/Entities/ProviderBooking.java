package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "provider_bookings")
public class ProviderBooking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "provider_id")
    private ServiceProvider provider;

    private LocalDateTime requestedTime;

    private String note;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private ProviderBookingStatus status = ProviderBookingStatus.PENDING;

    private Double totalAmount;
    @Column(columnDefinition = "TEXT")
    private String coachNotes;
    private String cancelReason;
    private Boolean reminder1hSent;
    private Boolean consentPolicy;

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

    public ServiceProvider getProvider() {
        return provider;
    }

    public void setProvider(ServiceProvider provider) {
        this.provider = provider;
    }

    public LocalDateTime getRequestedTime() {
        return requestedTime;
    }

    public void setRequestedTime(LocalDateTime requestedTime) {
        this.requestedTime = requestedTime;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public ProviderBookingStatus getStatus() {
        return status;
    }

    public void setStatus(ProviderBookingStatus status) {
        this.status = status;
    }

    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    public String getCoachNotes() { return coachNotes; }
    public void setCoachNotes(String coachNotes) { this.coachNotes = coachNotes; }
    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
    public Boolean getReminder1hSent() { return reminder1hSent; }
    public void setReminder1hSent(Boolean reminder1hSent) { this.reminder1hSent = reminder1hSent; }
    public Boolean getConsentPolicy() { return consentPolicy; }
    public void setConsentPolicy(Boolean consentPolicy) { this.consentPolicy = consentPolicy; }
}

