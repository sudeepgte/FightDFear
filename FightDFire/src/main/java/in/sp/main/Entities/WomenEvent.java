package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "women_events")
public class WomenEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private WomenEventCategory category;

    @Column(length = 5000)
    private String description;

    private LocalDate eventDate;
    private LocalTime eventTime;

    private String venue;
    private String city;

    private Double entryFee = 0.0;
    private boolean isFree = true;

    private Integer maxParticipants;

    private String bannerImage;
    private String contactInfo;
    private String mapsLocation;

    // Organizer info
    private String organizerName;
    private String organizerType; // NGO, Government, College, Company, Community, Gym, Hospital, Fitness Trainer, Women Entrepreneur

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organizer_host_id")
    private EventHost organizer;

    // Admin control
    private String status = "PENDING"; // PENDING, APPROVED, REJECTED
    private boolean featured = false;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    private boolean virtual = false;
    private String streamLink;
    private Double boothFee = 0.0;

    // ---------- Getters & Setters ----------

    public boolean isVirtual() { return virtual; }
    public void setVirtual(boolean virtual) { this.virtual = virtual; }

    public String getStreamLink() { return streamLink; }
    public void setStreamLink(String streamLink) { this.streamLink = streamLink; }

    public Double getBoothFee() { return boothFee; }
    public void setBoothFee(Double boothFee) { this.boothFee = boothFee; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public WomenEventCategory getCategory() { return category; }
    public void setCategory(WomenEventCategory category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getEventDate() { return eventDate; }
    public void setEventDate(LocalDate eventDate) { this.eventDate = eventDate; }

    public LocalTime getEventTime() { return eventTime; }
    public void setEventTime(LocalTime eventTime) { this.eventTime = eventTime; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Double getEntryFee() { return entryFee; }
    public void setEntryFee(Double entryFee) {
        this.entryFee = entryFee;
        this.isFree = (entryFee == null || entryFee == 0.0);
    }

    public boolean isFree() { return isFree; }
    public void setFree(boolean free) { isFree = free; }

    public Integer getMaxParticipants() { return maxParticipants; }
    public void setMaxParticipants(Integer maxParticipants) { this.maxParticipants = maxParticipants; }

    public String getBannerImage() { return bannerImage; }
    public void setBannerImage(String bannerImage) { this.bannerImage = bannerImage; }

    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }

    public String getMapsLocation() { return mapsLocation; }
    public void setMapsLocation(String mapsLocation) { this.mapsLocation = mapsLocation; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getOrganizerType() { return organizerType; }
    public void setOrganizerType(String organizerType) { this.organizerType = organizerType; }

    public EventHost getOrganizer() { return organizer; }
    public void setOrganizer(EventHost organizer) { this.organizer = organizer; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
