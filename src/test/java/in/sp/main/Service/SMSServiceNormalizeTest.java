package in.sp.main.Service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

class SMSServiceNormalizeTest {

    private SMSService smsService;

    @BeforeEach
    void setUp() {
        smsService = new SMSService();
        ReflectionTestUtils.setField(smsService, "defaultCountryCode", "91");
        ReflectionTestUtils.setField(smsService, "smsEnabled", false);
    }

    @Test
    void normalizeAddsCountryCodeForTenDigitIndianNumbers() {
        assertEquals("919876543210", smsService.normalizePhone("9876543210"));
        assertEquals("919876543210", smsService.normalizePhone("+91 98765-43210"));
    }

    @Test
    void normalizeRejectsUnusableInput() {
        assertNull(smsService.normalizePhone(null));
        assertNull(smsService.normalizePhone(""));
        assertNull(smsService.normalizePhone("123"));
    }

    @Test
    void sendSmsReturnsFalseWhenDisabled() {
        assertFalse(smsService.sendSMS("9876543210", "test"));
    }
}
