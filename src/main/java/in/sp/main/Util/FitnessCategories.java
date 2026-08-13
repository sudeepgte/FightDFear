package in.sp.main.Util;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

/** Standard fitness trainer specializations (mobile + web). */
public final class FitnessCategories {

    private FitnessCategories() {}

    public static final List<String> ALL = List.of(
            "Gym Training",
            "Zumba",
            "Dance Fitness",
            "Yoga",
            "Aerobics",
            "Pilates",
            "Strength Training",
            "Cardio Training",
            "CrossFit",
            "Functional Training",
            "HIIT",
            "Weight Loss Programs",
            "Weight Gain Programs",
            "Personal Training",
            "Prenatal & Postnatal Fitness",
            "Meditation & Mindfulness",
            "Nutrition & Diet Consultation",
            "Home Workout Sessions"
    );

    /** Mobile browse filter chips (subset). */
    public static final List<String> BROWSE_FILTERS = List.of(
            "all", "Yoga", "HIIT", "Zumba", "Strength Training", "Personal Training", "Pilates", "CrossFit"
    );

    private static final Set<String> NORMALIZED = ALL.stream()
            .map(FitnessCategories::norm)
            .collect(Collectors.toUnmodifiableSet());

    public static List<String> asList() {
        return Collections.unmodifiableList(ALL);
    }

    public static String norm(String value) {
        if (value == null) return "";
        return value.trim().toLowerCase(Locale.ROOT)
                .replace("(high-intensity interval training)", "")
                .replaceAll("\\s+", " ")
                .trim();
    }

    public static boolean isKnown(String value) {
        String n = norm(value);
        if (n.isEmpty()) return false;
        if (NORMALIZED.contains(n)) return true;
        return ALL.stream().anyMatch(c -> norm(c).contains(n) || n.contains(norm(c)));
    }

    public static List<String> splitSpecializations(String raw) {
        if (raw == null || raw.isBlank()) return List.of();
        return Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());
    }
}
