package in.sp.main.Util;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/** Canonical Women Products categories (seller catalog + user shop). */
public final class ProductCategories {

    public static final List<String> CODES = List.of(
            "FASHION",
            "BEAUTY",
            "HOME_DECOR",
            "ORGANIC_FOOD",
            "BABY",
            "JEWELLERY",
            "BOOKS",
            "FITNESS"
    );

    private ProductCategories() {
    }

    public static String normalize(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String key = raw.trim().toUpperCase(Locale.ROOT).replace('-', '_').replace(' ', '_');
        return switch (key) {
            case "CLOTHING", "APPAREL", "ETHNIC", "SAREE", "KURTI" -> "FASHION";
            case "SKINCARE", "HAIRCARE", "HYGIENE", "MAKEUP", "COSMETICS" -> "BEAUTY";
            case "HOME", "DECOR", "HOMEDECOR" -> "HOME_DECOR";
            case "FOOD", "ORGANIC", "GROCERY" -> "ORGANIC_FOOD";
            case "BABY_PRODUCTS", "KIDS" -> "BABY";
            case "JEWELRY", "JEWEL" -> "JEWELLERY";
            case "BOOK", "STATIONERY" -> "BOOKS";
            case "WELLNESS", "YOGA", "GYM" -> "FITNESS";
            case "ACCESSORIES" -> "FASHION";
            default -> CODES.contains(key) ? key : key;
        };
    }

    public static boolean isKnown(String raw) {
        String n = normalize(raw);
        return n != null && CODES.contains(n);
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
        if (n == null) return "";
        return switch (n) {
            case "FASHION" -> "Fashion";
            case "BEAUTY" -> "Beauty";
            case "HOME_DECOR" -> "Home Decor";
            case "ORGANIC_FOOD" -> "Organic Food";
            case "BABY" -> "Baby Products";
            case "JEWELLERY" -> "Jewellery";
            case "BOOKS" -> "Books";
            case "FITNESS" -> "Fitness";
            default -> n.replace('_', ' ');
        };
    }
}
