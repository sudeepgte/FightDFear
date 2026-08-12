package in.sp.main.Config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * Fail fast on startup when the production profile is active but required
 * environment configuration is missing or unsafe.
 */
@Component
@Profile("prod")
public class ProductionEnvironmentValidator {

    private static final String DEV_JWT_PLACEHOLDER = "LOCAL_DEV_ONLY_change_me_min_32_chars_abcdefgh";

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    @Value("${app.payments.mock-enabled}")
    private boolean paymentMockEnabled;

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUsername;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    @Value("${spring.mail.username}")
    private String mailUsername;

    @Value("${spring.mail.password}")
    private String mailPassword;

    @PostConstruct
    void validate() {
        if (paymentMockEnabled) {
            throw new IllegalStateException(
                    "Production requires PAYMENT_MOCK=false (app.payments.mock-enabled=false)");
        }
        requireNonBlank(razorpayKeyId, "RAZORPAY_KEY_ID");
        requireNonBlank(razorpayKeySecret, "RAZORPAY_KEY_SECRET");
        requireNonBlank(jwtSecret, "JWT_SECRET");
        if (DEV_JWT_PLACEHOLDER.equals(jwtSecret)) {
            throw new IllegalStateException(
                    "Production must not use the local-dev JWT_SECRET placeholder");
        }
        if (jwtSecret.length() < 32) {
            throw new IllegalStateException("JWT_SECRET must be at least 32 characters");
        }
        requireNonBlank(dbUrl, "DB_URL");
        requireNonBlank(dbUsername, "DB_USERNAME");
        requireNonBlank(dbPassword, "DB_PASSWORD");
        requireNonBlank(mailUsername, "MAIL_USERNAME");
        requireNonBlank(mailPassword, "MAIL_PASSWORD");
    }

    private static void requireNonBlank(String value, String envName) {
        if (value == null || value.isBlank()) {
            throw new IllegalStateException("Production requires " + envName + " to be set");
        }
    }
}
