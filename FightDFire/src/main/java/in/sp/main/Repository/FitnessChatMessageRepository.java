package in.sp.main.Repository;

import in.sp.main.Entities.FitnessChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FitnessChatMessageRepository extends JpaRepository<FitnessChatMessage, Long> {
    List<FitnessChatMessage> findByUser_IdAndTrainer_IdOrderByTimestampAsc(Long userId, Long trainerId);
}
