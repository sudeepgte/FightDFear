package in.sp.main;

import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.DoctorPaymentService;
import in.sp.main.Service.PaymentPendingOrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:payment_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=rzp_test_mockkey",
        "razorpay.key.secret=mocksecret1234567890",
        "razorpay.webhook.secret=test-webhook-secret",
        "app.payments.mock-enabled=false",
        "google.maps.apiKey=unused",
        "spring.mvc.view.prefix=/WEB-INF/views/",
        "spring.mvc.view.suffix=.jsp"
})
class PaymentSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PaymentPendingOrderService paymentPendingOrderService;

    @Autowired
    private DoctorPaymentService doctorPaymentService;

    private User testUser1;
    private User testUser2;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();

        testUser1 = new User();
        testUser1.setEmail("payuser1@example.com");
        testUser1.setPassword("Pass@12345");
        testUser1.setFullName("Payment User One");
        testUser1.setPhoneNumber("9876543210");
        testUser1 = userRepository.save(testUser1);

        testUser2 = new User();
        testUser2.setEmail("payuser2@example.com");
        testUser2.setPassword("Pass@12345");
        testUser2.setFullName("Payment User Two");
        testUser2.setPhoneNumber("9876543211");
        testUser2 = userRepository.save(testUser2);
    }

    @Test
    void rejectsUnauthenticatedCreateOrder() throws Exception {
        mockMvc.perform(post("/payment/create-order")
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"amount\":500,\"type\":\"MARTIAL_ARTS\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void rejectsUnauthenticatedVerifyPayment() throws Exception {
        mockMvc.perform(post("/payment/verify")
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"razorpay_order_id\":\"order_123\",\"razorpay_payment_id\":\"pay_123\",\"razorpay_signature\":\"sig_123\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void rejectsMockSignatureWhenMockModeDisabled() throws Exception {
        assertFalse(doctorPaymentService.mockPaymentsEnabled(), "Mock mode must be disabled in this test configuration");

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser1);

        // Pre-save pending order for testUser1
        paymentPendingOrderService.savePendingOrder(
                "order_mock_test123",
                testUser1,
                50000,
                "MARTIAL_ARTS",
                null,
                null,
                null,
                "Testing mock bypass"
        );

        // Attempting to verify with a mock_ signature when mock mode is disabled MUST fail signature verification
        mockMvc.perform(post("/payment/verify")
                        .session(session)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"razorpay_order_id\":\"order_mock_test123\",\"razorpay_payment_id\":\"mock_pay_123\",\"razorpay_signature\":\"mock_sig\",\"type\":\"MARTIAL_ARTS\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Invalid payment signature."));
    }

    @Test
    void rejectsCrossUserOrderVerification() throws Exception {
        // User 1 creates an order
        paymentPendingOrderService.savePendingOrder(
                "order_user1_real",
                testUser1,
                20000,
                "MARTIAL_ARTS",
                null,
                null,
                null,
                "User 1 batch"
        );

        // User 2 logs in and attempts to verify User 1's order
        MockHttpSession sessionUser2 = new MockHttpSession();
        sessionUser2.setAttribute("user", testUser2);

        mockMvc.perform(post("/payment/verify")
                        .session(sessionUser2)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"razorpay_order_id\":\"order_user1_real\",\"razorpay_payment_id\":\"pay_test_999\",\"razorpay_signature\":\"sig_test_999\",\"type\":\"MARTIAL_ARTS\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Unknown or expired payment order. Create a new order and try again."));
    }

    @Test
    void rejectsUnknownOrExpiredOrder() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser1);

        mockMvc.perform(post("/payment/verify")
                        .session(session)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"razorpay_order_id\":\"order_non_existent\",\"razorpay_payment_id\":\"pay_123\",\"razorpay_signature\":\"sig_123\",\"type\":\"MARTIAL_ARTS\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Unknown or expired payment order. Create a new order and try again."));
    }

    @Test
    void recordingControllerSessionIsolation() throws Exception {
        MockHttpSession sessionA = new MockHttpSession();
        sessionA.setAttribute("user", testUser1);

        MockHttpSession sessionB = new MockHttpSession();
        sessionB.setAttribute("user", testUser2);

        // User A starts recording
        mockMvc.perform(post("/recording/start")
                        .session(sessionA)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .param("autoTrigger", "false"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.Recording").value("Started"));

        // User A status shows Active
        mockMvc.perform(get("/recording/status").session(sessionA))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$['Recording Active']").value("Yes"));

        // User B status shows No active recording (isolated!)
        mockMvc.perform(get("/recording/status").session(sessionB))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$['Recording Active']").value("No"));

        // User A stops recording
        mockMvc.perform(post("/recording/stop")
                        .session(sessionA)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.Recording").value("Stopped"));

        // User A status now No
        mockMvc.perform(get("/recording/status").session(sessionA))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$['Recording Active']").value("No"));
    }

    @Test
    void doctorPaymentOrderRequiresTargetIdAndAppointmentTime() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", testUser1);

        // Missing targetId
        mockMvc.perform(post("/payment/create-order")
                        .session(session)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"DOCTOR\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Doctor id is required"));

        // Doctor not found
        mockMvc.perform(post("/payment/create-order")
                        .session(session)
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"DOCTOR\",\"targetId\":999999,\"appointmentTime\":\"2026-10-10 10:00:00\"}"))
                .andExpect(status().isBadRequest());
    }
}
