package in.sp.main.Repository;

import in.sp.main.Entities.InvestmentMeeting;
import in.sp.main.Entities.Investor;
import in.sp.main.Entities.BusinessProposal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InvestmentMeetingRepository extends JpaRepository<InvestmentMeeting, Long> {
    List<InvestmentMeeting> findByInvestor(Investor investor);
    List<InvestmentMeeting> findByProposal(BusinessProposal proposal);
    List<InvestmentMeeting> findByProposal_Entrepreneur_Id(Long entrepreneurId);
}
