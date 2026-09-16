package in.sp.main;

import in.sp.main.Config.ProductionEnvironmentValidator;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

class SecretConfigurationSecurityTest {

    private ProductionEnvironmentValidator createValidator(
            String jwtSecret,
            String razorpayKeyId,
            String razorpayKeySecret,
            boolean paymentMockEnabled,
            String dbUrl,
            String dbUsername,
            String dbPassword,
            String mailUsername,
            String mailPassword) {

        ProductionEnvironmentValidator validator = new ProductionEnvironmentValidator();
        ReflectionTestUtils.setField(validator, "jwtSecret", jwtSecret);
        ReflectionTestUtils.setField(validator, "razorpayKeyId", razorpayKeyId);
        ReflectionTestUtils.setField(validator, "razorpayKeySecret", razorpayKeySecret);
        ReflectionTestUtils.setField(validator, "paymentMockEnabled", paymentMockEnabled);
        ReflectionTestUtils.setField(validator, "dbUrl", dbUrl);
        ReflectionTestUtils.setField(validator, "dbUsername", dbUsername);
        ReflectionTestUtils.setField(validator, "dbPassword", dbPassword);
        ReflectionTestUtils.setField(validator, "mailUsername", mailUsername);
        ReflectionTestUtils.setField(validator, "mailPassword", mailPassword);
        ReflectionTestUtils.setField(validator, "razorpayWebhookSecret", "valid_test_webhook_secret");
        return validator;
    }

    @Test
    void testValidProductionConfigurationPasses() {
        ProductionEnvironmentValidator validator = createValidator(
                "production-secure-jwt-secret-minimum-32-characters",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                false,
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        assertDoesNotThrow(() -> ReflectionTestUtils.invokeMethod(validator, "validate"));
    }

    @Test
    void testProductionRejectsPaymentMockEnabled() {
        ProductionEnvironmentValidator validator = createValidator(
                "production-secure-jwt-secret-minimum-32-characters",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                true, // Mock enabled in prod!
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("PAYMENT_MOCK=false"));
    }

    @Test
    void testProductionRejectsDevJwtSecretPlaceholder() {
        ProductionEnvironmentValidator validator = createValidator(
                "LOCAL_DEV_ONLY_change_me_min_32_chars_abcdefgh",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                false,
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("local-dev JWT_SECRET placeholder"));
    }

    @Test
    void testProductionRejectsShortJwtSecret() {
        ProductionEnvironmentValidator validator = createValidator(
                "short-secret",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                false,
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("at least 32 characters"));
    }

    @Test
    void testProductionRejectsMissingDatabaseCredentials() {
        ProductionEnvironmentValidator validator = createValidator(
                "production-secure-jwt-secret-minimum-32-characters",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                false,
                null,
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("DB_URL"));
    }

    @Test
    void testProductionRejectsMissingRazorpayCredentials() {
        ProductionEnvironmentValidator validator = createValidator(
                "production-secure-jwt-secret-minimum-32-characters",
                "",
                "realRazorpayKeySecret12345",
                false,
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                "notifications@fightdfear.com",
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("RAZORPAY_KEY_ID"));
    }

    @Test
    void testProductionRejectsMissingMailCredentials() {
        ProductionEnvironmentValidator validator = createValidator(
                "production-secure-jwt-secret-minimum-32-characters",
                "rzp_live_realKeyId12345",
                "realRazorpayKeySecret12345",
                false,
                "jdbc:mysql://prod-db:3306/womenbesafe",
                "prod_user",
                "prod_password",
                null,
                "smtp-app-password"
        );
        IllegalStateException ex = assertThrows(IllegalStateException.class,
                () -> ReflectionTestUtils.invokeMethod(validator, "validate"));
        assertTrue(ex.getMessage().contains("MAIL_USERNAME"));
    }
}
