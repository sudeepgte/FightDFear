package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.BusinessProposal;
import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Entities.Investment;
import in.sp.main.Entities.InvestmentMeeting;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Repository.InvestmentMeetingRepository;
import in.sp.main.Repository.InvestmentRepository;

@Service
public class FundingCareService {

    public static final String CANCEL_POLICY =
            "Pending interest can be withdrawn anytime. Meetings are free to cancel until 2 hours before. Released funds are not refunded.";
    public static final double COMMISSION_RATE = 0.02;

    @Autowired private InvestmentRepository investmentRepository;
    @Autowired private EntrepreneurRepository entrepreneurRepository;
    @Autowired private InvestmentMeetingRepository meetingRepository;

    public static boolean isPublicProposal(BusinessProposal p) {
        if (p == null || p.getStatus() != VerificationStatus.VERIFIED) return false;
        return EntrepreneurProfileService.isApproved(p.getEntrepreneur());
    }

    public boolean canWithdrawInterest(Investment i) {
        return i != null && "PENDING".equalsIgnoreCase(i.getStatus());
    }

    public boolean canCancelMeeting(InvestmentMeeting m) {
        if (m == null) return false;
        String st = m.getStatus() == null ? "" : m.getStatus();
        if ("CANCELLED".equalsIgnoreCase(st) || "REJECTED".equalsIgnoreCase(st)) return false;
        if ("PENDING".equalsIgnoreCase(st)) return true;
        LocalDateTime t = m.getMeetingTime();
        if (t == null) return true;
        return LocalDateTime.now().plusHours(2).isBefore(t);
    }

    @Transactional
    public Investment withdrawInterest(Investment i) {
        if (i == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Investment not found");
        if (!canWithdrawInterest(i)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        i.setStatus("WITHDRAWN");
        return investmentRepository.save(i);
    }

    @Transactional
    public InvestmentMeeting cancelMeeting(InvestmentMeeting m) {
        if (m == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Meeting not found");
        if (!canCancelMeeting(m)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        m.setStatus("CANCELLED");
        return meetingRepository.save(m);
    }

    public double commissionOf(Investment i) {
        if (i == null) return 0;
        double base = i.getReleasedAmount() != null ? i.getReleasedAmount()
                : (i.getAmount() == null ? 0 : i.getAmount());
        return Math.round(base * COMMISSION_RATE * 100.0) / 100.0;
    }

    @Transactional
    public void creditPayout(Investment i) {
        if (i == null || Boolean.TRUE.equals(i.getPayoutCredited())) return;
        if (!"COMPLETED".equalsIgnoreCase(i.getStatus())) return;
        Entrepreneur e = i.getProposal() == null ? null : i.getProposal().getEntrepreneur();
        if (e == null) return;
        double amount = i.getReleasedAmount() != null ? i.getReleasedAmount()
                : (i.getAmount() == null ? 0 : i.getAmount());
        if (amount <= 0) return;
        e.setPayoutBalance(e.getPayoutBalance() + amount);
        entrepreneurRepository.save(e);
        i.setPayoutCredited(true);
        investmentRepository.save(i);
    }

    @Transactional
    public Map<String, Object> requestPayout(Entrepreneur e) {
        if (e == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Entrepreneur profile required");
        if (PartnerLifecycleSupport.blank(e.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = e.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        e.setPayoutRequestedAt(LocalDateTime.now());
        entrepreneurRepository.save(e);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + e.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", e.getUpiId());
        return m;
    }

    @Transactional
    public Investment markCommissionPaid(Investment i) {
        if (i == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Investment not found");
        if (!"COMPLETED".equalsIgnoreCase(i.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Commission can only be paid on released investments");
        }
        if (i.isCommissionPaid()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Commission already paid");
        }
        i.setCommissionPaid(true);
        return investmentRepository.save(i);
    }

    @Transactional
    public Investment rate(Investment i, int rating, String review) {
        if (i == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Investment not found");
        if (!"COMPLETED".equalsIgnoreCase(i.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Review after funds are released.");
        }
        if (i.getRating() != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already reviewed");
        }
        int stars = Math.max(1, Math.min(5, rating));
        i.setRating(stars);
        i.setReview(review);
        investmentRepository.save(i);
        Entrepreneur e = i.getProposal() == null ? null : i.getProposal().getEntrepreneur();
        if (e != null) {
            Long eid = e.getId();
            List<Investment> all = investmentRepository.findAll().stream()
                    .filter(x -> x.getProposal() != null && x.getProposal().getEntrepreneur() != null
                            && eid.equals(x.getProposal().getEntrepreneur().getId())
                            && x.getRating() != null)
                    .toList();
            double avg = all.stream().mapToInt(Investment::getRating).average().orElse(stars);
            e.setRating(avg);
            e.setReviewCount(all.size());
            entrepreneurRepository.save(e);
        }
        return i;
    }
}
