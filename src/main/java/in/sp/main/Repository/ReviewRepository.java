package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Review;
import in.sp.main.Entities.Stylist;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findBySalonId(Long salonId);
    List<Review> findByUserId(Long userId);
    List<Review> findByStylistId(Long stylistId);
    List<Review> findByStylist(Stylist stylist);

    List<Review> findTop20ByOrderByCreatedAtDesc();
}
