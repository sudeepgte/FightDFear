package in.sp.main.Repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorPaymentEvent;

public interface DoctorPaymentEventRepository extends JpaRepository<DoctorPaymentEvent, Long> {
    Optional<DoctorPaymentEvent> findByRazorpayEventId(String razorpayEventId);
    Optional<DoctorPaymentEvent> findFirstByRazorpayPaymentIdOrderByIdDesc(String razorpayPaymentId);
}
