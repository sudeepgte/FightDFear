package in.sp.main.Repository;
 
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
 
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Treatment;
 
public interface TreatmentRepository extends JpaRepository<Treatment, Long> {
    List<Treatment> findBySalonId(Long salonId);
 
	List<Treatment> findBySalon(Salon salon);
}