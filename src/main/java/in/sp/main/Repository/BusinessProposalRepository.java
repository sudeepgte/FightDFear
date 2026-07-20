package in.sp.main.Repository;

import in.sp.main.Entities.BusinessProposal;
import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Entities.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BusinessProposalRepository extends JpaRepository<BusinessProposal, Long> {
    List<BusinessProposal> findByEntrepreneur(Entrepreneur entrepreneur);
    List<BusinessProposal> findByStatus(VerificationStatus status);
    List<BusinessProposal> findByStatusAndCategoryContainingIgnoreCase(VerificationStatus status, String category);
    List<BusinessProposal> findByStatusAndLocationContainingIgnoreCase(VerificationStatus status, String location);
    List<BusinessProposal> findByStatusAndCategoryContainingIgnoreCaseAndLocationContainingIgnoreCase(VerificationStatus status, String category, String location);
}
