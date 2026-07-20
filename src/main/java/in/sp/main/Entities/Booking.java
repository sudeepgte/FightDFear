package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "bookings")
public class Booking {
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
    private StylistService service;
    
    @ManyToOne
    @JoinColumn(name = "salon_service_id", nullable = true)
    private Service1 salonService;

    public Service1 getSalonService() {
		return salonService;
	}
	public void setSalonService(Service1 salonService) {
		this.salonService = salonService;
	}

	@ManyToOne
    @JoinColumn(name = "stylist_id")
    private Stylist stylist;

    private LocalDateTime bookingTime; // scheduled time
    @Enumerated(EnumType.STRING)
    private BookingStatus status;
    private Double rating; // rating given by the user for this booking
    private Boolean isInstant = false; // for "Available Now"

    private Double pricePaid;
    private String paymentMode; // "UPI", "CARD", "CASH", "RAZORPAY"
    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;

    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Salon getSalon() {
		return salon;
	}

	public void setSalon(Salon salon) {
		this.salon = salon;
	}

	public StylistService getService() {
		return service;
	}

	public void setService(StylistService service) {
		this.service = service;
	}

	public Stylist getStylist() {
		return stylist;
	}

	public void setStylist(Stylist stylist) {
		this.stylist = stylist;
	}

	public LocalDateTime getBookingTime() {
		return bookingTime;
	}

	public void setBookingTime(LocalDateTime bookingTime) {
		this.bookingTime = bookingTime;
	}

	
	public Boolean getIsInstant() {
		return isInstant;
	}

	public void setIsInstant(Boolean isInstant) {
		this.isInstant = isInstant;
	}

	public Double getPricePaid() {
		return pricePaid;
	}

	public void setPricePaid(Double pricePaid) {
		this.pricePaid = pricePaid;
	}

	public BookingStatus getStatus() {
		return status;
	}

	public void setStatus(BookingStatus status) {
		this.status = status;
	}

	public Double getRating() {
		return rating;
	}

	public void setRating(Double rating) {
		this.rating = rating;
	}

    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String razorpayOrderId) { this.razorpayOrderId = razorpayOrderId; }

    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }

    public String getRazorpaySignature() { return razorpaySignature; }
    public void setRazorpaySignature(String razorpaySignature) { this.razorpaySignature = razorpaySignature; }
}
