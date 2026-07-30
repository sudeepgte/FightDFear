package in.sp.main.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import in.sp.main.Entities.MedicalDetails;
import in.sp.main.Entities.User;
import in.sp.main.Service.MedicalDetailsService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/medical-details")
public class MedicalDetailsController {

    @Autowired
    private MedicalDetailsService medicalDetailsService;

    private boolean owns(HttpSession session, Long userId) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getId().equals(userId);
    }

    @RequestMapping(value = "/{userId}", method = RequestMethod.GET)
    public String getMedicalDetails(@PathVariable Long userId, Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        List<MedicalDetails> medicalDetailsList = medicalDetailsService.getMedicalDetailsByUserId(userId);
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", medicalDetailsList);
        return "medical-details";
    }

    @RequestMapping(value = "/new/{userId}", method = RequestMethod.GET)
    public String showCreateForm(@PathVariable Long userId, Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", new MedicalDetails());
        return "medical-details-form";
    }

    @RequestMapping(value = "/{userId}", method = RequestMethod.POST)
    public String addMedicalDetails(@PathVariable Long userId,
                                    @ModelAttribute MedicalDetails medicalDetails,
                                    HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        medicalDetailsService.createMedicalDetails(userId, medicalDetails);
        return "redirect:/medical-details/" + userId;
    }

    @RequestMapping(value = "/edit/{userId}/{id}", method = RequestMethod.GET)
    public String showEditForm(@PathVariable Long userId, @PathVariable Long id,
                               Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        MedicalDetails medicalDetails = medicalDetailsService.getMedicalDetailsById(id);
        if (medicalDetails == null || medicalDetails.getUser() == null
                || !medicalDetails.getUser().getId().equals(userId)) {
            return "redirect:/medical-details/" + userId;
        }
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", medicalDetails);
        return "medical-details-form";
    }

    @RequestMapping(value = "/edit/{userId}/{id}", method = RequestMethod.POST)
    public String updateMedicalDetails(@PathVariable Long userId, @PathVariable Long id,
                                       @ModelAttribute MedicalDetails medicalDetails,
                                       HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        MedicalDetails existing = medicalDetailsService.getMedicalDetailsById(id);
        if (existing == null || existing.getUser() == null || !existing.getUser().getId().equals(userId)) {
            return "redirect:/medical-details/" + userId;
        }
        medicalDetailsService.updateMedicalDetails(id, medicalDetails);
        return "redirect:/medical-details/" + userId;
    }

    @RequestMapping(value = "/delete/{userId}/{id}", method = RequestMethod.GET)
    public String deleteMedicalDetails(@PathVariable Long userId, @PathVariable Long id,
                                       HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        MedicalDetails existing = medicalDetailsService.getMedicalDetailsById(id);
        if (existing != null && existing.getUser() != null && existing.getUser().getId().equals(userId)) {
            medicalDetailsService.deleteMedicalDetails(id);
        }
        return "redirect:/medical-details/" + userId;
    }

    /** Global PHI dump removed — only the logged-in user's records are accessible. */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String getAllMedicalDetails(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        return "redirect:/medical-details/" + user.getId();
    }
}
