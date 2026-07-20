package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "fitness_bookings")
public class FitnessBooking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private FitnessTrainer trainer;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "fitness_class_id", nullable = true)
    private FitnessClass fitnessClass;

    private String category; // e.g. Yoga, Zumba
    private LocalDate bookingDate;
    private String bookingTime; // Time slot e.g., "10:00 - 11:00"
    private String sessionType; // ONLINE or OFFLINE
    private String status; // PENDING, APPROVED, REJECTED, COMPLETED, CANCELLED
    private Double paymentAmount = 0.0;
    private String paymentStatus; // PENDING, PAID, REFUNDED
    private String duration = "SINGLE"; // SINGLE, MONTHLY, QUARTERLY, HALF_YEAR, YEAR
    private Integer totalSessions = 1;
    private Integer completedSessions = 0;
    private LocalDate startDate;
    private LocalDate endDate;

    // Getters and Setters
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public Integer getTotalSessions() { return totalSessions; }
    public void setTotalSessions(Integer totalSessions) { this.totalSessions = totalSessions; }

    public Integer getCompletedSessions() { return completedSessions; }
    public void setCompletedSessions(Integer completedSessions) { this.completedSessions = completedSessions; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }

    public String getBookingTime() { return bookingTime; }
    public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getPaymentAmount() { return paymentAmount; }
    public void setPaymentAmount(Double paymentAmount) { this.paymentAmount = paymentAmount; }

    public FitnessClass getFitnessClass() { return fitnessClass; }
    public void setFitnessClass(FitnessClass fitnessClass) { this.fitnessClass = fitnessClass; }
}
