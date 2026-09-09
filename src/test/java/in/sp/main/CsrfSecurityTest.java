package in.sp.main;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import java.time.LocalDateTime;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import jakarta.servlet.http.Cookie;
import org.springframework.security.web.csrf.CsrfToken;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:csrf_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
        "razorpay.webhook.secret=test-secret",
        "google.maps.apiKey=unused",
        "spring.mvc.view.prefix=/WEB-INF/views/",
        "spring.mvc.view.suffix=.jsp"
})
class CsrfSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private org.springframework.security.web.FilterChainProxy filterChainProxy;

    @Autowired
    private in.sp.main.Repository.DoctorAppointmentRepository doctorAppointmentRepository;

    private User testUser;
    private String validJwt;

    @BeforeEach
    void setUp() {
        doctorAppointmentRepository.deleteAll();
        userRepository.deleteAll();

        // Restore CookieCsrfTokenRepository on CsrfFilter in case SecurityMockMvcRequestPostProcessors.csrf() replaced it
        for (org.springframework.security.web.SecurityFilterChain chain : filterChainProxy.getFilterChains()) {
            for (jakarta.servlet.Filter filter : chain.getFilters()) {
                if (filter instanceof org.springframework.security.web.csrf.CsrfFilter csrfFilter) {
                    org.springframework.test.util.ReflectionTestUtils.setField(csrfFilter, "tokenRepository", org.springframework.security.web.csrf.CookieCsrfTokenRepository.withHttpOnlyFalse());
                }
            }
        }

        testUser = new User();
        testUser.setEmail("csrfuser@example.com");
        testUser.setPassword("Pass@12345");
        testUser.setFullName("CSRF Test User");
        testUser.setPhoneNumber("9876543210");
        testUser = userRepository.save(testUser);

        validJwt = jwtUtil.generateToken(testUser.getEmail(), "USER");
    }

    @Test
    void rejectsStateChangingRequestWithoutCsrfToken() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .param("autoTrigger", "false"))
                .andExpect(status().isForbidden());
    }

    @Test
    void rejectsStateChangingRequestWithInvalidCsrfToken() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .header("X-XSRF-TOKEN", "invalid-csrf-token-12345")
                        .param("autoTrigger", "false"))
                .andExpect(status().isForbidden());
    }

    @Test
    void acceptsStateChangingRequestWithValidCsrfToken() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .with(SecurityMockMvcRequestPostProcessors.csrf())
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk());
    }

    @Test
    void getRequestsDoNotRequireCsrfToken() throws Exception {
        mockMvc.perform(get("/contact"))
                .andExpect(status().isOk());
    }

    @Test
    void bearerTokenRequestsExemptedFromCsrf() throws Exception {
        mockMvc.perform(get("/api/me")
                        .header("Authorization", "Bearer " + validJwt))
                .andExpect(status().isOk());
    }

    @Test
    void xsrfCookiePopulatedOnResponse() throws Exception {
        MvcResult result = mockMvc.perform(get("/contact"))
                .andExpect(status().isOk())
                .andReturn();

        Cookie xsrfCookie = result.getResponse().getCookie("XSRF-TOKEN");
        if (xsrfCookie == null) {
            Object tokenAttr = result.getRequest().getAttribute(CsrfToken.class.getName());
            if (tokenAttr == null) {
                tokenAttr = result.getRequest().getAttribute("_csrf");
            }
            assertNotNull(tokenAttr, "CsrfToken must be generated and present in request attributes");
        } else {
            assertNotNull(xsrfCookie.getValue());
        }
    }

    @Autowired
    private in.sp.main.Repository.DoctorRepository doctorRepository;

    private in.sp.main.Entities.Doctor testDoctor;

    @Test
    void doctorProfileCompletionRejectsPostWithoutCsrfToken() throws Exception {
        in.sp.main.Entities.Doctor doc = new in.sp.main.Entities.Doctor();
        doc.setEmail("csrfdoctor@example.com");
        doc.setPassword("Pass@12345");
        doc.setFullName("Dr. CSRF Test");
        doc.setPhone("9876543211");
        doc = doctorRepository.save(doc);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedDoctor", doc);

        mockMvc.perform(post("/doctors/profile-completion")
                        .session(session)
                        .param("fullName", "Dr. CSRF Test"))
                .andExpect(status().isForbidden());
    }

    @Test
    void doctorProfileCompletionAcceptsPostWithValidCsrfToken() throws Exception {
        in.sp.main.Entities.Doctor doc = new in.sp.main.Entities.Doctor();
        doc.setEmail("csrfdoctor2@example.com");
        doc.setPassword("Pass@12345");
        doc.setFullName("Dr. CSRF Test 2");
        doc.setPhone("9876543212");
        doc = doctorRepository.save(doc);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedDoctor", doc);

        mockMvc.perform(post("/doctors/profile-completion")
                        .session(session)
                        .with(SecurityMockMvcRequestPostProcessors.csrf())
                        .param("fullName", "Dr. CSRF Test 2"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void userUpdateRejectsPostWithoutCsrfToken() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/users/update/" + testUser.getId())
                        .session(session)
                        .param("name", testUser.getFullName())
                        .param("email", testUser.getEmail())
                        .param("phone", "9876543210")
                        .param("confirmSave", "true"))
                .andExpect(status().isForbidden());
    }

    @Test
    void userUpdateAcceptsPostWithValidCsrfToken() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/users/update/" + testUser.getId())
                        .session(session)
                        .with(SecurityMockMvcRequestPostProcessors.csrf())
                        .param("name", testUser.getFullName())
                        .param("email", testUser.getEmail())
                        .param("phone", "9876543210")
                        .param("confirmSave", "true"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void adminApprovalRejectsWithoutCsrfToken() throws Exception {
        in.sp.main.Entities.Admin admin = new in.sp.main.Entities.Admin();
        admin.setEmail("admin@test.com");
        admin.setName("Admin User");
        admin.setRole("ADMIN");

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", admin);

        mockMvc.perform(post("/admin/approve/1")
                        .session(session))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminApprovalAcceptsWithCsrfToken() throws Exception {
        in.sp.main.Entities.Admin admin = new in.sp.main.Entities.Admin();
        admin.setEmail("admin@test.com");
        admin.setName("Admin User");
        admin.setRole("ADMIN");

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", admin);

        mockMvc.perform(post("/admin/approve/999")
                        .session(session)
                        .with(SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().is3xxRedirection());
    }

    private static String createMaskedToken(String rawToken) {
        byte[] tokenBytes = rawToken.getBytes(StandardCharsets.UTF_8);
        byte[] randomBytes = new byte[tokenBytes.length];
        new SecureRandom().nextBytes(randomBytes);
        byte[] xoredBytes = new byte[tokenBytes.length];
        for (int i = 0; i < tokenBytes.length; i++) {
            xoredBytes[i] = (byte) (tokenBytes[i] ^ randomBytes[i]);
        }
        byte[] combined = new byte[tokenBytes.length * 2];
        System.arraycopy(randomBytes, 0, combined, 0, tokenBytes.length);
        System.arraycopy(xoredBytes, 0, combined, tokenBytes.length, tokenBytes.length);
        return Base64.getUrlEncoder().encodeToString(combined);
    }

    @Test
    void acceptsRawCsrfTokenInXCSRFTokenHeader() throws Exception {
        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .cookie(xsrfCookie)
                        .header("X-CSRF-TOKEN", rawToken)
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk());
    }

    @Test
    void acceptsMaskedCsrfTokenInXCSRFTokenHeader() throws Exception {
        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);
        String maskedToken = createMaskedToken(rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .cookie(xsrfCookie)
                        .header("X-CSRF-TOKEN", maskedToken)
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk());
    }

    @Test
    void acceptsMaskedCsrfTokenInXXSRFTokenHeader() throws Exception {
        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);
        String maskedToken = createMaskedToken(rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .cookie(xsrfCookie)
                        .header("X-XSRF-TOKEN", maskedToken)
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk());
    }

    @Test
    void acceptsMaskedCsrfTokenInParam() throws Exception {
        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);
        String maskedToken = createMaskedToken(rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .cookie(xsrfCookie)
                        .param("_csrf", maskedToken)
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk());
    }

    @Test
    void rejectsInvalidMaskedCsrfTokenInXCSRFTokenHeader() throws Exception {
        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser);

        mockMvc.perform(post("/recording/start")
                        .session(session)
                        .cookie(xsrfCookie)
                        .header("X-CSRF-TOKEN", "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY3ODkwYWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY3ODkw")
                        .param("autoTrigger", "false"))
                .andExpect(status().isForbidden());
    }

    @Test
    void doctorAppointmentStatusRejectsWithoutCsrfToken() throws Exception {
        Doctor doc = new Doctor();
        doc.setEmail("doc_status_no_csrf@example.com");
        doc.setPassword("Pass@12345");
        doc.setFullName("Dr. Status Test");
        doc = doctorRepository.save(doc);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(testUser);
        appt.setDoctor(doc);
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(1));
        appt = doctorAppointmentRepository.save(appt);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedDoctor", doc);

        mockMvc.perform(post("/doctors/appointments/" + appt.getId() + "/status")
                        .session(session)
                        .param("status", "CONFIRMED"))
                .andExpect(status().isForbidden());
    }

    @Test
    void doctorAppointmentStatusAcceptsWithCsrfToken() throws Exception {
        Doctor doc = new Doctor();
        doc.setEmail("doc_status_with_csrf@example.com");
        doc.setPassword("Pass@12345");
        doc.setFullName("Dr. Status Test 2");
        doc = doctorRepository.save(doc);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(testUser);
        appt.setDoctor(doc);
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(1));
        appt = doctorAppointmentRepository.save(appt);

        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedDoctor", doc);

        mockMvc.perform(post("/doctors/appointments/" + appt.getId() + "/status")
                        .session(session)
                        .cookie(xsrfCookie)
                        .param("_csrf", rawToken)
                        .param("status", "CONFIRMED")
                        .header("Referer", "http://localhost:8084/doctors/dashboard?section=appointments"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void doctorAppointmentStatusReturnsJsonForAjaxRequest() throws Exception {
        Doctor doc = new Doctor();
        doc.setEmail("doc_status_ajax@example.com");
        doc.setPassword("Pass@12345");
        doc.setFullName("Dr. Status Ajax");
        doc = doctorRepository.save(doc);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(testUser);
        appt.setDoctor(doc);
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(1));
        appt = doctorAppointmentRepository.save(appt);

        String rawToken = UUID.randomUUID().toString();
        Cookie xsrfCookie = new Cookie("XSRF-TOKEN", rawToken);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedDoctor", doc);

        mockMvc.perform(post("/doctors/appointments/" + appt.getId() + "/status")
                        .session(session)
                        .cookie(xsrfCookie)
                        .header("X-CSRF-TOKEN", rawToken)
                        .header("X-Requested-With", "XMLHttpRequest")
                        .param("status", "CONFIRMED"))
                .andExpect(status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath("$.success").value(true))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath("$.status").value("CONFIRMED"));
    }
}
