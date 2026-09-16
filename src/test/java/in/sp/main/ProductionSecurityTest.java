package in.sp.main;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.lang.reflect.Method;
import java.util.Arrays;

import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Profile;
import org.springframework.test.util.ReflectionTestUtils;

import in.sp.main.Config.ProductionEnvironmentValidator;

public class ProductionSecurityTest {

    private ProductionEnvironmentValidator createValidator(
            boolean mockPayments,
            String jwtSecret,
            String rzpKeyId,
            String rzpKeySecret,
            String rzpWebhookSecret,
            String dbUrl,
            String dbUser,
            String dbPass,
            String mailUser,
            String mailPass) {

        ProductionEnvironmentValidator validator = new ProductionEnvironmentValidator();
        ReflectionTestUtils.setField(validator, "paymentMockEnabled", mockPayments);
        ReflectionTestUtils.setField(validator, "jwtSecret", jwtSecret);
        ReflectionTestUtils.setField(validator, "razorpayKeyId", rzpKeyId);
        ReflectionTestUtils.setField(validator, "razorpayKeySecret", rzpKeySecret);
        ReflectionTestUtils.setField(validator, "razorpayWebhookSecret", rzpWebhookSecret);
        ReflectionTestUtils.setField(validator, "dbUrl", dbUrl);
        ReflectionTestUtils.setField(validator, "dbUsername", dbUser);
        ReflectionTestUtils.setField(validator, "dbPassword", dbPass);
        ReflectionTestUtils.setField(validator, "mailUsername", mailUser);
        ReflectionTestUtils.setField(validator, "mailPassword", mailPass);
        return validator;
    }

    private void invokeValidate(ProductionEnvironmentValidator validator) throws Exception {
        Method method = ProductionEnvironmentValidator.class.getDeclaredMethod("validate");
        method.setAccessible(true);
        method.invoke(validator);
    }

    @Test
    void testProductionValidator_PassesWithValidConfiguration() {
        ProductionEnvironmentValidator validator = createValidator(
                false,
                "StrongProductionSecretKeyThatHasMoreThan32Characters!!",
                "rzp_live_abc123",
                "rzp_secret_def456",
                "webhook_sec_789",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        assertDoesNotThrow(() -> invokeValidate(validator));
    }

    @Test
    void testProductionValidator_FailsWhenMockPaymentsEnabled() {
        ProductionEnvironmentValidator validator = createValidator(
                true,
                "StrongProductionSecretKeyThatHasMoreThan32Characters!!",
                "rzp_live_abc123",
                "rzp_secret_def456",
                "webhook_sec_789",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        Exception ex = assertThrows(Exception.class, () -> invokeValidate(validator));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertTrue(ex.getCause().getMessage().contains("PAYMENT_MOCK=false"));
    }

    @Test
    void testProductionValidator_FailsWhenDevJwtPlaceholderUsed() {
        ProductionEnvironmentValidator validator = createValidator(
                false,
                "LOCAL_DEV_ONLY_change_me_min_32_chars_abcdefgh",
                "rzp_live_abc123",
                "rzp_secret_def456",
                "webhook_sec_789",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        Exception ex = assertThrows(Exception.class, () -> invokeValidate(validator));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertTrue(ex.getCause().getMessage().contains("placeholder"));
    }

    @Test
    void testProductionValidator_FailsWhenJwtSecretTooShort() {
        ProductionEnvironmentValidator validator = createValidator(
                false,
                "ShortSecretKey",
                "rzp_live_abc123",
                "rzp_secret_def456",
                "webhook_sec_789",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        Exception ex = assertThrows(Exception.class, () -> invokeValidate(validator));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertTrue(ex.getCause().getMessage().contains("at least 32 characters"));
    }

    @Test
    void testProductionValidator_FailsWhenRazorpayCredentialsMissing() {
        ProductionEnvironmentValidator validator = createValidator(
                false,
                "StrongProductionSecretKeyThatHasMoreThan32Characters!!",
                "",
                "rzp_secret_def456",
                "webhook_sec_789",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        Exception ex = assertThrows(Exception.class, () -> invokeValidate(validator));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertTrue(ex.getCause().getMessage().contains("RAZORPAY_KEY_ID"));
    }

    @Test
    void testProductionValidator_FailsWhenWebhookSecretMissing() {
        ProductionEnvironmentValidator validator = createValidator(
                false,
                "StrongProductionSecretKeyThatHasMoreThan32Characters!!",
                "rzp_live_abc123",
                "rzp_secret_def456",
                "",
                "jdbc:mysql://prod-db:3306/db",
                "prod_user",
                "prod_pass",
                "prod_mail_user@example.com",
                "prod_mail_password");

        Exception ex = assertThrows(Exception.class, () -> invokeValidate(validator));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertTrue(ex.getCause().getMessage().contains("RAZORPAY_WEBHOOK_SECRET"));
    }

    @Test
    void testDiagnosticRunners_AreDisabledInProduction() {
        Profile profile1 = TestRunner.class.getAnnotation(Profile.class);
        assertNotNull(profile1, "TestRunner must have @Profile annotation");
        assertTrue(Arrays.asList(profile1.value()).contains("!prod"), "TestRunner must be excluded in prod profile");

        Profile profile2 = TestRunner2.class.getAnnotation(Profile.class);
        assertNotNull(profile2, "TestRunner2 must have @Profile annotation");
        assertTrue(Arrays.asList(profile2.value()).contains("!prod"), "TestRunner2 must be excluded in prod profile");
    }

    private void assertNotNull(Object obj, String message) {
        assertTrue(obj != null, message);
    }
}
