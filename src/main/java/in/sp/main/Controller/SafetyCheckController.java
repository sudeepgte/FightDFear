package in.sp.main.Controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.CrimeData;
import in.sp.main.Repository.CrimeDataRepository;
import in.sp.main.Service.AISafetyService;

@Controller
@RequestMapping("/safety")
public class SafetyCheckController {

    @Autowired
    private CrimeDataRepository crimeDataRepository;

    @Autowired
    private AISafetyService aiSafetyService;

    @RequestMapping(value = "/check", method = RequestMethod.GET)
    public String checkSafety(@RequestParam double latitude, @RequestParam double longitude, Model model) {
        // Fetch crime data for the nearest location
        Optional<CrimeData> crimeData = crimeDataRepository.findNearestLocation(latitude, longitude);

        if (crimeData.isPresent()) {
            try {
                // Use AI to predict safety
                String safetyStatus = aiSafetyService.predictSafety(
                    crimeData.get().getCrimeCount(),
                    crimeData.get().getNightTimeCrime(),
                    crimeData.get().getPoliceStations()
                );

                // Send data to JSP
                model.addAttribute("latitude", latitude);
                model.addAttribute("longitude", longitude);
                model.addAttribute("safety_status", safetyStatus);
            } catch (Exception e) {
                model.addAttribute("safety_status", "Error in AI Prediction");
            }
        } else {
            model.addAttribute("safety_status", "Crime Data Not Found");
        }

        return "safetyCheck";
    }
}
