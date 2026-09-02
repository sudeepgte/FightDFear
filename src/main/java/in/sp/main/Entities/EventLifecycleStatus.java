package in.sp.main.Entities;

/**
 * Authoritative event lifecycle. The legacy {@code women_events.status} string
 * stays in sync so existing member/host queries keep working.
 */
public enum EventLifecycleStatus {
    DRAFT,
    SUBMITTED,
    UNDER_REVIEW,
    CHANGES_REQUESTED,
    APPROVED,
    PUBLISHED,
    SOLD_OUT,
    ONGOING,
    COMPLETED,
    CANCELLED,
    REJECTED;

    public String listingStatus() {
        return switch (this) {
            case DRAFT -> "DRAFT";
            case SUBMITTED, UNDER_REVIEW -> "PENDING";
            case CHANGES_REQUESTED -> "CHANGES_REQUESTED";
            case APPROVED, PUBLISHED -> "APPROVED";
            case SOLD_OUT -> "SOLD_OUT";
            case ONGOING -> "ONGOING";
            case COMPLETED -> "COMPLETED";
            case CANCELLED -> "CANCELLED";
            case REJECTED -> "REJECTED";
        };
    }

    public static EventLifecycleStatus fromLegacy(String status) {
        if (status == null || status.isBlank()) return DRAFT;
        return switch (status.trim().toUpperCase()) {
            case "DRAFT" -> DRAFT;
            case "PENDING", "SUBMITTED", "UNDER_REVIEW" -> SUBMITTED;
            case "CHANGES_REQUESTED" -> CHANGES_REQUESTED;
            case "APPROVED" -> APPROVED;
            case "PUBLISHED" -> PUBLISHED;
            case "SOLD_OUT" -> SOLD_OUT;
            case "ONGOING" -> ONGOING;
            case "COMPLETED" -> COMPLETED;
            case "CANCELLED", "CANCELLED_BY_HOST" -> CANCELLED;
            case "REJECTED" -> REJECTED;
            default -> DRAFT;
        };
    }
}
