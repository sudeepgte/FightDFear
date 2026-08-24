package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fitness_qr_attendance_sessions")
public class FitnessQrAttendanceSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 64)
    private String token;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trainer_id", nullable = false)
    private FitnessTrainer trainer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", nullable = true)
    private FitnessClass fitnessClass;

    @Column(nullable = false)
    private LocalDate sessionDate;

    private String sessionTime;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime expiresAt;

    private LocalDateTime closedAt;

    @Column(nullable = false)
    private boolean active = true;

    private Double latitude;
    private Double longitude;
    private Integer radiusMeters = 250;

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt) || !active;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public FitnessClass getFitnessClass() { return fitnessClass; }
    public void setFitnessClass(FitnessClass fitnessClass) { this.fitnessClass = fitnessClass; }

    public LocalDate getSessionDate() { return sessionDate; }
    public void setSessionDate(LocalDate sessionDate) { this.sessionDate = sessionDate; }

    public String getSessionTime() { return sessionTime; }
    public void setSessionTime(String sessionTime) { this.sessionTime = sessionTime; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }

    public LocalDateTime getClosedAt() { return closedAt; }
    public void setClosedAt(LocalDateTime closedAt) { this.closedAt = closedAt; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Integer getRadiusMeters() { return radiusMeters; }
    public void setRadiusMeters(Integer radiusMeters) { this.radiusMeters = radiusMeters; }
}
