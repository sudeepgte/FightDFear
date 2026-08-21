package in.sp.main.Repository;

import in.sp.main.Entities.FitnessProgressLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FitnessProgressLogRepository extends JpaRepository<FitnessProgressLog, Long> {
    List<FitnessProgressLog> findByUser_IdOrderByLogDateDesc(Long userId);
    List<FitnessProgressLog> findByTrainer_IdOrderByLogDateDesc(Long trainerId);
    List<FitnessProgressLog> findByTrainer_IdAndUser_IdOrderByLogDateDesc(Long trainerId, Long userId);
    Optional<FitnessProgressLog> findTopByUser_IdOrderByLogDateDesc(Long userId);
}
