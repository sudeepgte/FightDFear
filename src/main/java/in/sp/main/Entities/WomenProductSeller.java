package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

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

    @Column(length = 100)
    private String category;
    @Column(length = 255)
    private String serviceArea;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String qualification;
    @Column(length = 100)
    private String experience;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String availableDays;
    @Column(length = 50)
    private String workingHoursFrom;
    @Column(length = 50)
    private String workingHoursTo;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String languagesSpoken;

    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private Double rating = 0.0;
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
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getServiceArea() { return serviceArea; }
    public void setServiceArea(String serviceArea) { this.serviceArea = serviceArea; }
    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }
    public String getAvailableDays() { return availableDays; }
    public void setAvailableDays(String availableDays) { this.availableDays = availableDays; }
    public String getWorkingHoursFrom() { return workingHoursFrom; }
    public void setWorkingHoursFrom(String workingHoursFrom) { this.workingHoursFrom = workingHoursFrom; }
    public String getWorkingHoursTo() { return workingHoursTo; }
    public void setWorkingHoursTo(String workingHoursTo) { this.workingHoursTo = workingHoursTo; }
    public String getLanguagesSpoken() { return languagesSpoken; }
    public void setLanguagesSpoken(String languagesSpoken) { this.languagesSpoken = languagesSpoken; }
    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
