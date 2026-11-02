package in.sp.main.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.ProviderNotification;
import in.sp.main.Entities.ServiceProvider;

@Repository
public interface ProviderNotificationRepository extends JpaRepository<ProviderNotification, Long> {

    List<ProviderNotification> findByProviderOrderByCreatedAtDesc(ServiceProvider provider);

    List<ProviderNotification> findByProvider_IdOrderByCreatedAtDesc(Long providerId);

    long countByProvider_IdAndReadFlagFalse(Long providerId);
}
