package in.sp.main.Repository;

import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FitnessTrainerRepository extends JpaRepository<FitnessTrainer, Long> {
    Optional<FitnessTrainer> findByEmail(String email);
    List<FitnessTrainer> findByVerificationStatus(VerificationStatus status);
    List<FitnessTrainer> findByVerificationStatusAndSuspended(VerificationStatus status, boolean suspended);
}
