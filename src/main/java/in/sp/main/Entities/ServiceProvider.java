package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;

@Entity
@Table(name = "service_providers")
public class ServiceProvider {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    private String email;
    private String phone;
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "provider_category", length = 64)
    private ProviderCategory category;

    // Purpose: service details from mobile registration (can be long).
    @Lob
    @Column(columnDefinition = "TEXT")
    private String description;

    // Purpose: city/area / GPS maps link for search.
    @Lob
    @Column(columnDefinition = "TEXT")
    private String locationText;

    // Purpose: admin verification document.
    private String identityDocumentPath;

    @Enumerated(EnumType.STRING)
    @Column(name = "v_status", length = 20)
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

    @Column(name = "practice_areas", columnDefinition = "TEXT")
    private String practiceAreas;

    @Column(name = "bar_council_id", length = 80)
    private String barCouncilId;

    @Column(name = "experience_years")
    private Integer experienceYears;

    @Column(length = 255)
    private String languages;

    @Column(name = "consultation_fee")
    private Double consultationFee;

    @Column(name = "consultation_mode", length = 40)
    private String consultationMode;

    private String designation;
    private String whatsappNumber;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private Double latitude;
    private Double longitude;
    private String audience;
    private Boolean doorService;
    @Column(columnDefinition = "TEXT")
    private String facilities;
    private String openDays;
    private java.time.LocalTime openTime;
    private java.time.LocalTime closeTime;
    private java.time.LocalTime breakStart;
    private java.time.LocalTime breakEnd;
    @Column(columnDefinition = "TEXT")
    private String blockedDates;
    @Column(columnDefinition = "TEXT")
    private String bio;
    private Integer durationMinutes;
    private Integer bufferMinutes;
    private String serviceMode;
    private String upiId;
    private String bankDetails;
    private Double payoutBalance;
    private java.time.LocalDateTime payoutRequestedAt;
    @Column(columnDefinition = "TEXT")
    private String galleryPhotos;
    private String profileImageUrl;

    private String profilePhoto;
    private String businessName;
    private String serviceArea;
    private String qualification;
    private String experience;
    private String availableDays;
    private String workingHoursFrom;
    private String workingHoursTo;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String languagesSpoken;

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

    public ProviderCategory getCategory() {
        return category;
    }

    public void setCategory(ProviderCategory category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocationText() {
        return locationText;
    }

    public void setLocationText(String locationText) {
        this.locationText = locationText;
    }

    public String getIdentityDocumentPath() {
        return identityDocumentPath;
    }

    public void setIdentityDocumentPath(String identityDocumentPath) {
        this.identityDocumentPath = identityDocumentPath;
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

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public String getPracticeAreas() {
        return practiceAreas;
    }

    public void setPracticeAreas(String practiceAreas) {
        this.practiceAreas = practiceAreas;
    }

    public String getBarCouncilId() {
        return barCouncilId;
    }

    public void setBarCouncilId(String barCouncilId) {
        this.barCouncilId = barCouncilId;
    }

    public Integer getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(Integer experienceYears) {
        this.experienceYears = experienceYears;
    }

    public String getLanguages() {
        return languages;
    }

    public void setLanguages(String languages) {
        this.languages = languages;
    }

    public Double getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(Double consultationFee) {
        this.consultationFee = consultationFee;
    }

    public String getConsultationMode() {
        return consultationMode;
    }

    public void setConsultationMode(String consultationMode) {
        this.consultationMode = consultationMode;
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
    public String getAudience() { return audience; }
    public void setAudience(String audience) { this.audience = audience; }
    public Boolean getDoorService() { return doorService; }
    public void setDoorService(Boolean doorService) { this.doorService = doorService; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getOpenDays() { return openDays; }
    public void setOpenDays(String openDays) { this.openDays = openDays; }
    public java.time.LocalTime getOpenTime() { return openTime; }
    public void setOpenTime(java.time.LocalTime openTime) { this.openTime = openTime; }
    public java.time.LocalTime getCloseTime() { return closeTime; }
    public void setCloseTime(java.time.LocalTime closeTime) { this.closeTime = closeTime; }
    public java.time.LocalTime getBreakStart() { return breakStart; }
    public void setBreakStart(java.time.LocalTime breakStart) { this.breakStart = breakStart; }
    public java.time.LocalTime getBreakEnd() { return breakEnd; }
    public void setBreakEnd(java.time.LocalTime breakEnd) { this.breakEnd = breakEnd; }
    public String getBlockedDates() { return blockedDates; }
    public void setBlockedDates(String blockedDates) { this.blockedDates = blockedDates; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public Integer getBufferMinutes() { return bufferMinutes; }
    public void setBufferMinutes(Integer bufferMinutes) { this.bufferMinutes = bufferMinutes; }
    public String getServiceMode() { return serviceMode; }
    public void setServiceMode(String serviceMode) { this.serviceMode = serviceMode; }
    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }
    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
    public Double getPayoutBalance() { return payoutBalance == null ? 0d : payoutBalance; }
    public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
    public java.time.LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
    public void setPayoutRequestedAt(java.time.LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
    public String getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(String galleryPhotos) { this.galleryPhotos = galleryPhotos; }
    public String getProfileImageUrl() { return profileImageUrl; }
    public void setProfileImageUrl(String profileImageUrl) { this.profileImageUrl = profileImageUrl; }

    public String getProfilePhoto() {
        return profilePhoto;
    }

    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getAvailableDays() {
        return availableDays;
    }

    public void setAvailableDays(String availableDays) {
        this.availableDays = availableDays;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getServiceArea() {
        return serviceArea;
    }

    public void setServiceArea(String serviceArea) {
        this.serviceArea = serviceArea;
    }

    public String getWorkingHoursFrom() {
        return workingHoursFrom;
    }

    public void setWorkingHoursFrom(String workingHoursFrom) {
        this.workingHoursFrom = workingHoursFrom;
    }

    public String getWorkingHoursTo() {
        return workingHoursTo;
    }

    public void setWorkingHoursTo(String workingHoursTo) {
        this.workingHoursTo = workingHoursTo;
    }

    public String getLanguagesSpoken() {
        return languagesSpoken;
    }

    public void setLanguagesSpoken(String languagesSpoken) {
        this.languagesSpoken = languagesSpoken;
    }
}

