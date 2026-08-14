package in.sp.main.Entities;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "salons")
public class Salon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private String phone;
    private String email;
    private String website;
    private String profileImageUrl;
    @Column(length = 2000)
    private String bio;

    // --- NEW SALON PROFILE FIELDS ---
    private String salonTagline;
    private String salonCategory;
    private Boolean isWomenOnly = false;
    private String currentStatus = "OPEN";

    // Extended Profile Fields
    private String businessRegistrationNo;
    private String gstNumber;
    private String salonLicenseNo;
    private String alternateNumber;
    private String hygieneStandard;
    private String languagesSpoken;
    private String landmark;
    private Boolean hasReceptionArea;
    private Boolean hasWaitingArea;

    private Integer salonSizeSqFt;
    private Integer totalFloors;
    private Integer totalChairs;
    private Integer treatmentRooms;
    private Integer washrooms;

    private Boolean hasParking = false;
    private Boolean hasAc = false;
    private Boolean hasWifi = false;
    private Boolean hasPowerBackup = false;
    private Boolean isWheelchairAccessible = false;

    @Column(columnDefinition = "TEXT")
    private String amenitiesJson;

    @Column(columnDefinition = "TEXT")
    private String preferencesJson;
    
    @Column(columnDefinition = "TEXT")
    private String operatingHoursJson;

    @Column(columnDefinition = "TEXT")
    private String socialMediaJson;

    @Column(columnDefinition = "TEXT")
    private String interiorImagesJson;

    private String coverImageUrl;
    private String businessRegistrationUrl;
    private String salonLicenseUrl;
    private String fireSafetyUrl;
    private String gstCertificateUrl;

    public String getSalonTagline() { return salonTagline; }
    public void setSalonTagline(String salonTagline) { this.salonTagline = salonTagline; }
    public String getSalonCategory() { return salonCategory; }
    public void setSalonCategory(String salonCategory) { this.salonCategory = salonCategory; }
    public Boolean getIsWomenOnly() { return isWomenOnly; }
    public void setIsWomenOnly(Boolean isWomenOnly) { this.isWomenOnly = isWomenOnly; }
    public String getCurrentStatus() { return currentStatus; }
    public void setCurrentStatus(String currentStatus) { this.currentStatus = currentStatus; }
    public Integer getSalonSizeSqFt() { return salonSizeSqFt; }
    public void setSalonSizeSqFt(Integer salonSizeSqFt) { this.salonSizeSqFt = salonSizeSqFt; }
    public Integer getTotalFloors() { return totalFloors; }
    public void setTotalFloors(Integer totalFloors) { this.totalFloors = totalFloors; }
    public Integer getTotalChairs() { return totalChairs; }
    public void setTotalChairs(Integer totalChairs) { this.totalChairs = totalChairs; }
    public Integer getTreatmentRooms() { return treatmentRooms; }
    public void setTreatmentRooms(Integer treatmentRooms) { this.treatmentRooms = treatmentRooms; }
    public Integer getWashrooms() { return washrooms; }
    public void setWashrooms(Integer washrooms) { this.washrooms = washrooms; }
    public Boolean getHasParking() { return hasParking; }
    public void setHasParking(Boolean hasParking) { this.hasParking = hasParking; }
    public Boolean getHasAc() { return hasAc; }
    public void setHasAc(Boolean hasAc) { this.hasAc = hasAc; }
    public Boolean getHasWifi() { return hasWifi; }
    public void setHasWifi(Boolean hasWifi) { this.hasWifi = hasWifi; }
    public Boolean getHasPowerBackup() { return hasPowerBackup; }
    public void setHasPowerBackup(Boolean hasPowerBackup) { this.hasPowerBackup = hasPowerBackup; }
    public Boolean getIsWheelchairAccessible() { return isWheelchairAccessible; }
    public void setIsWheelchairAccessible(Boolean isWheelchairAccessible) { this.isWheelchairAccessible = isWheelchairAccessible; }
    public String getAmenitiesJson() { return amenitiesJson; }
    public void setAmenitiesJson(String amenitiesJson) { this.amenitiesJson = amenitiesJson; }

    public String getPreferencesJson() { return preferencesJson; }
    public void setPreferencesJson(String preferencesJson) { this.preferencesJson = preferencesJson; }
    public String getOperatingHoursJson() { return operatingHoursJson; }
    public void setOperatingHoursJson(String operatingHoursJson) { this.operatingHoursJson = operatingHoursJson; }
    public String getSocialMediaJson() { return socialMediaJson; }
    public void setSocialMediaJson(String socialMediaJson) { this.socialMediaJson = socialMediaJson; }
    public String getInteriorImagesJson() { return interiorImagesJson; }
    public void setInteriorImagesJson(String interiorImagesJson) { this.interiorImagesJson = interiorImagesJson; }
    public String getCoverImageUrl() { return coverImageUrl; }
    public void setCoverImageUrl(String coverImageUrl) { this.coverImageUrl = coverImageUrl; }
    public String getBusinessRegistrationUrl() { return businessRegistrationUrl; }
    public void setBusinessRegistrationUrl(String businessRegistrationUrl) { this.businessRegistrationUrl = businessRegistrationUrl; }
    public String getSalonLicenseUrl() { return salonLicenseUrl; }
    public void setSalonLicenseUrl(String salonLicenseUrl) { this.salonLicenseUrl = salonLicenseUrl; }
    public String getFireSafetyUrl() { return fireSafetyUrl; }
    public void setFireSafetyUrl(String fireSafetyUrl) { this.fireSafetyUrl = fireSafetyUrl; }
    public String getGstCertificateUrl() { return gstCertificateUrl; }
    public void setGstCertificateUrl(String gstCertificateUrl) { this.gstCertificateUrl = gstCertificateUrl; }
    // --- END NEW SALON PROFILE FIELDS ---

    /** Matches typical JPA/MySQL VARCHAR default for unconstrained String columns. */
    public static final int NAME_MAX_LENGTH = 255;
    public static final int USERNAME_MIN_LENGTH = 3;
    public static final int USERNAME_MAX_LENGTH = 20;
    /** Letters, digits, underscore only — same rule as salon registration UI. */
    public static final String USERNAME_PATTERN = "^[a-zA-Z0-9_]{3,20}$";
    public static final int EMAIL_MAX_LENGTH = 255;
    public static final int PHONE_LENGTH = 10;
    public static final String EMAIL_PATTERN = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$";
    public static final String PHONE_PATTERN = "^\\d{10}$";
    public static final int ADDRESS_MAX_LENGTH = 500;
    public static final int CITY_STATE_MAX_LENGTH = 100;
    public static final int CITY_STATE_MIN_LENGTH = 2;
    public static final int PINCODE_LENGTH = 6;
    public static final String PINCODE_PATTERN = "^\\d{6}$";
    public static final int BIO_MAX_LENGTH = 2000;
    public static final int WEBSITE_MAX_LENGTH = 255;
    public static final int HOURS_MAX_LENGTH = 255;
    /** Earliest accepted salon established year. */
    public static final int ESTABLISHED_YEAR_MIN = 1900;
    public static final String ESTABLISHED_YEAR_PATTERN = "^\\d{4}$";

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    
    @Transient
    private Double averageRating;


	public Double getAverageRating() {
		return averageRating;
	}
	public void setAverageRating(Double averageRating) {
		this.averageRating = averageRating;
	}

    @Transient
    private Integer totalReviews;

    public Integer getTotalReviews() {
        return totalReviews != null ? totalReviews : 0;
    }

    public void setTotalReviews(Integer totalReviews) {
        this.totalReviews = totalReviews;
    }
	private Integer establishedYear; // e.g., 2015

    private String availabilityHours; // e.g., "Mon-Fri: 10am-8pm, Sat-Sun: 10am-6pm"

    public String getAvailabilityHours() {
        return availabilityHours;
    }

    public void setAvailabilityHours(String availabilityHours) {
        this.availabilityHours = availabilityHours;
    }


    public Integer getEstablishedYear() {
		return establishedYear;
	}

	public void setEstablishedYear(Integer establishedYear) {
		this.establishedYear = establishedYear;
	}


	private String username; // username for login
    private String password; // hashed password

    public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getBusinessRegistrationNo() { return businessRegistrationNo; }
    public void setBusinessRegistrationNo(String businessRegistrationNo) { this.businessRegistrationNo = businessRegistrationNo; }
    
    public String getGstNumber() { return gstNumber; }
    public void setGstNumber(String gstNumber) { this.gstNumber = gstNumber; }
    
    public String getSalonLicenseNo() { return salonLicenseNo; }
    public void setSalonLicenseNo(String salonLicenseNo) { this.salonLicenseNo = salonLicenseNo; }
    
    public String getAlternateNumber() { return alternateNumber; }
    public void setAlternateNumber(String alternateNumber) { this.alternateNumber = alternateNumber; }
    
    public String getHygieneStandard() { return hygieneStandard; }
    public void setHygieneStandard(String hygieneStandard) { this.hygieneStandard = hygieneStandard; }
    
    public String getLanguagesSpoken() { return languagesSpoken; }
    public void setLanguagesSpoken(String languagesSpoken) { this.languagesSpoken = languagesSpoken; }
    
    public String getLandmark() { return landmark; }
    public void setLandmark(String landmark) { this.landmark = landmark; }
    
    public Boolean getHasReceptionArea() { return hasReceptionArea; }
    public void setHasReceptionArea(Boolean hasReceptionArea) { this.hasReceptionArea = hasReceptionArea; }
    
    public Boolean getHasWaitingArea() { return hasWaitingArea; }
    public void setHasWaitingArea(Boolean hasWaitingArea) { this.hasWaitingArea = hasWaitingArea; }

	private Double latitude;
    private Double longitude;

    private Boolean isEcoFriendly = false;
    private Boolean isCertified = false;

   
    // For hygiene info
    private Double sanitationRating = 0.0;
    private String hygieneCertificateUrl;
    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean approved = false;
 
    public boolean isApproved() {
		return approved;
	}
	public void setApproved(boolean approved) {
		this.approved = approved;
	}
 
 

    @OneToMany(mappedBy = "salon", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Service1> services1;
    
    @OneToMany(mappedBy = "salon", cascade = CascadeType.ALL)
    private List<StylistService> services;

    @OneToMany(mappedBy = "salon", cascade = CascadeType.ALL)
    private List<Stylist> stylists;

    public List<Service1> getServices1() {
		return services1;
	}
	public void setServices1(List<Service1> services1) {
		this.services1 = services1;
	}

	@OneToMany(mappedBy = "salon", cascade = CascadeType.ALL)
    private List<SalonReview> reviews;

    @OneToMany(mappedBy = "salon", cascade = CascadeType.ALL)
    private List<Booking> bookings;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getPincode() {
		return pincode;
	}

	public void setPincode(String pincode) {
		this.pincode = pincode;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}
	 public String getProfileImageUrl() {
	        return profileImageUrl;
	    }

	    public void setProfileImageUrl(String profileImageUrl) {
	        this.profileImageUrl = profileImageUrl;
	    }

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}

	public Boolean getIsEcoFriendly() {
		return isEcoFriendly;
	}

	public void setIsEcoFriendly(Boolean isEcoFriendly) {
		this.isEcoFriendly = isEcoFriendly;
	}

	public Boolean getIsCertified() {
		return isCertified;
	}

	public void setIsCertified(Boolean isCertified) {
		this.isCertified = isCertified;
	}


	public Double getSanitationRating() {
		return sanitationRating;
	}

	public void setSanitationRating(Double sanitationRating) {
		this.sanitationRating = sanitationRating;
	}

	public String getHygieneCertificateUrl() {
		return hygieneCertificateUrl;
	}

	public void setHygieneCertificateUrl(String hygieneCertificateUrl) {
		this.hygieneCertificateUrl = hygieneCertificateUrl;
	}

	public List<StylistService> getServices() {
		return services;
	}

	public void setServices(List<StylistService> services) {
		this.services = services;
	}

	public List<Stylist> getStylists() {
		return stylists;
	}

	public void setStylists(List<Stylist> stylists) {
		this.stylists = stylists;
	}

	public List<SalonReview> getReviews() {
		return reviews;
	}

	public void setReviews(List<SalonReview> reviews) {
		this.reviews = reviews;
	}
	public List<Booking> getBookings() {
		return bookings;
	}

	public void setBookings(List<Booking> bookings) {
		this.bookings = bookings;
	}

    private double rating;
    
    
    public double getRating() {
		return rating;
	}
 
	public void setRating(double rating) {
		this.rating = rating;
	}

	@Enumerated(EnumType.STRING)
	@Column(name = "partner_profile_status", length = 40)
	private PartnerProfileStatus partnerProfileStatus;

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

	public PartnerProfileStatus getPartnerProfileStatus() { return partnerProfileStatus; }
	public void setPartnerProfileStatus(PartnerProfileStatus partnerProfileStatus) {
		this.partnerProfileStatus = partnerProfileStatus;
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

	private String salonType;
	private String designation;
	private String contactPerson;
	private String whatsappNumber;
	@Column(columnDefinition = "TEXT")
	private String categoriesOffered;
	private String audience;
	private Boolean doorService;
	private Boolean femaleStaff;
	@Column(columnDefinition = "TEXT")
	private String facilities;
	private String openDays;
	private java.time.LocalTime openTime;
	private java.time.LocalTime closeTime;
	private java.time.LocalTime breakStart;
	private java.time.LocalTime breakEnd;
	@Column(columnDefinition = "TEXT")
	private String blockedDates;
	private String hygieneNotes;
	@Column(columnDefinition = "TEXT")
	private String galleryPhotos;
	private String upiId;
	private String bankDetails;
	private Double payoutBalance;
	private java.time.LocalDateTime payoutRequestedAt;

	public String getSalonType() { return salonType; }
	public void setSalonType(String salonType) { this.salonType = salonType; }
	public String getDesignation() { return designation; }
	public void setDesignation(String designation) { this.designation = designation; }
	public String getContactPerson() { return contactPerson; }
	public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
	public String getWhatsappNumber() { return whatsappNumber; }
	public void setWhatsappNumber(String whatsappNumber) { this.whatsappNumber = whatsappNumber; }
	public String getCategoriesOffered() { return categoriesOffered; }
	public void setCategoriesOffered(String categoriesOffered) { this.categoriesOffered = categoriesOffered; }
	public String getAudience() { return audience; }
	public void setAudience(String audience) { this.audience = audience; }
	public Boolean getDoorService() { return doorService; }
	public void setDoorService(Boolean doorService) { this.doorService = doorService; }
	public Boolean getFemaleStaff() { return femaleStaff; }
	public void setFemaleStaff(Boolean femaleStaff) { this.femaleStaff = femaleStaff; }
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
	public String getHygieneNotes() { return hygieneNotes; }
	public void setHygieneNotes(String hygieneNotes) { this.hygieneNotes = hygieneNotes; }
	public String getGalleryPhotos() { return galleryPhotos; }
	public void setGalleryPhotos(String galleryPhotos) { this.galleryPhotos = galleryPhotos; }
	public String getUpiId() { return upiId; }
	public void setUpiId(String upiId) { this.upiId = upiId; }
	public String getBankDetails() { return bankDetails; }
	public void setBankDetails(String bankDetails) { this.bankDetails = bankDetails; }
	public Double getPayoutBalance() { return payoutBalance == null ? 0d : payoutBalance; }
	public void setPayoutBalance(Double payoutBalance) { this.payoutBalance = payoutBalance; }
	public java.time.LocalDateTime getPayoutRequestedAt() { return payoutRequestedAt; }
	public void setPayoutRequestedAt(java.time.LocalDateTime payoutRequestedAt) { this.payoutRequestedAt = payoutRequestedAt; }
}
