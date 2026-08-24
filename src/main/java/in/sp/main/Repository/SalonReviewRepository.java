package in.sp.main.Repository;
 
import in.sp.main.Entities.Review;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonReview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
 
public interface SalonReviewRepository extends JpaRepository<SalonReview, Long> {
    List<SalonReview> findBySalonIdOrderByCreatedAtDesc(Long salonId);
    List<SalonReview> findBySalonId(Long salonId);
    
// ✅ Optional: Get reviews that already have replies
    List<SalonReview> findBySalonIdAndReplyIsNotNull(Long salonId);
 
    // ✅ Optional: Get reviews that don't have replies yet
    List<SalonReview> findBySalonIdAndReplyIsNull(Long salonId);
    List<SalonReview> findBySalonId(int salonId);
    
    List<SalonReview> findBySalon(Salon salon);

    boolean existsByUserIdAndSalon_Id(Long userId, Long salonId);
    
    List<SalonReview> findTop20ByOrderByCreatedAtDesc();
}
 
 