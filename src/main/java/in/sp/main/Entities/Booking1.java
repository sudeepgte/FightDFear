package in.sp.main.Entities;
 
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
 
@Entity
public class Booking1 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;
 
    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service1 service;
 
    @ManyToOne
    @JoinColumn(name = "treatment_id")
    private Treatment treatment; // <-- New field for treatment booking

    @ManyToOne
    @JoinColumn(name = "offer_id")
    private Offer offer; // <-- New field for offer booking

    @ManyToOne
    @JoinColumn(name = "package_id")
    private SalonPackage salonPackage;

    @ManyToOne
    @JoinColumn(name = "membership_id")
    private SalonMembership salonMembership;

    private String status = "PENDING";
    public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	// Add getters and setters
    public Offer getOffer() { return offer; }
    public void setOffer(Offer offer) { this.offer = offer; }
 
 
    private LocalDate bookingDate;
    private String bookingType; // "ONLINE" or "DOOR"
    private String address; // for door booking
    private double price;
    private String notes; // optional
    private LocalTime preferredTime; 
    
    private String emergencyContact;
    private String allergyInfo;
    private LocalDateTime createdAt = LocalDateTime.now();
    @Column(columnDefinition = "TEXT")
    private String coachNotes;
    private String cancelReason;
    @Column(name = "reminder_1h_sent")
    private Boolean reminder1hSent;
    private Boolean consentPolicy;
 
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }
    public Service1 getService() { return service; }
    public void setService(Service1 service) { this.service = service; }
    public Treatment getTreatment() { return treatment; }
    public void setTreatment(Treatment treatment) { this.treatment = treatment; }
    public String getBookingType() { return bookingType; }
    public void setBookingType(String bookingType) { this.bookingType = bookingType; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public String getEmergencyContact() { return emergencyContact; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }
    public String getAllergyInfo() { return allergyInfo; }
    public void setAllergyInfo(String allergyInfo) { this.allergyInfo = allergyInfo; }
	public LocalTime getPreferredTime() {
		return preferredTime;
	}
	public void setPreferredTime(LocalTime preferredTime) {
		this.preferredTime = preferredTime;
	}
	public LocalDate getBookingDate() {
		return bookingDate;
	}
	public void setBookingDate(LocalDate localDate) {
		this.bookingDate = localDate;
	}
	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
	public String getCoachNotes() { return coachNotes; }
	public void setCoachNotes(String coachNotes) { this.coachNotes = coachNotes; }
	public String getCancelReason() { return cancelReason; }
	public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
	public Boolean getReminder1hSent() { return reminder1hSent; }
	public void setReminder1hSent(Boolean reminder1hSent) { this.reminder1hSent = reminder1hSent; }
	public Boolean getConsentPolicy() { return consentPolicy; }
	public void setConsentPolicy(Boolean consentPolicy) { this.consentPolicy = consentPolicy; }
	public SalonPackage getSalonPackage() { return salonPackage; }
	public void setSalonPackage(SalonPackage salonPackage) { this.salonPackage = salonPackage; }
	public SalonMembership getSalonMembership() { return salonMembership; }
	public void setSalonMembership(SalonMembership salonMembership) { this.salonMembership = salonMembership; }
}