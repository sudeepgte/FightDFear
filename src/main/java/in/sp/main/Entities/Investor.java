package in.sp.main.Entities;

import java.time.LocalDateTime;
import java.time.LocalTime;

import jakarta.persistence.*;

@Entity
@Table(name = "investors")
public class Investor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // --- Personal & Profile Details ---
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String profilePhoto;

    // --- Company & Professional details ---
    private String companyName;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String investmentInterests; // e.g. text description

    private String budgetRange;          // e.g. "1,000 - 10,000 USD" or "10,000 - 50,000 USD"

    // --- Preferences ---
    @Lob
    @Column(columnDefinition = "TEXT")
    private String preferredLocations;   // Comma-separated preferred cities/regions

    @Lob
    @Column(columnDefinition = "TEXT")
    private String preferredCategories;  // Comma-separated categories

    // --- Verification & Premium Status ---
    @Lob
    @Column(columnDefinition = "TEXT")
    private String verificationDocuments; // Document paths

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

    private boolean subscribed = false; // Subscription for access to platform features

    private String designation;
    private String whatsappNumber;
    @Column(columnDefinition = "TEXT")
    private String address;
    private String city;
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
    private String ticketMode;
    private Integer durationMinutes;
    private Integer bufferMinutes;
    private Double typicalCheque;
    private String upiId;
    @Column(columnDefinition = "TEXT")
    private String bankDetails;
    private Double payoutBalance = 0.0;
    private LocalDateTime payoutRequestedAt;
    @Column(columnDefinition = "TEXT")
    private String galleryPhotos;
    private Double rating = 0.0;
    private Integer reviewCount = 0;
    @Column(columnDefinition = "TEXT")
    private String bio;

    // --- Getters and Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfilePhoto() {
        return profilePhoto;
    }

    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getInvestmentInterests() {
        return investmentInterests;
    }

    public void setInvestmentInterests(String investmentInterests) {
        this.investmentInterests = investmentInterests;
    }

    public String getBudgetRange() {
        return budgetRange;
    }

    public void setBudgetRange(String budgetRange) {
        this.budgetRange = budgetRange;
    }

    public String getPreferredLocations() {
        return preferredLocations;
    }

    public void setPreferredLocations(String preferredLocations) {
        this.preferredLocations = preferredLocations;
    }

    public String getPreferredCategories() {
        return preferredCategories;
    }

    public void setPreferredCategories(String preferredCategories) {
        this.preferredCategories = preferredCategories;
    }

    public String getVerificationDocuments() {
        return verificationDocuments;
    }

    public void setVerificationDocuments(String verificationDocuments) {
        this.verificationDocuments = verificationDocuments;
    }

    public VerificationStatus getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(VerificationStatus verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public PartnerProfileStatus getPartnerProfileStatus() {
        return partnerProfileStatus;
    }

    public void setPartnerProfileStatus(PartnerProfileStatus partnerProfileStatus) {
        this.partnerProfileStatus = partnerProfileStatus;
    }

    public Integer getProfileCompletionPct() {
        return profileCompletionPct;
    }

    public void setProfileCompletionPct(Integer profileCompletionPct) {
        this.profileCompletionPct = profileCompletionPct;
    }

    public LocalDateTime getAcceptedTermsAt() {
        return acceptedTermsAt;
    }

    public void setAcceptedTermsAt(LocalDateTime acceptedTermsAt) {
        this.acceptedTermsAt = acceptedTermsAt;
    }

    public LocalDateTime getSubmittedForVerificationAt() {
        return submittedForVerificationAt;
    }

    public void setSubmittedForVerificationAt(LocalDateTime submittedForVerificationAt) {
        this.submittedForVerificationAt = submittedForVerificationAt;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getChangesRequestedNote() {
        return changesRequestedNote;
    }

    public void setChangesRequestedNote(String changesRequestedNote) {
        this.changesRequestedNote = changesRequestedNote;
    }

    public boolean isSubscribed() {
        return subscribed;
    }

    public void setSubscribed(boolean subscribed) {
        this.subscribed = subscribed;
    }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
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
    public String getTicketMode() { return ticketMode; }
    public void setTicketMode(String ticketMode) { this.ticketMode = ticketMode; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public Integer getBufferMinutes() { return bufferMinutes; }
    public void setBufferMinutes(Integer bufferMinutes) { this.bufferMinutes = bufferMinutes; }
    public Double getTypicalCheque() { return typicalCheque; }
    public void setTypicalCheque(Double typicalCheque) { this.typicalCheque = typicalCheque; }
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
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
}
