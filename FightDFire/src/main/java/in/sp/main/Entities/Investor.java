package in.sp.main.Entities;

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
    private String investmentInterests; // e.g. text description
    private String budgetRange;          // e.g. "1,000 - 10,000 USD" or "10,000 - 50,000 USD"

    // --- Preferences ---
    private String preferredLocations;   // Comma-separated preferred cities/regions
    private String preferredCategories;  // Comma-separated categories

    // --- Verification & Premium Status ---
    private String verificationDocuments; // Document paths

    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private boolean subscribed = false; // Subscription for access to platform features

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

    public boolean isSubscribed() {
        return subscribed;
    }

    public void setSubscribed(boolean subscribed) {
        this.subscribed = subscribed;
    }
}
