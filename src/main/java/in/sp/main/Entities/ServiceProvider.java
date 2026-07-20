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
    @Column(name = "provider_category", length = 50)
    private ProviderCategory category;

    // Purpose: short description shown to users (subjects taught, menu, languages).
    private String description;

    // Purpose: city/area for search.
    private String locationText;

    // Purpose: admin verification document.
    private String identityDocumentPath;

    @Enumerated(EnumType.STRING)
    @Column(name = "v_status", length = 20)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private Double rating = 0.0;

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
}

