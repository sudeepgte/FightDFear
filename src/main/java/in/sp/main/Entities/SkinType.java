package in.sp.main.Entities;
 
public enum SkinType {
    DRY("Dry Skin", "/images/dryskin.jpeg"),
    OILY("Oily Skin", "/images/oilyskin.jpeg"),
    COMBINATION("Combination Skin", "/images/combinationskin.jpeg"),
    SENSITIVE("Sensitive Skin", "/images/sensitiveskin.jpeg");
 
    private final String displayName;
    private final String imageUrl;
 
    SkinType(String displayName, String imageUrl) {
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