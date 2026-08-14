package in.sp.main.Repository;

import in.sp.main.Entities.PaymentWebhookEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PaymentWebhookEventRepository extends JpaRepository<PaymentWebhookEvent, Long> {

    Optional<PaymentWebhookEvent> findByRazorpayEventId(String razorpayEventId);
}
