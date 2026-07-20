package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "entrepreneurs")
public class Entrepreneur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // --- Personal Details ---
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String profilePhoto;
    private String dob;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    // --- Aadhaar Verification ---
    private String aadhaarNumber;
    private String aadhaarDocPath;

    // --- Business Details ---
    private String businessName;
    private String businessCategory;
    private String businessLocation;
    
    @Column(length = 2000)
    private String businessDescription;
    
    private Double investmentNeeded;
    private Double expectedMonthlyIncome;
    private Integer businessExperience; // in years

    // --- Media & Documents ---
    private String photosPath;       // Comma-separated paths of uploaded photos
    private String documentsPath;    // Comma-separated paths of uploaded documents
    private String videoPitchPath;   // Optional video pitch path

    // --- Bank Details ---
    private String bankName;
    private String accountNumber;
    private String ifscCode;
    private String upiId;

    // --- Verification & Premium Status ---
    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private boolean verificationFeePaid = false;
    private boolean premiumListing = false;
    private boolean featured = false;

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

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getAadhaarNumber() {
        return aadhaarNumber;
    }

    public void setAadhaarNumber(String aadhaarNumber) {
        this.aadhaarNumber = aadhaarNumber;
    }

    public String getAadhaarDocPath() {
        return aadhaarDocPath;
    }

    public void setAadhaarDocPath(String aadhaarDocPath) {
        this.aadhaarDocPath = aadhaarDocPath;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getBusinessCategory() {
        return businessCategory;
    }

    public void setBusinessCategory(String businessCategory) {
        this.businessCategory = businessCategory;
    }

    public String getBusinessLocation() {
        return businessLocation;
    }

    public void setBusinessLocation(String businessLocation) {
        this.businessLocation = businessLocation;
    }

    public String getBusinessDescription() {
        return businessDescription;
    }

    public void setBusinessDescription(String businessDescription) {
        this.businessDescription = businessDescription;
    }

    public Double getInvestmentNeeded() {
        return investmentNeeded;
    }

    public void setInvestmentNeeded(Double investmentNeeded) {
        this.investmentNeeded = investmentNeeded;
    }

    public Double getExpectedMonthlyIncome() {
        return expectedMonthlyIncome;
    }

    public void setExpectedMonthlyIncome(Double expectedMonthlyIncome) {
        this.expectedMonthlyIncome = expectedMonthlyIncome;
    }

    public Integer getBusinessExperience() {
        return businessExperience;
    }

    public void setBusinessExperience(Integer businessExperience) {
        this.businessExperience = businessExperience;
    }

    public String getPhotosPath() {
        return photosPath;
    }

    public void setPhotosPath(String photosPath) {
        this.photosPath = photosPath;
    }

    public String getDocumentsPath() {
        return documentsPath;
    }

    public void setDocumentsPath(String documentsPath) {
        this.documentsPath = documentsPath;
    }

    public String getVideoPitchPath() {
        return videoPitchPath;
    }

    public void setVideoPitchPath(String videoPitchPath) {
        this.videoPitchPath = videoPitchPath;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getIfscCode() {
        return ifscCode;
    }

    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }

    public String getUpiId() {
        return upiId;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public VerificationStatus getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(VerificationStatus verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public boolean isVerificationFeePaid() {
        return verificationFeePaid;
    }

    public void setVerificationFeePaid(boolean verificationFeePaid) {
        this.verificationFeePaid = verificationFeePaid;
    }

    public boolean isPremiumListing() {
        return premiumListing;
    }

    public void setPremiumListing(boolean premiumListing) {
        this.premiumListing = premiumListing;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }
}
