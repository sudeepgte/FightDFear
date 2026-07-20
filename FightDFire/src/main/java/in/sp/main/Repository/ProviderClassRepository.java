package in.sp.main.Repository;

import in.sp.main.Entities.ProviderClass;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProviderClassRepository extends JpaRepository<ProviderClass, Long> {
    List<ProviderClass> findByProvider_Id(Long providerId);
}