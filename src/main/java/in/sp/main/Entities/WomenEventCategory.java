package in.sp.main.Entities;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public enum WomenEventCategory {
    HEALTH_WELLNESS("Health & Wellness"),
    ENTREPRENEURSHIP_CAREER("Entrepreneurship & Career"),
    FITNESS_SPORTS("Fitness & Sports"),
    EDUCATION_SKILLS("Education & Skills"),
    SOCIAL_COMMUNITY("Social & Community"),
    SAFETY_AWARENESS("Safety & Awareness"),
    WOMEN_EMPOWERMENT("Women Empowerment"),
    CAREER("Career"),
    EDUCATION("Education"),
    BUSINESS("Business"),
    ENTREPRENEURSHIP("Entrepreneurship"),
    NETWORKING("Networking"),
    FITNESS("Fitness"),
    SELF_DEFENSE("Self Defense"),
    BEAUTY("Beauty"),
    FINANCE("Finance"),
    INVESTMENT("Investment"),
    TECHNOLOGY("Technology"),
    ARTS_CULTURE("Arts & Culture"),
    ENTERTAINMENT("Entertainment"),
    COMMUNITY("Community"),
    OTHER("Other");

    private final String displayName;

    WomenEventCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static List<Map<String, String>> asCatalog() {
        List<Map<String, String>> list = new ArrayList<>();
        for (WomenEventCategory c : values()) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("code", c.name());
            row.put("label", c.displayName);
            list.add(row);
        }
        return list;
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
                case "HEALTH", "WELLNESS", "HEALTH_WELLNESS", "HEALTH_AND_WELLNESS",
                     "HEALTH_CAMP", "MENTAL_WELLNESS", "YOGA", "BLOOD_DONATION" -> HEALTH_WELLNESS;
                case "ENTREPRENEURSHIP", "CAREER", "ENTREPRENEURSHIP_CAREER", "ENTREPRENEURSHIP_AND_CAREER",
                     "CAREER_FAIR", "STARTUP_MEETUP", "BUSINESS_NETWORKING", "LEADERSHIP_TRAINING",
                     "FINANCIAL_LITERACY" -> ENTREPRENEURSHIP_CAREER;
                case "FITNESS", "SPORTS", "FITNESS_SPORTS", "FITNESS_AND_SPORTS", "MARATHON" -> FITNESS_SPORTS;
                case "EDUCATION", "SKILLS", "TECHNOLOGY", "EDUCATION_SKILLS", "EDUCATION_AND_SKILLS",
                     "EDUCATION_WORKSHOP", "CODING_BOOTCAMP", "LEGAL_AWARENESS", "PARENTING" -> EDUCATION_SKILLS;
                case "CULTURAL", "SOCIAL", "COMMUNITY", "SOCIAL_COMMUNITY", "SOCIAL_AND_COMMUNITY",
                     "CULTURAL_EVENT", "MUSIC_FESTIVAL", "ART_EXHIBITION", "FASHION_SHOW",
                     "COMMUNITY_SERVICE", "WOMEN_EMPOWERMENT" -> SOCIAL_COMMUNITY;
                case "SELF_DEFENCE", "SELFDEFENCE", "SELF_DEFENSE", "SAFETY", "AWARENESS",
                     "SAFETY_AWARENESS", "SAFETY_AND_AWARENESS", "WOMEN_SAFETY" -> SAFETY_AWARENESS;
                default -> null;
            };
        }
    }
}
