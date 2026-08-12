package in.sp.main.Entities;

import java.util.Locale;

/**
 * Marketplace / Service Partner categories used across the application.
 */
public enum ProviderCategory {
    TUTOR("Tutor"),
    TAILOR("Tailor"),
    HOME_COOK("Home Cook"),
    CATERING_SERVICE("Catering Service"),
    EVENT_PLANNER("Event Planner"),
    BABYSITTER("Babysitter"),
    PET_CARE("Pet Care"),
    DIETITIAN("Dietitian"),
    HOME_CLEANER("Home Cleaner"),
    INTERIOR_DESIGNER("Interior Designer"),
    HANDICRAFT_SELLER("Handicraft Seller"),
    DIGITAL_MARKETING_CONSULTANT("Digital Marketing Consultant"),
    HOME_BAKER("Home Baker"),
    LANGUAGE_TRAINER("Language Trainer"),
    WOMEN_PRODUCTS("Women Products"),
    WOMEN_LAWYER("Women Lawyer"),
    FITNESS_ZUMBA("Fitness / Zumba"),
    BEAUTICIAN("Beautician"),
    MAKEUP_ARTIST("Makeup Artist"),
    MEHENDI_ARTIST("Mehendi Artist"),
    PHOTOGRAPHER("Photographer"),
    YOGA_TRAINER("Yoga Trainer"),
    FITNESS_TRAINER("Fitness Trainer"),
    DANCE_INSTRUCTOR("Dance Instructor"),
    MUSIC_TEACHER("Music Teacher"),
    CRAFT_SELLER("Craft Seller"),
    HANDMADE_PRODUCTS("Handmade Products"),
    BOUTIQUE("Boutique"),
    FASHION_DESIGNER("Fashion Designer"),
    FREELANCER("Freelancer"),
    GRAPHIC_DESIGNER("Graphic Designer"),
    CONTENT_WRITER("Content Writer"),
    MARTIAL_ARTS("Martial Arts"),
    FEMALE_DOCTORS("Female Doctors");

    private final String displayName;

    ProviderCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static ProviderCategory fromFlexible(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String trimmed = raw.trim();
        for (ProviderCategory cat : values()) {
            if (cat.name().equalsIgnoreCase(trimmed) || cat.getDisplayName().equalsIgnoreCase(trimmed)) {
                return cat;
            }
        }
        String key = trimmed.toUpperCase(Locale.ROOT)
                .replace('-', '_')
                .replace(' ', '_')
                .replace('/', '_');
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
                case "FITNESS", "ZUMBA", "FITNESS_ZUMBA" -> FITNESS_ZUMBA;
                case "LAWYER" -> WOMEN_LAWYER;
                case "PRODUCTS", "SELLER", "MARKETPLACE_SELLER" -> WOMEN_PRODUCTS;
                case "YOGA" -> YOGA_TRAINER;
                case "DANCE" -> DANCE_INSTRUCTOR;
                case "MUSIC" -> MUSIC_TEACHER;
                case "MAKEUP" -> MAKEUP_ARTIST;
                case "MEHENDI" -> MEHENDI_ARTIST;
                case "MARTIAL", "SELF_DEFENSE", "MARTIAL_ARTS_INSTRUCTOR" -> MARTIAL_ARTS;
                case "DOCTOR", "DOCTORS", "FEMALE_DOCTOR" -> FEMALE_DOCTORS;
                default -> null;
            };
        }
    }
}
