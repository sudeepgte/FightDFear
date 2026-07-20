package in.sp.main.Repository;

import in.sp.main.Entities.MarketplaceEnrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface MarketplaceEnrollmentRepository extends JpaRepository<MarketplaceEnrollment, Long> {
    List<MarketplaceEnrollment> findByUser_Id(Long userId);
    
    @Query("SELECT e FROM MarketplaceEnrollment e WHERE e.providerClass.provider.id = :providerId")
    List<MarketplaceEnrollment> findByProviderId(@Param("providerId") Long providerId);
    
    boolean existsByUser_IdAndProviderClass_Id(Long userId, Long classId);
}