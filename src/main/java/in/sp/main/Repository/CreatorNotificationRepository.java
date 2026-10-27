package in.sp.main.Repository;

import in.sp.main.Entities.CreatorNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreatorNotificationRepository extends JpaRepository<CreatorNotification, Long> {
    List<CreatorNotification> findByUser_IdOrderByCreatedAtDesc(Long userId);
    int countByUser_IdAndIsReadFalse(Long userId);
    boolean existsByUser_IdAndSender_IdAndType(Long userId, Long senderId, String type);
    boolean existsByUser_IdAndSender_IdAndTypeAndVideoId(Long userId, Long senderId, String type, Long videoId);
}
