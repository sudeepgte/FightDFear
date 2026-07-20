package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "fitness_trainers")
public class FitnessTrainer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;

    @Column(unique = true)
    private String email;

    private String phone;
    private String password;
    private Integer experience;
    private String certificationsPath;
    
    @Column(columnDefinition = "TEXT")
    private String specializations; // Comma separated tags e.g., Yoga, HIIT, Zumba

    private String availableTimings; // e.g., "09:00 - 13:00, 17:00 - 21:00"
    private Double sessionFees = 0.0;
    private String profilePhotoPath;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private boolean suspended = false;
    private Double rating = 0.0;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Integer getExperience() { return experience; }
    public void setExperience(Integer experience) { this.experience = experience; }

    public String getCertificationsPath() { return certificationsPath; }
    public void setCertificationsPath(String certificationsPath) { this.certificationsPath = certificationsPath; }

    public String getSpecializations() { return specializations; }
    public void setSpecializations(String specializations) { this.specializations = specializations; }

    public String getAvailableTimings() { return availableTimings; }
    public void setAvailableTimings(String availableTimings) { this.availableTimings = availableTimings; }

    public Double getSessionFees() { return sessionFees; }
    public void setSessionFees(Double sessionFees) { this.sessionFees = sessionFees; }

    public String getProfilePhotoPath() { return profilePhotoPath; }
    public void setProfilePhotoPath(String profilePhotoPath) { this.profilePhotoPath = profilePhotoPath; }

    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }

    public boolean isSuspended() { return suspended; }
    public void setSuspended(boolean suspended) { this.suspended = suspended; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
}
