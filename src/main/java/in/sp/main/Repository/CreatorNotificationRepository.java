package in.sp.main.Repository;

import in.sp.main.Entities.CreatorNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreatorNotificationRepository extends JpaRepository<CreatorNotification, Long> {
    List<CreatorNotification> findByUser_IdOrderByCreatedAtDesc(Long userId);
    int countByUser_IdAndIsReadFalse(Long userId);
}
