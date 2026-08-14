package in.sp.main.Controller;

import in.sp.main.Entities.Salon;
import in.sp.main.Repository.SalonRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/salon/settings")
public class SalonSettingsController {

    @Autowired
    private SalonRepository salonRepository;

    @GetMapping
    public String viewSettings(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        // Fetch fresh salon data from DB to ensure it's up to date
        Salon freshSalon = salonRepository.findById(loggedSalon.getId()).orElse(loggedSalon);
        model.addAttribute("salon", freshSalon);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-settings";
    }

    @PostMapping("/update")
    public String updateSettings(@RequestParam("name") String name,
                                 @RequestParam("email") String email,
                                 @RequestParam("phone") String phone,
                                 @RequestParam("address") String address,
                                 @RequestParam("city") String city,
                                 @RequestParam("state") String state,
                                 @RequestParam("pincode") String pincode,
                                 @RequestParam("bio") String bio,
                                 @RequestParam("availabilityHours") String availabilityHours,
                                 @RequestParam(value = "isWomenOnly", defaultValue = "false") Boolean isWomenOnly,
                                 @RequestParam(value = "hasParking", defaultValue = "false") Boolean hasParking,
                                 @RequestParam(value = "hasAc", defaultValue = "false") Boolean hasAc,
                                 @RequestParam(value = "hasWifi", defaultValue = "false") Boolean hasWifi,
                                 HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Salon salon = salonRepository.findById(loggedSalon.getId()).orElse(null);
        if (salon != null) {
            salon.setName(name);
            salon.setEmail(email);
            salon.setPhone(phone);
            salon.setAddress(address);
            salon.setCity(city);
            salon.setState(state);
            salon.setPincode(pincode);
            salon.setBio(bio);
            salon.setAvailabilityHours(availabilityHours);
            salon.setIsWomenOnly(isWomenOnly);
            salon.setHasParking(hasParking);
            salon.setHasAc(hasAc);
            salon.setHasWifi(hasWifi);

            salonRepository.save(salon);
            
            // Update session object too
            session.setAttribute("loggedSalon", salon);
            session.setAttribute("successMsg", "Salon settings updated successfully!");
        }

        return "redirect:/salon/settings";
    }
}
