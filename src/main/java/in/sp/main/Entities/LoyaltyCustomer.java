package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "salon_loyalty_customers")
public class LoyaltyCustomer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "salon_id", nullable = false)
    private Salon salon;

    private String clientName;
    private String clientPhone;

    private int totalPointsEarned = 0; // Lifetime points (used for tiers)
    private int currentPointsBalance = 0; // Points available to spend

    private String currentTier = "Silver"; // Silver, Gold, Platinum

    // Getters and Setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getClientPhone() { return clientPhone; }
    public void setClientPhone(String clientPhone) { this.clientPhone = clientPhone; }

    public int getTotalPointsEarned() { return totalPointsEarned; }
    public void setTotalPointsEarned(int totalPointsEarned) { this.totalPointsEarned = totalPointsEarned; }

    public int getCurrentPointsBalance() { return currentPointsBalance; }
    public void setCurrentPointsBalance(int currentPointsBalance) { this.currentPointsBalance = currentPointsBalance; }

    public String getCurrentTier() { return currentTier; }
    public void setCurrentTier(String currentTier) { this.currentTier = currentTier; }
}
