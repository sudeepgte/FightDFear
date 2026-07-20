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

    @PostMapping("/users/redeem")
    public String redeemReward(@RequestParam int cost, @RequestParam String rewardName, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userRepository.findById(user.getId()).orElse(null);
        if (freshUser != null) {
            int currentPoints = (freshUser.getRewardPoints() != null) ? freshUser.getRewardPoints() : 0;
            if (currentPoints >= cost) {
                freshUser.setRewardPoints(currentPoints - cost);
                userRepository.save(freshUser);
                session.setAttribute("user", freshUser);
                redirectAttributes.addFlashAttribute("message", "Successfully redeemed: " + rewardName);
                redirectAttributes.addFlashAttribute("coupon", "COUPON-" + System.currentTimeMillis() % 10000);
            } else {
                redirectAttributes.addFlashAttribute("error", "Insufficient coins!");
            }
        }
        return "redirect:/users/wallet";
    }
}
