package in.sp.main;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.slf4j.LoggerFactory;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.read.ListAppender;
import in.sp.main.Service.SecurityAuditLogger;
import in.sp.main.Util.LogSanitizer;

public class SecurityLoggingTest {

    private SecurityAuditLogger auditLogger;
    private ListAppender<ILoggingEvent> listAppender;
    private Logger rootLogger;

    @BeforeEach
    void setUp() {
        auditLogger = new SecurityAuditLogger();
        rootLogger = (Logger) LoggerFactory.getLogger(SecurityAuditLogger.class);
        listAppender = new ListAppender<>();
        listAppender.start();
        rootLogger.addAppender(listAppender);
    }

    @AfterEach
    void tearDown() {
        if (rootLogger != null && listAppender != null) {
            rootLogger.detachAppender(listAppender);
        }
    }

    @Test
    void testLogSanitizer_StripsCrlfAndControlCharacters() {
        String maliciousInput = "admin@example.com\r\n2026-09-07 WARN Fake Log Entry Injected\nAnotherLine\t\0";
        String sanitized = LogSanitizer.sanitize(maliciousInput);

        assertFalse(sanitized.contains("\r"), "Sanitized output must not contain carriage return");
        assertFalse(sanitized.contains("\n"), "Sanitized output must not contain line feed");
        assertFalse(sanitized.contains("\t"), "Sanitized output must not contain tab");
        assertFalse(sanitized.contains("\0"), "Sanitized output must not contain null byte");
        assertTrue(sanitized.startsWith("admin@example.com__2026-09-07"), "Control characters must be replaced with underscores");
    }

    @Test
    void testLogSanitizer_EnforcesMaximumLength() {
        String veryLongString = "A".repeat(300);
        String sanitized = LogSanitizer.sanitize(veryLongString);

        assertTrue(sanitized.length() <= 135, "Sanitized string must be truncated to safe length with ellipsis");
        assertTrue(sanitized.endsWith("..."), "Truncated string must end with ellipsis");
    }

    @Test
    void testLogSanitizer_FilenameSanitization() {
        String maliciousFilename = "../../etc/passwd\r\nexploit.jsp\0";
        String sanitized = LogSanitizer.sanitizeFilename(maliciousFilename);

        assertFalse(sanitized.contains("/"), "Sanitized filename must not contain slashes");
        assertFalse(sanitized.contains("\r"), "Sanitized filename must not contain CR");
        assertFalse(sanitized.contains("\n"), "Sanitized filename must not contain LF");
        assertFalse(sanitized.contains("\0"), "Sanitized filename must not contain null byte");
    }

    @Test
    void testSecurityAuditLogger_AuthEventsDoNotLeakSecrets() {
        auditLogger.logAuthSuccess("WEB", 42L, "user@example.com", "USER", "127.0.0.1");
        auditLogger.logAuthFailure("MOBILE", "attacker@test.com", "INVALID_CREDENTIALS", "192.168.1.100");

        assertFalse(listAppender.list.isEmpty(), "Audit log events must be emitted");

        for (ILoggingEvent event : listAppender.list) {
            String msg = event.getFormattedMessage();
            assertTrue(msg.contains("[SECURITY-AUDIT]"), "Log message must contain structured security audit tag");
            assertFalse(msg.contains("password"), "Log message must not contain password field");
            assertFalse(msg.contains("token"), "Log message must not contain token");
            assertFalse(msg.contains("secret"), "Log message must not contain secret");
        }
    }

    @Test
    void testSecurityAuditLogger_PaymentEventsLogSafeIdentifiersOnly() {
        auditLogger.logPaymentEvent("VERIFIED", 99L, 101L, "order_rzp_123", "pay_rzp_456", "SUCCESS");
        auditLogger.logPaymentEvent("SIGNATURE_MISMATCH", 99L, 101L, "order_rzp_123", "pay_rzp_456", "FAILED");

        boolean verifiedFound = false;
        boolean mismatchFound = false;

        for (ILoggingEvent event : listAppender.list) {
            String msg = event.getFormattedMessage();
            if (msg.contains("PAYMENT_VERIFIED")) {
                verifiedFound = true;
                assertTrue(msg.contains("userId=99"), "Must include user ID");
                assertTrue(msg.contains("orderId=order_rzp_123"), "Must include order ID");
                assertTrue(msg.contains("paymentId=pay_rzp_456"), "Must include payment ID");
                assertFalse(msg.contains("secret"), "Must never log Razorpay secret");
                assertFalse(msg.contains("signature="), "Must never log full raw signature");
            }
            if (msg.contains("PAYMENT_SIGNATURE_MISMATCH")) {
                mismatchFound = true;
                assertTrue(event.getLevel() == Level.WARN, "Failure must be logged at WARN level");
            }
        }

        assertTrue(verifiedFound, "Must have logged verified payment event");
        assertTrue(mismatchFound, "Must have logged signature mismatch payment event");
    }

    @Test
    void testSecurityAuditLogger_UploadBlockedLogsMetadataOnly() {
        auditLogger.logUploadBlocked(55L, "shell.php\r\n.jpg", "IMAGE", "DANGEROUS_EXTENSION");

        boolean blockedFound = false;
        for (ILoggingEvent event : listAppender.list) {
            String msg = event.getFormattedMessage();
            if (msg.contains("UPLOAD_BLOCKED")) {
                blockedFound = true;
                assertTrue(msg.contains("userId=55"));
                assertTrue(msg.contains("category=IMAGE"));
                assertTrue(msg.contains("reason=DANGEROUS_EXTENSION"));
                assertFalse(msg.contains("\r"), "Logged filename must be sanitized of CR");
                assertFalse(msg.contains("\n"), "Logged filename must be sanitized of LF");
            }
        }
        assertTrue(blockedFound, "Must log upload blocked event");
    }
}
