package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import in.sp.main.Entities.LoyaltySettings;
import java.util.Optional;

@Repository
public interface LoyaltySettingsRepository extends JpaRepository<LoyaltySettings, Long> {
    Optional<LoyaltySettings> findBySalonId(Long salonId);
}
