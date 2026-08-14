package in.sp.main.Controller;
 
import java.util.List;

import jakarta.servlet.http.HttpSession;
 
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.Salon;

import in.sp.main.Entities.Treatment;

import in.sp.main.Entities.SkinType;

import in.sp.main.Entities.TreatmentType;

import in.sp.main.Repository.SalonRepository;

import in.sp.main.Service.TreatmentService;
 
@Controller

@RequestMapping("/salon/treatments")

public class TreatmentController {
 
    @Autowired

    private TreatmentService treatmentService;
 
    @Autowired

    private SalonRepository salonRepository;
 
    // Add Form

    @GetMapping("/add")

    public String showAddForm(Model model) {

        model.addAttribute("treatment", new Treatment());

        model.addAttribute("treatmentTypes", TreatmentType.values());

        model.addAttribute("skinTypes", SkinType.values());

        return "salon/treatments";

    }
 
    // Save Treatment
    @PostMapping("/save")
    public String saveTreatment(@ModelAttribute Treatment treatment,
                                HttpSession session,
                                RedirectAttributes redirectAttributes,
                                Model model) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        String validationError = validateTreatmentForm(treatment);
        if (validationError != null) {
            model.addAttribute("treatment", treatment);
            model.addAttribute("treatmentTypes", TreatmentType.values());
            model.addAttribute("skinTypes", SkinType.values());
            model.addAttribute("error", validationError);
            return "salon/treatments";
        }

        treatment.setSalon(loggedSalon);
        treatmentService.saveTreatment(treatment);
        redirectAttributes.addFlashAttribute("message", "Treatment saved successfully.");
        return "redirect:/salon/treatments/view";
    }

    private static final int SERVICE_NAME_MAX = 150;
    private static final int DESCRIPTION_MAX = 2000;
    private static final int DURATION_MAX_MINUTES = 24 * 60;

    /** Server-side rules for add/edit treatment (must not rely on browser validation alone). */
    private static String validateTreatmentForm(Treatment treatment) {
        String category = treatment.getCategory();
        if (category == null || category.isBlank()) {
            return "Category is required.";
        }
        category = category.trim();
        if (!"Skin".equalsIgnoreCase(category) && !"Hair".equalsIgnoreCase(category)) {
            return "Category must be Skin or Hair.";
        }
        // Normalize casing used by the form
        treatment.setCategory("Skin".equalsIgnoreCase(category) ? "Skin" : "Hair");

        String serviceName = treatment.getServiceName();
        if (serviceName == null || serviceName.isBlank()) {
            return "Service Name is required.";
        }
        serviceName = serviceName.trim();
        if (serviceName.length() < 2) {
            return "Service Name must be at least 2 characters.";
        }
        if (serviceName.length() > SERVICE_NAME_MAX) {
            return "Service Name cannot exceed " + SERVICE_NAME_MAX + " characters.";
        }
        treatment.setServiceName(serviceName);

        if ("Skin".equals(treatment.getCategory())) {
            if (treatment.getTreatmentType() == null) {
                return "Specific Treatment Type is required for Skin Care treatments.";
            }
            if (treatment.getSkinType() == null) {
                return "Recommended Skin Type is required for Skin Care treatments.";
            }
        } else {
            // Hair treatments do not use skin-specific enums
            treatment.setTreatmentType(null);
            treatment.setSkinType(null);
        }

        if (treatment.getPrice() < 0) {
            return "Base Price cannot be negative. Please enter zero or a positive amount.";
        }
        if (treatment.getDuration() <= 0) {
            return "Duration must be a positive value (at least 1 minute).";
        }
        if (treatment.getDuration() > DURATION_MAX_MINUTES) {
            return "Duration cannot exceed " + DURATION_MAX_MINUTES + " minutes.";
        }

        String description = treatment.getDescription();
        if (description == null || description.isBlank()) {
            return "Detailed Description is required.";
        }
        description = description.trim();
        if (description.length() < 10) {
            return "Detailed Description must be at least 10 characters.";
        }
        if (description.length() > DESCRIPTION_MAX) {
            return "Detailed Description cannot exceed " + DESCRIPTION_MAX + " characters.";
        }
        treatment.setDescription(description);
        return null;
    }
 
    // View Treatments

    @GetMapping("/view")

    public String viewTreatments(HttpSession session, Model model) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");

        List<Treatment> treatments = treatmentService.getTreatmentsBySalon(loggedSalon.getId());

        model.addAttribute("treatments", treatments);

        return "salon/view-treatment";

    }
 
    // Edit Form

    @GetMapping("/edit/{id}")

    public String editTreatment(@PathVariable Long id, Model model) {

        Treatment treatment = treatmentService.getTreatmentById(id);

        model.addAttribute("treatment", treatment);

        model.addAttribute("treatmentTypes", TreatmentType.values());

        model.addAttribute("skinTypes", SkinType.values());

        return "salon/treatments"; // reuse same form

    }
 
    // Delete

    @GetMapping("/delete/{id}")

    public String deleteTreatment(@PathVariable Long id) {

        treatmentService.deleteTreatment(id);

        return "redirect:/salon/treatments/view";

    }

    @GetMapping("/viewtreatments")

    public String viewAllTreatments(Model model) {

        List<Treatment> treatments = treatmentService.getAllTreatments();

        model.addAttribute("treatments", treatments);

        return "user/view-treatments"; // JSP page

    }

}

 