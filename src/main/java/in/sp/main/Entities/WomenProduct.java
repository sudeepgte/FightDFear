package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "women_products")
public class WomenProduct {
    public static final int NAME_MIN_LENGTH = 2;
    public static final int NAME_MAX_LENGTH = 100;
    public static final int BRAND_MAX_LENGTH = 80;
    /** Short description — strict Add Item form limit. */
    public static final int SHORT_DESCRIPTION_MAX_LENGTH = 22;
    public static final int FULL_DESCRIPTION_MAX_LENGTH = 5000;
    public static final int OFFER_BADGE_MAX_LENGTH = 40;
    public static final int SKU_MAX_LENGTH = 50;
    public static final int WEIGHT_SIZE_MAX_LENGTH = 50;
    public static final int MANUFACTURER_MAX_LENGTH = 100;
    public static final int INGREDIENTS_MAX_LENGTH = 2000;
    public static final int BENEFITS_MAX_LENGTH = 2000;
    public static final int USAGE_MAX_LENGTH = 2000;
    public static final int TAGS_MAX_LENGTH = 200;
    public static final double PRICE_MAX = 1_000_000d;
    public static final int STOCK_MAX = 1_000_000;
    public static final int ALERT_LEVEL_MIN = 0;
    public static final int ALERT_LEVEL_MAX = 1_000_000;
    public static final int MAX_PRODUCT_IMAGES = 8;

    /** Canonical category codes used on both seller and user sides. */
    public static final java.util.List<String> CATEGORY_CODES = java.util.List.of(
            "SKINCARE", "HAIRCARE", "HYGIENE", "CLOTHING", "ACCESSORIES", "WELLNESS", "OTHER");

    private static final java.util.Map<String, String> CATEGORY_LABELS = java.util.Map.of(
            "SKINCARE", "Skincare",
            "HAIRCARE", "Haircare",
            "HYGIENE", "Hygiene",
            "CLOTHING", "Clothing",
            "ACCESSORIES", "Accessories",
            "WELLNESS", "Wellness",
            "OTHER", "Other");

    /** Maps legacy display names / aliases to canonical codes. */
    private static final java.util.Map<String, String> CATEGORY_ALIASES;
    static {
        java.util.Map<String, String> aliases = new java.util.HashMap<>();
        for (String code : CATEGORY_CODES) {
            aliases.put(code.toLowerCase(java.util.Locale.ROOT), code);
            aliases.put(CATEGORY_LABELS.get(code).toLowerCase(java.util.Locale.ROOT), code);
        }
        // Legacy seller option labels that may have been stored as values
        aliases.put("skincare defense", "SKINCARE");
        aliases.put("sanitary hygiene", "HYGIENE");
        aliases.put("personal wear", "CLOTHING");
        aliases.put("tactical accessories", "ACCESSORIES");
        aliases.put("wellness essentials", "WELLNESS");
        aliases.put("other domains", "OTHER");
        CATEGORY_ALIASES = java.util.Collections.unmodifiableMap(aliases);
    }

    private static final java.util.Set<String> ALLOWED_CATEGORIES = new java.util.HashSet<>(CATEGORY_CODES);

    public static boolean isAllowedCategory(String category) {
        return normalizeCategory(category) != null;
    }

    /** Returns canonical code (e.g. SKINCARE) or null if unknown. */
    public static String normalizeCategory(String category) {
        if (category == null || category.isBlank()) return null;
        String key = category.trim().toLowerCase(java.util.Locale.ROOT);
        return CATEGORY_ALIASES.get(key);
    }

    public static String categoryLabel(String category) {
        String code = normalizeCategory(category);
        if (code == null) return category == null ? "" : category.trim();
        return CATEGORY_LABELS.getOrDefault(code, code);
    }

    public String getCategoryLabel() {
        return categoryLabel(this.category);
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = NAME_MAX_LENGTH)
    private String name;

    @Column(length = BRAND_MAX_LENGTH)
    private String brand;

    @Column(length = SHORT_DESCRIPTION_MAX_LENGTH)
    private String description;

    @Column(columnDefinition = "TEXT")
    private String fullDescription;

    private Double price;
    private Double originalPrice;
    @Column(length = OFFER_BADGE_MAX_LENGTH)
    private String offerBadge;

    private Integer stock;
    private Integer lowStockAlertLevel = 5;
    @Column(length = SKU_MAX_LENGTH)
    private String sku;

    private String category; // SKINCARE, HAIRCARE, HYGIENE, CLOTHING, ACCESSORIES, WELLNESS, OTHER
    @Column(length = WEIGHT_SIZE_MAX_LENGTH)
    private String weightSize;
    @Column(length = MANUFACTURER_MAX_LENGTH)
    private String manufacturer;

    @Column(columnDefinition = "TEXT")
    private String ingredients;

    @Column(columnDefinition = "TEXT")
    private String benefits;

    @Column(columnDefinition = "TEXT")
    private String usageInstructions;

    @Column(length = TAGS_MAX_LENGTH)
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

    public boolean isListedForShop() {
        return Boolean.TRUE.equals(active) && !getDeleted() && seller != null && seller.isApprovedForCatalog();
    }

    public boolean isOutOfStock() {
        return stock == null || stock <= 0;
    }

    public boolean isLowStock() {
        if (isOutOfStock()) return false;
        int alert = lowStockAlertLevel == null ? 5 : lowStockAlertLevel;
        return stock <= alert;
    }

    public String getInventoryLabel() {
        if (isOutOfStock()) return "Out of stock";
        if (isLowStock()) return "Low stock";
        return "In stock";
    }

    public int getDiscountPercent() {
        if (originalPrice == null || price == null || originalPrice <= 0 || price >= originalPrice) return 0;
        return (int) Math.round(((originalPrice - price) / originalPrice) * 100);
    }

    /** Normalize stored upload path to a public /uploads/... URL. */
    public static String toPublicUploadPath(String stored) {
        if (stored == null || stored.isBlank()) return null;
        String path = stored.trim().replace('\\', '/');
        if (path.startsWith("http://") || path.startsWith("https://")) return path;
        int idx = path.toLowerCase().lastIndexOf("/uploads/");
        if (idx >= 0) {
            path = path.substring(idx);
        } else if (path.toLowerCase().startsWith("uploads/")) {
            path = "/" + path;
        } else if (!path.startsWith("/")) {
            path = "/uploads/" + path;
        }
        return path;
    }

    public String getPublicImagePath() {
        return toPublicUploadPath(imagePath);
    }

    public boolean isRemoteImage() {
        String p = getPublicImagePath();
        return p != null && (p.startsWith("http://") || p.startsWith("https://"));
    }

    public java.util.List<String> getPublicAdditionalImagePaths() {
        java.util.List<String> urls = new java.util.ArrayList<>();
        if (additionalImagePaths == null || additionalImagePaths.isBlank()) return urls;
        for (String part : additionalImagePaths.split(",")) {
            String url = toPublicUploadPath(part);
            if (url != null && !url.isBlank()) urls.add(url);
        }
        return urls;
    }
}
