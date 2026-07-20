package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.Salon;

@Repository
public interface SalonRepository extends JpaRepository<Salon, Long> {
    List<Salon> findByCity(String city);
    List<Salon> findByIsEcoFriendlyTrue();
   // List<Salon> findByAverageRatingGreaterThanEqual(Double rating);
    Optional<Salon> findByUsername(String username);
	List<Salon> findByAddressContainingIgnoreCase(String location);
	List<Salon> findByNameContainingIgnoreCase(String name);
	boolean existsByEmail(String email);
	Salon findByEmail(String email);
	void deleteSalonById(Long id);
	
	 @Modifying
	    @Transactional
	    @Query("DELETE FROM Service1 s WHERE s.id = :serviceId AND s.salon.id = :salonId")
	    void deleteByIdAndSalonId(@Param("serviceId") Long serviceId,
	                              @Param("salonId") Long salonId);

    List<Salon> findByApproved(boolean approved);
	}

