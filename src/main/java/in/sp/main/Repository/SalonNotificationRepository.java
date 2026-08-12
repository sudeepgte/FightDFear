package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.SalonNotification;

@Repository
public interface SalonNotificationRepository extends JpaRepository<SalonNotification, Long> {
    List<SalonNotification> findBySalonIdOrderByTimestampDesc(Long salonId);
    List<SalonNotification> findBySalonIdAndIsReadFalseOrderByTimestampDesc(Long salonId);
}
