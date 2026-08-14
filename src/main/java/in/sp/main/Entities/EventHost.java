package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "event_hosts")
public class EventHost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    private String email;
    private String phone;
    private String password;

    private String organizerName;
    private String organizerType;
    private String hostContact;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String hostBio;

    private String city;
    private String state;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String officeAddress;

    private String website;
    private String instagram;
    private String facebook;
    private String linkedin;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String eventCategories;

    private Integer yearsExperience;
    private Integer expectedParticipants;

    private String logoPath;
    private String documentPath;
    private String portfolioPath;

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

    private LocalDateTime createdAt;

    private String whatsappNumber;
    private String pincode;
    private Double latitude;
    private Double longitude;
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
    @Column(columnDefinition = "TEXT")
    private String bankDetails;
    private Double payoutBalance = 0.0;
    private LocalDateTime payoutRequestedAt;
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

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getOrganizerType() { return organizerType; }
    public void setOrganizerType(String organizerType) { this.organizerType = organizerType; }

    public String getHostContact() { return hostContact; }
    public void setHostContact(String hostContact) { this.hostContact = hostContact; }

    public String getHostBio() { return hostBio; }
    public void setHostBio(String hostBio) { this.hostBio = hostBio; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getOfficeAddress() { return officeAddress; }
    public void setOfficeAddress(String officeAddress) { this.officeAddress = officeAddress; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getInstagram() { return instagram; }
    public void setInstagram(String instagram) { this.instagram = instagram; }

    public String getFacebook() { return facebook; }
    public void setFacebook(String facebook) { this.facebook = facebook; }

    public String getLinkedin() { return linkedin; }
    public void setLinkedin(String linkedin) { this.linkedin = linkedin; }

    public String getEventCategories() { return eventCategories; }
    public void setEventCategories(String eventCategories) { this.eventCategories = eventCategories; }

    public Integer getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(Integer yearsExperience) { this.yearsExperience = yearsExperience; }

    public Integer getExpectedParticipants() { return expectedParticipants; }
    public void setExpectedParticipants(Integer expectedParticipants) { this.expectedParticipants = expectedParticipants; }

    public String getLogoPath() { return logoPath; }
    public void setLogoPath(String logoPath) { this.logoPath = logoPath; }

    public String getDocumentPath() { return documentPath; }
    public void setDocumentPath(String documentPath) { this.documentPath = documentPath; }

    public String getPortfolioPath() { return portfolioPath; }
    public void setPortfolioPath(String portfolioPath) { this.portfolioPath = portfolioPath; }

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

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
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
    public String getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(String galleryPhotos) { this.galleryPhotos = galleryPhotos; }
    public Double getRating() { return rating == null ? 0d : rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public Integer getReviewCount() { return reviewCount == null ? 0 : reviewCount; }
    public void setReviewCount(Integer reviewCount) { this.reviewCount = reviewCount; }
}
