package in.sp.main.Entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "salon_promotions")
public class SalonPromotion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "salon_id", nullable = false)
    private Salon salon;

    @Column(nullable = false)
    private String promotionName;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String headline;
    private String ctaText;

    private String bannerUrl;

    private String category;
    private String targetAudience;

    @Column(nullable = false)
    private LocalDate startDate;

    @Column(nullable = false)
    private LocalDate endDate;

    private LocalTime startTime;
    private LocalTime endTime;

    // e.g. "Draft", "Paused", or null (null means we calculate dynamically)
    private String explicitStatus;

    @ManyToMany
    @JoinTable(
        name = "promotion_offers",
        joinColumns = @JoinColumn(name = "promotion_id"),
        inverseJoinColumns = @JoinColumn(name = "offer_id")
    )
    private List<Offer> promotedOffers;

    // Transient derived status
    @Transient
    private String dynamicStatus;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Salon getSalon() {
        return salon;
    }

    public void setSalon(Salon salon) {
        this.salon = salon;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHeadline() {
        return headline;
    }

    public void setHeadline(String headline) {
        this.headline = headline;
    }

    public String getCtaText() {
        return ctaText;
    }

    public void setCtaText(String ctaText) {
        this.ctaText = ctaText;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTargetAudience() {
        return targetAudience;
    }

    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getExplicitStatus() {
        return explicitStatus;
    }

    public void setExplicitStatus(String explicitStatus) {
        this.explicitStatus = explicitStatus;
    }

    public List<Offer> getPromotedOffers() {
        return promotedOffers;
    }

    public void setPromotedOffers(List<Offer> promotedOffers) {
        this.promotedOffers = promotedOffers;
    }

    public String getDynamicStatus() {
        if (explicitStatus != null && !explicitStatus.trim().isEmpty()) {
            return explicitStatus;
        }
        
        LocalDate today = LocalDate.now();
        if (today.isBefore(startDate)) {
            return "Scheduled";
        } else if (today.isAfter(endDate)) {
            return "Expired";
        } else {
            return "Active";
        }
    }

    public void setDynamicStatus(String dynamicStatus) {
        this.dynamicStatus = dynamicStatus;
    }
}
