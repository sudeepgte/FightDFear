package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
public class WalletController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private in.sp.main.Repository.WalletTransactionRepository walletTransactionRepo;

    @GetMapping("/users/wallet")
    public String viewWallet(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Refresh user from DB to get latest points
        User freshUser = userRepository.findById(user.getId()).orElse(user);
        model.addAttribute("user", freshUser);
        
        // Dummy rewards for now
        List<String> rewards = new ArrayList<>();
        rewards.add("10% Off Salon Service - 100 Coins");
        rewards.add("Free Martial Arts Trial - 200 Coins");
        rewards.add("Exclusive Badge - 50 Coins");
        model.addAttribute("rewards", rewards);
        // Fetch Transaction History
        List<in.sp.main.Entities.WalletTransaction> transactions = walletTransactionRepo.findByUser_IdOrderByTransactionDateDesc(user.getId());
        model.addAttribute("transactions", transactions);
        
        return "wallet";
    }

    @Autowired
    private in.sp.main.Service.AtomicCoinService atomicCoinService;

    @PostMapping("/users/redeem")
    public String redeemReward(@RequestParam int cost, @RequestParam String rewardName, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User updatedUser = atomicCoinService.debitCoins(user.getId(), cost, "Redeemed: " + (rewardName != null ? rewardName : "Reward"));
            session.setAttribute("user", updatedUser);
            redirectAttributes.addFlashAttribute("message", "Successfully redeemed: " + rewardName);
            redirectAttributes.addFlashAttribute("coupon", "COUPON-" + System.currentTimeMillis() % 10000);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Insufficient coins!");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Redeem failed. Please try again.");
        }
        return "redirect:/users/wallet";
    }
}
