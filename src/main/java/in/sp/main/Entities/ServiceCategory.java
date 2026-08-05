package in.sp.main.Entities;

/**
 * Glow Space service categories.
 * Legacy values kept for existing rows stored as STRING enums.
 */
public enum ServiceCategory {
    HAIR,
    SKIN_CARE,
    MAKEUP,
    NAIL_CARE,
    SPA_MASSAGE,
    WAXING,
    THREADING,
    EYE_BROW,
    BRIDAL,
    MEHENDI,
    WELLNESS,
    COSMETIC,
    TRAINING,
    PACKAGES,

    // Legacy (pre Glow Space taxonomy)
    FACIAL,
    HAIRCUT,
    MASSAGE,
    MANICURE,
    PEDICURE,
    HAIR_COLOR,
    SPA;

    public static ServiceCategory fromFlexible(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String key = raw.trim().toUpperCase().replace('-', '_').replace(' ', '_');
        try {
            return ServiceCategory.valueOf(key);
        } catch (Exception ignored) {
            return switch (key) {
                case "SKIN", "SKINCARE", "FACIALS" -> SKIN_CARE;
                case "NAILS", "NAIL" -> NAIL_CARE;
                case "SPA_AND_MASSAGE", "SPA_MASSAGE", "MASSAGES" -> SPA_MASSAGE;
                case "EYE", "BROW", "EYE_AND_BROW", "EYEBROW" -> EYE_BROW;
                case "COSMETIC_TREATMENTS", "COSMETICS" -> COSMETIC;
                case "SPECIAL_PACKAGES", "PACKAGE" -> PACKAGES;
                case "TRAINING_WORKSHOPS", "WORKSHOPS" -> TRAINING;
                case "HAIR_SERVICES" -> HAIR;
                default -> null;
            };
        }
    }

    /** Prefer modern taxonomy labels when exposing to clients. */
    public ServiceCategory normalized() {
        return switch (this) {
            case FACIAL -> SKIN_CARE;
            case HAIRCUT, HAIR_COLOR -> HAIR;
            case MASSAGE, SPA -> SPA_MASSAGE;
            case MANICURE, PEDICURE -> NAIL_CARE;
            default -> this;
        };
    }

    public String displayLabel() {
        return switch (normalized()) {
            case HAIR -> "Hair Services";
            case SKIN_CARE -> "Skin Care";
            case MAKEUP -> "Makeup";
            case NAIL_CARE -> "Nail Care";
            case SPA_MASSAGE -> "Spa & Massage";
            case WAXING -> "Waxing";
            case THREADING -> "Threading";
            case EYE_BROW -> "Eye & Brow";
            case BRIDAL -> "Bridal Services";
            case MEHENDI -> "Mehendi";
            case WELLNESS -> "Wellness";
            case COSMETIC -> "Cosmetic Treatments";
            case TRAINING -> "Training & Workshops";
            case PACKAGES -> "Special Packages";
            default -> name();
        };
    }
}
