package in.sp.main.Entities;
 
public enum TreatmentType {
    FACIAL_TREATMENT("Facial Treatment", "/images/facial.png"),
    ACNE_TREATMENT("Acne Treatment", "/images/acne.png"),
    ANTI_AGING_TREATMENT("Anti Aging Treatment", "/images/anti_aging.png"),
    WHITENING_TREATMENT("Whitening Treatment", "/images/whitening.png"),
    SKIN_TIGHTENING("Skin Tightening", "/images/skin_tightening.png");
 
    private String displayName;
    private String imageUrl;
 
    // Constructor
    TreatmentType(String displayName, String imageUrl) {
        this.displayName = displayName;
        this.imageUrl = imageUrl;
    }
 
    public String getDisplayName() {
        return displayName;
    }
 
    public String getImageUrl() {
        return imageUrl;
    }
}