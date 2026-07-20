package in.sp.main.Repository;

import in.sp.main.Entities.Entrepreneur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EntrepreneurRepository extends JpaRepository<Entrepreneur, Long> {
    Optional<Entrepreneur> findByEmail(String email);
}
