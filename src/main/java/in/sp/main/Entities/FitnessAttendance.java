package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fitness_attendance")
public class FitnessAttendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private FitnessBooking booking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trainer_id", nullable = false)
    private FitnessTrainer trainer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private LocalDate sessionDate;

    private String sessionTime; // e.g. "07:00 AM - 08:00 AM"

    @Column(length = 20)
    private String status = "PRESENT"; // PRESENT, ABSENT, LATE, EXCUSED

    @Column(columnDefinition = "TEXT")
    private String notes;

    private LocalDateTime checkInTime = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FitnessBooking getBooking() { return booking; }
    public void setBooking(FitnessBooking booking) { this.booking = booking; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public LocalDate getSessionDate() { return sessionDate; }
    public void setSessionDate(LocalDate sessionDate) { this.sessionDate = sessionDate; }

    public String getSessionTime() { return sessionTime; }
    public void setSessionTime(String sessionTime) { this.sessionTime = sessionTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCheckInTime() { return checkInTime; }
    public void setCheckInTime(LocalDateTime checkInTime) { this.checkInTime = checkInTime; }
}
