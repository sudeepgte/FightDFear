package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "salon_loyalty_settings")
public class LoyaltySettings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "salon_id", nullable = false, unique = true)
    private Salon salon;

    private boolean isActive = false;

    private int pointsPerHundredSpent = 10;
    
    // Tier thresholds
    private int silverTierThreshold = 0;
    private int goldTierThreshold = 500;
    private int platinumTierThreshold = 1000;

    private double pointValueInRupees = 0.50; // 100 points = ₹50

    // Getters and Setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getPointsPerHundredSpent() { return pointsPerHundredSpent; }
    public void setPointsPerHundredSpent(int pointsPerHundredSpent) { this.pointsPerHundredSpent = pointsPerHundredSpent; }

    public int getSilverTierThreshold() { return silverTierThreshold; }
    public void setSilverTierThreshold(int silverTierThreshold) { this.silverTierThreshold = silverTierThreshold; }

    public int getGoldTierThreshold() { return goldTierThreshold; }
    public void setGoldTierThreshold(int goldTierThreshold) { this.goldTierThreshold = goldTierThreshold; }

    public int getPlatinumTierThreshold() { return platinumTierThreshold; }
    public void setPlatinumTierThreshold(int platinumTierThreshold) { this.platinumTierThreshold = platinumTierThreshold; }

    public double getPointValueInRupees() { return pointValueInRupees; }
    public void setPointValueInRupees(double pointValueInRupees) { this.pointValueInRupees = pointValueInRupees; }
}
