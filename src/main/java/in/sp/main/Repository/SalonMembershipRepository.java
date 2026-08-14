package in.sp.main.Repository;

import in.sp.main.Entities.SalonMembership;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SalonMembershipRepository extends JpaRepository<SalonMembership, Long> {
    List<SalonMembership> findBySalonId(Long salonId);
}
