package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.OfflineFunctionality;
import in.sp.main.Service.OfflineFunctionalityService;

@Controller
public class OfflineFunctionalityController {

    @Autowired
    private OfflineFunctionalityService offlineFunctionalityService;

    @RequestMapping(value = "/offlineFunctionalityStatus", method = RequestMethod.GET)
    public String showOfflineFunctionalityStatus(Model model) {
        offlineFunctionalityService.getLatestOfflineFunctionality()
                .ifPresent(status -> model.addAttribute("offlineFunctionality", status));
        return "offlineFunctionalityStatus";
    }

    @RequestMapping(value = "/updateOfflineFunctionalityPage", method = RequestMethod.GET)
    public String showUpdateOfflineFunctionalityPage() {
        return "updateOfflineFunctionality";
    }

    @RequestMapping(value = "/updateOfflineFunctionality", method = RequestMethod.POST)
    public String updateOfflineFunctionality(@RequestParam("fakeCallAvailable") boolean fakeCallAvailable,
                                             @RequestParam("sosAlertViaSMS") boolean sosAlertViaSMS,
                                             @RequestParam("emergencyMessage") String emergencyMessage,
                                             Model model) {
        OfflineFunctionality status = new OfflineFunctionality();
        status.setFakeCallAvailable(fakeCallAvailable);
        status.setSosAlertViaSMS(sosAlertViaSMS);
        status.setEmergencyMessage(emergencyMessage);

        offlineFunctionalityService.saveOfflineFunctionality(status);
        return "redirect:/offlineFunctionalityStatus";
    }

    @RequestMapping(value = "/terms", method = RequestMethod.GET)
    public String showTermsPage() {
        return "terms";
    }
   
}
