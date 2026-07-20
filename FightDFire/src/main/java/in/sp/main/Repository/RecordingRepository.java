package in.sp.main.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.RecordingEntity;

public interface RecordingRepository extends JpaRepository<RecordingEntity, Long> {
    RecordingEntity findTopByOrderByStartTimeDesc();
}
