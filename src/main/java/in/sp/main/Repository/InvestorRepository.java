package in.sp.main.Repository;

import in.sp.main.Entities.Investor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface InvestorRepository extends JpaRepository<Investor, Long> {
    Optional<Investor> findByEmail(String email);
}
