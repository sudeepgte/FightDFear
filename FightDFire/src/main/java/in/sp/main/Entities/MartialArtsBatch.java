package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
public class MartialArtsBatch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String style;
    private String instructor;
    private String ageGroup;
    private String skillLevel;
    private LocalDate startDate;
    private LocalDate endDate;
    private String availableDays;
    private String batchType; // Online / Offline
    private String status; // Active, Full, Upcoming, Closed
    private Integer capacity;
    private String meetingLink;
    private String location;
    private String timeSlot;
    private Double fee;

    @ManyToOne
    @JoinColumn(name = "center_id")
    @JsonIgnore
    private MartialArtsCenter center;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }
    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }
    public String getAgeGroup() { return ageGroup; }
    public void setAgeGroup(String ageGroup) { this.ageGroup = ageGroup; }
    public String getSkillLevel() { return skillLevel; }
    public void setSkillLevel(String skillLevel) { this.skillLevel = skillLevel; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    public String getAvailableDays() { return availableDays; }
    public void setAvailableDays(String availableDays) { this.availableDays = availableDays; }
    public String getBatchType() { return batchType; }
    public void setBatchType(String batchType) { this.batchType = batchType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    public Double getFee() { return fee; }
    public void setFee(Double fee) { this.fee = fee; }
    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }
}
