package in.sp.main.Entities;
 

import jakarta.persistence.*;
 
@Entity
@Table(name = "treatments")
public class Treatment {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    private String category; // "Skin" or "Hair"
    private String serviceName;
    private String description;
    private double price;
    private int duration; // in minutes
    private String imageUrl;
 
    @Enumerated(EnumType.STRING)
    private TreatmentType treatmentType;
 
    @Enumerated(EnumType.STRING)
    private SkinType skinType; // optional, only for skin
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;
 
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public TreatmentType getTreatmentType() { return treatmentType; }
    public void setTreatmentType(TreatmentType treatmentType) { this.treatmentType = treatmentType; }
    public SkinType getSkinType() { return skinType; }
    public void setSkinType(SkinType skinType) { this.skinType = skinType; }
    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }
}