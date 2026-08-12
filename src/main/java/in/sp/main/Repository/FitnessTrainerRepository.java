package in.sp.main.Repository;

import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface FitnessTrainerRepository extends JpaRepository<FitnessTrainer, Long> {
    Optional<FitnessTrainer> findByEmail(String email);
    List<FitnessTrainer> findByVerificationStatus(VerificationStatus status);
    List<FitnessTrainer> findByVerificationStatusAndSuspended(VerificationStatus status, boolean suspended);
    List<FitnessTrainer> findByPartnerProfileStatus(PartnerProfileStatus status);
    List<FitnessTrainer> findByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    List<FitnessTrainer> findByPartnerProfileStatusIsNull();
}
