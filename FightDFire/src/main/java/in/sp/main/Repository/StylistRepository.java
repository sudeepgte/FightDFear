package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Stylist;

@Repository
public interface StylistRepository extends JpaRepository<Stylist, Long> {
    List<Stylist> findBySalonId(Long salonId);
    List<Stylist> findBySpecialization(String specialization);
    List<Stylist> findByAvailableTrue();
	Optional<Stylist> findByEmail(String email);
	List<Stylist> findByIsIndependent(boolean b);
    List<Stylist> findByApproved(boolean approved);
}
