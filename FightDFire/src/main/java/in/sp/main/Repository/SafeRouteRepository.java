package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import in.sp.main.Entities.SafeRoute;

public interface SafeRouteRepository extends JpaRepository<SafeRoute, Long> {
    java.util.List<SafeRoute> findByVerified(boolean verified);
}
