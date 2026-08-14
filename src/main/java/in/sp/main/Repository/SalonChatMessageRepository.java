package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.SalonChatMessage;

@Repository
public interface SalonChatMessageRepository extends JpaRepository<SalonChatMessage, Long> {
    List<SalonChatMessage> findBySalonIdOrderByTimestampAsc(Long salonId);
    List<SalonChatMessage> findBySalonIdAndUserIdOrderByTimestampAsc(Long salonId, Long userId);
    long countBySalonIdAndIsReadFalseAndSenderRoleNot(Long salonId, String senderRole);
}
