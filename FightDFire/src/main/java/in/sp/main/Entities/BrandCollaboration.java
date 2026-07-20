package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "brand_collaborations")
public class BrandCollaboration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String brandName;
    private String campaignTitle;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Double payRate = 0.0;
    private String status = "ACTIVE"; // ACTIVE, CLOSED
    private LocalDateTime createdAt = LocalDateTime.now();

    public BrandCollaboration() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getCampaignTitle() { return campaignTitle; }
    public void setCampaignTitle(String campaignTitle) { this.campaignTitle = campaignTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getPayRate() { return payRate; }
    public void setPayRate(Double payRate) { this.payRate = payRate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
