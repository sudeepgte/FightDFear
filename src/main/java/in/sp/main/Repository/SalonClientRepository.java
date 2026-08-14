package in.sp.main.Repository;

import in.sp.main.Entities.SalonClient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SalonClientRepository extends JpaRepository<SalonClient, Long> {
    
    List<SalonClient> findBySalonId(Long salonId);
    
    Optional<SalonClient> findBySalonIdAndUserId(Long salonId, Long userId);
    
    Optional<SalonClient> findBySalonIdAndUserPhoneNumber(Long salonId, String phoneNumber);
}
