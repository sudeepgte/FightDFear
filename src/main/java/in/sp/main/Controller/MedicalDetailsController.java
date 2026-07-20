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
import in.sp.main.Service.MedicalDetailsService;

@Controller
@RequestMapping("/medical-details")
public class MedicalDetailsController {

    @Autowired
    private MedicalDetailsService medicalDetailsService;

    // GET all Medical Details for a specific user
    @RequestMapping(value = "/{userId}", method = RequestMethod.GET)
    public String getMedicalDetails(@PathVariable Long userId, Model model) {
        List<MedicalDetails> medicalDetailsList = medicalDetailsService.getMedicalDetailsByUserId(userId);
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", medicalDetailsList);
        return "medical-details";
    }

    // Show form to create new medical detail
    @RequestMapping(value = "/new/{userId}", method = RequestMethod.GET)
    public String showCreateForm(@PathVariable Long userId, Model model) {
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", new MedicalDetails());
        return "medical-details-form";
    }

    // Create new medical detail
    @RequestMapping(value = "/{userId}", method = RequestMethod.POST)
    public String addMedicalDetails(@PathVariable Long userId, @ModelAttribute MedicalDetails medicalDetails) {
        medicalDetailsService.createMedicalDetails(userId, medicalDetails);
        return "redirect:/medical-details/" + userId;
    }

    // Show form to edit existing medical detail
    @RequestMapping(value = "/edit/{userId}/{id}", method = RequestMethod.GET)
    public String showEditForm(@PathVariable Long userId, @PathVariable Long id, Model model) {
        MedicalDetails medicalDetails = medicalDetailsService.getMedicalDetailsById(id);
        model.addAttribute("userId", userId);
        model.addAttribute("medicalDetails", medicalDetails);
        return "medical-details-form";
    }

    // Update existing medical detail
    @RequestMapping(value = "/edit/{userId}/{id}", method = RequestMethod.POST)
    public String updateMedicalDetails(@PathVariable Long userId, @PathVariable Long id,
                                       @ModelAttribute MedicalDetails medicalDetails) {
        medicalDetailsService.updateMedicalDetails(id, medicalDetails);
        return "redirect:/medical-details/" + userId;
    }

    // Delete existing medical detail
    @RequestMapping(value = "/delete/{userId}/{id}", method = RequestMethod.GET)
    public String deleteMedicalDetails(@PathVariable Long userId, @PathVariable Long id) {
        medicalDetailsService.deleteMedicalDetails(id);
        return "redirect:/medical-details/" + userId;
    }

    // List all medical details
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String getAllMedicalDetails(Model model) {
        List<MedicalDetails> medicalDetailsList = medicalDetailsService.getAllMedicalDetails();
        model.addAttribute("medicalDetailsList", medicalDetailsList);
        return "medical-details-list";
    }
}
