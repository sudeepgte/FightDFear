package in.sp.main.Repository;

import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.TrainingSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TrainingSessionRepository extends JpaRepository<TrainingSession, Long> {
    List<TrainingSession> findByBatch(MartialArtsBatch batch);
}
