package in.sp.main.Controller;

import in.sp.main.Entities.Service1;
import in.sp.main.Service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

/**
 * Web (JSP) routes for browsing salon services.
 * Note: JSON APIs under {@code /api/glow/services} are handled separately.
 */
@Controller
public class ServicesPageController {

    @Autowired
    private ServiceService serviceService;

    @GetMapping({"/services", "/index/services"})
    public String viewServices(Model model) {
        List<Service1> serviceList = serviceService.getAllServicesWithSalonDetails();
        model.addAttribute("serviceList", serviceList);
        model.addAttribute("pageTitle", "Salon Services");
        return "user/view-services";
    }
}
