package in.sp.main.Repository;

import in.sp.main.Entities.FitnessReview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FitnessReviewRepository extends JpaRepository<FitnessReview, Long> {
    List<FitnessReview> findByBooking_Trainer_Id(Long trainerId);
    boolean existsByBooking_Id(Long bookingId);
}
