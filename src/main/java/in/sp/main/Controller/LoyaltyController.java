package in.sp.main.Controller;

import in.sp.main.Entities.LoyaltyCustomer;
import in.sp.main.Entities.LoyaltySettings;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.LoyaltyCustomerRepository;
import in.sp.main.Repository.LoyaltySettingsRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/salon/loyalty")
public class LoyaltyController {

    @Autowired
    private LoyaltySettingsRepository settingsRepository;

    @Autowired
    private LoyaltyCustomerRepository customerRepository;

    @GetMapping
    public String viewLoyaltyDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        LoyaltySettings settings = settingsRepository.findBySalonId(loggedSalon.getId()).orElse(new LoyaltySettings());
        List<LoyaltyCustomer> customers = customerRepository.findBySalonIdOrderByTotalPointsEarnedDesc(loggedSalon.getId());

        model.addAttribute("settings", settings);
        model.addAttribute("customers", customers);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-loyalty";
    }

    @PostMapping("/updateSettings")
    public String updateSettings(@RequestParam(value = "isActive", required = false) String isActiveStr,
                                 @RequestParam("pointsPerHundredSpent") int pointsPerHundredSpent,
                                 @RequestParam("silverTierThreshold") int silverTierThreshold,
                                 @RequestParam("goldTierThreshold") int goldTierThreshold,
                                 @RequestParam("platinumTierThreshold") int platinumTierThreshold,
                                 @RequestParam("pointValueInRupees") double pointValueInRupees,
                                 HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        boolean isActive = isActiveStr != null && isActiveStr.equals("on");

        LoyaltySettings settings = settingsRepository.findBySalonId(loggedSalon.getId()).orElse(new LoyaltySettings());
        settings.setSalon(loggedSalon);
        settings.setActive(isActive);
        settings.setPointsPerHundredSpent(pointsPerHundredSpent);
        settings.setSilverTierThreshold(silverTierThreshold);
        settings.setGoldTierThreshold(goldTierThreshold);
        settings.setPlatinumTierThreshold(platinumTierThreshold);
        settings.setPointValueInRupees(pointValueInRupees);

        settingsRepository.save(settings);
        session.setAttribute("successMsg", "Loyalty Settings updated successfully!");

        return "redirect:/salon/loyalty";
    }
}
