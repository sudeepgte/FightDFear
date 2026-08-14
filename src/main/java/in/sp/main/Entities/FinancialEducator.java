package in.sp.main.Entities;

import java.time.LocalDateTime;
import java.time.LocalTime;

import jakarta.persistence.*;

@Entity
@Table(name = "financial_educators")
public class FinancialEducator {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    @Column(unique = true)
    private String email;
    private String phone;
    private String password;
    private String city;
    private String expertise;
    private String organization;
    private Integer yearsExperience;

    @Column(columnDefinition = "TEXT")
    private String bio;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "partner_profile_status", length = 40)
    private PartnerProfileStatus partnerProfileStatus;

    private Integer profileCompletionPct = 0;
    private LocalDateTime acceptedTermsAt;
    private LocalDateTime submittedForVerificationAt;

    @Column(columnDefinition = "TEXT")
    private String rejectionReason;
    @Column(columnDefinition = "TEXT")
    private String changesRequestedNote;

    private boolean suspended = false;
    private LocalDateTime createdAt;

    private String designation;
    private String whatsappNumber;
    @Column(columnDefinition = "TEXT")
    private String address;
    private String state;
    private String pincode;
    private Double latitude;
    private Double longitude;
    @Column(columnDefinition = "TEXT")
    private String categoriesOffered;
    @Column(columnDefinition = "TEXT")
    private String audience;
    private Boolean doorService = false;
    @Column(columnDefinition = "TEXT")
    private String facilities;
    private String openDays;
    private LocalTime openTime;
    private LocalTime closeTime;
    private LocalTime breakStart;
    private LocalTime breakEnd;
    @Column(columnDefinition = "TEXT")
    private String blockedDates;
    private String credentialNumber;
    private String sessionMode;
    private Integer durationMinutes;
    private Integer bufferMinutes;
    private Double typicalPrice;
    private String upiId;
    private String bankDetails;
    private Double payoutBalance = 0.0;
    private LocalDateTime payoutRequestedAt;
    @Column(length = 500)
    private String profilePhotoPath;
    @Column(columnDefinition = "TEXT")
    private String galleryPhotos;
    private Double rating = 0.0;
    private Integer reviewCount = 0;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

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
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getExpertise() { return expertise; }
    public void setExpertise(String expertise) { this.expertise = expertise; }
    public String getOrganization() { return organization; }
    public void setOrganization(String organization) { this.organization = organization; }
    public Integer getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(Integer yearsExperience) { this.yearsExperience = yearsExperience; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }
    public PartnerProfileStatus getPartnerProfileStatus() { return partnerProfileStatus; }
    public void setPartnerProfileStatus(PartnerProfileStatus partnerProfileStatus) { this.partnerProfileStatus = partnerProfileStatus; }
    public Integer getProfileCompletionPct() { return profileCompletionPct; }
    public void setProfileCompletionPct(Integer profileCompletionPct) { this.profileCompletionPct = profileCompletionPct; }
    public LocalDateTime getAcceptedTermsAt() { return acceptedTermsAt; }
    public void setAcceptedTermsAt(LocalDateTime acceptedTermsAt) { this.acceptedTermsAt = acceptedTermsAt; }
    public LocalDateTime getSubmittedForVerificationAt() { return submittedForVerificationAt; }
    public void setSubmittedForVerificationAt(LocalDateTime submittedForVerificationAt) { this.submittedForVerificationAt = submittedForVerificationAt; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    public String getChangesRequestedNote() { return changesRequestedNote; }
    public void setChangesRequestedNote(String changesRequestedNote) { this.changesRequestedNote = changesRequestedNote; }
    public boolean isSuspended() { return suspended; }
    public void setSuspended(boolean suspended) { this.suspended = suspended; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
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
    public String getAudience() { return audience; }
    public void setAudience(String audience) { this.audience = audience; }
    public Boolean getDoorService() { return doorService; }
    public void setDoorService(Boolean doorService) { this.doorService = doorService; }
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
    public String getCredentialNumber() { return credentialNumber; }
    public void setCredentialNumber(String credentialNumber) { this.credentialNumber = credentialNumber; }
    public String getSessionMode() { return sessionMode; }
    public void setSessionMode(String sessionMode) { this.sessionMode = sessionMode; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public Integer getBufferMinutes() { return bufferMinutes; }
    public void setBufferMinutes(Integer bufferMinutes) { this.bufferMinutes = bufferMinutes; }
    public Double getTypicalPrice() { return typicalPrice; }
    public void setTypicalPrice(Double typicalPrice) { this.typicalPrice = typicalPrice; }
    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }
    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
    public Double getPayoutBalance() { return payoutBalance == null ? 0d : payoutBalance; }
    public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
    public LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
    public void setPayoutRequestedAt(LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
    public String getProfilePhotoPath() { return profilePhotoPath; }
    public void setProfilePhotoPath(String profilePhotoPath) { this.profilePhotoPath = profilePhotoPath; }
    public String getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(String galleryPhotos) { this.galleryPhotos = galleryPhotos; }
    public Double getRating() { return rating == null ? 0d : rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public Integer getReviewCount() { return reviewCount == null ? 0 : reviewCount; }
    public void setReviewCount(Integer reviewCount) { this.reviewCount = reviewCount; }
}
