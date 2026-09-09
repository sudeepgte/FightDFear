package in.sp.main;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.EmailOtpVerification;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.User;
import in.sp.main.Exception.RateLimitExceededException;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.EmailOtpVerificationRepository;
import in.sp.main.Repository.RateLimitBucketRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.OtpVerificationService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.RateLimitService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:otp_ratelimit_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused",
        "spring.mvc.view.prefix=/WEB-INF/views/",
        "spring.mvc.view.suffix=.jsp"
})
class OtpAndRateLimitSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private EmailOtpVerificationRepository otpRepository;

    @Autowired
    private RateLimitBucketRepository rateLimitBucketRepository;

    @Autowired
    private RateLimitService rateLimitService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    @BeforeEach
    void setUp() {
        otpRepository.deleteAll();
        rateLimitBucketRepository.deleteAll();
        userRepository.deleteAll();
        adminRepository.deleteAll();
    }

    private void seedOtp(String email, String code, OtpPurpose purpose, boolean expired) {
        EmailOtpVerification record = new EmailOtpVerification();
        record.setEmail(email.trim().toLowerCase());
        record.setCodeHash(passwordEncoder.encode(code));
        record.setPurpose(purpose);
        record.setChannel(OtpChannel.EMAIL);
        record.setVerified(false);
        record.setExpiresAt(expired ? LocalDateTime.now().minusMinutes(5) : LocalDateTime.now().plusMinutes(10));
        record.setCreatedAt(LocalDateTime.now().minusMinutes(expired ? 15 : 1));
        otpRepository.save(record);
    }

    @Test
    void validOtpVerificationSucceeds() {
        String email = "victim@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, false);

        boolean verified = otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER);
        assertTrue(verified);
    }

    @Test
    void invalidOtpVerificationFails() {
        String email = "victim@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, false);

        boolean verified = otpVerificationService.verifyOtp(email, "999999", OtpPurpose.USER_REGISTER);
        assertFalse(verified);
    }

    @Test
    void invalidOtpAttemptsAreThrottledAfterFiveFailures() {
        String email = "victim@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, false);

        // 5 failed attempts
        for (int i = 0; i < 5; i++) {
            assertFalse(otpVerificationService.verifyOtp(email, "00000" + i, OtpPurpose.USER_REGISTER));
        }

        // 6th attempt must be throttled with RateLimitExceededException
        assertThrows(RateLimitExceededException.class, () ->
                otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER));
    }

    @Test
    void successfulVerificationResetsFailureCounter() {
        String email = "victim@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, false);

        // 3 failed attempts
        for (int i = 0; i < 3; i++) {
            assertFalse(otpVerificationService.verifyOtp(email, "00000" + i, OtpPurpose.USER_REGISTER));
        }

        // Valid attempt clears failure counter
        assertTrue(otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER));
    }

    @Test
    void expiredOtpIsRejected() {
        String email = "expired@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, true);

        assertFalse(otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER));
    }

    @Test
    void consumedOrVerifiedOtpCannotBeReused() {
        String email = "reuse@example.com";
        seedOtp(email, "123456", OtpPurpose.USER_REGISTER, false);

        assertTrue(otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER));
        // Second attempt to verify the same code fails
        assertFalse(otpVerificationService.verifyOtp(email, "123456", OtpPurpose.USER_REGISTER));
    }

    @Test
    void repeatedWebLoginAttemptsAreThrottled() throws Exception {
        User user = new User();
        user.setEmail("testuser@example.com");
        user.setPassword(passwordService.encode("StrongPassword@123"));
        user.setFullName("Test User");
        userRepository.save(user);

        // 5 failed password attempts
        for (int i = 0; i < 5; i++) {
            mockMvc.perform(post("/login")
                            .param("email", "testuser@example.com")
                            .param("password", "WrongPassword"))
                    .andExpect(status().isOk())
                    .andExpect(model().attribute("error", "Invalid credentials. Please try again."));
        }

        // 6th attempt is throttled
        mockMvc.perform(post("/login")
                        .param("email", "testuser@example.com")
                        .param("password", "StrongPassword@123"))
                .andExpect(status().isOk())
                .andExpect(model().attribute("error", "Too many failed login attempts. Please try again in 15 minutes."));
    }

    @Test
    void repeatedAdminLoginAttemptsAreThrottled() throws Exception {
        Admin admin = new Admin("Super Admin", "admin@example.com", passwordService.encode("AdminPass@123"));
        adminRepository.save(admin);

        // 5 failed password attempts
        for (int i = 0; i < 5; i++) {
            mockMvc.perform(post("/admin/loginAdmin")
                            .param("email", "admin@example.com")
                            .param("password", "WrongAdminPass"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(flash().attribute("error", "Invalid credentials!"));
        }

        // 6th attempt is throttled
        mockMvc.perform(post("/admin/loginAdmin")
                        .param("email", "admin@example.com")
                        .param("password", "AdminPass@123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(flash().attribute("error", "Too many failed login attempts. Please try again in 15 minutes."));
    }

    @Test
    void mobileAdminBackdoorIsEliminated() throws Exception {
        // Attempting to log into mobile admin with hardcoded credentials when not configured
        mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"admin@gmail.com\",\"password\":\"Admin@123\"}"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.success").value(false));
    }
}
