package in.sp.main.Repository;
 
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import in.sp.main.Entities.Offer;
import in.sp.main.Entities.OfferBooking;
 
@Repository
public interface OfferRepository extends JpaRepository<Offer, Integer> {
	List<Offer> findBySalonId(Long salonId);
    List<Offer> findByActiveTrue(); // Only active offers
    List<Offer> findByActiveTrueAndEndDateGreaterThanEqual(LocalDate date);
	Optional<Offer> findById(Long id);
	
	List<Offer> findByUser_FullName(String fullName);

	   
}