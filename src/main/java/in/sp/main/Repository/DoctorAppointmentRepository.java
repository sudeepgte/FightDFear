package in.sp.main.Repository;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.User;

public interface DoctorAppointmentRepository extends JpaRepository<DoctorAppointment, Long> {
    List<DoctorAppointment> findByUserOrderByAppointmentTimeDesc(User user);
    List<DoctorAppointment> findByDoctorOrderByAppointmentTimeDesc(Doctor doctor);
    java.util.Optional<DoctorAppointment> findByRazorpayPaymentId(String razorpayPaymentId);
    java.util.Optional<DoctorAppointment> findByRazorpayOrderId(String razorpayOrderId);

    List<DoctorAppointment> findByStatusInAndAppointmentTimeBetween(
            Collection<DoctorAppointmentStatus> statuses, LocalDateTime from, LocalDateTime to);
}
