package in.sp.main.Repository;

import in.sp.main.Entities.SalonPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SalonPackageRepository extends JpaRepository<SalonPackage, Long> {
    List<SalonPackage> findBySalonId(Long salonId);
}
