package in.sp.main.Entities;

import java.util.Locale;

/**
 * Marketplace / Service Partner categories used by mobile + admin.
 */
public enum ProviderCategory {
    TUTOR,
    TAILOR,
    HOME_COOK,
    CATERING_SERVICE,
    EVENT_PLANNER,
    BABYSITTER,
    PET_CARE,
    DIETITIAN,
    HOME_CLEANER,
    INTERIOR_DESIGNER,
    HANDICRAFT_SELLER,
    DIGITAL_MARKETING_CONSULTANT,
    HOME_BAKER,
    LANGUAGE_TRAINER,
    WOMEN_PRODUCTS,
    WOMEN_LAWYER,
    FITNESS_ZUMBA,
    BEAUTICIAN,
    MAKEUP_ARTIST,
    MEHENDI_ARTIST,
    PHOTOGRAPHER,
    YOGA_TRAINER,
    FITNESS_TRAINER,
    DANCE_INSTRUCTOR,
    MUSIC_TEACHER,
    CRAFT_SELLER,
    HANDMADE_PRODUCTS,
    BOUTIQUE,
    FASHION_DESIGNER,
    FREELANCER,
    GRAPHIC_DESIGNER,
    CONTENT_WRITER;

    public static ProviderCategory fromFlexible(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String key = raw.trim().toUpperCase(Locale.ROOT)
                .replace('-', '_')
                .replace(' ', '_');
        try {
            return ProviderCategory.valueOf(key);
        } catch (Exception ignored) {
            return switch (key) {
                case "CATERING", "CATERING_SERVICES" -> CATERING_SERVICE;
                case "HANDICRAFT", "HANDICRAFTS" -> HANDICRAFT_SELLER;
                case "DIGITAL_MARKETING" -> DIGITAL_MARKETING_CONSULTANT;
                case "HOMECOOK", "COOK" -> HOME_COOK;
                case "PETCARE", "PET_SITTER" -> PET_CARE;
                case "BABY_SITTER", "CHILDCARE" -> BABYSITTER;
                case "CLEANER", "CLEANING" -> HOME_CLEANER;
                case "INTERIOR", "INTERIOR_DESIGN" -> INTERIOR_DESIGNER;
                case "ZUMBA", "FITNESS" -> FITNESS_ZUMBA;
                case "LAWYER" -> WOMEN_LAWYER;
                case "PRODUCTS", "SELLER", "MARKETPLACE_SELLER" -> WOMEN_PRODUCTS;
                case "YOGA" -> YOGA_TRAINER;
                case "DANCE" -> DANCE_INSTRUCTOR;
                case "MUSIC" -> MUSIC_TEACHER;
                case "MAKEUP" -> MAKEUP_ARTIST;
                case "MEHENDI" -> MEHENDI_ARTIST;
                default -> null;
            };
        }
    }
}
