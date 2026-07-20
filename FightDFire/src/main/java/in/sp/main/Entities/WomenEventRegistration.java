package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "women_event_registrations")
public class WomenEventRegistration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private WomenEvent event;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private LocalDateTime registeredAt;

    private String status = "REGISTERED"; // REGISTERED, CANCELLED, ATTENDED

    // UUID-based QR code / digital ticket identifier
    @Column(unique = true)
    private String ticketCode;

    private boolean checkedIn = false;

    @PrePersist
    protected void onCreate() {
        this.registeredAt = LocalDateTime.now();
        this.ticketCode = UUID.randomUUID().toString().toUpperCase().replace("-", "").substring(0, 12);
    }

    private String role = "ATTENDEE"; // ATTENDEE, VOLUNTEER

    // ---------- Getters & Setters ----------

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public WomenEvent getEvent() { return event; }
    public void setEvent(WomenEvent event) { this.event = event; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public LocalDateTime getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(LocalDateTime registeredAt) { this.registeredAt = registeredAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    public boolean isCheckedIn() { return checkedIn; }
    public void setCheckedIn(boolean checkedIn) { this.checkedIn = checkedIn; }

    private boolean paid = false;
    private Double amountPaid = 0.0;

    public boolean isPaid() {
        return paid;
    }

    public void setPaid(boolean paid) {
        this.paid = paid;
    }

    public Double getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(Double amountPaid) {
        this.amountPaid = amountPaid;
    }
}
