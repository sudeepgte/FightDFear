package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "investments")
public class Investment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "proposal_id")
    private BusinessProposal proposal;

    @ManyToOne
    @JoinColumn(name = "investor_id")
    private Investor investor;

    private Double amount;
    private Double releasedAmount;
    private Double adminAmount;
    private String status; // PENDING, COMPLETED

    private boolean commissionPaid = false;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // --- Getters and Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public BusinessProposal getProposal() {
        return proposal;
    }

    public void setProposal(BusinessProposal proposal) {
        this.proposal = proposal;
    }

    public Investor getInvestor() {
        return investor;
    }

    public void setInvestor(Investor investor) {
        this.investor = investor;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isCommissionPaid() {
        return commissionPaid;
    }

    public void setCommissionPaid(boolean commissionPaid) {
        this.commissionPaid = commissionPaid;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Double getReleasedAmount() {
        return releasedAmount;
    }

    public void setReleasedAmount(Double releasedAmount) {
        this.releasedAmount = releasedAmount;
    }

    public Double getAdminAmount() {
        return adminAmount;
    }

    public void setAdminAmount(Double adminAmount) {
        this.adminAmount = adminAmount;
    }
}
