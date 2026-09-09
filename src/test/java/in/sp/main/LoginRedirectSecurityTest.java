package in.sp.main;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.SafeRedirectValidator;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:login_redirect_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=test",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused",
        "spring.mvc.view.prefix=/WEB-INF/views/",
        "spring.mvc.view.suffix=.jsp"
})
public class LoginRedirectSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordService passwordService;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
    }

    @Test
    void safeRedirectValidator_RejectsMaliciousRedirects() {
        String[] malicious = {
                "//evil.com",
                "///evil.com",
                "//example.invalid",
                "https://example.invalid",
                "http://example.invalid",
                "/\\example.invalid",
                "%2F%2Fexample.invalid",
                "%5C%5Cexample.invalid",
                "javascript:alert(1)",
                "%0d%0aLocation:%20//example.invalid",
                "data:text/html,<script>alert(1)</script>",
                "/evil\r\nSet-Cookie: session=evil",
                "/evil\nLocation: evil.com",
                "",
                "   ",
                null
        };

        for (String url : malicious) {
            assertFalse(SafeRedirectValidator.isSafeRedirect(url),
                    "Payload should be rejected: " + url);
            assertEquals("/users/dashboard",
                    SafeRedirectValidator.getSafeLocalRedirect(url, "/users/dashboard"),
                    "Fallback must be returned for: " + url);
        }
    }

    @Test
    void safeRedirectValidator_AcceptsSafeLocalPaths() {
        String[] safe = {
                "/users/dashboard",
                "/centres/dashboard",
                "/user/stylist/view?id=45&serviceId=12",
                "/",
                "/marketplace/products",
                "/attendance/my-attendance"
        };

        for (String url : safe) {
            assertTrue(SafeRedirectValidator.isSafeRedirect(url),
                    "Safe local path should be allowed: " + url);
            assertEquals(url, SafeRedirectValidator.getSafeLocalRedirect(url, "/users/dashboard"));
        }
    }

    @Test
    void loginFlow_ExplicitMaliciousPayloadVerification() throws Exception {
        User user = new User();
        user.setEmail("verifier@test.com");
        user.setPassword(passwordService.encode("Password@123"));
        user.setFullName("Verifier");
        user.setVerificationStatus(VerificationStatus.VERIFIED);
        userRepository.save(user);

        String[] testCases = {
                "//example.invalid",
                "https://example.invalid",
                "http://example.invalid",
                "/\\example.invalid",
                "%2F%2Fexample.invalid",
                "%5C%5Cexample.invalid",
                "javascript:alert(1)",
                "%0d%0aLocation:%20//example.invalid"
        };

        for (String redirectCandidate : testCases) {
            // 1. Visit login page with candidate
            MvcResult getResult = mockMvc.perform(get("/login").param("redirect", redirectCandidate))
                    .andExpect(status().isOk())
                    .andReturn();

            MockHttpSession session = (MockHttpSession) getResult.getRequest().getSession();
            assertNull(session.getAttribute("redirectAfterLogin"),
                    "Unsafe redirect must not be stored in session: " + redirectCandidate);

            // 2. Perform login with credentials
            MvcResult postResult = mockMvc.perform(post("/login")
                            .session(session)
                            .with(csrf())
                            .param("email", "verifier@test.com")
                            .param("password", "Password@123"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("/users/dashboard"))
                    .andReturn();

            String finalLocation = postResult.getResponse().getHeader("Location");
            assertEquals("/users/dashboard", finalLocation,
                    "Redirect for " + redirectCandidate + " must fall back to /users/dashboard");
        }

        // Safe target check
        MvcResult safeGet = mockMvc.perform(get("/login").param("redirect", "/users/dashboard"))
                .andExpect(status().isOk())
                .andReturn();
        MockHttpSession safeSession = (MockHttpSession) safeGet.getRequest().getSession();
        assertEquals("/users/dashboard", safeSession.getAttribute("redirectAfterLogin"));

        MvcResult safePost = mockMvc.perform(post("/login")
                        .session(safeSession)
                        .with(csrf())
                        .param("email", "verifier@test.com")
                        .param("password", "Password@123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/users/dashboard"))
                .andReturn();
        assertEquals("/users/dashboard", safePost.getResponse().getHeader("Location"));
    }
}
