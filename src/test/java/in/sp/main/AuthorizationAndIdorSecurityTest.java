package in.sp.main;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.User;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:idor_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
        "google.maps.apiKey=unused"
})
class AuthorizationAndIdorSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    private User userA;
    private User userB;
    private Admin admin;

    @BeforeEach
    void setup() {
        userRepository.deleteAll();
        adminRepository.deleteAll();

        User u1 = new User();
        u1.setFullName("User Alice");
        u1.setEmail("alice@test.com");
        u1.setPassword("Pass@1234");
        userA = userRepository.save(u1);

        User u2 = new User();
        u2.setFullName("User Bob");
        u2.setEmail("bob@test.com");
        u2.setPassword("Pass@1234");
        userB = userRepository.save(u2);

        Admin adm = new Admin("Super Admin", "admin@test.com", "Admin@1234");
        admin = adminRepository.save(adm);
    }

    @Test
    void unauthenticatedUserCannotAccessUserProfileById() throws Exception {
        mockMvc.perform(get("/users/" + userA.getId()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login"));
    }

    @Test
    void userCanAccessOwnProfileById() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/users/" + userA.getId()).session(session))
                .andExpect(status().isOk());
    }

    @Test
    void userCannotAccessOtherUserProfileById() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        // User A trying to view User B -> Redirected to User A's own profile
        mockMvc.perform(get("/users/" + userB.getId()).session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/users/" + userA.getId()));
    }

    @Test
    void adminCanAccessAnyUserProfileById() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", admin);

        mockMvc.perform(get("/users/" + userA.getId()).session(session))
                .andExpect(status().isOk());
    }

    @Test
    void nonAdminCannotAccessUserList() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/users/list").session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));
    }

    @Test
    void unauthenticatedCannotDeleteUser() throws Exception {
        mockMvc.perform(post("/users/delete/" + userA.getId()).with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void userCannotDeleteAnotherUser() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(post("/users/delete/" + userB.getId()).session(session).with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/users/" + userA.getId()));
    }

    @Test
    void nonAdminCannotAccessSafeRoutesList() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/admin/saferoutes/list").session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));
    }

    @Test
    void nonAdminCannotAccessVideoManagement() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/video/videoManagement").session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/loginAdmin"));
    }
}
