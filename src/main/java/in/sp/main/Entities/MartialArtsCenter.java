package in.sp.main.Entities;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.TreeSet;
import java.util.List;
import java.util.Set;

@Entity
public class MartialArtsCenter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String location;
    private String phoneNumber;
    private String email;
    private String password;

    private String profilePhoto;
    private String trainerCertificatePath;

    @Column(columnDefinition = "TEXT")
    private String about;
    @Column(columnDefinition = "TEXT")
    private String howWeTeach;
    @Column(columnDefinition = "TEXT")
    private String whatWeOffer;

    @ElementCollection
    @CollectionTable(name = "center_gallery_photos", joinColumns = @JoinColumn(name = "center_id"))
    private List<String> galleryPhotos = new ArrayList<>();

    @ElementCollection(targetClass = DayAvailable.class)
    @CollectionTable(name = "center_available_days", joinColumns = @JoinColumn(name = "center_id"))
    @Enumerated(EnumType.STRING)
    @OrderBy
    private Set<DayAvailable> availableDays = new TreeSet<>();

    // getters and setters
    public Set<DayAvailable> getAvailableDays() {
        return availableDays;
    }

    public void setAvailableDays(Set<DayAvailable> availableDays) {
        this.availableDays = availableDays;
    }
 
    private boolean approved = false;
    // No direct binding from form now, will use JSON

    @Enumerated(EnumType.STRING)
    @Column(name = "centre_profile_status", length = 40)
    private CentreProfileStatus centreProfileStatus;

    @Column(name = "profile_completion_pct")
    private Integer profileCompletionPct = 0;

    @Column(name = "accepted_terms_at")
    private java.time.LocalDateTime acceptedTermsAt;

    @Column(name = "submitted_for_verification_at")
    private java.time.LocalDateTime submittedForVerificationAt;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(name = "changes_requested_note", columnDefinition = "TEXT")
    private String changesRequestedNote;

    @Column(name = "contact_person", length = 120)
    private String contactPerson;
    
    @OneToMany(mappedBy = "centre", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MartialArtsType> martialArtsTypes = new ArrayList<>();

    @OneToMany(mappedBy = "center", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MartialArtsBatch> batches = new ArrayList<>();


    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getPhone() { return phoneNumber; }
    public void setPhone(String phone) { this.phoneNumber = phone; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public String getTrainerCertificatePath() { return trainerCertificatePath; }
    public void setTrainerCertificatePath(String trainerCertificatePath) { this.trainerCertificatePath = trainerCertificatePath; }

   
    public List<MartialArtsType> getMartialArtsTypes() { return martialArtsTypes; }
    public void setMartialArtsTypes(List<MartialArtsType> martialArtsTypes) { this.martialArtsTypes = martialArtsTypes; }
    public List<MartialArtsBatch> getBatches() {
        if (batches == null) return new ArrayList<>();
        List<MartialArtsBatch> activeBatches = new ArrayList<>();
        for (MartialArtsBatch b : batches) {
            if (b.getStatus() == null || !"Closed".equalsIgnoreCase(b.getStatus())) {
                activeBatches.add(b);
            }
        }
        return activeBatches;
    }
    public void setBatches(List<MartialArtsBatch> batches) {
        // Do not re-assign or modify the collection directly to prevent Hibernate orphan-removal errors
    }
    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    public CentreProfileStatus getCentreProfileStatus() { return centreProfileStatus; }
    public void setCentreProfileStatus(CentreProfileStatus centreProfileStatus) {
        this.centreProfileStatus = centreProfileStatus;
    }

    public Integer getProfileCompletionPct() { return profileCompletionPct; }
    public void setProfileCompletionPct(Integer profileCompletionPct) {
        this.profileCompletionPct = profileCompletionPct;
    }

    public java.time.LocalDateTime getAcceptedTermsAt() { return acceptedTermsAt; }
    public void setAcceptedTermsAt(java.time.LocalDateTime acceptedTermsAt) {
        this.acceptedTermsAt = acceptedTermsAt;
    }

    public java.time.LocalDateTime getSubmittedForVerificationAt() { return submittedForVerificationAt; }
    public void setSubmittedForVerificationAt(java.time.LocalDateTime submittedForVerificationAt) {
        this.submittedForVerificationAt = submittedForVerificationAt;
    }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getChangesRequestedNote() { return changesRequestedNote; }
    public void setChangesRequestedNote(String changesRequestedNote) {
        this.changesRequestedNote = changesRequestedNote;
    }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getAbout() { return about; }
    public void setAbout(String about) { this.about = about; }

    public String getHowWeTeach() { return howWeTeach; }
    public void setHowWeTeach(String howWeTeach) { this.howWeTeach = howWeTeach; }

    public String getWhatWeOffer() { return whatWeOffer; }
    public void setWhatWeOffer(String whatWeOffer) { this.whatWeOffer = whatWeOffer; }

    public List<String> getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(List<String> galleryPhotos) { this.galleryPhotos = galleryPhotos; }

    private String centreType;
    private String designation;
    private String whatsappNumber;
    private Integer yearStarted;
    private String affiliation;
    private String area;
    private String city;
    private String state;
    private String pincode;
    private String googleMapLocation;
    private Double centreLat;
    private Double centreLng;
    @Column(columnDefinition = "TEXT")
    private String stylesTaught;
    private String audience;
    private Boolean womenOnlyBatches;
    private Boolean femaleInstructor;
    private String ageGroups;
    @Column(columnDefinition = "TEXT")
    private String facilities;
    private String openTime;
    private String closeTime;
    private String breakStart;
    private String breakEnd;
    @Column(columnDefinition = "TEXT")
    private String blockedDates;
    private Double startingFee;
    private Boolean trialAvailable;
    private String upiId;
    private String bankDetails;
    private Double payoutBalance;
    private java.time.LocalDateTime payoutRequestedAt;
    private Double rating;

    public String getCentreType() { return centreType; }
    public void setCentreType(String centreType) { this.centreType = centreType; }
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getWhatsappNumber() { return whatsappNumber; }
    public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
    public Integer getYearStarted() { return yearStarted; }
    public void setYearStarted(Integer yearStarted) { this.yearStarted = yearStarted; }
    public String getAffiliation() { return affiliation; }
    public void setAffiliation(String affiliation) { this.affiliation = affiliation; }
    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public String getGoogleMapLocation() { return googleMapLocation; }
    public void setGoogleMapLocation(String googleMapLocation) { this.googleMapLocation = googleMapLocation; }
    public Double getCentreLat() { return centreLat; }
    public void setCentreLat(Double centreLat) { this.centreLat = centreLat; }
    public Double getCentreLng() { return centreLng; }
    public void setCentreLng(Double centreLng) { this.centreLng = centreLng; }
    public String getStylesTaught() { return stylesTaught; }
    public void setStylesTaught(String stylesTaught) { this.stylesTaught = stylesTaught; }
    public String getAudience() { return audience; }
    public void setAudience(String audience) { this.audience = audience; }
    public Boolean getWomenOnlyBatches() { return womenOnlyBatches; }
    public void setWomenOnlyBatches(Boolean womenOnlyBatches) { this.womenOnlyBatches = womenOnlyBatches; }
    public Boolean getFemaleInstructor() { return femaleInstructor; }
    public void setFemaleInstructor(Boolean femaleInstructor) { this.femaleInstructor = femaleInstructor; }
    public String getAgeGroups() { return ageGroups; }
    public void setAgeGroups(String ageGroups) { this.ageGroups = ageGroups; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }
    public String getCloseTime() { return closeTime; }
    public void setCloseTime(String closeTime) { this.closeTime = closeTime; }
    public String getBreakStart() { return breakStart; }
    public void setBreakStart(String breakStart) { this.breakStart = breakStart; }
    public String getBreakEnd() { return breakEnd; }
    public void setBreakEnd(String breakEnd) { this.breakEnd = breakEnd; }
    public String getBlockedDates() { return blockedDates; }
    public void setBlockedDates(String blockedDates) { this.blockedDates = blockedDates; }
    public Double getStartingFee() { return startingFee; }
    public void setStartingFee(Double startingFee) { this.startingFee = startingFee; }
    public Boolean getTrialAvailable() { return trialAvailable; }
    public void setTrialAvailable(Boolean trialAvailable) { this.trialAvailable = trialAvailable; }
    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }
    public String getBankDetails() { return bankDetails; }
    public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
    public Double getPayoutBalance() { return payoutBalance; }
    public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
    public java.time.LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
    public void setPayoutRequestedAt(java.time.LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
}
