package in.sp.main.Util;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Canonical business proposal categories for entrepreneur create + investor market filters.
 */
public final class FundingCatalog {

    private static final List<String> CATEGORIES = List.of(
            "Food",
            "Fashion",
            "Technology",
            "Education",
            "Healthcare",
            "Beauty",
            "Handicrafts",
            "Retail",
            "Services"
    );

    private FundingCatalog() {
    }

    public static List<String> categories() {
        return CATEGORIES;
    }

    public static List<Map<String, String>> asCatalog() {
        List<Map<String, String>> out = new ArrayList<>();
        for (String c : CATEGORIES) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("code", c);
            row.put("label", c);
            out.add(row);
        }
        return out;
    }

    public static String normalize(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String t = raw.trim();
        for (String c : CATEGORIES) {
            if (c.equalsIgnoreCase(t)) return c;
        }
        return t;
    }

    public static boolean matchesFilter(String category, String filter) {
        if (filter == null || filter.isBlank() || "all".equalsIgnoreCase(filter.trim())) {
            return true;
        }
        if (category == null) return false;
        return category.toLowerCase(Locale.ROOT).contains(filter.trim().toLowerCase(Locale.ROOT))
                || filter.trim().equalsIgnoreCase(category.trim());
    }
}
