package in.sp.main.Repository;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface WomenProductSellerRepository extends JpaRepository<WomenProductSeller, Long> {
    Optional<WomenProductSeller> findByEmail(String email);
    Optional<WomenProductSeller> findByPhone(String phone);
    List<WomenProductSeller> findByVerificationStatus(VerificationStatus status);
    long countByVerificationStatus(VerificationStatus status);
    List<WomenProductSeller> findAllByOrderByCreatedAtDesc();
    List<WomenProductSeller> findByPartnerProfileStatus(PartnerProfileStatus status);
    List<WomenProductSeller> findByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    List<WomenProductSeller> findByPartnerProfileStatusIsNull();
}
