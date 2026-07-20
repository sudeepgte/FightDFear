package in.sp.main.Controller;
 
import java.util.List;

import jakarta.servlet.http.HttpSession;
 
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;
 
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

    public String saveTreatment(@ModelAttribute Treatment treatment, HttpSession session) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");

        if (loggedSalon != null) {

            treatment.setSalon(loggedSalon);

        }

        treatmentService.saveTreatment(treatment);

        return "redirect:/salon/treatments/view";

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

 