package in.sp.main.Entities;

import java.util.List;

import jakarta.persistence.CascadeType;
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