package in.sp.main.Repository;
 
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import in.sp.main.Entities.OfferBooking;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.User;
 
public interface OfferBookingRepository extends JpaRepository<OfferBooking, Long> {
    List<OfferBooking> findByCustomerEmail(String email);
 
	List<OfferBooking> findBySalonId(Long salonId);
 
	List<OfferBooking> findByCustomerName(String customerName);

	List<OfferBooking> findByUser(User user);

	List<OfferBooking> findBySalon(Salon loggedSalon);
}