package in.sp.main.Entities;

import jakarta.persistence.*;
import java.util.Date;

@Entity
public class MarketplaceMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private ProviderBooking booking;

    @Column(columnDefinition = "TEXT")
    private String content;

    private String senderRole; // "USER" or "PROVIDER"

    @Temporal(TemporalType.TIMESTAMP)
    private Date timestamp = new Date();

    public MarketplaceMessage() {}

    public MarketplaceMessage(ProviderBooking booking, String content, String senderRole) {
        this.booking = booking;
        this.content = content;
        this.senderRole = senderRole;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public ProviderBooking getBooking() { return booking; }
    public void setBooking(ProviderBooking booking) { this.booking = booking; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getSenderRole() { return senderRole; }
    public void setSenderRole(String senderRole) { this.senderRole = senderRole; }

    public Date getTimestamp() { return timestamp; }
    public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }
}
