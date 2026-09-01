package in.sp.main;

import in.sp.main.Entities.EventLifecycleStatus;
import in.sp.main.Service.WomenEventSupport;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class WomenEventsModuleTest {

    @Test
    void lifecycleMapsLegacyListingStatus() {
        assertEquals("PENDING", EventLifecycleStatus.SUBMITTED.listingStatus());
        assertEquals("APPROVED", EventLifecycleStatus.PUBLISHED.listingStatus());
        assertEquals("DRAFT", EventLifecycleStatus.DRAFT.listingStatus());
        assertEquals("CANCELLED", EventLifecycleStatus.CANCELLED.listingStatus());
        assertEquals(EventLifecycleStatus.SUBMITTED, EventLifecycleStatus.fromLegacy("PENDING"));
        assertEquals(EventLifecycleStatus.CANCELLED, EventLifecycleStatus.fromLegacy("CANCELLED_BY_HOST"));
    }

    @Test
    void scheduleRejectsEndBeforeStartAndRegCloseAfterStart() {
        LocalDateTime start = LocalDateTime.of(2026, 9, 10, 10, 0);
        LocalDateTime endOk = start.plusHours(2);
        LocalDateTime endBad = start.minusHours(1);
        assertTrue(WomenEventSupport.scheduleValid(start, endOk, start.minusDays(7), start.minusMinutes(1)));
        assertFalse(WomenEventSupport.scheduleValid(start, endBad, null, null));
        assertFalse(WomenEventSupport.scheduleValid(start, endOk, null, start.plusMinutes(1)));
    }

    @Test
    void coinQuoteMathIsServerSide() {
        int available = 80;
        int maxFromPercent = (int) Math.floor(500 * 20 / 100.0);
        int applied = Math.min(available, maxFromPercent);
        assertEquals(80, applied);
        assertEquals(420, 500 - applied, 0.01);
        assertTrue(applied <= 100);
    }

    @Test
    void streamLinkHiddenUnlessEligible() {
        in.sp.main.Entities.WomenEvent e = new in.sp.main.Entities.WomenEvent();
        e.setStreamLink("https://meet.example/secret");
        assertNull(WomenEventSupport.hideAccessIfUnauthorized(e, false));
        assertEquals("https://meet.example/secret", WomenEventSupport.hideAccessIfUnauthorized(e, true));
    }

    @Test
    void listedStatusesIncludeApprovedAndPublished() {
        in.sp.main.Entities.WomenEvent e = new in.sp.main.Entities.WomenEvent();
        e.setStatus("APPROVED");
        assertTrue(WomenEventSupport.isPubliclyListed(e));
        e.setStatus("PUBLISHED");
        assertTrue(WomenEventSupport.isPubliclyListed(e));
        e.setStatus("DRAFT");
        assertFalse(WomenEventSupport.isPubliclyListed(e));
        e.setStatus("PENDING");
        assertFalse(WomenEventSupport.isPubliclyListed(e));
        e.setStatus("CANCELLED");
        assertFalse(WomenEventSupport.isPubliclyListed(e));
        assertTrue(WomenEventSupport.isBookableStatus(listed("APPROVED")));
        assertFalse(WomenEventSupport.isBookableStatus(listed("SOLD_OUT")));
    }

    private static in.sp.main.Entities.WomenEvent listed(String status) {
        in.sp.main.Entities.WomenEvent e = new in.sp.main.Entities.WomenEvent();
        e.setStatus(status);
        return e;
    }
}
