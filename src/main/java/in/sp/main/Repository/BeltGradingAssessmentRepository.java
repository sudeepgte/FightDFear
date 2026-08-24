package in.sp.main.Repository;

import in.sp.main.Entities.BeltGradingAssessment;
import in.sp.main.Entities.GradingStatus;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BeltGradingAssessmentRepository extends JpaRepository<BeltGradingAssessment, Long> {

    List<BeltGradingAssessment> findByUserOrderByAssessmentDateDesc(User user);

    List<BeltGradingAssessment> findByUserIdOrderByCreatedAtDesc(Long userId);

    List<BeltGradingAssessment> findByCenterOrderByCreatedAtDesc(MartialArtsCenter center);

    List<BeltGradingAssessment> findByCenter_IdOrderByCreatedAtDesc(Long centerId);

    List<BeltGradingAssessment> findByUserIdAndStatus(Long userId, GradingStatus status);

    Optional<BeltGradingAssessment> findFirstByUserIdAndPassedTrueOrderByPromotionDateDesc(Long userId);

    Optional<BeltGradingAssessment> findFirstByUserIdOrderByCreatedAtDesc(Long userId);
}
