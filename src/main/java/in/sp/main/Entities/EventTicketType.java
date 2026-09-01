package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "event_ticket_types")
public class EventTicketType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private WomenEvent event;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(nullable = false)
    private Double price = 0.0;

    @Column(nullable = false)
    private Integer quantity = 0;

    @Column(nullable = false)
    private Integer soldCount = 0;

    private LocalDateTime saleStart;
    private LocalDateTime saleEnd;
    private Integer maxPerUser = 1;

    @Column(nullable = false)
    private boolean active = true;

    @Version
    private Long version;

    public int remaining() {
        int qty = quantity == null ? 0 : quantity;
        int sold = soldCount == null ? 0 : soldCount;
        return Math.max(0, qty - sold);
    }

    public boolean isOnSale(LocalDateTime now) {
        if (!active) return false;
        if (saleStart != null && now.isBefore(saleStart)) return false;
        if (saleEnd != null && now.isAfter(saleEnd)) return false;
        return remaining() > 0;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public WomenEvent getEvent() { return event; }
    public void setEvent(WomenEvent event) { this.event = event; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Double getPrice() { return price == null ? 0d : price; }
    public void setPrice(Double price) { this.price = price; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Integer getSoldCount() { return soldCount == null ? 0 : soldCount; }
    public void setSoldCount(Integer soldCount) { this.soldCount = soldCount; }
    public LocalDateTime getSaleStart() { return saleStart; }
    public void setSaleStart(LocalDateTime saleStart) { this.saleStart = saleStart; }
    public LocalDateTime getSaleEnd() { return saleEnd; }
    public void setSaleEnd(LocalDateTime saleEnd) { this.saleEnd = saleEnd; }
    public Integer getMaxPerUser() { return maxPerUser == null ? 1 : maxPerUser; }
    public void setMaxPerUser(Integer maxPerUser) { this.maxPerUser = maxPerUser; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public Long getVersion() { return version; }
    public void setVersion(Long version) { this.version = version; }
}
