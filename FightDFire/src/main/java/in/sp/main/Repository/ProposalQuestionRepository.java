package in.sp.main.Repository;

import in.sp.main.Entities.ProposalQuestion;
import in.sp.main.Entities.Investor;
import in.sp.main.Entities.BusinessProposal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProposalQuestionRepository extends JpaRepository<ProposalQuestion, Long> {
    List<ProposalQuestion> findByProposal(BusinessProposal proposal);
    List<ProposalQuestion> findByProposalAndInvestor(BusinessProposal proposal, Investor investor);
    List<ProposalQuestion> findByProposal_Entrepreneur_Id(Long entrepreneurId);
}
