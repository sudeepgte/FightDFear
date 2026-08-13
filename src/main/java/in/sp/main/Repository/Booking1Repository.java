package in.sp.main.Repository;
 
import java.util.List;
 
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
 
import in.sp.main.Entities.*;
 
@Repository
public interface Booking1Repository extends JpaRepository<Booking1, Long> {

    List<Booking1> findByUser(User user);

    /** Prefer ID-based lookup — session User entities are detached. */
    List<Booking1> findByUser_IdOrderByIdDesc(Long userId);

    List<Booking1> findBySalon(Salon salon);
}
