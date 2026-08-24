package in.sp.main;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:webhook_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
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
        "razorpay.webhook.secret=test-webhook-secret",
        "google.maps.apiKey=unused"
})
class PaymentWebhookSignatureTest {

    @Autowired
    private MockMvc mockMvc;

    private static final String SAMPLE_BODY = """
            {"event":"payment.captured","id":"evt_test_1","payload":{"payment":{"entity":{"id":"pay_x","order_id":"order_x"}}}}
            """;

    @Test
    void rejectsMissingSignatureWhenSecretConfigured() throws Exception {
        mockMvc.perform(post("/payment/webhook/razorpay")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(SAMPLE_BODY))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Missing webhook signature"));
    }

    @Test
    void rejectsInvalidSignatureWhenSecretConfigured() throws Exception {
        mockMvc.perform(post("/payment/webhook/razorpay")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("X-Razorpay-Signature", "not-a-valid-signature")
                        .content(SAMPLE_BODY))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Invalid webhook signature"));
    }
}
