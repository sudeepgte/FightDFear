package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

@Entity
@Table(name = "doctors")
public class Doctor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ── 1. Basic Details ──
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String profilePhotoPath;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    // ── 2. Professional Details ──
    private String medicalRegNumber;
    private String specialization;
    private Integer experienceYears;
    private String qualification;
    private String hospitalName;

    @Enumerated(EnumType.STRING)
    private ConsultationType consultationType;

    // Purpose: comma-separated modes e.g. "CLINIC,VIDEO,ONLINE"
    @Column(length = 200)
    private String consultationModes;

    // ── 3. Location Details ──
    // Purpose: basic location text for search (city/area) + packed metadata from mobile.
    @Column(length = 4000)
    private String locationText;
    private String clinicAddress;
    private String city;
    private String state;
    private String pincode;
    private String googleMapLocation;

    // ── 4. Availability ──
    // Purpose: comma-separated day values e.g. "MONDAY,WEDNESDAY,FRIDAY"
    private String availableDays;
    private String startTime;
    private String endTime;
    private Boolean emergencyAvailable = false;

    // Purpose: JSON array of dynamic slots [{"day":"MONDAY","start":"09:00","end":"12:00"}]
    @Column(columnDefinition = "TEXT")
    private String availabilitySlots;

    private Integer slotDurationMinutes = 30;
    private Integer bufferMinutes = 0;
    private String breakStart;
    private String breakEnd;
    @Column(columnDefinition = "TEXT")
    private String blockedDates;
    private Boolean autoConfirm = false;
    @Column(columnDefinition = "TEXT")
    private String clinicPhotos;
    private Double clinicLat;
    private Double clinicLng;
    private LocalDateTime payoutRequestedAt;

    @Column(length = 500)
    private String languages;

    @Column(length = 1000)
    private String services;

    @Column(columnDefinition = "TEXT")
    private String bio;

    // ── 5. Verification ──
    // Purpose: admin verification uses uploaded document path.
    private String identityDocumentPath;
    private String medicalLicensePath;
    private String idProofPath;
    private String degreeCertificatePath;
    @Column(length = 1000)
    private String additionalCertificatePath;

    // Purpose: admin-controlled verification gate; only VERIFIED doctors are shown to users.
    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    @Enumerated(EnumType.STRING)
    private DoctorProfileStatus doctorProfileStatus = DoctorProfileStatus.REGISTERED;

    private Integer profileCompletionPct = 0;

    private LocalDateTime acceptedTermsAt;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @Column(columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(columnDefinition = "TEXT")
    private String changesRequestedNote;

    private LocalDateTime submittedForVerificationAt;

    private Boolean hasPendingReverification = false;

    private Boolean isOnline = false;

    private LocalDateTime lastSeenAt;

    // ── 6. Earnings Setup ──
    private Double consultationFee = 500.0;
    private Double chatFee;
    private Double callFee;
    private Double videoFee;
    private String upiId;
    @Column(length = 500)
    private String bankDetails;

    private Double payoutBalance = 0.0;
    private Double totalEarned = 0.0;
    private Double commissionPercent;
    @Column(length = 512)
    private String fcmToken;

    private Double rating = 0.0;

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) {
            createdAt = now;
        }
        updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // ═══════════ GETTERS & SETTERS ═══════════

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

    public String getProfilePhotoPath() { return profilePhotoPath; }
    public void setProfilePhotoPath(String profilePhotoPath) { this.profilePhotoPath = profilePhotoPath; }

    public Gender getGender() { return gender; }
    public void setGender(Gender gender) { this.gender = gender; }

    public String getMedicalRegNumber() { return medicalRegNumber; }
    public void setMedicalRegNumber(String medicalRegNumber) { this.medicalRegNumber = medicalRegNumber; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }

    public ConsultationType getConsultationType() { return consultationType; }
    public void setConsultationType(ConsultationType consultationType) { this.consultationType = consultationType; }

    public String getConsultationModes() { return consultationModes; }
    public void setConsultationModes(String consultationModes) { this.consultationModes = consultationModes; }

    public String getLocationText() { return locationText; }
    public void setLocationText(String locationText) { this.locationText = locationText; }

    public String getClinicAddress() { return clinicAddress; }
    public void setClinicAddress(String clinicAddress) { this.clinicAddress = clinicAddress; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public String getGoogleMapLocation() { return googleMapLocation; }
    public void setGoogleMapLocation(String googleMapLocation) { this.googleMapLocation = googleMapLocation; }

    public String getAvailableDays() { return availableDays; }
    public void setAvailableDays(String availableDays) { this.availableDays = availableDays; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public Boolean getEmergencyAvailable() { return emergencyAvailable; }
    public void setEmergencyAvailable(Boolean emergencyAvailable) { this.emergencyAvailable = emergencyAvailable; }

    public String getAvailabilitySlots() { return availabilitySlots; }
    public void setAvailabilitySlots(String availabilitySlots) { this.availabilitySlots = availabilitySlots; }

    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }

    public String getServices() { return services; }
    public void setServices(String services) { this.services = services; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getIdentityDocumentPath() { return identityDocumentPath; }
    public void setIdentityDocumentPath(String identityDocumentPath) { this.identityDocumentPath = identityDocumentPath; }

    public String getMedicalLicensePath() { return medicalLicensePath; }
    public void setMedicalLicensePath(String medicalLicensePath) { this.medicalLicensePath = medicalLicensePath; }

    public String getIdProofPath() { return idProofPath; }
    public void setIdProofPath(String idProofPath) { this.idProofPath = idProofPath; }

    public String getDegreeCertificatePath() { return degreeCertificatePath; }
    public void setDegreeCertificatePath(String degreeCertificatePath) { this.degreeCertificatePath = degreeCertificatePath; }

    public String getAdditionalCertificatePath() { return additionalCertificatePath; }
    public void setAdditionalCertificatePath(String additionalCertificatePath) {
        this.additionalCertificatePath = additionalCertificatePath;
    }

    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }

    public DoctorProfileStatus getDoctorProfileStatus() { return doctorProfileStatus; }
    public void setDoctorProfileStatus(DoctorProfileStatus doctorProfileStatus) { this.doctorProfileStatus = doctorProfileStatus; }

    public Integer getProfileCompletionPct() { return profileCompletionPct; }
    public void setProfileCompletionPct(Integer profileCompletionPct) { this.profileCompletionPct = profileCompletionPct; }

    public LocalDateTime getAcceptedTermsAt() { return acceptedTermsAt; }
    public void setAcceptedTermsAt(LocalDateTime acceptedTermsAt) { this.acceptedTermsAt = acceptedTermsAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getChangesRequestedNote() { return changesRequestedNote; }
    public void setChangesRequestedNote(String changesRequestedNote) { this.changesRequestedNote = changesRequestedNote; }

    public LocalDateTime getSubmittedForVerificationAt() { return submittedForVerificationAt; }
    public void setSubmittedForVerificationAt(LocalDateTime submittedForVerificationAt) {
        this.submittedForVerificationAt = submittedForVerificationAt;
    }

    public Boolean getHasPendingReverification() { return hasPendingReverification; }
    public void setHasPendingReverification(Boolean hasPendingReverification) {
        this.hasPendingReverification = hasPendingReverification;
    }

    public Boolean getIsOnline() { return isOnline; }
    public void setIsOnline(Boolean isOnline) { this.isOnline = isOnline; }

    public LocalDateTime getLastSeenAt() { return lastSeenAt; }
    public void setLastSeenAt(LocalDateTime lastSeenAt) { this.lastSeenAt = lastSeenAt; }

    public Double getConsultationFee() { return consultationFee; }
    public void setConsultationFee(Double consultationFee) { this.consultationFee = consultationFee; }

    public Double getChatFee() { return chatFee; }
    public void setChatFee(Double chatFee) { this.chatFee = chatFee; }

    public Double getCallFee() { return callFee; }
    public void setCallFee(Double callFee) { this.callFee = callFee; }

    public Double getVideoFee() { return videoFee; }
    public void setVideoFee(Double videoFee) { this.videoFee = videoFee; }

    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }

    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }

    public Double getPayoutBalance() { return payoutBalance; }
    public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
    public Double getTotalEarned() { return totalEarned; }
    public void setTotalEarned(Double totalEarned) { this.totalEarned = totalEarned; }
    public Double getCommissionPercent() { return commissionPercent; }
    public void setCommissionPercent(Double commissionPercent) { this.commissionPercent = commissionPercent; }
    public String getFcmToken() { return fcmToken; }
    public void setFcmToken(String fcmToken) { this.fcmToken = fcmToken; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Integer getSlotDurationMinutes() { return slotDurationMinutes; }
    public void setSlotDurationMinutes(Integer slotDurationMinutes) { this.slotDurationMinutes = slotDurationMinutes; }
    public Integer getBufferMinutes() { return bufferMinutes; }
    public void setBufferMinutes(Integer bufferMinutes) { this.bufferMinutes = bufferMinutes; }
    public String getBreakStart() { return breakStart; }
    public void setBreakStart(String breakStart) { this.breakStart = breakStart; }
    public String getBreakEnd() { return breakEnd; }
    public void setBreakEnd(String breakEnd) { this.breakEnd = breakEnd; }
    public String getBlockedDates() { return blockedDates; }
    public void setBlockedDates(String blockedDates) { this.blockedDates = blockedDates; }
    public Boolean getAutoConfirm() { return autoConfirm; }
    public void setAutoConfirm(Boolean autoConfirm) { this.autoConfirm = autoConfirm; }
    public String getClinicPhotos() { return clinicPhotos; }
    public void setClinicPhotos(String clinicPhotos) { this.clinicPhotos = clinicPhotos; }
    public Double getClinicLat() { return clinicLat; }
    public void setClinicLat(Double clinicLat) { this.clinicLat = clinicLat; }
    public Double getClinicLng() { return clinicLng; }
    public void setClinicLng(Double clinicLng) { this.clinicLng = clinicLng; }
    public LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
    public void setPayoutRequestedAt(LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
}
