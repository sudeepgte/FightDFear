package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.LiveLocation;

public interface LiveLocationRepository extends JpaRepository<LiveLocation, Long> {
	    List<LiveLocation> findByUserIdAndIsActiveTrue(Long userId);
    List<LiveLocation> findByIsActiveTrue();
}


