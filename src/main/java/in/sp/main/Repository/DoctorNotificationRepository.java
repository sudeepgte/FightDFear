package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorNotification;

public interface DoctorNotificationRepository extends JpaRepository<DoctorNotification, Long> {
    List<DoctorNotification> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);

    long countByDoctorIdAndReadFlagFalse(Long doctorId);
}
