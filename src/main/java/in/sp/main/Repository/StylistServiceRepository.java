package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Service1;
import in.sp.main.Entities.StylistService;
import java.util.List;

public interface StylistServiceRepository extends JpaRepository<StylistService, Long> {
    List<StylistService> findByStylistId(Long stylistId);

	List<StylistService> findBySalonId(Long salonId);
}
