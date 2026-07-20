package in.sp.main.Entities;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
    private String bio;  // add this field

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

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

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
	
}
