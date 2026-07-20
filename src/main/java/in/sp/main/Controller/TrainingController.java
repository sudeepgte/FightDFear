package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.TrainingProgress;
import in.sp.main.Service.TrainingService;

@Controller
public class TrainingController {

    @Autowired
    private TrainingService trainingService;

    @RequestMapping(value = "/training", method = RequestMethod.GET)
    public String getTrainingProgress(Model model) {
        model.addAttribute("trainingProgressList", trainingService.getAllTrainingProgress());
        return "training";
    }

    @RequestMapping(value = "/updateTraining", method = RequestMethod.POST)
    public String updateTrainingProgress(@RequestParam("moduleName") String moduleName,
                                         @RequestParam("progressPercentage") int progressPercentage,
                                         @RequestParam(value = "jobAssistanceRequested", required = false) boolean jobAssistanceRequested,
                                         @RequestParam(value = "financialLiteracyAccessed", required = false) boolean financialLiteracyAccessed,
                                         Model model) {
        TrainingProgress progress = new TrainingProgress(moduleName, progressPercentage, jobAssistanceRequested, financialLiteracyAccessed);
        trainingService.saveTrainingProgress(progress);
        model.addAttribute("trainingProgressList", trainingService.getAllTrainingProgress());
        return "training";
    }
}
