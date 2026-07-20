package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "women_return_requests")
public class WomenReturnRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "order_id")
    private WomenProductOrder order;

    private String type; // RETURN, EXCHANGE
    private String reason;
    
    @Column(columnDefinition = "TEXT")
    private String comments;
    
    @Column(columnDefinition = "TEXT")
    private String bankDetails;
    
    private String imagePath;
    private String status; // PENDING, APPROVED, REJECTED, COMPLETED
    
    private LocalDateTime requestTime;

    @ManyToOne
    @JoinColumn(name = "seller_id")
    private WomenProductSeller seller;

    @PrePersist
    protected void onCreate() { this.requestTime = LocalDateTime.now(); }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public WomenProductOrder getOrder() { return order; }
    public void setOrder(WomenProductOrder order) { this.order = order; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getRequestTime() { return requestTime; }
    public void setRequestTime(LocalDateTime requestTime) { this.requestTime = requestTime; }
    public WomenProductSeller getSeller() { return seller; }
    public void setSeller(WomenProductSeller seller) { this.seller = seller; }
}
