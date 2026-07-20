package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "women_products")
public class WomenProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String brand;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String fullDescription;

    private Double price;
    private Double originalPrice;
    private String offerBadge;

    private Integer stock;
    private Integer lowStockAlertLevel = 5;
    private String sku;

    private String category; // SKINCARE, HAIRCARE, HYGIENE, CLOTHING, ACCESSORIES, WELLNESS, OTHER
    private String weightSize;
    private String manufacturer;

    @Column(columnDefinition = "TEXT")
    private String ingredients;

    @Column(columnDefinition = "TEXT")
    private String benefits;

    @Column(columnDefinition = "TEXT")
    private String usageInstructions;

    private String tags;

    private String imagePath;
    @Column(columnDefinition = "TEXT")
    private String additionalImagePaths;

    private Boolean active = true;
    private Boolean featured = false;
    private Boolean trackInventory = true;
    private Boolean deleted = false;

    @ManyToOne
    @JoinColumn(name = "seller_id")
    private WomenProductSeller seller;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getFullDescription() { return fullDescription; }
    public void setFullDescription(String fullDescription) { this.fullDescription = fullDescription; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public Double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(Double originalPrice) { this.originalPrice = originalPrice; }
    public String getOfferBadge() { return offerBadge; }
    public void setOfferBadge(String offerBadge) { this.offerBadge = offerBadge; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public Integer getLowStockAlertLevel() { return lowStockAlertLevel; }
    public void setLowStockAlertLevel(Integer lowStockAlertLevel) { this.lowStockAlertLevel = lowStockAlertLevel; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getWeightSize() { return weightSize; }
    public void setWeightSize(String weightSize) { this.weightSize = weightSize; }
    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }
    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }
    public String getBenefits() { return benefits; }
    public void setBenefits(String benefits) { this.benefits = benefits; }
    public String getUsageInstructions() { return usageInstructions; }
    public void setUsageInstructions(String usageInstructions) { this.usageInstructions = usageInstructions; }
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public String getAdditionalImagePaths() { return additionalImagePaths; }
    public void setAdditionalImagePaths(String additionalImagePaths) { this.additionalImagePaths = additionalImagePaths; }
    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
    public Boolean getFeatured() { return featured; }
    public void setFeatured(Boolean featured) { this.featured = featured; }
    public Boolean getTrackInventory() { return trackInventory; }
    public void setTrackInventory(Boolean trackInventory) { this.trackInventory = trackInventory; }
    public WomenProductSeller getSeller() { return seller; }
    public void setSeller(WomenProductSeller seller) { this.seller = seller; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public Boolean getDeleted() { return deleted != null && deleted; }
    public void setDeleted(Boolean deleted) { this.deleted = deleted; }
}
