package in.sp.main.Entities;

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

    private Double rating = 0.0;

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

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

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

