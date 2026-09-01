package in.sp.main.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Locale;
import java.util.Set;

import in.sp.main.Entities.WomenEvent;

/**
 * Pure event rules used by booking, listing, and tests. Backend is authoritative.
 */
public final class WomenEventSupport {

    public static final ZoneId IST = ZoneId.of("Asia/Kolkata");

    private static final Set<String> LISTED = Set.of("APPROVED", "PUBLISHED", "SOLD_OUT", "ONGOING");
    private static final Set<String> BOOKABLE = Set.of("APPROVED", "PUBLISHED");
    private static final Set<String> TERMINAL = Set.of("CANCELLED", "CANCELLED_BY_HOST", "REJECTED", "COMPLETED");

    private WomenEventSupport() {}

    public static String norm(String status) {
        return status == null ? "" : status.trim().toUpperCase(Locale.ROOT);
    }

    public static boolean isPubliclyListed(WomenEvent e) {
        if (e == null) return false;
        return LISTED.contains(norm(e.getStatus()));
    }

    public static boolean isBookableStatus(WomenEvent e) {
        if (e == null) return false;
        return BOOKABLE.contains(norm(e.getStatus()));
    }

    public static boolean isTerminal(WomenEvent e) {
        return e != null && TERMINAL.contains(norm(e.getStatus()));
    }

    public static boolean registrationWindowOpen(WomenEvent e, LocalDateTime now) {
        if (e == null) return false;
        if (e.getRegistrationOpensAt() != null && now.isBefore(e.getRegistrationOpensAt())) return false;
        if (e.getRegistrationClosesAt() != null && now.isAfter(e.getRegistrationClosesAt())) return false;
        LocalDateTime start = eventStart(e);
        if (start != null && !now.isBefore(start) && e.getRegistrationClosesAt() == null) return false;
        return true;
    }

    public static LocalDateTime eventStart(WomenEvent e) {
        if (e == null) return null;
        if (e.getStartsAt() != null) return e.getStartsAt();
        if (e.getEventDate() == null) return null;
        var t = e.getEventTime() == null ? java.time.LocalTime.of(10, 0) : e.getEventTime();
        return LocalDateTime.of(e.getEventDate(), t);
    }

    public static LocalDateTime eventEnd(WomenEvent e) {
        if (e == null) return null;
        if (e.getEndsAt() != null) return e.getEndsAt();
        LocalDateTime start = eventStart(e);
        return start == null ? null : start.plusHours(2);
    }

    public static boolean scheduleValid(LocalDateTime start, LocalDateTime end,
                                        LocalDateTime regOpen, LocalDateTime regClose) {
        if (start == null) return false;
        if (end != null && end.isBefore(start)) return false;
        if (regClose != null && !regClose.isBefore(start) && !regClose.equals(start)) {
            // registration closing cannot occur after event start
            if (regClose.isAfter(start)) return false;
        }
        if (regOpen != null && regClose != null && regClose.isBefore(regOpen)) return false;
        return true;
    }

    public static String hideAccessIfUnauthorized(WomenEvent e, boolean eligibleAttendee) {
        if (e == null) return null;
        if (eligibleAttendee) return e.getStreamLink();
        return null;
    }
}
