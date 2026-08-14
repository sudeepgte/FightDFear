package in.sp.main.Util;

import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.MartialArtsType;

/**
 * Keeps fitness / wellness-only listings out of Self-Defense / Martial Arts discovery.
 */
public final class MartialArtsDiscoveryFilter {

    private MartialArtsDiscoveryFilter() {}

    private static final Set<String> MARTIAL_ARTS_KEYWORDS = Set.of(
            "karate", "taekwondo", "tae kwon do", "judo", "kung fu", "kungfu",
            "self-defence", "self defense", "mma", "boxing", "kickboxing",
            "muay thai", "krav maga", "aikido", "hapkido", "silat", "capoeira",
            "martial arts", "martial art", "kalaripayattu", "wrestling", "jujitsu", "jiu jitsu"
    );

    private static final Set<String> FITNESS_ONLY_KEYWORDS = Set.of(
            "yoga", "fitness", "zumba", "aerobics", "pilates", "hiit", "gym training",
            "gym", "personal training", "crossfit", "functional training", "cardio",
            "dance fitness", "weight loss", "weight gain", "meditation", "mindfulness",
            "nutrition", "diet", "home workout", "prenatal", "postnatal"
    );

    public static boolean isMartialArtsCentreForDiscovery(MartialArtsCenter centre) {
        if (centre == null || !centre.isApproved()) return false;
        Set<String> labels = collectLabels(centre);
        if (labels.isEmpty()) {
            // Name heuristic: pure "fitness" branded centres belong in Fitness & Wellness.
            String name = centre.getName() == null ? "" : centre.getName().toLowerCase(Locale.ROOT);
            return !(name.contains("fitness") && !name.contains("martial"));
        }
        if (labels.stream().anyMatch(MartialArtsDiscoveryFilter::isMartialArtsLabel)) {
            return true;
        }
        return !labels.stream().allMatch(MartialArtsDiscoveryFilter::isFitnessOnlyLabel);
    }

    private static Set<String> collectLabels(MartialArtsCenter centre) {
        Set<String> labels = new HashSet<>();
        if (centre.getMartialArtsTypes() != null) {
            for (MartialArtsType t : centre.getMartialArtsTypes()) {
                if (t != null && t.getName() != null && !t.getName().isBlank()) {
                    labels.add(norm(t.getName()));
                }
            }
        }
        if (centre.getBatches() != null) {
            for (MartialArtsBatch b : centre.getBatches()) {
                if (b != null && b.getStyle() != null && !b.getStyle().isBlank()) {
                    labels.add(norm(b.getStyle()));
                }
            }
        }
        return labels;
    }

    public static boolean isFitnessOnlyProgram(String label) {
        return isFitnessOnlyLabel(norm(label));
    }

    /** True when style is clearly martial arts (Karate, Taekwondo, etc.). */
    public static boolean isMartialArtsProgram(String label) {
        return isMartialArtsLabel(norm(label));
    }

    private static boolean isMartialArtsLabel(String label) {
        String n = norm(label);
        if (n.isEmpty()) return false;
        return MARTIAL_ARTS_KEYWORDS.stream().anyMatch(n::contains);
    }

    private static boolean isFitnessOnlyLabel(String label) {
        String n = norm(label);
        if (n.isEmpty()) return false;
        if (isMartialArtsLabel(n)) return false;
        return FITNESS_ONLY_KEYWORDS.stream().anyMatch(n::contains)
                || FitnessCategories.isKnown(n);
    }

    private static String norm(String value) {
        return value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
    }
}
