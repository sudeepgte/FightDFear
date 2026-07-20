package in.sp.main.Repository;
 
import java.time.LocalDateTime;

import java.util.List;
 
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;
 
import in.sp.main.Entities.*;
 
@Repository

public interface Booking1Repository extends JpaRepository<Booking1, Long> {

	  List<Booking1> findByUser(User user);
	    List<Booking1> findBySalon(Salon salon);
	 
 
	

}

 