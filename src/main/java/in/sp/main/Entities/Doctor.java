package in.sp.main.Entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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

    // ── 3. Location Details ──
    // Purpose: basic location text for search (city/area).
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

    // ── 5. Verification ──
    // Purpose: admin verification uses uploaded document path.
    private String identityDocumentPath;
    private String medicalLicensePath;
    private String idProofPath;
    private String degreeCertificatePath;

    // Purpose: admin-controlled verification gate; only VERIFIED doctors are shown to users.
    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    // ── 6. Earnings Setup ──
    private Double consultationFee = 500.0;
    private Double chatFee;
    private Double callFee;
    private Double videoFee;
    private String upiId;
    @Column(length = 500)
    private String bankDetails;

    private Double rating = 0.0;

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

    public String getIdentityDocumentPath() { return identityDocumentPath; }
    public void setIdentityDocumentPath(String identityDocumentPath) { this.identityDocumentPath = identityDocumentPath; }

    public String getMedicalLicensePath() { return medicalLicensePath; }
    public void setMedicalLicensePath(String medicalLicensePath) { this.medicalLicensePath = medicalLicensePath; }

    public String getIdProofPath() { return idProofPath; }
    public void setIdProofPath(String idProofPath) { this.idProofPath = idProofPath; }

    public String getDegreeCertificatePath() { return degreeCertificatePath; }
    public void setDegreeCertificatePath(String degreeCertificatePath) { this.degreeCertificatePath = degreeCertificatePath; }

    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }

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

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
}
