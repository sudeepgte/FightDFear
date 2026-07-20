package in.sp.main.Repository;

import in.sp.main.Entities.ProposalChatMessage;
import in.sp.main.Entities.Investor;
import in.sp.main.Entities.BusinessProposal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProposalChatMessageRepository extends JpaRepository<ProposalChatMessage, Long> {
    List<ProposalChatMessage> findByProposalAndInvestorOrderByTimestampAsc(BusinessProposal proposal, Investor investor);
    List<ProposalChatMessage> findByProposal_Entrepreneur_Id(Long entrepreneurId);
    List<ProposalChatMessage> findByInvestor(Investor investor);
}
