package in.sp.main.Repository;

import in.sp.main.Entities.EventHost;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface EventHostRepository extends JpaRepository<EventHost, Long> {
    Optional<EventHost> findByEmail(String email);
    List<EventHost> findByVerificationStatus(VerificationStatus status);
    List<EventHost> findByVerificationStatusOrderByCreatedAtDesc(VerificationStatus status);
}
