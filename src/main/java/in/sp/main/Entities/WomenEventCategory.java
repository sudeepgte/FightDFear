package in.sp.main.Entities;

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
}
