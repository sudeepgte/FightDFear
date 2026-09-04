package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "martial_arts_centre_instructor")
public class CentreInstructor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "center_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private MartialArtsCenter center;

    @Column(nullable = false)
    private String name;

    private String email;
    private String phone;
    private String designation; // e.g. Chief Instructor, Assistant Trainer, Black Belt Coach
    private String specialization; // e.g. Kumite, Katas, Self-Defence
    private String experienceYears;
    private boolean active = true;

    private LocalDateTime createdAt = LocalDateTime.now();

    public CentreInstructor() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getExperienceYears() { return experienceYears; }
    public void setExperienceYears(String experienceYears) { this.experienceYears = experienceYears; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
