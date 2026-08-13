package in.sp.main.Util;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Canonical worker job categories + subcategories (mobile apply, user Workers chips, web earn form).
 */
public final class JobCategories {

    private static final Map<String, List<String>> CATEGORIES = new LinkedHashMap<>();

    static {
        CATEGORIES.put("Caregiver", List.of("Elderly Caregiver", "Patient Care Assistant", "Child Caregiver", "Home Care Assistant"));
        CATEGORIES.put("Babysitting", List.of("Babysitter", "Nanny", "Daycare Assistant"));
        CATEGORIES.put("Housekeeping", List.of("House Maid", "Housekeeper", "Cleaner"));
        CATEGORIES.put("Cooking", List.of("Home Cook", "Personal Cook", "Kitchen Assistant"));
        CATEGORIES.put("Beauty & Salon", List.of("Beautician", "Hair Stylist", "Makeup Artist", "Nail Technician"));
        CATEGORIES.put("Healthcare", List.of("Nurse", "Care Assistant", "Receptionist", "Lab Assistant"));
        CATEGORIES.put("Teaching", List.of("Tutor", "School Teacher", "Preschool Teacher"));
        CATEGORIES.put("Office Jobs", List.of("Receptionist", "Office Assistant", "Data Entry Operator"));
        CATEGORIES.put("Retail", List.of("Cashier", "Sales Executive", "Store Assistant"));
        CATEGORIES.put("Hospitality", List.of("Hotel Receptionist", "Housekeeping Staff", "Waitress"));
        CATEGORIES.put("Customer Support", List.of("Call Center Executive", "Customer Care Representative"));
        CATEGORIES.put("Delivery & Logistics", List.of("Parcel Coordinator", "Delivery Executive (where applicable)"));
        CATEGORIES.put("Domestic Help", List.of("Laundry Assistant", "Home Helper"));
        CATEGORIES.put("Tailoring & Fashion", List.of("Tailor", "Boutique Assistant", "Fashion Designer"));
        CATEGORIES.put("Digital Jobs", List.of("Content Writer", "Graphic Designer", "Social Media Executive"));
        CATEGORIES.put("Freelancing", List.of("Virtual Assistant", "Translator", "Online Tutor"));
        CATEGORIES.put("Entrepreneurship", List.of("Sell Handmade Products", "Home Bakery", "Boutique Owner"));
    }

    private JobCategories() {
    }

    public static List<String> names() {
        return List.copyOf(CATEGORIES.keySet());
    }

    public static List<String> subcategories(String category) {
        String key = normalize(category);
        if (key == null) return List.of();
        return CATEGORIES.getOrDefault(key, List.of());
    }

    public static List<Map<String, Object>> asCatalog() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (Map.Entry<String, List<String>> e : CATEGORIES.entrySet()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("code", e.getKey());
            row.put("value", e.getKey());
            row.put("label", e.getKey());
            row.put("subcategories", e.getValue());
            out.add(row);
        }
        return out;
    }

    public static String normalize(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String t = raw.trim();
        for (String c : CATEGORIES.keySet()) {
            if (c.equalsIgnoreCase(t)) return c;
        }
        return t;
    }

    public static boolean isKnown(String raw) {
        if (raw == null || raw.isBlank()) return false;
        String t = raw.trim();
        for (String c : CATEGORIES.keySet()) {
            if (c.equalsIgnoreCase(t)) return true;
        }
        return false;
    }

    public static boolean matchesFilter(String category, String filter) {
        if (filter == null || filter.isBlank() || "all".equalsIgnoreCase(filter.trim())) {
            return true;
        }
        if (category == null) return false;
        return category.equalsIgnoreCase(filter.trim());
    }
}
