package in.sp.main.Entities;
 


import jakarta.persistence.*;
 
@Entity
@Table(name = "skincare_services")
public class SkinCareService {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    private String treatmentName;
    private String description;
 
    @Enumerated(EnumType.STRING)
    private TreatmentType treatmentType; // Facial, Acne, etc.
 
    private String skinType; // Oily, Dry, Sensitive
    private Double price;
    private String imageUrl;
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;
 
    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
 
    public String getTreatmentName() { return treatmentName; }
    public void setTreatmentName(String treatmentName) { this.treatmentName = treatmentName; }
 
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
 
    public TreatmentType getTreatmentType() { return treatmentType; }
    public void setTreatmentType(TreatmentType treatmentType) { this.treatmentType = treatmentType; }
 
    public String getSkinType() { return skinType; }
    public void setSkinType(String skinType) { this.skinType = skinType; }
 
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
 
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
 
    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }
}