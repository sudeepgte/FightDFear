package in.sp.main.Repository;

import in.sp.main.Entities.SalonPromotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SalonPromotionRepository extends JpaRepository<SalonPromotion, Long> {
    List<SalonPromotion> findBySalonId(Long salonId);
}
