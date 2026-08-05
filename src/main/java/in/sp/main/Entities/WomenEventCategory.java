package in.sp.main.Entities;

import java.util.Locale;

public enum WomenEventCategory {
    HEALTH_WELLNESS("Health & Wellness"),
    ENTREPRENEURSHIP_CAREER("Entrepreneurship & Career"),
    FITNESS_SPORTS("Fitness & Sports"),
    EDUCATION_SKILLS("Education & Skills"),
    SOCIAL_COMMUNITY("Social & Community"),
    SAFETY_AWARENESS("Safety & Awareness");

    private final String displayName;

    WomenEventCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static WomenEventCategory fromFlexible(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String key = raw.trim().toUpperCase(Locale.ROOT)
                .replace("&", "AND")
                .replace('-', '_')
                .replace(' ', '_')
                .replaceAll("_+", "_");
        try {
            return WomenEventCategory.valueOf(key);
        } catch (Exception ignored) {
            return switch (key) {
                case "HEALTH", "WELLNESS", "HEALTH_WELLNESS", "HEALTH_AND_WELLNESS" -> HEALTH_WELLNESS;
                case "ENTREPRENEURSHIP", "CAREER", "ENTREPRENEURSHIP_CAREER", "ENTREPRENEURSHIP_AND_CAREER" -> ENTREPRENEURSHIP_CAREER;
                case "FITNESS", "SPORTS", "FITNESS_SPORTS", "FITNESS_AND_SPORTS" -> FITNESS_SPORTS;
                case "EDUCATION", "SKILLS", "TECHNOLOGY", "EDUCATION_SKILLS", "EDUCATION_AND_SKILLS" -> EDUCATION_SKILLS;
                case "CULTURAL", "SOCIAL", "COMMUNITY", "SOCIAL_COMMUNITY", "SOCIAL_AND_COMMUNITY" -> SOCIAL_COMMUNITY;
                case "SELF_DEFENCE", "SELFDEFENCE", "SAFETY", "AWARENESS", "SAFETY_AWARENESS", "SAFETY_AND_AWARENESS" -> SAFETY_AWARENESS;
                default -> null;
            };
        }
    }
}
