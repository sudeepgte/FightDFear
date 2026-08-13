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
    public String addServiceForm(Model model, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";
        model.addAttribute("service", new StylistService());
        return "stylistServices/stylist-service-form";
    }

    // ===== Save Service =====
    @PostMapping("/save")
    public String saveService(@ModelAttribute("service") StylistService service, HttpSession session, Model model) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        String name = service.getName() == null ? "" : service.getName().trim();
        if (name.length() < 2 || name.length() > 100) {
            model.addAttribute("error", "Service name must be 2–100 characters.");
            model.addAttribute("service", service);
            return "stylistServices/stylist-service-form";
        }
        if (service.getPrice() == null || service.getPrice() < 0) {
            model.addAttribute("error", "Price must be zero or greater.");
            model.addAttribute("service", service);
            return "stylistServices/stylist-service-form";
        }

        Optional<Stylist> stylistOpt = stylistRepository.findById(stylist.getId());
        if (stylistOpt.isEmpty()) return "redirect:/stylists/login";

        // Prevent editing another stylist's service
        if (service.getId() != null) {
            Optional<StylistService> existingOpt = serviceManager.findById(service.getId());
            if (existingOpt.isEmpty()
                    || existingOpt.get().getStylist() == null
                    || !existingOpt.get().getStylist().getId().equals(stylist.getId())) {
                return "redirect:/stylists/services";
            }
        }

        service.setName(name);
        service.setStylist(stylistOpt.get());
        serviceManager.save(service);
        return "redirect:/stylists/services";
    }

    // ===== Edit Form =====
    @GetMapping("/edit/{id}")
    public String editService(@PathVariable Long id, Model model, HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        Optional<StylistService> serviceOpt = serviceManager.findById(id);
        if (serviceOpt.isPresent()
                && serviceOpt.get().getStylist() != null
                && serviceOpt.get().getStylist().getId().equals(stylist.getId())) {
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

        Optional<StylistService> serviceOpt = serviceManager.findById(id);
        if (serviceOpt.isPresent()
                && serviceOpt.get().getStylist() != null
                && serviceOpt.get().getStylist().getId().equals(stylist.getId())) {
            serviceManager.delete(id);
        }
        return "redirect:/stylists/services";
    }
}
