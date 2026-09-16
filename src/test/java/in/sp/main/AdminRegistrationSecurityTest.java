package in.sp.main;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.User;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.PasswordService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

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
        "spring.datasource.url=jdbc:h2:mem:admin_reg_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
public class AdminRegistrationSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordService passwordService;

    @BeforeEach
    void setUp() {
        adminRepository.deleteAll();
        userRepository.deleteAll();
    }

    @Test
    void test1_AnonymousGetRegisterAdmin_RedirectsToLogin() throws Exception {
        long countBefore = adminRepository.count();
        mockMvc.perform(get("/admin/registerAdmin"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));
        long countAfter = adminRepository.count();
        assertEquals(countBefore, countAfter, "Admin DB count must remain unchanged");
    }

    @Test
    void test2_AnonymousPostRegisterAdmin_RedirectsToLoginAndNoDbInsertion() throws Exception {
        long countBefore = adminRepository.count();
        mockMvc.perform(post("/admin/registerAdmin")
                        .with(csrf())
                        .param("name", "Rogue Admin")
                        .param("email", "rogue@fightdfear.com")
                        .param("password", "P@ssword123")
                        .param("confirmPassword", "P@ssword123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));

        long countAfter = adminRepository.count();
        assertEquals(countBefore, countAfter, "Admin DB count must remain identical before and after anonymous POST");
        assertTrue(adminRepository.findByEmail("rogue@fightdfear.com").isEmpty());
    }

    @Test
    void test3_AuthenticatedNormalUserPost_ForbiddenAndNoDbInsertion() throws Exception {
        User user = new User();
        user.setEmail("member@test.com");
        user.setFullName("Normal Member");
        user.setPassword("hashedpass");
        user = userRepository.save(user);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", user);

        long countBefore = adminRepository.count();

        mockMvc.perform(get("/admin/registerAdmin").session(session))
                .andExpect(status().isForbidden());

        mockMvc.perform(post("/admin/registerAdmin")
                        .session(session)
                        .with(csrf())
                        .param("name", "Escalated Admin")
                        .param("email", "escalated@fightdfear.com")
                        .param("password", "P@ssword123")
                        .param("confirmPassword", "P@ssword123"))
                .andExpect(status().isForbidden());

        long countAfter = adminRepository.count();
        assertEquals(countBefore, countAfter, "Admin DB count must remain identical before and after normal user attempt");
        assertTrue(adminRepository.findByEmail("escalated@fightdfear.com").isEmpty());
    }

    @Test
    void test4_AuthenticatedNormalAdminPost_ForbiddenAndNoDbInsertion() throws Exception {
        Admin standardAdmin = new Admin("Standard Admin", "staff@fightdfear.com", "hash", "ADMIN");
        standardAdmin = adminRepository.save(standardAdmin);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", standardAdmin);

        long countBefore = adminRepository.count();
        assertEquals(1, countBefore);

        mockMvc.perform(get("/admin/registerAdmin").session(session))
                .andExpect(status().isForbidden());

        mockMvc.perform(post("/admin/registerAdmin")
                        .session(session)
                        .with(csrf())
                        .param("name", "Peer Admin")
                        .param("email", "peer@fightdfear.com")
                        .param("password", "P@ssword123")
                        .param("confirmPassword", "P@ssword123"))
                .andExpect(status().isForbidden());

        long countAfter = adminRepository.count();
        assertEquals(countBefore, countAfter, "Admin DB count must remain identical before and after standard admin attempt");
        assertTrue(adminRepository.findByEmail("peer@fightdfear.com").isEmpty());
    }

    @Test
    void test5_PostWithoutCsrf_ForbiddenByCsrfProtection() throws Exception {
        Admin superAdmin = new Admin("System Root", "root@fightdfear.com", "hash", "SUPER_ADMIN");
        superAdmin = adminRepository.save(superAdmin);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", superAdmin);

        long countBefore = adminRepository.count();
        assertEquals(1, countBefore);

        // Super Admin submits POST WITHOUT CSRF token -> blocked by CSRF protection
        mockMvc.perform(post("/admin/registerAdmin")
                        .session(session)
                        .param("name", "New Auditor")
                        .param("email", "nocsrf@fightdfear.com")
                        .param("password", "Auditor@123456")
                        .param("confirmPassword", "Auditor@123456"))
                .andExpect(status().isForbidden());

        long countAfter = adminRepository.count();
        assertEquals(countBefore, countAfter, "Admin DB count must remain identical when CSRF token is missing");
        assertTrue(adminRepository.findByEmail("nocsrf@fightdfear.com").isEmpty());
    }

    @Test
    void test6_AuthorizedSuperAdminGetAndPost_SuccessWithAdminRoleAndBcrypt() throws Exception {
        Admin superAdmin = new Admin("System Root", "root@fightdfear.com", "hash", "SUPER_ADMIN");
        superAdmin = adminRepository.save(superAdmin);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", superAdmin);

        // GET register page allowed for Super Admin
        mockMvc.perform(get("/admin/registerAdmin").session(session))
                .andExpect(status().isOk());

        long countBefore = adminRepository.count();
        assertEquals(1, countBefore);

        // POST with valid CSRF creates new admin
        mockMvc.perform(post("/admin/registerAdmin")
                        .session(session)
                        .with(csrf())
                        .param("name", "New Auditor")
                        .param("email", "auditor@fightdfear.com")
                        .param("password", "Auditor@123456")
                        .param("confirmPassword", "Auditor@123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));

        long countAfter = adminRepository.count();
        assertEquals(countBefore + 1, countAfter, "Admin DB count must increase by exactly 1 for Super Admin registration");

        var createdOpt = adminRepository.findByEmail("auditor@fightdfear.com");
        assertTrue(createdOpt.isPresent(), "Super Admin must be able to create new admins");
        Admin created = createdOpt.get();
        assertEquals("New Auditor", created.getName());
        assertEquals("auditor@fightdfear.com", created.getEmail());
        assertEquals("ADMIN", created.getRole(), "Created admin must always receive role ADMIN");
        assertFalse(created.isSuperAdmin(), "Newly registered admin must never be a Super Admin");
        assertTrue(passwordService.isBcryptEncoded(created.getPassword()), "Password must be BCrypt encoded");
        assertTrue(passwordService.matches("Auditor@123456", created.getPassword()), "Password must match raw input via BCrypt");
    }
}
