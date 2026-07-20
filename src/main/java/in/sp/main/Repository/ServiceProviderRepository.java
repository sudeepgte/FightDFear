package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.VerificationStatus;

public interface ServiceProviderRepository extends JpaRepository<ServiceProvider, Long> {
    Optional<ServiceProvider> findByEmail(String email);
    List<ServiceProvider> findByVerificationStatus(VerificationStatus status);
    List<ServiceProvider> findByCategoryAndVerificationStatus(ProviderCategory category, VerificationStatus status);
}

