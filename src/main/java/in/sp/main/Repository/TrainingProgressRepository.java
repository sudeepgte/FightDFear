package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.TrainingProgress;

@Repository
public interface TrainingProgressRepository extends JpaRepository<TrainingProgress, Long> {
}
