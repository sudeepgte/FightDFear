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
    @Column(nullable = false, length = 64, columnDefinition = "VARCHAR(64)")
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
        this.updatedAt = this.createdAt;
        if (this.lifecycleStatus == null) {
            this.lifecycleStatus = EventLifecycleStatus.fromLegacy(this.status);
        }
        if (this.eventFormat == null) {
            this.eventFormat = this.virtual ? EventFormat.ONLINE : EventFormat.OFFLINE;
        }
        if (this.timezone == null || this.timezone.isBlank()) {
            this.timezone = "Asia/Kolkata";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    @Column(name = "is_virtual", nullable = false)
    private boolean virtual = false;

    @Column(name = "`virtual`", nullable = false)
    private boolean legacyVirtual = false;
    private String streamLink;
    private Double boothFee = 0.0;

    @Enumerated(EnumType.STRING)
    @Column(name = "lifecycle_status", length = 40)
    private EventLifecycleStatus lifecycleStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "event_format", length = 20)
    private EventFormat eventFormat = EventFormat.OFFLINE;

    @Column(name = "short_description", length = 500)
    private String shortDescription;
    private String subcategory;

    @Column(name = "starts_at")
    private LocalDateTime startsAt;
    @Column(name = "ends_at")
    private LocalDateTime endsAt;
    @Column(name = "registration_opens_at")
    private LocalDateTime registrationOpensAt;
    @Column(name = "registration_closes_at")
    private LocalDateTime registrationClosesAt;
    @Column(length = 64)
    private String timezone = "Asia/Kolkata";

    @Column(name = "min_participants")
    private Integer minParticipants;

    @Column(name = "venue_area")
    private String venueArea;
    @Column(name = "venue_state")
    private String venueState;
    @Column(name = "venue_pincode")
    private String venuePincode;
    @Column(name = "parking_available")
    private Boolean parkingAvailable = false;
    @Column(name = "accessibility_info", columnDefinition = "TEXT")
    private String accessibilityInfo;
    @Column(name = "venue_instructions", columnDefinition = "TEXT")
    private String venueInstructions;

    @Column(name = "meeting_platform")
    private String meetingPlatform;
    @Column(name = "access_instructions", columnDefinition = "TEXT")
    private String accessInstructions;

    @Column(name = "cancellation_policy", columnDefinition = "TEXT")
    private String cancellationPolicy;
    @Column(name = "refund_policy", columnDefinition = "TEXT")
    private String refundPolicy;
    @Column(name = "age_restriction")
    private String ageRestriction;
    @Column(name = "participant_requirements", columnDefinition = "TEXT")
    private String participantRequirements;
    @Column(name = "what_to_bring", columnDefinition = "TEXT")
    private String whatToBring;
    @Column(name = "terms_instructions", columnDefinition = "TEXT")
    private String termsInstructions;

    @Column(name = "poster_path")
    private String posterPath;
    @Column(name = "promo_video_path")
    private String promoVideoPath;

    @Column(name = "admin_review_note", columnDefinition = "TEXT")
    private String adminReviewNote;
    @Column(name = "published_at")
    private LocalDateTime publishedAt;
    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Version
    private Long version;

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

    public EventLifecycleStatus getLifecycleStatus() { return lifecycleStatus; }
    public void setLifecycleStatus(EventLifecycleStatus lifecycleStatus) { this.lifecycleStatus = lifecycleStatus; }
    public EventFormat getEventFormat() { return eventFormat; }
    public void setEventFormat(EventFormat eventFormat) { this.eventFormat = eventFormat; }
    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }
    public String getSubcategory() { return subcategory; }
    public void setSubcategory(String subcategory) { this.subcategory = subcategory; }
    public LocalDateTime getStartsAt() { return startsAt; }
    public void setStartsAt(LocalDateTime startsAt) { this.startsAt = startsAt; }
    public LocalDateTime getEndsAt() { return endsAt; }
    public void setEndsAt(LocalDateTime endsAt) { this.endsAt = endsAt; }
    public LocalDateTime getRegistrationOpensAt() { return registrationOpensAt; }
    public void setRegistrationOpensAt(LocalDateTime registrationOpensAt) { this.registrationOpensAt = registrationOpensAt; }
    public LocalDateTime getRegistrationClosesAt() { return registrationClosesAt; }
    public void setRegistrationClosesAt(LocalDateTime registrationClosesAt) { this.registrationClosesAt = registrationClosesAt; }
    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }
    public Integer getMinParticipants() { return minParticipants; }
    public void setMinParticipants(Integer minParticipants) { this.minParticipants = minParticipants; }
    public String getVenueArea() { return venueArea; }
    public void setVenueArea(String venueArea) { this.venueArea = venueArea; }
    public String getVenueState() { return venueState; }
    public void setVenueState(String venueState) { this.venueState = venueState; }
    public String getVenuePincode() { return venuePincode; }
    public void setVenuePincode(String venuePincode) { this.venuePincode = venuePincode; }
    public Boolean getParkingAvailable() { return parkingAvailable; }
    public void setParkingAvailable(Boolean parkingAvailable) { this.parkingAvailable = parkingAvailable; }
    public String getAccessibilityInfo() { return accessibilityInfo; }
    public void setAccessibilityInfo(String accessibilityInfo) { this.accessibilityInfo = accessibilityInfo; }
    public String getVenueInstructions() { return venueInstructions; }
    public void setVenueInstructions(String venueInstructions) { this.venueInstructions = venueInstructions; }
    public String getMeetingPlatform() { return meetingPlatform; }
    public void setMeetingPlatform(String meetingPlatform) { this.meetingPlatform = meetingPlatform; }
    public String getAccessInstructions() { return accessInstructions; }
    public void setAccessInstructions(String accessInstructions) { this.accessInstructions = accessInstructions; }
    public String getCancellationPolicy() { return cancellationPolicy; }
    public void setCancellationPolicy(String cancellationPolicy) { this.cancellationPolicy = cancellationPolicy; }
    public String getRefundPolicy() { return refundPolicy; }
    public void setRefundPolicy(String refundPolicy) { this.refundPolicy = refundPolicy; }
    public String getAgeRestriction() { return ageRestriction; }
    public void setAgeRestriction(String ageRestriction) { this.ageRestriction = ageRestriction; }
    public String getParticipantRequirements() { return participantRequirements; }
    public void setParticipantRequirements(String participantRequirements) { this.participantRequirements = participantRequirements; }
    public String getWhatToBring() { return whatToBring; }
    public void setWhatToBring(String whatToBring) { this.whatToBring = whatToBring; }
    public String getTermsInstructions() { return termsInstructions; }
    public void setTermsInstructions(String termsInstructions) { this.termsInstructions = termsInstructions; }
    public String getPosterPath() { return posterPath; }
    public void setPosterPath(String posterPath) { this.posterPath = posterPath; }
    public String getPromoVideoPath() { return promoVideoPath; }
    public void setPromoVideoPath(String promoVideoPath) { this.promoVideoPath = promoVideoPath; }
    public String getAdminReviewNote() { return adminReviewNote; }
    public void setAdminReviewNote(String adminReviewNote) { this.adminReviewNote = adminReviewNote; }
    public LocalDateTime getPublishedAt() { return publishedAt; }
    public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }
    public LocalDateTime getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(LocalDateTime cancelledAt) { this.cancelledAt = cancelledAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public Long getVersion() { return version; }
    public void setVersion(Long version) { this.version = version; }
}
