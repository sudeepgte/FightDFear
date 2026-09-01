package in.sp.main.Util;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Entities.WomenProduct;

/**
 * Shared Women Products input validation (web + mobile).
 * Rules mirror WomenProductController web product / checkout validation.
 */
public final class WomenProductValidation {

    public static final Set<String> RETURN_STATUSES =
            Set.of("PENDING", "APPROVED", "REJECTED", "COMPLETED");

    public static final int REVIEW_MAX_LENGTH = 2000;
    public static final int SHIPPING_ADDRESS_MIN = 8;
    public static final int SHIPPING_ADDRESS_MAX = 2000;
    public static final int REJECTION_REASON_MAX = 1000;

    private static final Pattern PINCODE_LABELED =
            Pattern.compile("(?i)Pincode:\\s*(\\d{6}|N/A)");
    private static final Pattern PINCODE_DIGITS = Pattern.compile("^\\d{6}$");
    private static final Set<String> FAKE_PINCODES = Set.of(
            "111111", "222222", "333333", "444444", "555555",
            "666666", "777777", "888888", "999999", "123456", "654321", "000000");

    private WomenProductValidation() {}

    public static String validateReturnStatus(String status) {
        if (status == null || status.isBlank()) {
            return "Please select a valid return/exchange status.";
        }
        String cleaned = status.trim().toUpperCase();
        if (!RETURN_STATUSES.contains(cleaned)) {
            return "Invalid return/exchange status.";
        }
        return null;
    }

    public static String normalizeReturnStatus(String status) {
        return status == null ? "" : status.trim().toUpperCase();
    }

    /** Same rules as web Women Products checkout address checks + FE pincode rules. */
    public static String validateShippingAddress(String shippingAddress) {
        String address = shippingAddress == null ? "" : shippingAddress.trim();
        if (address.length() < SHIPPING_ADDRESS_MIN) {
            return "Please enter a complete delivery address.";
        }
        if (address.length() > SHIPPING_ADDRESS_MAX) {
            return "Delivery address must be at most " + SHIPPING_ADDRESS_MAX + " characters.";
        }
        if (!address.matches(".*[A-Za-z].*")) {
            return "Please enter a complete delivery address.";
        }

        Matcher labeled = PINCODE_LABELED.matcher(address);
        if (labeled.find()) {
            String pin = labeled.group(1);
            if (!"N/A".equalsIgnoreCase(pin)) {
                String pinErr = validatePincode(pin);
                if (pinErr != null) return pinErr;
            }
        }
        return null;
    }

    /** Matches checkout.jsp pincode rules (^[1-8]\\d{5}$, reject obvious fake pins). */
    public static String validatePincode(String pin) {
        String p = pin == null ? "" : pin.trim();
        if (!PINCODE_DIGITS.matcher(p).matches()
                || !p.matches("^[1-8]\\d{5}$")
                || FAKE_PINCODES.contains(p)) {
            return "Please enter a valid 6-digit pincode.";
        }
        return null;
    }

    public static String validateReviewText(String review) {
        String cleaned = review == null ? "" : review.trim();
        if (cleaned.length() > REVIEW_MAX_LENGTH) {
            return "Review must be at most " + REVIEW_MAX_LENGTH + " characters.";
        }
        return null;
    }

    /** @return error message, or null if valid */
    public static String validateRejectionReason(String reason) {
        String cleaned = reason == null ? "" : reason.trim();
        if (cleaned.isEmpty()) {
            return "Rejection reason is required.";
        }
        if (cleaned.length() > REJECTION_REASON_MAX) {
            return "Rejection reason must be at most " + REJECTION_REASON_MAX + " characters.";
        }
        return null;
    }

