package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "women_product_orders")
public class WomenProductOrder {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private WomenProduct product;

    @ManyToOne
    @JoinColumn(name = "seller_id")
    private WomenProductSeller seller;

    private Integer quantity;
    private Double totalPrice;
    private String paymentMethod; // COD, ONLINE
    private String razorpayPaymentId;
    private String status; // PLACED, CONFIRMED, SHIPPED, DELIVERED, CANCELLED
    private String shippingAddress;
    private Integer rating;
    private String review;

    private LocalDateTime orderTime;
    
    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL)
    private WomenReturnRequest returnRequest;

    @PrePersist
    protected void onCreate() { this.orderTime = LocalDateTime.now(); }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public WomenProduct getProduct() { return product; }
    public void setProduct(WomenProduct product) { this.product = product; }
    public WomenProductSeller getSeller() { return seller; }
    public void setSeller(WomenProductSeller seller) { this.seller = seller; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(Double totalPrice) { this.totalPrice = totalPrice; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public LocalDateTime getOrderTime() { return orderTime; }
    public void setOrderTime(LocalDateTime orderTime) { this.orderTime = orderTime; }
    public WomenReturnRequest getReturnRequest() { return returnRequest; }
    public void setReturnRequest(WomenReturnRequest returnRequest) { this.returnRequest = returnRequest; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }
}
