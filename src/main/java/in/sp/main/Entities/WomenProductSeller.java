package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "women_product_sellers")
public class WomenProductSeller {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String businessName;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String description;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String address;
    @Column(length = 500)
    private String profilePhotoPath;
    @Column(length = 500)
    private String identityDocPath;

    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "partner_profile_status", length = 40)
    private PartnerProfileStatus partnerProfileStatus;

    @Column(name = "profile_completion_pct")
    private Integer profileCompletionPct = 0;

    @Column(name = "accepted_terms_at")
    private LocalDateTime acceptedTermsAt;

    @Column(name = "submitted_for_verification_at")
    private LocalDateTime submittedForVerificationAt;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(name = "changes_requested_note", columnDefinition = "TEXT")
    private String changesRequestedNote;

    private Double rating = 0.0;
    private String designation;
    private String whatsappNumber;
    private String city;
    private String state;
    private String pincode;
    private Double latitude;
    private Double longitude;
    @Column(columnDefinition = "TEXT")
    private String categoriesOffered;
    private String brandType;
    @Column(columnDefinition = "TEXT")
    private String audience;
    @Column(columnDefinition = "TEXT")
    private String facilities;
    private String openDays;
    private LocalTime openTime;
    private LocalTime closeTime;
    private LocalTime breakStart;
    private LocalTime breakEnd;
    @Column(columnDefinition = "TEXT")
    private String blockedDates;
    @Column(columnDefinition = "TEXT")
    private String bio;
    private Integer dispatchHours;
    private Double typicalPrice;
    private String primaryCategory;
    private String gstin;
    private String upiId;
    private String bankDetails;
    private Double payoutBalance = 0.0;
    private LocalDateTime payoutRequestedAt;
    @Column(columnDefinition = "TEXT")
    private String galleryPhotos;
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getProfilePhotoPath() { return profilePhotoPath; }
    public void setProfilePhotoPath(String profilePhotoPath) { this.profilePhotoPath = profilePhotoPath; }
    public String getIdentityDocPath() { return identityDocPath; }
    public void setIdentityDocPath(String identityDocPath) { this.identityDocPath = identityDocPath; }
    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }
    public PartnerProfileStatus getPartnerProfileStatus() { return partnerProfileStatus; }
    public void setPartnerProfileStatus(PartnerProfileStatus partnerProfileStatus) {
        this.partnerProfileStatus = partnerProfileStatus;
    }
    public Integer getProfileCompletionPct() { return profileCompletionPct; }
    public void setProfileCompletionPct(Integer profileCompletionPct) {
        this.profileCompletionPct = profileCompletionPct;
    }
    public LocalDateTime getAcceptedTermsAt() { return acceptedTermsAt; }
    public void setAcceptedTermsAt(LocalDateTime acceptedTermsAt) { this.acceptedTermsAt = acceptedTermsAt; }
    public LocalDateTime getSubmittedForVerificationAt() { return submittedForVerificationAt; }
    public void setSubmittedForVerificationAt(LocalDateTime submittedForVerificationAt) {
        this.submittedForVerificationAt = submittedForVerificationAt;
    }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    public String getChangesRequestedNote() { return changesRequestedNote; }
    public void setChangesRequestedNote(String changesRequestedNote) {
        this.changesRequestedNote = changesRequestedNote;
    }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    public String getCategoriesOffered() { return categoriesOffered; }
    public void setCategoriesOffered(String categoriesOffered) { this.categoriesOffered = categoriesOffered; }
    public String getBrandType() { return brandType; }
    public void setBrandType(String brandType) { this.brandType = brandType; }
    public String getAudience() { return audience; }
    public void setAudience(String audience) { this.audience = audience; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getOpenDays() { return openDays; }
    public void setOpenDays(String openDays) { this.openDays = openDays; }
    public LocalTime getOpenTime() { return openTime; }
    public void setOpenTime(LocalTime openTime) { this.openTime = openTime; }
    public LocalTime getCloseTime() { return closeTime; }
    public void setCloseTime(LocalTime closeTime) { this.closeTime = closeTime; }
    public LocalTime getBreakStart() { return breakStart; }
    public void setBreakStart(LocalTime breakStart) { this.breakStart = breakStart; }
    public LocalTime getBreakEnd() { return breakEnd; }
    public void setBreakEnd(LocalTime breakEnd) { this.breakEnd = breakEnd; }
    public String getBlockedDates() { return blockedDates; }
    public void setBlockedDates(String blockedDates) { this.blockedDates = blockedDates; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public Integer getDispatchHours() { return dispatchHours; }
    public void setDispatchHours(Integer dispatchHours) { this.dispatchHours = dispatchHours; }
    public Double getTypicalPrice() { return typicalPrice; }
    public void setTypicalPrice(Double typicalPrice) { this.typicalPrice = typicalPrice; }
    public String getPrimaryCategory() { return primaryCategory; }
    public void setPrimaryCategory(String primaryCategory) { this.primaryCategory = primaryCategory; }
    public String getGstin() { return gstin; }
    public void setGstin(String gstin) { this.gstin = gstin; }
    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }
    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
    public Double getPayoutBalance() { return payoutBalance == null ? 0d : payoutBalance; }
    public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
    public LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
    public void setPayoutRequestedAt(LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
    public String getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(String galleryPhotos) { this.galleryPhotos = galleryPhotos; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
