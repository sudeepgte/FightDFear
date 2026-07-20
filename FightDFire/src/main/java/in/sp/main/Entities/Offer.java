package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "offer")
public class Offer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String title;

    @Column(length = 500)
    private String description;

    private double discountPercent;

    // 🟩 New fields for prices
    private double originalPrice;
    private double discountedPrice;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	private double offerPrice;

    public double getOfferPrice() {
		return offerPrice;
	}

	public void setOfferPrice(double offerPrice) {
		this.offerPrice = offerPrice;
	}

	private LocalDate startDate;
    private LocalDate endDate;

    private boolean active;

    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;

    // 🟦 Automatically calculate discounted price whenever set
    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
        calculateDiscountedPrice();
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
        calculateDiscountedPrice();
    }

    private void calculateDiscountedPrice() {
        if (originalPrice > 0 && discountPercent > 0) {
            this.discountedPrice = originalPrice - (originalPrice * discountPercent / 100);
        } else {
            this.discountedPrice = originalPrice;
        }
    }

    // 🔹 Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public double getOriginalPrice() {
        return originalPrice;
    }

    public double getDiscountedPrice() {
        return discountedPrice;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Salon getSalon() {
        return salon;
    }

    public void setSalon(Salon salon) {
        this.salon = salon;
    }
}
