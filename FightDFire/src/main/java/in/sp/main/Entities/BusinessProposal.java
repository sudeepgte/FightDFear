package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "business_proposals")
public class BusinessProposal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "entrepreneur_id")
    private Entrepreneur entrepreneur;

    private String title;
    private String category;
    private String location;

    @Column(length = 2000)
    private String description;

    private Double fundingNeeded;
    private Double expectedMonthlyIncome;
    private Double amountRaised = 0.0;

    private String photos;      // Comma-separated paths of images
    private String documents;   // Comma-separated paths of document attachments
    private String videoPitch;  // URL path for video pitch

    @Enumerated(EnumType.STRING)
    private VerificationStatus status = VerificationStatus.PENDING;

    private boolean featured = false;
    private boolean premium = false;

    // --- Getters and Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Entrepreneur getEntrepreneur() {
        return entrepreneur;
    }

    public void setEntrepreneur(Entrepreneur entrepreneur) {
        this.entrepreneur = entrepreneur;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getFundingNeeded() {
        return fundingNeeded;
    }

    public void setFundingNeeded(Double fundingNeeded) {
        this.fundingNeeded = fundingNeeded;
    }

    public Double getExpectedMonthlyIncome() {
        return expectedMonthlyIncome;
    }

    public void setExpectedMonthlyIncome(Double expectedMonthlyIncome) {
        this.expectedMonthlyIncome = expectedMonthlyIncome;
    }

    public Double getAmountRaised() {
        return amountRaised;
    }

    public void setAmountRaised(Double amountRaised) {
        this.amountRaised = amountRaised;
    }

    public String getPhotos() {
        return photos;
    }

    public void setPhotos(String photos) {
        this.photos = photos;
    }

    public String getDocuments() {
        return documents;
    }

    public void setDocuments(String documents) {
        this.documents = documents;
    }

    public String getVideoPitch() {
        return videoPitch;
    }

    public void setVideoPitch(String videoPitch) {
        this.videoPitch = videoPitch;
    }

    public VerificationStatus getStatus() {
        return status;
    }

    public void setStatus(VerificationStatus status) {
        this.status = status;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public boolean isPremium() {
        return premium;
    }

    public void setPremium(boolean premium) {
        this.premium = premium;
    }
}
