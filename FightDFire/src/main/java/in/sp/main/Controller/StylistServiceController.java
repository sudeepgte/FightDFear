package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import in.sp.main.Entities.StylistService;
import in.sp.main.Entities.Stylist;
import in.sp.main.Service.StylistServiceManager;
import in.sp.main.Repository.StylistRepository;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/stylists/services")
public class StylistServiceController {

    @Autowired
    private StylistServiceManager serviceManager;

    @Autowired
    private StylistRepository stylistRepository;

    // ===== List all services for logged-in stylist =====
    @GetMapping
    public String listServices(Model model, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        List<StylistService> services = serviceManager.findByStylist(stylist.getId());
        model.addAttribute("services", services);
        return "stylistServices/stylist-services";
    }

    // ===== Show Add Form =====
    @GetMapping("/add")
    public String addServiceForm(Model model) {
        model.addAttribute("service", new StylistService());
        return "stylistServices/stylist-service-form";
    }

    // ===== Save Service =====
    @PostMapping("/save")
    public String saveService(@ModelAttribute("service") StylistService service, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        // Attach managed Stylist entity
        Optional<Stylist> stylistOpt = stylistRepository.findById(stylist.getId());
        stylistOpt.ifPresent(service::setStylist);

        serviceManager.save(service);
        return "redirect:/stylists/services";
    }

    // ===== Edit Form =====
    @GetMapping("/edit/{id}")
    public String editService(@PathVariable Long id, Model model, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        Optional<StylistService> serviceOpt = serviceManager.findById(id);
        if (serviceOpt.isPresent()) {
            model.addAttribute("service", serviceOpt.get());
            return "stylistServices/stylist-service-form";
        }
        return "redirect:/stylists/services";
    }

    // ===== Delete Service =====
    @GetMapping("/delete/{id}")
    public String deleteService(@PathVariable Long id, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        serviceManager.delete(id);
        return "redirect:/stylists/services";
    }
}
