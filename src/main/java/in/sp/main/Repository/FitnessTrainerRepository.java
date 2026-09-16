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
    long countByVerificationStatus(VerificationStatus status);
    List<FitnessTrainer> findByVerificationStatusAndSuspended(VerificationStatus status, boolean suspended);
    List<FitnessTrainer> findByPartnerProfileStatus(PartnerProfileStatus status);
    List<FitnessTrainer> findByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    long countByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    List<FitnessTrainer> findByPartnerProfileStatusIsNull();

    @org.springframework.data.jpa.repository.Lock(jakarta.persistence.LockModeType.PESSIMISTIC_WRITE)
    @org.springframework.data.jpa.repository.Query("SELECT t FROM FitnessTrainer t WHERE t.id = :id")
    Optional<FitnessTrainer> findByIdForUpdate(@org.springframework.data.repository.query.Param("id") Long id);
}
