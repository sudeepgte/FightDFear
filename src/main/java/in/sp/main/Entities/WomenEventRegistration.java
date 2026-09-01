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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_type_id")
    private EventTicketType ticketType;

    private String ticketTypeName;
    private Integer quantity = 1;
    private Integer coinsUsed = 0;
    private Double payableAmount = 0.0;
    private Boolean refunded = false;
    private Double refundAmount = 0.0;

    @Column(name = "qr_token", unique = true, length = 64)
    private String qrToken;

    private LocalDateTime checkedInAt;

    @PrePersist
    protected void onCreate() {
        if (this.registeredAt == null) this.registeredAt = LocalDateTime.now();
        if (this.ticketCode == null || this.ticketCode.isBlank()) {
            this.ticketCode = UUID.randomUUID().toString().toUpperCase().replace("-", "").substring(0, 12);
        }
        if (this.qrToken == null || this.qrToken.isBlank()) {
            this.qrToken = UUID.randomUUID().toString().replace("-", "");
        }
        if (this.quantity == null || this.quantity < 1) this.quantity = 1;
        if (this.coinsUsed == null) this.coinsUsed = 0;
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
    private Boolean payoutCredited = false;
    @Column(columnDefinition = "TEXT")
    private String coachNotes;

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

    public Boolean getPayoutCredited() { return payoutCredited; }
    public void setPayoutCredited(Boolean payoutCredited) { this.payoutCredited = payoutCredited; }
    public String getCoachNotes() { return coachNotes; }
    public void setCoachNotes(String coachNotes) { this.coachNotes = coachNotes; }

    public EventTicketType getTicketType() { return ticketType; }
    public void setTicketType(EventTicketType ticketType) { this.ticketType = ticketType; }
    public String getTicketTypeName() { return ticketTypeName; }
    public void setTicketTypeName(String ticketTypeName) { this.ticketTypeName = ticketTypeName; }
    public Integer getQuantity() { return quantity == null ? 1 : quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Integer getCoinsUsed() { return coinsUsed == null ? 0 : coinsUsed; }
    public void setCoinsUsed(Integer coinsUsed) { this.coinsUsed = coinsUsed; }
    public Double getPayableAmount() { return payableAmount == null ? 0d : payableAmount; }
    public void setPayableAmount(Double payableAmount) { this.payableAmount = payableAmount; }
    public Boolean getRefunded() { return refunded; }
    public void setRefunded(Boolean refunded) { this.refunded = refunded; }
    public Double getRefundAmount() { return refundAmount == null ? 0d : refundAmount; }
    public void setRefundAmount(Double refundAmount) { this.refundAmount = refundAmount; }
    public String getQrToken() { return qrToken; }
    public void setQrToken(String qrToken) { this.qrToken = qrToken; }
    public LocalDateTime getCheckedInAt() { return checkedInAt; }
    public void setCheckedInAt(LocalDateTime checkedInAt) { this.checkedInAt = checkedInAt; }
}
