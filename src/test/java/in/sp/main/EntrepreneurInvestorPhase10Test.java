package in.sp.main;

import in.sp.main.Entities.*;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Repository.InvestorRepository;
import in.sp.main.Repository.ProposalQuestionRepository;
import in.sp.main.Service.EntrepreneurProfileService;
import in.sp.main.Service.InvestorProfileService;
import in.sp.main.Service.PartnerLifecycleSupport;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class EntrepreneurInvestorPhase10Test {

    @Autowired
    private EntrepreneurProfileService entrepreneurProfileService;

    @Autowired
    private InvestorProfileService investorProfileService;

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private BusinessProposalRepository proposalRepository;

    @Autowired
    private ProposalQuestionRepository questionRepository;

    @Test
    @DisplayName("Entrepreneur 16 criteria profile completion calculation")
    public void testEntrepreneur16CriteriaCompletion() {
        Entrepreneur e = new Entrepreneur();
        // Incomplete initially
        List<String> missing = entrepreneurProfileService.missingItems(e);
        assertFalse(missing.isEmpty(), "New entrepreneur must have missing items");
        int initialPct = entrepreneurProfileService.calculateCompletionPct(e);
        assertEquals(0, initialPct);

        // Fill all 16 required items
        e.setProfilePhoto("/uploads/founder.jpg");
        e.setFullName("Ananya Sharma");
        e.setBusinessName("Lotus Crafts");
        e.setBusinessCategory("Handicrafts & Arts");
        e.setEmail("ananya@lotuscrafts.in");
        e.setPhone("9876543210");
        e.setBusinessLocation("Shop 12, Janpath Market, Connaught Place");
        e.setState("Delhi");
        e.setCity("New Delhi");
        e.setPincode("110001");
        e.setInvestmentNeeded(250000.0);
        e.setExpectedMonthlyIncome(45000.0);
        e.setBusinessExperience(3);
        e.setAadhaarNumber("123456789012");
        e.setBusinessDescription("Handmade eco-friendly terracotta lifestyle products distributed pan-India.");
        e.setUpiId("ananya@okaxis");

        List<String> missingAfter = entrepreneurProfileService.missingItems(e);
        assertTrue(missingAfter.isEmpty(), "All 16 items filled should leave 0 missing items. Missing: " + missingAfter);
        int finalPct = entrepreneurProfileService.calculateCompletionPct(e);
        assertEquals(100, finalPct);
        assertTrue(entrepreneurProfileService.isReadyForVerification(e));
    }

    @Test
    @DisplayName("Entrepreneur bank details alternative satisfies criteria 16")
    public void testEntrepreneurBankAlternative() {
        Entrepreneur e = new Entrepreneur();
        e.setProfilePhoto("/uploads/founder.jpg");
        e.setFullName("Meera Patel");
        e.setBusinessName("Kutch Weaves");
        e.setBusinessCategory("Apparel & Fashion");
        e.setEmail("meera@kutchweaves.in");
        e.setPhone("9823456789");
        e.setBusinessLocation("Bhadra Road, Old City");
        e.setState("Gujarat");
        e.setCity("Ahmedabad");
        e.setPincode("380001");
        e.setInvestmentNeeded(500000.0);
        e.setExpectedMonthlyIncome(80000.0);
        e.setBusinessExperience(5);
        e.setAadhaarNumber("987654321098");
        e.setBusinessDescription("Authentic handmade artisanal handloom apparel preserving traditional embroidery.");
        
        // Instead of UPI, supply bank account
        e.setAccountNumber("50100234567890");
        e.setIfscCode("HDFC0001234");
        e.setBankName("HDFC Bank");

        List<String> missing = entrepreneurProfileService.missingItems(e);
        assertTrue(missing.isEmpty(), "Bank details should satisfy item 16 without UPI. Missing: " + missing);
        assertEquals(100, entrepreneurProfileService.calculateCompletionPct(e));
    }

    @Test
    @DisplayName("Investor 17 criteria profile completion calculation")
    public void testInvestor17CriteriaCompletion() {
        Investor inv = new Investor();
        // Incomplete initially
        List<String> missing = investorProfileService.missingItems(inv);
        assertFalse(missing.isEmpty(), "New investor must have missing items");

        // Fill all 17 items
        inv.setProfilePhoto("/uploads/investor.jpg");
        inv.setFullName("Vikram Singhania");
        inv.setDesignation("Managing Partner");
        inv.setCompanyName("Apex Capital Ventures");
        inv.setCredentialNumber("AAACV1234F");
        inv.setPhone("9812345678");
        inv.setAddress("Level 14, Express Towers, Nariman Point");
        inv.setCity("Mumbai");
        inv.setState("Maharashtra");
        inv.setPincode("400021");
        inv.setCategoriesOffered("Tech, Retail, Apparel, Handicrafts");
        inv.setAudience("Women Founders, Early-stage D2C");
        inv.setOpenDays("Mon-Fri");
        inv.setOpenTime(java.time.LocalTime.of(9, 0));
        inv.setCloseTime(java.time.LocalTime.of(18, 0));
        inv.setBio("Seed stage micro-VC investing in women-led consumption and handicraft startups across tier 1-2 cities.");
        inv.setTicketMode("Angel");
        inv.setTypicalCheque(200000.0);

        List<String> missingAfter = investorProfileService.missingItems(inv);
        assertTrue(missingAfter.isEmpty(), "All 17 items filled should leave 0 missing items. Missing: " + missingAfter);
        int finalPct = investorProfileService.calculateCompletionPct(inv);
        assertEquals(100, finalPct);
        assertTrue(investorProfileService.isReadyForVerification(inv));
    }

    @Test
    @DisplayName("applyExtraFields persists all website form fields on Entrepreneur")
    public void testEntrepreneurApplyExtraFields() {
        Entrepreneur e = new Entrepreneur();
        e.setEmail("test.apply@fightdfear.in");
        e.setFullName("Test Founder");
        entrepreneurRepository.save(e);

        Map<String, Object> body = new HashMap<>();
        body.put("dob", "1992-05-14");
        body.put("gender", "FEMALE");
        body.put("aadhaarNumber", "112233445566");
        body.put("panNumber", "ABCDE1234F");
        body.put("bankName", "State Bank of India");
        body.put("bankAccountNumber", "12345678901");
        body.put("bankIfsc", "SBIN0001234");
        body.put("bankAccountHolder", "Test Founder");
        body.put("bankBranch", "Connaught Place");
        body.put("pitchDeckPath", "/uploads/pitch.pdf");

        entrepreneurProfileService.applyExtraFields(e, body);

        assertEquals("1992-05-14", e.getDob());
        assertEquals(Gender.FEMALE, e.getGender());
        assertEquals("112233445566", e.getAadhaarNumber());
        assertEquals("ABCDE1234F", e.getCredentialNumber());
        assertEquals("State Bank of India", e.getBankName());
        assertEquals("12345678901", e.getAccountNumber());
        assertEquals("SBIN0001234", e.getIfscCode());
        assertEquals("/uploads/pitch.pdf", e.getDocumentsPath());
        assertNotNull(e.getBankDetails());
        assertTrue(e.getBankDetails().contains("Connaught Place"));
    }

    @Test
    @DisplayName("Q&A flow between Investor and Entrepreneur")
    public void testQnAWorkflow() {
        // 1. Create Entrepreneur & Proposal
        Entrepreneur ent = new Entrepreneur();
        ent.setEmail("qna.ent@fightdfear.in");
        ent.setFullName("QnA Entrepreneur");
        ent.setBusinessName("QnA Enterprise");
        ent.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        ent.setVerificationStatus(VerificationStatus.VERIFIED);
        entrepreneurRepository.save(ent);

        BusinessProposal proposal = new BusinessProposal();
        proposal.setEntrepreneur(ent);
        proposal.setTitle("Solar Dryer Innovation");
        proposal.setFundingNeeded(300000.0);
        proposal.setStatus(VerificationStatus.VERIFIED);
        proposalRepository.save(proposal);

        // 2. Create Investor
        Investor inv = new Investor();
        inv.setEmail("qna.inv@fightdfear.in");
        inv.setFullName("Green Ventures");
        inv.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        inv.setVerificationStatus(VerificationStatus.VERIFIED);
        investorRepository.save(inv);

        // 3. Investor asks question
        ProposalQuestion q = new ProposalQuestion();
        q.setProposal(proposal);
        q.setInvestor(inv);
        q.setQuestion("What is the patent status of your drying technology?");
        questionRepository.save(q);

        assertNotNull(q.getId());
        assertNull(q.getAnswer());

        // 4. Entrepreneur finds and answers question
        List<ProposalQuestion> entQuestions = questionRepository.findByProposal_Entrepreneur_Id(ent.getId());
        assertEquals(1, entQuestions.size());
        assertEquals("What is the patent status of your drying technology?", entQuestions.get(0).getQuestion());

        entQuestions.get(0).setAnswer("Provisional patent filed with Indian Patent Office under application #2026/IN/0045.");
        questionRepository.save(entQuestions.get(0));

        // 5. Verify answered question
        ProposalQuestion answered = questionRepository.findById(q.getId()).orElse(null);
        assertNotNull(answered);
        assertEquals("Provisional patent filed with Indian Patent Office under application #2026/IN/0045.", answered.getAnswer());
    }
}
