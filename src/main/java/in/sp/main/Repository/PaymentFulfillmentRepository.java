package in.sp.main.Repository;

import in.sp.main.Entities.PaymentFulfillment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PaymentFulfillmentRepository extends JpaRepository<PaymentFulfillment, Long> {

    Optional<PaymentFulfillment> findByRazorpayPaymentId(String razorpayPaymentId);

    Optional<PaymentFulfillment> findByRazorpayOrderId(String razorpayOrderId);
}
