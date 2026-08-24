package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import in.sp.main.Entities.LoyaltyCustomer;
import java.util.List;

@Repository
public interface LoyaltyCustomerRepository extends JpaRepository<LoyaltyCustomer, Long> {
    List<LoyaltyCustomer> findBySalonIdOrderByTotalPointsEarnedDesc(Long salonId);
}