    /**
     * Web product form validation (source of truth for mobile create/update).
     * @return error message or null if valid
     */
    public static String validateProductInput(String name, String brand, String description,
                                              String fullDescription, Double price, Double originalPrice,
                                              String offerBadge, Integer stock, Integer lowStockAlertLevel,
                                              String sku, String category, String weightSize,
                                              String manufacturer, String ingredients, String benefits,
                                              String usageInstructions, String tags,
                                              boolean requireImages, List<MultipartFile> images) {
        String cleanedName = name == null ? "" : name.trim();
        if (cleanedName.length() < WomenProduct.NAME_MIN_LENGTH
                || cleanedName.length() > WomenProduct.NAME_MAX_LENGTH) {
            return "Product Name must be between " + WomenProduct.NAME_MIN_LENGTH
                    + " and " + WomenProduct.NAME_MAX_LENGTH + " characters.";
        }

        String cleanedBrand = brand == null ? "" : brand.trim();
        if (cleanedBrand.isEmpty() || cleanedBrand.length() > WomenProduct.BRAND_MAX_LENGTH) {
            return "Brand is required (max " + WomenProduct.BRAND_MAX_LENGTH + " characters).";
        }

        if (category == null || category.trim().isEmpty() || !WomenProduct.isAllowedCategory(category)) {
            return "Please select a valid product category.";
        }

        String cleanedDescription = description == null ? "" : description.trim();
        if (cleanedDescription.isEmpty()) {
            return "Short Description is required.";
        }
        if (cleanedDescription.length() > WomenProduct.SHORT_DESCRIPTION_MAX_LENGTH) {
            return "Short Description must be at most "
                    + WomenProduct.SHORT_DESCRIPTION_MAX_LENGTH + " characters.";
        }

        if (fullDescription != null && fullDescription.trim().length() > WomenProduct.FULL_DESCRIPTION_MAX_LENGTH) {
            return "Full Description must be at most "
                    + WomenProduct.FULL_DESCRIPTION_MAX_LENGTH + " characters.";
        }

        if (price == null || price <= 0 || price > WomenProduct.PRICE_MAX) {
            return "Selling price must be greater than 0 and at most " + (long) WomenProduct.PRICE_MAX + ".";
        }
        if (originalPrice != null) {
            if (originalPrice <= 0 || originalPrice > WomenProduct.PRICE_MAX) {
                return "MRP must be greater than 0 when provided.";
            }
            if (originalPrice < price) {
                return "MRP cannot be less than the selling price.";
            }
        }

        if (offerBadge != null && offerBadge.trim().length() > WomenProduct.OFFER_BADGE_MAX_LENGTH) {
            return "Offer Badge must be at most " + WomenProduct.OFFER_BADGE_MAX_LENGTH + " characters.";
        }

        if (stock == null || stock < 0 || stock > WomenProduct.STOCK_MAX) {
            return "Stock quantity must be between 0 and " + WomenProduct.STOCK_MAX + ".";
        }
        if (lowStockAlertLevel == null
                || lowStockAlertLevel < WomenProduct.ALERT_LEVEL_MIN
                || lowStockAlertLevel > WomenProduct.ALERT_LEVEL_MAX) {
            return "Alert Level must be a non-negative number (0 or greater). Negative values are not allowed.";
        }

        if (sku != null && !sku.trim().isEmpty()) {
            String cleanedSku = sku.trim();
            if (cleanedSku.length() > WomenProduct.SKU_MAX_LENGTH || !cleanedSku.matches("^[A-Za-z0-9_-]+$")) {
                return "SKU must be at most " + WomenProduct.SKU_MAX_LENGTH
                        + " characters and use only letters, numbers, hyphens, or underscores.";
            }
        }

        if (weightSize != null && weightSize.trim().length() > WomenProduct.WEIGHT_SIZE_MAX_LENGTH) {
            return "Weight/Size must be at most " + WomenProduct.WEIGHT_SIZE_MAX_LENGTH + " characters.";
        }
        if (manufacturer != null && manufacturer.trim().length() > WomenProduct.MANUFACTURER_MAX_LENGTH) {
            return "Manufacturer must be at most " + WomenProduct.MANUFACTURER_MAX_LENGTH + " characters.";
        }
        if (ingredients != null && ingredients.trim().length() > WomenProduct.INGREDIENTS_MAX_LENGTH) {
            return "Ingredients must be at most " + WomenProduct.INGREDIENTS_MAX_LENGTH + " characters.";
        }
        if (benefits != null && benefits.trim().length() > WomenProduct.BENEFITS_MAX_LENGTH) {
            return "Benefits must be at most " + WomenProduct.BENEFITS_MAX_LENGTH + " characters.";
        }
        if (usageInstructions != null && usageInstructions.trim().length() > WomenProduct.USAGE_MAX_LENGTH) {
            return "Usage Instructions must be at most " + WomenProduct.USAGE_MAX_LENGTH + " characters.";
        }
        if (tags != null && tags.trim().length() > WomenProduct.TAGS_MAX_LENGTH) {
            return "Tags must be at most " + WomenProduct.TAGS_MAX_LENGTH + " characters.";
        }

        List<MultipartFile> uploaded = nonEmptyImages(images);
        if (requireImages && uploaded.isEmpty()) {
            return "At least one product image is required.";
        }
        if (uploaded.size() > WomenProduct.MAX_PRODUCT_IMAGES) {
            return "You can upload at most " + WomenProduct.MAX_PRODUCT_IMAGES + " images per product.";
        }
        for (MultipartFile img : uploaded) {
            String imgErr = validateProductImageFile(img);
            if (imgErr != null) return imgErr;
        }
        return null;
    }

    public static String validateProductImageFile(MultipartFile img) {
        if (img == null || img.isEmpty()) {
            return "At least one product image is required.";
        }
        String contentType = img.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            return "Only image files (JPG/PNG) are allowed for product photos.";
        }
        if (img.getSize() > 5L * 1024 * 1024) {
            return "Each product image must be 5MB or smaller.";
        }
        return null;
    }

    public static List<MultipartFile> nonEmptyImages(List<MultipartFile> images) {
        List<MultipartFile> uploaded = new ArrayList<>();
        if (images == null) return uploaded;
        for (MultipartFile img : images) {
            if (img != null && !img.isEmpty()) {
                uploaded.add(img);
            }
        }
        return uploaded;
    }
}
