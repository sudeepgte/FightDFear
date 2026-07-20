package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class ProviderClass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String className;
    private String description;
    private String duration;
    private LocalDateTime dateTime;
    private String mode; // Live / Recorded
    private Double price;
    private Integer availableSeats;
    private String meetingLink;

    @ManyToOne
    private ServiceProvider provider;

    @Enumerated(EnumType.STRING)
    private ProviderCategory category;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }
    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public Integer getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(Integer availableSeats) { this.availableSeats = availableSeats; }
    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }
    public ServiceProvider getProvider() { return provider; }
    public void setProvider(ServiceProvider provider) { this.provider = provider; }

    public ProviderCategory getCategory() {
        if (category == null && provider != null) {
            return provider.getCategory();
        }
        return category;
    }
    public void setCategory(ProviderCategory category) { this.category = category; }
}