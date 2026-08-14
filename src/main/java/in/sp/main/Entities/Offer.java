package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "offer")
public class Offer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String title;

    @Column(length = 500)
    private String description;

    private double discountPercent;

    // 🟩 New fields for prices
    private double originalPrice;
    private double discountedPrice;
    
    private String category;
    private String imageUrl;
    private String offerType;

    private Double minBookingAmount = 0.0;
    private Double maxDiscountAmount = 0.0;
    private String customerEligibility; // All, New, Returning
    
    private Integer maxUsagePerCustomer = 0;
    private Integer totalUsageLimit = 0;
    private Integer usageCount = 0;
    
    private String applicableDays;
    private LocalTime startTime;
    private LocalTime endTime;
    private Boolean advanceBookingRequired = false;

    private Double totalDiscountGiven = 0.0;
    private Double revenueGenerated = 0.0;

    private String explicitStatus;

    @ManyToMany
    @JoinTable(
        name = "offer_applicable_services",
        joinColumns = @JoinColumn(name = "offer_id"),
        inverseJoinColumns = @JoinColumn(name = "service_id")
    )
    private List<Service1> applicableServices;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	private double offerPrice;

    public double getOfferPrice() {
		return offerPrice;
	}

	public void setOfferPrice(double offerPrice) {
		this.offerPrice = offerPrice;
	}

	private LocalDate startDate;
    private LocalDate endDate;

    private boolean active;

    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;

    // 🟦 Automatically calculate discounted price whenever set
    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
        calculateDiscountedPrice();
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
        calculateDiscountedPrice();
    }

    private void calculateDiscountedPrice() {
        if (originalPrice > 0 && discountPercent > 0) {
            this.discountedPrice = originalPrice - (originalPrice * discountPercent / 100);
        } else {
            this.discountedPrice = originalPrice;
        }
    }

    // 🔹 Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public double getOriginalPrice() {
        return originalPrice;
    }

    public double getDiscountedPrice() {
        return discountedPrice;
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

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Salon getSalon() {
        return salon;
    }

    public void setSalon(Salon salon) {
        this.salon = salon;
    }

    // New Getters and Setters

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getOfferType() {
        return offerType;
    }

    public void setOfferType(String offerType) {
        this.offerType = offerType;
    }

    public Double getMinBookingAmount() {
        return minBookingAmount;
    }

    public void setMinBookingAmount(Double minBookingAmount) {
        this.minBookingAmount = minBookingAmount;
    }

    public Double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(Double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public String getCustomerEligibility() {
        return customerEligibility;
    }

    public void setCustomerEligibility(String customerEligibility) {
        this.customerEligibility = customerEligibility;
    }

    public Integer getMaxUsagePerCustomer() {
        return maxUsagePerCustomer;
    }

    public void setMaxUsagePerCustomer(Integer maxUsagePerCustomer) {
        this.maxUsagePerCustomer = maxUsagePerCustomer;
    }

    public Integer getTotalUsageLimit() {
        return totalUsageLimit;
    }

    public void setTotalUsageLimit(Integer totalUsageLimit) {
        this.totalUsageLimit = totalUsageLimit;
    }

    public Integer getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(Integer usageCount) {
        this.usageCount = usageCount;
    }

    public String getApplicableDays() {
        return applicableDays;
    }

    public void setApplicableDays(String applicableDays) {
        this.applicableDays = applicableDays;
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

    public Boolean getAdvanceBookingRequired() {
        return advanceBookingRequired;
    }

    public void setAdvanceBookingRequired(Boolean advanceBookingRequired) {
        this.advanceBookingRequired = advanceBookingRequired;
    }

    public Double getTotalDiscountGiven() {
        return totalDiscountGiven;
    }

    public void setTotalDiscountGiven(Double totalDiscountGiven) {
        this.totalDiscountGiven = totalDiscountGiven;
    }

    public Double getRevenueGenerated() {
        return revenueGenerated;
    }

    public void setRevenueGenerated(Double revenueGenerated) {
        this.revenueGenerated = revenueGenerated;
    }

    public String getExplicitStatus() {
        return explicitStatus;
    }

    public void setExplicitStatus(String explicitStatus) {
        this.explicitStatus = explicitStatus;
    }

    public List<Service1> getApplicableServices() {
        return applicableServices;
    }

    public void setApplicableServices(List<Service1> applicableServices) {
        this.applicableServices = applicableServices;
    }

    @Transient
    public String getDynamicStatus() {
        if (explicitStatus != null && !explicitStatus.trim().isEmpty()) {
            return explicitStatus;
        }
        
        LocalDate today = LocalDate.now();
        if (startDate != null && today.isBefore(startDate)) {
            return "Scheduled";
        } else if (endDate != null && today.isAfter(endDate)) {
            return "Expired";
        } else {
            return "Active";
        }
    }
}
