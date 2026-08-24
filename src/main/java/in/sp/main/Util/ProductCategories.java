package in.sp.main.Util;

import in.sp.main.Entities.WomenProduct;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Canonical Women Products categories — same codes as {@link WomenProduct#CATEGORY_CODES}.
 * Legacy mobile catalog codes (FASHION, BEAUTY, …) are mapped for filter/save compatibility.
 */
public final class ProductCategories {

    /** Same as web shop / seller dashboard. */
    public static final List<String> CODES = WomenProduct.CATEGORY_CODES;

    private static final Set<String> BEAUTY_CODES = Set.of("SKINCARE", "HAIRCARE", "HYGIENE");
    private static final Set<String> FASHION_CODES = Set.of("CLOTHING", "ACCESSORIES");

    private ProductCategories() {
    }

    /**
     * Returns a stored canonical code (SKINCARE, …) or null if unknown.
     * Legacy mobile values are mapped onto the closest canonical code.
     */
    public static String normalize(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String fromProduct = WomenProduct.normalizeCategory(raw);
        if (fromProduct != null) return fromProduct;

        String key = raw.trim().toUpperCase(Locale.ROOT).replace('-', '_').replace(' ', '_');
        return switch (key) {
            case "FASHION", "APPAREL", "ETHNIC", "SAREE", "KURTI" -> "CLOTHING";
            case "BEAUTY", "MAKEUP", "COSMETICS" -> "SKINCARE";
            case "HOME", "DECOR", "HOMEDECOR", "HOME_DECOR" -> "OTHER";
            case "FOOD", "ORGANIC", "GROCERY", "ORGANIC_FOOD" -> "OTHER";
            case "BABY_PRODUCTS", "KIDS", "BABY" -> "OTHER";
            case "JEWELRY", "JEWEL", "JEWELLERY" -> "ACCESSORIES";
            case "BOOK", "STATIONERY", "BOOKS" -> "OTHER";
            case "FITNESS", "YOGA", "GYM" -> "WELLNESS";
            default -> CODES.contains(key) ? key : null;
        };
    }

    public static boolean isKnown(String raw) {
        return normalize(raw) != null;
    }

    /**
     * Whether a product's stored category should appear when the user selected {@code requested}.
     * Supports both canonical chips (SKINCARE) and legacy mobile filters (FASHION, BEAUTY).
     */
    public static boolean matchesFilter(String productCategory, String requested) {
        if (requested == null || requested.isBlank()) return true;
        String reqKey = requested.trim().toUpperCase(Locale.ROOT).replace('-', '_').replace(' ', '_');
        String prod = normalize(productCategory);
        if (prod == null) return false;

        if (isLegacyGroupKey(reqKey)) {
            return switch (reqKey) {
                case "BEAUTY", "MAKEUP", "COSMETICS" -> BEAUTY_CODES.contains(prod);
                case "FASHION", "APPAREL" -> FASHION_CODES.contains(prod);
                case "FITNESS", "YOGA", "GYM" -> "WELLNESS".equals(prod);
                case "HOME_DECOR", "HOME", "DECOR", "ORGANIC_FOOD", "FOOD", "ORGANIC",
                     "BABY", "BABY_PRODUCTS", "KIDS", "BOOKS", "BOOK" -> "OTHER".equals(prod);
                case "JEWELLERY", "JEWELRY", "JEWEL" -> "ACCESSORIES".equals(prod);
                default -> false;
            };
        }

        String canonical = normalize(requested);
        return canonical != null && canonical.equals(prod);
    }

    private static boolean isLegacyGroupKey(String reqKey) {
        return Set.of(
                "BEAUTY", "MAKEUP", "COSMETICS",
                "FASHION", "APPAREL",
                "FITNESS", "YOGA", "GYM",
                "HOME_DECOR", "HOME", "DECOR", "ORGANIC_FOOD", "FOOD", "ORGANIC",
                "BABY", "BABY_PRODUCTS", "KIDS", "BOOKS", "BOOK",
                "JEWELLERY", "JEWELRY", "JEWEL"
        ).contains(reqKey);
    }

    public static List<Map<String, Object>> asCatalog() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (String code : CODES) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("code", code);
            row.put("value", code);
            row.put("label", label(code));
            out.add(row);
        }
        return out;
    }

    public static String label(String code) {
        String n = normalize(code);
        if (n == null) return code == null ? "" : code.trim();
        return WomenProduct.categoryLabel(n);
    }
}
