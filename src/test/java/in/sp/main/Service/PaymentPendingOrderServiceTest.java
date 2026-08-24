package in.sp.main.Service;

import in.sp.main.Entities.PaymentPendingOrder;
import in.sp.main.Entities.User;
import in.sp.main.Repository.PaymentFulfillmentRepository;
import in.sp.main.Repository.PaymentPendingOrderRepository;
import in.sp.main.Repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:payment_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "app.payments.mock-enabled=true"
})
class PaymentPendingOrderServiceTest {

    @Autowired
    private PaymentPendingOrderService paymentPendingOrderService;

    @Autowired
    private PaymentPendingOrderRepository pendingOrderRepository;

    @Autowired
    private PaymentFulfillmentRepository fulfillmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    @Transactional
    void savePendingAndRecordIdempotentFulfillment() {
        User user = new User();
        user.setFullName("Pay Test User");
        user.setEmail("paytest-" + System.nanoTime() + "@example.com");
        user.setPassword("hash");
        user = userRepository.save(user);

        String orderId = "order_test_" + System.nanoTime();
        paymentPendingOrderService.savePendingOrder(
                orderId, user, 50000, "FITNESS", 1L, null, null, null);

        Optional<PaymentPendingOrder> pending =
                paymentPendingOrderService.findPendingForUser(orderId, user.getId());
        assertTrue(pending.isPresent());
        assertEquals(50000, pending.get().getAmountPaise());

        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("bookingId", 99);
        paymentPendingOrderService.markFulfilled(pending.get(), "pay_test_123");
        paymentPendingOrderService.recordFulfillment(
                "pay_test_123", orderId, user.getId(), "FITNESS", 1L, 50000, response);

        Optional<Map<String, Object>> cached =
                paymentPendingOrderService.findCachedFulfillmentResponse("pay_test_123", orderId);
        assertTrue(cached.isPresent());
        assertEquals("success", cached.get().get("status"));

        // Duplicate record should not create a second fulfillment row
        paymentPendingOrderService.recordFulfillment(
                "pay_test_123", orderId, user.getId(), "FITNESS", 1L, 50000, response);
        assertEquals(1, fulfillmentRepository.count());
        assertEquals(1, pendingOrderRepository.count());
    }
}
