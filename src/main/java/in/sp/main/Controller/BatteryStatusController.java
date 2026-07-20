package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.BatteryStatus;
import in.sp.main.Service.BatteryStatusService;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
public class BatteryStatusController {

    @Autowired
    private BatteryStatusService batteryStatusService;

    @RequestMapping(value = "/batteryStatus", method = GET)
    public String getBatteryStatus(Model model) {
        batteryStatusService.getLatestBatteryStatus()
            .ifPresent(status -> model.addAttribute("batteryStatus", status));
        return "batteryStatus"; 
    }

    @RequestMapping(value = "/updateBatteryStatus", method = POST)
    public String updateBatteryStatus(@RequestParam("batteryLevel") int batteryLevel,
                                      @RequestParam("lastKnownLocation") String lastKnownLocation,
                                      @RequestParam("nonEssentialAppsDisabled") boolean nonEssentialAppsDisabled,
                                      Model model) {
        BatteryStatus status = new BatteryStatus();
        status.setBatteryLevel(batteryLevel);
        status.setLastKnownLocation(lastKnownLocation);
        status.setNonEssentialAppsDisabled(nonEssentialAppsDisabled);
        status.setAlertSent(batteryLevel < 15); 

        batteryStatusService.saveBatteryStatus(status);
        model.addAttribute("batteryStatus", status);
        return "batteryStatus";
    }
}
