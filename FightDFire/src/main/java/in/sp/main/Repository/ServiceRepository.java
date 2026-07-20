package in.sp.main.Repository;
 
import java.util.List;
 
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
 
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.ServiceCategory;
 
 
@Repository
public interface ServiceRepository extends JpaRepository<Service1, Long> {
    List<Service1> findBySalonId(Long salonId);
    List<Service1> findByStylistId(Long stylistId);
    List<Service1> findByPriceBetween(Double min, Double max);
    List<Service1> findBySalon(Salon salon);
 
    List<Service1> findBySalonAndCategory(Salon salon, ServiceCategory category);
    // Correct way: add a custom query to fetch all services with salon details
    @Query("SELECT s FROM Service1 s JOIN FETCH s.salon")
    List<Service1> getAllServicesWithSalonDetails();
	List<Service1> findBySalonIdAndCategory(Long salonId, ServiceCategory category);
	void deleteByIdAndSalonId(Long id, Long id2);

 
}