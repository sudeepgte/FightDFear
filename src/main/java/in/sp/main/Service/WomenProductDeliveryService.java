package in.sp.main.Service;

import in.sp.main.Entities.WomenProduct;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Shared delivery ETA logic for Women Products (checkout, my-orders, product pincode check).
 */
@Service
public class WomenProductDeliveryService {

    private static final Pattern PINCODE_LABELED = Pattern.compile("Pincode:\\s*(\\d{6})", Pattern.CASE_INSENSITIVE);
    private static final Pattern PINCODE_ANY = Pattern.compile("\\b([1-9]\\d{5})\\b");
    private static final Set<String> METRO_PREFIXES = Set.of("11", "40", "50", "56", "60", "70", "12", "13", "14", "20", "30", "36", "38", "39", "41", "42", "44", "45", "52", "53", "57", "80");

    public String extractPincode(String shippingAddress) {
        if (shippingAddress == null || shippingAddress.isBlank()) return null;
        Matcher labeled = PINCODE_LABELED.matcher(shippingAddress);
        if (labeled.find()) return labeled.group(1);
        Matcher any = PINCODE_ANY.matcher(shippingAddress);
        if (any.find()) return any.group(1);
        return null;
    }

    /**
     * Days until delivery from order time, based on pincode, product category, quantity, and stock pressure.
     */
    public int calculateDeliveryDays(String shippingAddress, WomenProduct product, Integer quantity) {
        String pincode = extractPincode(shippingAddress);
        int days;

        if (pincode != null && pincode.matches("^[1-9]\\d{5}$")) {
            int sum = 0;
            for (int i = 0; i < pincode.length(); i++) {
                sum += Character.getNumericValue(pincode.charAt(i));
            }
            days = (sum % 6) + 2; // 2–7
            String prefix = pincode.substring(0, 2);
            if (METRO_PREFIXES.contains(prefix)) {
                days = (sum % 2) + 1; // 1–2 for metros
            }
        } else {
            days = 5; // no usable pincode
        }

        days += categoryProcessingDays(product != null ? product.getCategory() : null);

        if (quantity != null && quantity > 3) {
            days += 1;
        }
        if (quantity != null && quantity > 10) {
            days += 1;
        }

        if (product != null && product.getStock() != null && product.getLowStockAlertLevel() != null
                && product.getStock() > 0
                && product.getStock() <= product.getLowStockAlertLevel()) {
            days += 1; // extra processing when inventory is tight
        }

        return Math.max(1, Math.min(days, 14));
    }

    public LocalDate calculateExpectedDeliveryDate(LocalDateTime orderTime, String shippingAddress,
                                                   WomenProduct product, Integer quantity) {
        LocalDate base = orderTime != null ? orderTime.toLocalDate() : LocalDate.now();
        return base.plusDays(calculateDeliveryDays(shippingAddress, product, quantity));
    }

    private int categoryProcessingDays(String category) {
        if (category == null || category.isBlank()) return 1;
        return switch (category.trim().toUpperCase(Locale.ROOT)) {
            case "SKINCARE", "HYGIENE", "WELLNESS" -> 0;
            case "HAIRCARE", "ACCESSORIES" -> 1;
            case "CLOTHING" -> 2;
            default -> 1;
        };
    }
}
