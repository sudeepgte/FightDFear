package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "job_applications")
public class JobApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String jobCategory;

    @Column(nullable = false)
    private String jobSubCategory;

    @Column(nullable = false)
    private String documentPath;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private VerificationStatus status = VerificationStatus.PENDING;

    @Column(nullable = false)
    private LocalDateTime appliedAt = LocalDateTime.now();

    @Column(nullable = false)
    private Double hourlyRate = 0.0;

    @Column(columnDefinition = "TEXT")
    private String note;

    private String designation;
    private String whatsappNumber;
    private Integer yearsExperience;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private Double latitude;
    private Double longitude;
    @Column(columnDefinition = "TEXT")
    private String categoriesOffered;
    private String audience;
    private Boolean doorService;
    @Column(columnDefinition = "TEXT")
    private String languages;
    @Column(columnDefinition = "TEXT")
    private String skills;
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
    private String workType;
    private String upiId;
    private String bankDetails;
    private Double payoutBalance;
    private java.time.LocalDateTime payoutRequestedAt;
    @Column(columnDefinition = "TEXT")
    private String galleryPhotos;
    private String profileImageUrl;
    private Double rating;

    public JobApplication() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getJobCategory() {
        return jobCategory;
    }

    public void setJobCategory(String jobCategory) {
        this.jobCategory = jobCategory;
    }

    public String getJobSubCategory() {
        return jobSubCategory;
    }

    public void setJobSubCategory(String jobSubCategory) {
        this.jobSubCategory = jobSubCategory;
    }

    public String getDocumentPath() {
        return documentPath;
    }

    public void setDocumentPath(String documentPath) {
        this.documentPath = documentPath;
    }

    public VerificationStatus getStatus() {
        return status;
    }

    public void setStatus(VerificationStatus status) {
        this.status = status;
    }

    public LocalDateTime getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(LocalDateTime appliedAt) {
        this.appliedAt = appliedAt;
    }

    public Double getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(Double hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public Integer getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(Integer yearsExperience) { this.yearsExperience = yearsExperience; }
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
    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }
    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
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
    public String getWorkType() { return workType; }
    public void setWorkType(String workType) { this.workType = workType; }
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
    public Double getRating() { return rating == null ? 0d : rating; }
    public void setRating(Double rating) { this.rating = rating; }
}
