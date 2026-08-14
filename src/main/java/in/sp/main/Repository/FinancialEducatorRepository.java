package in.sp.main.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;

public interface FinancialEducatorRepository extends JpaRepository<FinancialEducator, Long> {
    Optional<FinancialEducator> findByEmail(String email);
    List<FinancialEducator> findByVerificationStatus(VerificationStatus status);
    List<FinancialEducator> findByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    List<FinancialEducator> findByPartnerProfileStatusIsNull();
    long countByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
}
