package in.sp.main.Entities;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "`user`")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String homeAddress;
    private String profilePhoto; // This stores the URL of the profile photo (e.g., /uploads/photo.jpg)
    private String password;
    
    private String dob;
    // New fields
    private Integer age;  // Age field
    private String identityDocument; // Identity document field (e.g., passport or ID card number)

    // Purpose: admin-controlled verification gate (used by Buddy Matching to show only verified users).
    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;
    
    @Enumerated(EnumType.STRING) // Ensures the gender is stored as a string in DB
    private Gender gender; // Gender field (Enum type)
    
    private java.time.LocalDateTime lastReadBroadcastTime;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<EmergencyContact> emergencyContacts;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private MedicalDetails medicalDetails;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TrustedContact> trustedContacts;

    @ManyToOne
    @JoinColumn(name = "martial_arts_center_id")
    private MartialArtsCenter martialArtsCenter;  // Reference to the martial arts center
    
    private Integer rewardPoints = 0;
    
    private Double walletBalance = 0.0;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Booking> bookings;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Review> reviews;

    @OneToMany(mappedBy = "follower", cascade = CascadeType.ALL)
    private List<UserFollow> following;

    @OneToMany(mappedBy = "followed", cascade = CascadeType.ALL)
    private List<UserFollow> followers;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<ExpressPost> posts;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Badge> badges;


	public Integer getRewardPoints() {
		return rewardPoints;
	}

	public void setRewardPoints(Integer rewardPoints) {
		this.rewardPoints = rewardPoints;
	}
	
	public Double getWalletBalance() {
		return walletBalance;
	}

	public void setWalletBalance(Double walletBalance) {
		this.walletBalance = walletBalance;
	}
	
	public java.time.LocalDateTime getLastReadBroadcastTime() {
		return lastReadBroadcastTime;
	}
	public void setLastReadBroadcastTime(java.time.LocalDateTime lastReadBroadcastTime) {
		this.lastReadBroadcastTime = lastReadBroadcastTime;
	}

	public List<Booking> getBookings() {
		return bookings;
	}

	public void setBookings(List<Booking> bookings) {
		this.bookings = bookings;
	}

	public List<Review> getReviews() {
		return reviews;
	}

	public void setReviews(List<Review> reviews) {
		this.reviews = reviews;
	}

	public List<UserFollow> getFollowing() {
		return following;
	}

	public void setFollowing(List<UserFollow> following) {
		this.following = following;
	}

	public List<UserFollow> getFollowers() {
		return followers;
	}

	public void setFollowers(List<UserFollow> followers) {
		this.followers = followers;
	}

	public List<ExpressPost> getPosts() {
		return posts;
	}

	public void setPosts(List<ExpressPost> posts) {
		this.posts = posts;
	}

	public List<Badge> getBadges() {
		return badges;
	}

	public void setBadges(List<Badge> badges) {
		this.badges = badges;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public String getIdentityDocument() {
		return identityDocument;
	}

	public void setIdentityDocument(String identityDocument) {
		this.identityDocument = identityDocument;
	}

    public VerificationStatus getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(VerificationStatus verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

	public Gender getGender() {
		return gender;
	}

	public void setGender(Gender gender) {
		this.gender = gender;
	}

	public MartialArtsCenter getMartialArtsCenter() {
		return martialArtsCenter;
	}

	public void setMartialArtsCenter(MartialArtsCenter martialArtsCenter) {
		this.martialArtsCenter = martialArtsCenter;
	}

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

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getHomeAddress() {
		return homeAddress;
	}

	public void setHomeAddress(String homeAddress) {
		this.homeAddress = homeAddress;
	}

	public String getProfilePhoto() {
		return profilePhoto;
	}

	public void setProfilePhoto(String profilePhoto) {
		this.profilePhoto = profilePhoto;
	}

	public List<EmergencyContact> getEmergencyContacts() {
		return emergencyContacts;
	}

	public void setEmergencyContacts(List<EmergencyContact> emergencyContacts) {
		if (this.emergencyContacts == null) {
			this.emergencyContacts = new java.util.ArrayList<>();
		}
		this.emergencyContacts.clear();
		if (emergencyContacts != null) {
			this.emergencyContacts.addAll(emergencyContacts);
		}
	}

	public MedicalDetails getMedicalDetails() {
		return medicalDetails;
	}

	public void setMedicalDetails(MedicalDetails medicalDetails) {
		this.medicalDetails = medicalDetails;
	}

	public List<TrustedContact> getTrustedContacts() {
		return trustedContacts;
	}

	public void setTrustedContacts(List<TrustedContact> trustedContacts) {
		if (this.trustedContacts == null) {
			this.trustedContacts = new java.util.ArrayList<>();
		}
		this.trustedContacts.clear();
		if (trustedContacts != null) {
			this.trustedContacts.addAll(trustedContacts);
		}
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getDob() {
		return dob;
	}

	public void setDob(String dob) {
		this.dob = dob;
	}

    private boolean isPrivate = false; // Social Media Privacy: If true, only followers see reels

    // Purpose: admin can explicitly ban a user without changing verificationStatus.
    private boolean banned = false;

    public boolean isPrivate() {
        return isPrivate;
    }

    public void setPrivate(boolean isPrivate) {
        this.isPrivate = isPrivate;
    }

    public boolean isBanned() {
        return banned;
    }

    public void setBanned(boolean banned) {
        this.banned = banned;
    }

    private boolean eventHost = false;
    private String eventHostStatus = "NONE"; // NONE, PENDING, APPROVED, REJECTED
    private String organizerName;
    private String organizerType;
    private String hostContact;
    private String hostBio;

    public boolean isEventHost() {
        return eventHost;
    }

    public void setEventHost(boolean eventHost) {
        this.eventHost = eventHost;
    }

    public String getEventHostStatus() {
        return eventHostStatus;
    }

    public void setEventHostStatus(String eventHostStatus) {
        this.eventHostStatus = eventHostStatus;
    }

    public String getOrganizerName() {
        return organizerName;
    }

    public void setOrganizerName(String organizerName) {
        this.organizerName = organizerName;
    }

    public String getOrganizerType() {
        return organizerType;
    }

    public void setOrganizerType(String organizerType) {
        this.organizerType = organizerType;
    }

    public String getHostContact() {
        return hostContact;
    }

    public void setHostContact(String hostContact) {
        this.hostContact = hostContact;
    }

    public String getHostBio() {
        return hostBio;
    }

    public void setHostBio(String hostBio) {
        this.hostBio = hostBio;
    }

    private boolean verifiedCreator = false;
    private Double creatorSubscriptionPrice = 0.0;
    private String creatorAffiliateCode;
    private boolean bannedCreator = false;
    private int adViewsClaimed = 0;

    @Enumerated(EnumType.STRING)
    private PartnerProfileStatus creatorProfileStatus;
    private String creatorCategory;
    private String creatorCity;
    private String creatorBio;
    private String creatorHandle;
    private Integer creatorProfileCompletionPct;
    private java.time.LocalDateTime creatorSubmittedForVerificationAt;
    private String creatorRejectionReason;
    private String creatorChangesRequestedNote;

    private String creatorDesignation;
    private String creatorWhatsapp;
    @Column(columnDefinition = "TEXT")
    private String creatorAddress;
    private String creatorState;
    private String creatorPincode;
    private Double creatorLatitude;
    private Double creatorLongitude;
    @Column(columnDefinition = "TEXT")
    private String creatorAudience;
    private Boolean creatorDoorService = false;
    @Column(columnDefinition = "TEXT")
    private String creatorFacilities;
    private String creatorOpenDays;
    private LocalTime creatorOpenTime;
    private LocalTime creatorCloseTime;
    private LocalTime creatorBreakStart;
    private LocalTime creatorBreakEnd;
    @Column(columnDefinition = "TEXT")
    private String creatorBlockedDates;
    private String creatorCredentialNumber;
    private String creatorSessionMode;
    private Integer creatorDurationMinutes;
    private Integer creatorBufferMinutes;
    private Double creatorTypicalPrice;
    private String creatorUpiId;
    @Column(columnDefinition = "TEXT")
    private String creatorBankDetails;
    private Double creatorPayoutBalance = 0.0;
    private LocalDateTime creatorPayoutRequestedAt;
    @Column(columnDefinition = "TEXT")
    private String creatorGalleryPhotos;
    private Double creatorRating = 0.0;
    private Integer creatorReviewCount = 0;

    public boolean isVerifiedCreator() { return verifiedCreator; }
    public void setVerifiedCreator(boolean verifiedCreator) { this.verifiedCreator = verifiedCreator; }
    public Double getCreatorSubscriptionPrice() { return creatorSubscriptionPrice; }
    public void setCreatorSubscriptionPrice(Double creatorSubscriptionPrice) { this.creatorSubscriptionPrice = creatorSubscriptionPrice; }
    public String getCreatorAffiliateCode() { return creatorAffiliateCode; }
    public void setCreatorAffiliateCode(String creatorAffiliateCode) { this.creatorAffiliateCode = creatorAffiliateCode; }
    public boolean isBannedCreator() { return bannedCreator; }
    public void setBannedCreator(boolean bannedCreator) { this.bannedCreator = bannedCreator; }
    public int getAdViewsClaimed() { return adViewsClaimed; }
    public void setAdViewsClaimed(int adViewsClaimed) { this.adViewsClaimed = adViewsClaimed; }

    public PartnerProfileStatus getCreatorProfileStatus() { return creatorProfileStatus; }
    public void setCreatorProfileStatus(PartnerProfileStatus creatorProfileStatus) { this.creatorProfileStatus = creatorProfileStatus; }
    public String getCreatorCategory() { return creatorCategory; }
    public void setCreatorCategory(String creatorCategory) { this.creatorCategory = creatorCategory; }
    public String getCreatorCity() { return creatorCity; }
    public void setCreatorCity(String creatorCity) { this.creatorCity = creatorCity; }
    public String getCreatorBio() { return creatorBio; }
    public void setCreatorBio(String creatorBio) { this.creatorBio = creatorBio; }
    public String getCreatorHandle() { return creatorHandle; }
    public void setCreatorHandle(String creatorHandle) { this.creatorHandle = creatorHandle; }
    public Integer getCreatorProfileCompletionPct() { return creatorProfileCompletionPct; }
    public void setCreatorProfileCompletionPct(Integer creatorProfileCompletionPct) { this.creatorProfileCompletionPct = creatorProfileCompletionPct; }
    public java.time.LocalDateTime getCreatorSubmittedForVerificationAt() { return creatorSubmittedForVerificationAt; }
    public void setCreatorSubmittedForVerificationAt(java.time.LocalDateTime creatorSubmittedForVerificationAt) {
        this.creatorSubmittedForVerificationAt = creatorSubmittedForVerificationAt;
    }
    public String getCreatorRejectionReason() { return creatorRejectionReason; }
    public void setCreatorRejectionReason(String creatorRejectionReason) { this.creatorRejectionReason = creatorRejectionReason; }
    public String getCreatorChangesRequestedNote() { return creatorChangesRequestedNote; }
    public void setCreatorChangesRequestedNote(String creatorChangesRequestedNote) { this.creatorChangesRequestedNote = creatorChangesRequestedNote; }

    public String getCreatorDesignation() { return creatorDesignation; }
    public void setCreatorDesignation(String creatorDesignation) { this.creatorDesignation = creatorDesignation; }
    public String getCreatorWhatsapp() { return creatorWhatsapp; }
    public void setCreatorWhatsapp(String creatorWhatsapp) { this.creatorWhatsapp = creatorWhatsapp; }
    public String getCreatorAddress() { return creatorAddress; }
    public void setCreatorAddress(String creatorAddress) { this.creatorAddress = creatorAddress; }
    public String getCreatorState() { return creatorState; }
    public void setCreatorState(String creatorState) { this.creatorState = creatorState; }
    public String getCreatorPincode() { return creatorPincode; }
    public void setCreatorPincode(String creatorPincode) { this.creatorPincode = creatorPincode; }
    public Double getCreatorLatitude() { return creatorLatitude; }
    public void setCreatorLatitude(Double creatorLatitude) { this.creatorLatitude = creatorLatitude; }
    public Double getCreatorLongitude() { return creatorLongitude; }
    public void setCreatorLongitude(Double creatorLongitude) { this.creatorLongitude = creatorLongitude; }
    public String getCreatorAudience() { return creatorAudience; }
    public void setCreatorAudience(String creatorAudience) { this.creatorAudience = creatorAudience; }
    public Boolean getCreatorDoorService() { return creatorDoorService; }
    public void setCreatorDoorService(Boolean creatorDoorService) { this.creatorDoorService = creatorDoorService; }
    public String getCreatorFacilities() { return creatorFacilities; }
    public void setCreatorFacilities(String creatorFacilities) { this.creatorFacilities = creatorFacilities; }
    public String getCreatorOpenDays() { return creatorOpenDays; }
    public void setCreatorOpenDays(String creatorOpenDays) { this.creatorOpenDays = creatorOpenDays; }
    public LocalTime getCreatorOpenTime() { return creatorOpenTime; }
    public void setCreatorOpenTime(LocalTime creatorOpenTime) { this.creatorOpenTime = creatorOpenTime; }
    public LocalTime getCreatorCloseTime() { return creatorCloseTime; }
    public void setCreatorCloseTime(LocalTime creatorCloseTime) { this.creatorCloseTime = creatorCloseTime; }
    public LocalTime getCreatorBreakStart() { return creatorBreakStart; }
    public void setCreatorBreakStart(LocalTime creatorBreakStart) { this.creatorBreakStart = creatorBreakStart; }
    public LocalTime getCreatorBreakEnd() { return creatorBreakEnd; }
    public void setCreatorBreakEnd(LocalTime creatorBreakEnd) { this.creatorBreakEnd = creatorBreakEnd; }
    public String getCreatorBlockedDates() { return creatorBlockedDates; }
    public void setCreatorBlockedDates(String creatorBlockedDates) { this.creatorBlockedDates = creatorBlockedDates; }
    public String getCreatorCredentialNumber() { return creatorCredentialNumber; }
    public void setCreatorCredentialNumber(String creatorCredentialNumber) { this.creatorCredentialNumber = creatorCredentialNumber; }
    public String getCreatorSessionMode() { return creatorSessionMode; }
    public void setCreatorSessionMode(String creatorSessionMode) { this.creatorSessionMode = creatorSessionMode; }
    public Integer getCreatorDurationMinutes() { return creatorDurationMinutes; }
    public void setCreatorDurationMinutes(Integer creatorDurationMinutes) { this.creatorDurationMinutes = creatorDurationMinutes; }
    public Integer getCreatorBufferMinutes() { return creatorBufferMinutes; }
    public void setCreatorBufferMinutes(Integer creatorBufferMinutes) { this.creatorBufferMinutes = creatorBufferMinutes; }
    public Double getCreatorTypicalPrice() { return creatorTypicalPrice; }
    public void setCreatorTypicalPrice(Double creatorTypicalPrice) { this.creatorTypicalPrice = creatorTypicalPrice; }
    public String getCreatorUpiId() { return creatorUpiId; }
    public void setCreatorUpiId(String creatorUpiId) { this.creatorUpiId = creatorUpiId; }
    public String getCreatorBankDetails() { return creatorBankDetails; }
    public void setCreatorBankDetails(String creatorBankDetails) { this.creatorBankDetails = creatorBankDetails; }
    public Double getCreatorPayoutBalance() { return creatorPayoutBalance == null ? 0d : creatorPayoutBalance; }
    public void setCreatorPayoutBalance(Double creatorPayoutBalance) { this.creatorPayoutBalance = creatorPayoutBalance; }
    public LocalDateTime getCreatorPayoutRequestedAt() { return creatorPayoutRequestedAt; }
    public void setCreatorPayoutRequestedAt(LocalDateTime creatorPayoutRequestedAt) { this.creatorPayoutRequestedAt = creatorPayoutRequestedAt; }
    public String getCreatorGalleryPhotos() { return creatorGalleryPhotos; }
    public void setCreatorGalleryPhotos(String creatorGalleryPhotos) { this.creatorGalleryPhotos = creatorGalleryPhotos; }
    public Double getCreatorRating() { return creatorRating == null ? 0d : creatorRating; }
    public void setCreatorRating(Double creatorRating) { this.creatorRating = creatorRating; }
    public Integer getCreatorReviewCount() { return creatorReviewCount == null ? 0 : creatorReviewCount; }
    public void setCreatorReviewCount(Integer creatorReviewCount) { this.creatorReviewCount = creatorReviewCount; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return id != null && id.equals(user.id);
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}