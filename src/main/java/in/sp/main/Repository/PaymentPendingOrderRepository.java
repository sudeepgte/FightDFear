package in.sp.main.Repository;

import in.sp.main.Entities.PaymentPendingOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.Optional;

public interface PaymentPendingOrderRepository extends JpaRepository<PaymentPendingOrder, Long> {

    Optional<PaymentPendingOrder> findByRazorpayOrderId(String razorpayOrderId);

    @Modifying
    @Query("UPDATE PaymentPendingOrder p SET p.status = 'EXPIRED' WHERE p.status = 'PENDING' AND p.expiresAt < :now")
    int expireOlderThan(@Param("now") LocalDateTime now);
}
