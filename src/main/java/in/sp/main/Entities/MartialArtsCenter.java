package in.sp.main.Entities;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.TreeSet;
import java.util.List;
import java.util.Set;

@Entity
public class MartialArtsCenter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String location;
    private String phoneNumber;
    private String email;
    private String password;

    private String profilePhoto;
    private String trainerCertificatePath;

    @Column(columnDefinition = "TEXT")
    private String about;
    @Column(columnDefinition = "TEXT")
    private String howWeTeach;
    @Column(columnDefinition = "TEXT")
    private String whatWeOffer;

    @ElementCollection
    @CollectionTable(name = "center_gallery_photos", joinColumns = @JoinColumn(name = "center_id"))
    private List<String> galleryPhotos = new ArrayList<>();

    @ElementCollection(targetClass = DayAvailable.class)
    @CollectionTable(name = "center_available_days", joinColumns = @JoinColumn(name = "center_id"))
    @Enumerated(EnumType.STRING)
    @OrderBy
    private Set<DayAvailable> availableDays = new TreeSet<>();

    // getters and setters
    public Set<DayAvailable> getAvailableDays() {
        return availableDays;
    }

    public void setAvailableDays(Set<DayAvailable> availableDays) {
        this.availableDays = availableDays;
    }
 
    private boolean approved = false;
    // No direct binding from form now, will use JSON
    
    @OneToMany(mappedBy = "centre", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MartialArtsType> martialArtsTypes = new ArrayList<>();

    @OneToMany(mappedBy = "center", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MartialArtsBatch> batches = new ArrayList<>();


    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public String getTrainerCertificatePath() { return trainerCertificatePath; }
    public void setTrainerCertificatePath(String trainerCertificatePath) { this.trainerCertificatePath = trainerCertificatePath; }

   
    public List<MartialArtsType> getMartialArtsTypes() { return martialArtsTypes; }
    public void setMartialArtsTypes(List<MartialArtsType> martialArtsTypes) { this.martialArtsTypes = martialArtsTypes; }
    public List<MartialArtsBatch> getBatches() {
        if (batches == null) return new ArrayList<>();
        List<MartialArtsBatch> activeBatches = new ArrayList<>();
        for (MartialArtsBatch b : batches) {
            if (b.getStatus() == null || !"Closed".equalsIgnoreCase(b.getStatus())) {
                activeBatches.add(b);
            }
        }
        return activeBatches;
    }
    public void setBatches(List<MartialArtsBatch> batches) {
        // Do not re-assign or modify the collection directly to prevent Hibernate orphan-removal errors
    }
    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    public String getAbout() { return about; }
    public void setAbout(String about) { this.about = about; }

    public String getHowWeTeach() { return howWeTeach; }
    public void setHowWeTeach(String howWeTeach) { this.howWeTeach = howWeTeach; }

    public String getWhatWeOffer() { return whatWeOffer; }
    public void setWhatWeOffer(String whatWeOffer) { this.whatWeOffer = whatWeOffer; }

    public List<String> getGalleryPhotos() { return galleryPhotos; }
    public void setGalleryPhotos(List<String> galleryPhotos) { this.galleryPhotos = galleryPhotos; }
}
