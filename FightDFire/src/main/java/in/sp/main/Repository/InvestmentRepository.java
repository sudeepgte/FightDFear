package in.sp.main.Repository;

import in.sp.main.Entities.Investment;
import in.sp.main.Entities.Investor;
import in.sp.main.Entities.BusinessProposal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InvestmentRepository extends JpaRepository<Investment, Long> {
    List<Investment> findByInvestor(Investor investor);
    List<Investment> findByProposal(BusinessProposal proposal);
    List<Investment> findByProposal_Entrepreneur_Id(Long entrepreneurId);
}
