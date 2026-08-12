package in.sp.main.Entities;

import java.time.LocalDateTime;
import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "stylists")
public class Stylist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;
    private String lastName;
    private String specialization;
    private Integer experienceInYears;
    private Double rating = 0.0;
    private Boolean available = true;

    // optional profile image URL
    private String profileImage;

    private String contactNumber;
    private String email;
    @Column(length = 1000)
    private String bio;
    private String availabilityHours;
    private String password;
    private Boolean isIndependent = false;

    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;

    @OneToMany(mappedBy = "stylist", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<StylistService> services;

    @OneToMany(mappedBy = "stylist", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Booking> bookings;

    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean approved = false;

    public boolean isApproved() { return approved; }
    public void setApproved(boolean approved) { this.approved = approved; }

    // ===== Getters & Setters =====
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public Integer getExperienceInYears() { return experienceInYears; }
    public void setExperienceInYears(Integer experienceInYears) { this.experienceInYears = experienceInYears; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Boolean getAvailable() { return available; }
    public void setAvailable(Boolean available) { this.available = available; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getAvailabilityHours() { return availabilityHours; }
    public void setAvailabilityHours(String availabilityHours) { this.availabilityHours = availabilityHours; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Boolean getIsIndependent() { return isIndependent; }
    public void setIsIndependent(Boolean isIndependent) { this.isIndependent = isIndependent; }

    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }

    public List<StylistService> getServices() { return services; }
    public void setServices(List<StylistService> services) { this.services = services; }

    public List<Booking> getBookings() { return bookings; }
    public void setBookings(List<Booking> bookings) { this.bookings = bookings; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Enumerated(EnumType.STRING)
    @Column(name = "partner_profile_status", length = 40)
    private PartnerProfileStatus partnerProfileStatus;

    @Column(name = "profile_completion_pct")
    private Integer profileCompletionPct = 0;

    @Column(name = "accepted_terms_at")
    private LocalDateTime acceptedTermsAt;

    @Column(name = "submitted_for_verification_at")
    private LocalDateTime submittedForVerificationAt;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @Column(name = "changes_requested_note", columnDefinition = "TEXT")
    private String changesRequestedNote;

    public PartnerProfileStatus getPartnerProfileStatus() { return partnerProfileStatus; }
    public void setPartnerProfileStatus(PartnerProfileStatus partnerProfileStatus) {
        this.partnerProfileStatus = partnerProfileStatus;
    }

    public Integer getProfileCompletionPct() { return profileCompletionPct; }
    public void setProfileCompletionPct(Integer profileCompletionPct) {
        this.profileCompletionPct = profileCompletionPct;
    }

    public LocalDateTime getAcceptedTermsAt() { return acceptedTermsAt; }
    public void setAcceptedTermsAt(LocalDateTime acceptedTermsAt) { this.acceptedTermsAt = acceptedTermsAt; }

    public LocalDateTime getSubmittedForVerificationAt() { return submittedForVerificationAt; }
    public void setSubmittedForVerificationAt(LocalDateTime submittedForVerificationAt) {
        this.submittedForVerificationAt = submittedForVerificationAt;
    }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getChangesRequestedNote() { return changesRequestedNote; }
    public void setChangesRequestedNote(String changesRequestedNote) {
        this.changesRequestedNote = changesRequestedNote;
    }
}
