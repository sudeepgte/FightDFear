package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.MartialArtsCenter;

@Repository
public interface MartialArtsCenterRepository extends JpaRepository<MartialArtsCenter, Long> {


	@Query("SELECT c FROM MartialArtsCenter c " +
		       "LEFT JOIN FETCH c.availableDays " +
		       "LEFT JOIN FETCH c.martialArtsTypes " +
		       "WHERE c.id = :id")
		Optional<MartialArtsCenter> findByIdWithDetails(@Param("id") Long id);

    MartialArtsCenter findByPhoneNumber(String contactDetails);
    List<MartialArtsCenter> findByLocation(String location);
    @Query("SELECT c FROM MartialArtsCenter c LEFT JOIN FETCH c.martialArtsTypes WHERE c.location = :location")
    List<MartialArtsCenter> findByLocationWithTypes(@Param("location") String location);

    Optional<MartialArtsCenter> findByEmail(String email);
    List<MartialArtsCenter> findByApproved(boolean approved);

}

