package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "women_product_sellers")
public class WomenProductSeller {
    public static final int FULL_NAME_MAX_LENGTH = 80;
    public static final int FULL_NAME_MIN_LENGTH = 2;
    /** Letters with optional spaces, apostrophes, periods, or hyphens — no digits. */
    public static final String FULL_NAME_PATTERN = "^[A-Za-z][A-Za-z .'-]{1,79}$";

    public static final int BUSINESS_NAME_MIN_LENGTH = 2;
    public static final int BUSINESS_NAME_MAX_LENGTH = 100;
    /** Starts with letter/digit; allows spaces and common business punctuation (no other symbols). */
    public static final String BUSINESS_NAME_PATTERN = "^[A-Za-z0-9][A-Za-z0-9 &.,'()\\-]{1,99}$";

    public static final int PHONE_LENGTH = 10;
    public static final String PHONE_PATTERN = "^\\d{10}$";
    public static final int ADDRESS_MIN_LENGTH = 10;
    public static final int ADDRESS_MAX_LENGTH = 1000;
    public static final int DESCRIPTION_MAX_LENGTH = 2000;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = FULL_NAME_MAX_LENGTH)
    private String fullName;
    private String email;
    private String phone;
    private String password;
    @Column(length = BUSINESS_NAME_MAX_LENGTH)
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
    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
