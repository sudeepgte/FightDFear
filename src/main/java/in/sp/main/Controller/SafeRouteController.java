package in.sp.main.Controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.SafeRoute;
import in.sp.main.Service.SafeRouteService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/saferoutes")
public class SafeRouteController {

    @Autowired
    private SafeRouteService safeRouteService;

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String showAddRouteForm(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        model.addAttribute("safeRoute", new SafeRoute());
        return "addSafeRoute";
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String saveRoute(@ModelAttribute SafeRoute safeRoute, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        safeRoute.setActive(true);
        safeRouteService.addSafeRoute(safeRoute);
        return "redirect:/admin/saferoutes/list";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String viewRoutes(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<SafeRoute> routes = safeRouteService.getAllRoutes();
        model.addAttribute("routes", routes);
        return "listSafeRoutes";
    }

    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.POST, RequestMethod.DELETE})
    public String deleteRoute(@PathVariable Long id, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        safeRouteService.deleteRoute(id);
        return "redirect:/admin/saferoutes/list";
    }
}
