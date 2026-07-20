package in.sp.main.Entities;
 

import jakarta.persistence.*;
 
@Entity
public class SkinCareTreatment {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    private String centerName;
    private String treatmentName;
 
    @Enumerated(EnumType.STRING)
    private TreatmentType treatmentType; // e.g., Facial, Acne, Anti-Ageing
 
    private String skinType; // e.g., Oily, Dry, Combination, Sensitive
    private Double price;
 
    private String imageUrl; // to show with photo
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon center;
 
    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
 
    public String getCenterName() { return centerName; }
    public void setCenterName(String centerName) { this.centerName = centerName; }
 
    public String getTreatmentName() { return treatmentName; }
    public void setTreatmentName(String treatmentName) { this.treatmentName = treatmentName; }
 
    public TreatmentType getTreatmentType() { return treatmentType; }
    public void setTreatmentType(TreatmentType treatmentType) { this.treatmentType = treatmentType; }
 
    public String getSkinType() { return skinType; }
    public void setSkinType(String skinType) { this.skinType = skinType; }
 
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
 
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
 
    public Salon getCenter() { return center; }
    public void setCenter(Salon center) { this.center = center; }
}