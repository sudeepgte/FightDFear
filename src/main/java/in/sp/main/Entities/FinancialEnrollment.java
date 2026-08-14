package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "financial_enrollments")
public class FinancialEnrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "live_session_id")
    private FinancialLiveSession liveSession;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "workshop_id")
    private FinancialWorkshop workshop;

    private String kind;
    private String fullName;
    private String mobile;
    private String email;
    private String occupation;
    private String city;
    private String status = "pending";
    private String paymentStatus = "FREE";
    private Double amount = 0.0;
    private String razorpayPaymentId;
    @Column(columnDefinition = "TEXT")
    private String coachNotes;
    private Integer rating;
    @Column(columnDefinition = "TEXT")
    private String review;
    private Boolean payoutCredited = false;
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public FinancialLiveSession getLiveSession() { return liveSession; }
    public void setLiveSession(FinancialLiveSession liveSession) { this.liveSession = liveSession; }
    public FinancialWorkshop getWorkshop() { return workshop; }
    public void setWorkshop(FinancialWorkshop workshop) { this.workshop = workshop; }
    public String getKind() { return kind; }
    public void setKind(String kind) { this.kind = kind; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getOccupation() { return occupation; }
    public void setOccupation(String occupation) { this.occupation = occupation; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public Double getAmount() { return amount == null ? 0d : amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }
    public String getCoachNotes() { return coachNotes; }
    public void setCoachNotes(String coachNotes) { this.coachNotes = coachNotes; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }
    public Boolean getPayoutCredited() { return payoutCredited; }
    public void setPayoutCredited(Boolean payoutCredited) { this.payoutCredited = payoutCredited; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
