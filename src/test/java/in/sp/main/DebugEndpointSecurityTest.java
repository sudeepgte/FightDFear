package in.sp.main;

import in.sp.main.Controller.DebugController;
import in.sp.main.Entities.Admin;
import in.sp.main.Entities.User;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:debug_endpoint_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
        "google.maps.apiKey=unused"
})
public class DebugEndpointSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        adminRepository.deleteAll();
    }

    @Test
    void debugPhotos_AnonymousAccessBlocked() throws Exception {
        mockMvc.perform(get("/debug-photos"))
                .andExpect(result -> {
                    int s = result.getResponse().getStatus();
                    assertTrue(s == 302 || s == 401 || s == 403,
                            "Anonymous request to /debug-photos must be blocked (got " + s + ")");
                });
    }

    @Test
    void debugPhotos_NormalUserAccessForbidden() throws Exception {
        User user = new User();
        user.setEmail("user@fightdfear.com");
        user.setFullName("Standard User");
        user = userRepository.save(user);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", user);

        mockMvc.perform(get("/debug-photos").session(session))
                .andExpect(status().isForbidden());
    }

    @Test
    void debugPhotos_AdminAccessAllowedInTestProfile() throws Exception {
        User user = new User();
        user.setEmail("target@fightdfear.com");
        user.setFullName("Target User");
        user.setProfilePhoto("uploads/target.jpg");
        userRepository.save(user);

        Admin admin = new Admin("Admin", "admin@test.com", "hash", "ADMIN");
        admin = adminRepository.save(admin);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", admin);

        String response = mockMvc.perform(get("/debug-photos").session(session))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        assertTrue(response.contains("Target User"), "Admin should be able to view debug output in dev/test");
        assertTrue(response.contains("uploads/target.jpg"));
    }

    @Test
    void debugController_NotLoadedInProduction() {
        new ApplicationContextRunner()
                .withUserConfiguration(DebugController.class)
                .withPropertyValues("spring.profiles.active=prod")
                .run(context -> {
                    assertFalse(context.containsBean("debugController"),
                            "DebugController must NOT be loaded under prod profile");
                });
    }
}
