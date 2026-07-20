package in.sp.main.Entities;
 
import jakarta.persistence.*;
 
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
 
@Entity
@Table(name = "offer_booking")
public class OfferBooking {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    private String customerName;
    private String customerEmail;
    private double originalPrice;
    public double getOriginalPrice() {
		return originalPrice;
	}
    @ManyToOne
    private User user;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	  private String status = "PENDING";
	    public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
	public void setOriginalPrice(double originalPrice) {
		this.originalPrice = originalPrice;
	}
	private LocalDate date;       // Booking date selected by user
    private LocalTime time;       // Booking time selected by user
    public LocalDate getDate() {
		return date;
	}
 
	public void setDate(LocalDate date) {
		this.date = date;
	}
 
	public LocalTime getTime() {
		return time;
	}
 
	public void setTime(LocalTime time) {
		this.time = time;
	}
 
	public String getNotes() {
		return notes;
	}
 
	public void setNotes(String notes) {
		this.notes = notes;
	}
	private String notes;   
    private LocalDateTime bookingDate;
 
    @ManyToOne
    @JoinColumn(name = "offer_id")
    private Offer offer;
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;
 
    public OfferBooking() {
        this.bookingDate = LocalDateTime.now();
    }
 
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
 
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
 
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
 
    public LocalDateTime getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDateTime bookingDate) { this.bookingDate = bookingDate; }
 
    public Offer getOffer() { return offer; }
    public void setOffer(Offer offer) { this.offer = offer; }
 
    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }
}