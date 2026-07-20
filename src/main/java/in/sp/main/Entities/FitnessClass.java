package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "fitness_classes")
public class FitnessClass {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private FitnessTrainer trainer;

    private String className;
    private String category;
    @Column(length = 2000)
    private String description;
    
    private LocalDate classDate;
    private LocalTime classTime;
    private Integer durationMinutes;
    
    private String sessionType; // ONLINE or OFFLINE
    private Integer maxCapacity;
    private Integer currentEnrollment = 0;
    private Double price;
    private String meetingLinkOrLocation;

    private String status = "ACTIVE"; // ACTIVE, CANCELLED, COMPLETED

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FitnessTrainer getTrainer() { return trainer; }
    public void setTrainer(FitnessTrainer trainer) { this.trainer = trainer; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getClassDate() { return classDate; }
    public void setClassDate(LocalDate classDate) { this.classDate = classDate; }

    public LocalTime getClassTime() { return classTime; }
    public void setClassTime(LocalTime classTime) { this.classTime = classTime; }

    public String getFormattedClassTime() {
        if (classTime == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");
        return classTime.format(formatter);
    }

    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public Integer getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(Integer maxCapacity) { this.maxCapacity = maxCapacity; }

    public Integer getCurrentEnrollment() { return currentEnrollment; }
    public void setCurrentEnrollment(Integer currentEnrollment) { this.currentEnrollment = currentEnrollment; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getMeetingLinkOrLocation() { return meetingLinkOrLocation; }
    public void setMeetingLinkOrLocation(String meetingLinkOrLocation) { this.meetingLinkOrLocation = meetingLinkOrLocation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
