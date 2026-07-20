package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.OfflineFunctionality;

@Repository
public interface OfflineFunctionalityRepository extends JpaRepository<OfflineFunctionality, Long> {
}
