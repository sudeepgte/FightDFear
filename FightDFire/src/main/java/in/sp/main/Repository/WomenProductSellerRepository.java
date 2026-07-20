package in.sp.main.Repository;

import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface WomenProductSellerRepository extends JpaRepository<WomenProductSeller, Long> {
    Optional<WomenProductSeller> findByEmail(String email);
    List<WomenProductSeller> findByVerificationStatus(VerificationStatus status);
    List<WomenProductSeller> findAllByOrderByCreatedAtDesc();
}
