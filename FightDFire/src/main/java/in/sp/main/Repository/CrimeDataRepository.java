package in.sp.main.Repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.CrimeData;

@Repository
public interface CrimeDataRepository extends JpaRepository<CrimeData, Long> {

    @Query(value = "SELECT * FROM crime_data ORDER BY (ABS(latitude - ?1) + ABS(longitude - ?2)) ASC LIMIT 1", nativeQuery = true)
    Optional<CrimeData> findNearestLocation(double latitude, double longitude);
}

