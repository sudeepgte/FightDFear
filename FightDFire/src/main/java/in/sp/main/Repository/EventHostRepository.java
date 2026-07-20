package in.sp.main.Repository;

import in.sp.main.Entities.EventHost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EventHostRepository extends JpaRepository<EventHost, Long> {
    Optional<EventHost> findByEmail(String email);
}
