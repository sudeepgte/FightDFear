package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Coin redemption for Women Events. Rules live on the server — never trust the client.
 * 1 Fight D Fear coin = {@code rupeesPerCoin} rupees. Cap is {@code maxPercent} of ticket amount.
 */
@Component
public class EventCoinPolicy {

    @Value("${app.events.coins.enabled:true}")
    private boolean enabled;

    @Value("${app.events.coins.rupees-per-coin:1}")
    private double rupeesPerCoin;

    @Value("${app.events.coins.max-percent:20}")
    private int maxPercent;

    @Value("${app.events.platform-fee-percent:5}")
    private double platformFeePercent;

    public boolean isEnabled() {
        return enabled;
    }

    public double rupeesPerCoin() {
        return rupeesPerCoin <= 0 ? 1d : rupeesPerCoin;
    }

    public int maxPercent() {
        return Math.max(0, Math.min(100, maxPercent));
    }

    public double platformFeePercent() {
        return Math.max(0, platformFeePercent);
    }

    public int maxRedeemableCoins(double ticketAmount, int availableCoins) {
        if (!enabled || ticketAmount <= 0 || availableCoins <= 0) return 0;
        double capRupees = ticketAmount * maxPercent() / 100.0;
        int fromCap = (int) Math.floor(capRupees / rupeesPerCoin());
        int fromAmount = (int) Math.floor(ticketAmount / rupeesPerCoin());
        return Math.max(0, Math.min(availableCoins, Math.min(fromCap, fromAmount)));
    }

    public double rupeesForCoins(int coins) {
        if (coins <= 0) return 0;
        return coins * rupeesPerCoin();
    }

    public double payable(double ticketAmount, int coinsApplied) {
        double pay = ticketAmount - rupeesForCoins(coinsApplied);
        return Math.max(0, Math.round(pay * 100.0) / 100.0);
    }

    public double platformFee(double gross) {
        if (gross <= 0) return 0;
        return Math.round(gross * platformFeePercent() / 100.0 * 100.0) / 100.0;
    }
}
