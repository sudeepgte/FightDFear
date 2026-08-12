package in.sp.main.Util;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/** Canonical Women Lawyer practice areas (portal chips, profile, user Legal Help). */
public final class LawyerCategories {

    public static final List<String> PRACTICE_AREAS = List.of(
            "Family Law",
            "Domestic Violence",
            "Divorce & Maintenance",
            "Child Custody",
            "Harassment at Workplace",
            "Property & Inheritance",
            "Cyber Crime",
            "Consumer Rights",
            "Labour & Employment",
            "Criminal Defense",
            "Documentation & Contracts",
            "Legal Aid / Pro Bono"
    );

    public static final List<String> CONSULT_MODES = List.of(
            "In-person",
            "Video",
            "Phone",
            "Chat"
    );

    private LawyerCategories() {
    }

    public static List<String> names() {
        return List.copyOf(PRACTICE_AREAS);
    }

    public static List<Map<String, Object>> asCatalog() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (String name : PRACTICE_AREAS) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("code", name);
            row.put("value", name);
            row.put("label", name);
            out.add(row);
        }
        return out;
    }

    public static String normalize(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String t = raw.trim();
        for (String c : PRACTICE_AREAS) {
            if (c.equalsIgnoreCase(t)) return c;
        }
        return t;
    }

    public static boolean isKnown(String raw) {
        if (raw == null || raw.isBlank()) return false;
        String t = raw.trim();
        for (String c : PRACTICE_AREAS) {
            if (c.equalsIgnoreCase(t)) return true;
        }
        return false;
    }

    public static String normalizeList(String raw) {
        if (raw == null || raw.isBlank()) return null;
        List<String> kept = new ArrayList<>();
        for (String part : raw.split("[,|]")) {
            String n = normalize(part.trim());
            if (n != null && isKnown(n) && !kept.contains(n)) {
                kept.add(n);
            }
        }
        return kept.isEmpty() ? null : String.join(", ", kept);
    }

    public static boolean matchesFilter(String practiceAreas, String filter) {
        if (filter == null || filter.isBlank() || "all".equalsIgnoreCase(filter.trim())) {
            return true;
        }
        if (practiceAreas == null || practiceAreas.isBlank()) return false;
        String want = filter.trim().toLowerCase(Locale.ROOT);
        for (String part : practiceAreas.split("[,|]")) {
            String n = part.trim().toLowerCase(Locale.ROOT);
            if (n.equals(want) || n.contains(want) || want.contains(n)) return true;
        }
        return false;
    }

    public static String normalizeMode(String raw) {
        if (raw == null || raw.isBlank()) return "In-person";
        String t = raw.trim();
        for (String m : CONSULT_MODES) {
            if (m.equalsIgnoreCase(t)) return m;
        }
        return "In-person";
    }
}
