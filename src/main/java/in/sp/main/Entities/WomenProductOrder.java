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
    private String status; // PLACED, CONFIRMED, READY_FOR_PICKUP, ASSIGNED, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    private String shippingAddress;
    private Integer rating;
    private String review;

    @ManyToOne
    @JoinColumn(name = "delivery_partner_id")
    private DeliveryPartner deliveryPartner;

    private LocalDateTime assignedAt;
    private LocalDateTime pickedUpAt;
    private LocalDateTime deliveredAt;
    private String trackingNote;

    private Double courierLat;
    private Double courierLng;
    private LocalDateTime courierLocationAt;
    private Double pickupLat;
    private Double pickupLng;
    private Double dropLat;
    private Double dropLng;
    private Integer etaMinutes;
    private Double remainingKm;
    @Column(columnDefinition = "TEXT")
    private String routePolyline;
    private LocalDateTime routeUpdatedAt;
    @Column(columnDefinition = "TEXT")
    private String coachNotes;
    @Column(columnDefinition = "TEXT")
    private String deliveryNotes;
    private Boolean sellerPayoutCredited = false;
    private Boolean deliveryPayoutCredited = false;
    private String paymentStatus;

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
    public DeliveryPartner getDeliveryPartner() { return deliveryPartner; }
    public void setDeliveryPartner(DeliveryPartner deliveryPartner) { this.deliveryPartner = deliveryPartner; }
    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }
    public LocalDateTime getPickedUpAt() { return pickedUpAt; }
    public void setPickedUpAt(LocalDateTime pickedUpAt) { this.pickedUpAt = pickedUpAt; }
    public LocalDateTime getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(LocalDateTime deliveredAt) { this.deliveredAt = deliveredAt; }
    public String getTrackingNote() { return trackingNote; }
    public void setTrackingNote(String trackingNote) { this.trackingNote = trackingNote; }
    public Double getCourierLat() { return courierLat; }
    public void setCourierLat(Double courierLat) { this.courierLat = courierLat; }
    public Double getCourierLng() { return courierLng; }
    public void setCourierLng(Double courierLng) { this.courierLng = courierLng; }
    public LocalDateTime getCourierLocationAt() { return courierLocationAt; }
    public void setCourierLocationAt(LocalDateTime courierLocationAt) { this.courierLocationAt = courierLocationAt; }
    public Double getPickupLat() { return pickupLat; }
    public void setPickupLat(Double pickupLat) { this.pickupLat = pickupLat; }
    public Double getPickupLng() { return pickupLng; }
    public void setPickupLng(Double pickupLng) { this.pickupLng = pickupLng; }
    public Double getDropLat() { return dropLat; }
    public void setDropLat(Double dropLat) { this.dropLat = dropLat; }
    public Double getDropLng() { return dropLng; }
    public void setDropLng(Double dropLng) { this.dropLng = dropLng; }
    public Integer getEtaMinutes() { return etaMinutes; }
    public void setEtaMinutes(Integer etaMinutes) { this.etaMinutes = etaMinutes; }
    public Double getRemainingKm() { return remainingKm; }
    public void setRemainingKm(Double remainingKm) { this.remainingKm = remainingKm; }
    public String getRoutePolyline() { return routePolyline; }
    public void setRoutePolyline(String routePolyline) { this.routePolyline = routePolyline; }
    public LocalDateTime getRouteUpdatedAt() { return routeUpdatedAt; }
    public void setRouteUpdatedAt(LocalDateTime routeUpdatedAt) { this.routeUpdatedAt = routeUpdatedAt; }
    public String getCoachNotes() { return coachNotes; }
    public void setCoachNotes(String coachNotes) { this.coachNotes = coachNotes; }
    public String getDeliveryNotes() { return deliveryNotes; }
    public void setDeliveryNotes(String deliveryNotes) { this.deliveryNotes = deliveryNotes; }
    public Boolean getSellerPayoutCredited() { return sellerPayoutCredited; }
    public void setSellerPayoutCredited(Boolean sellerPayoutCredited) { this.sellerPayoutCredited = sellerPayoutCredited; }
    public Boolean getDeliveryPayoutCredited() { return deliveryPayoutCredited; }
    public void setDeliveryPayoutCredited(Boolean deliveryPayoutCredited) { this.deliveryPayoutCredited = deliveryPayoutCredited; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}
