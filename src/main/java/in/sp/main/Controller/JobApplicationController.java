package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.User;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/marketplace/earn")
public class JobApplicationController {

    @Autowired
    private JobApplicationRepository jobApplicationRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @GetMapping
    public String earnPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "marketplace/earn-application";
    }

    @PostMapping
    public String submitApplication(
            @RequestParam("jobCategory") String jobCategory,
            @RequestParam("jobSubCategory") String jobSubCategory,
            @RequestParam("hourlyRate") Double hourlyRate,
            @RequestParam("proofDocument") MultipartFile proofDocument,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (hourlyRate == null || hourlyRate <= 0) {
            redirectAttributes.addFlashAttribute("error", "Hourly rate must be greater than zero.");
            return "redirect:/marketplace/earn";
        }

        if (jobApplicationRepo.existsByUser_IdAndStatusIn(user.getId(),
                java.util.List.of(in.sp.main.Entities.VerificationStatus.PENDING,
                        in.sp.main.Entities.VerificationStatus.VERIFIED))) {
            redirectAttributes.addFlashAttribute("error",
                    "You already have a pending or verified job application.");
            return "redirect:/marketplace/earn";
        }

        try {
            if (proofDocument == null || proofDocument.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Please upload a proof document.");
                return "redirect:/marketplace/earn";
            }
            if (proofDocument.getSize() > 5L * 1024 * 1024) {
                redirectAttributes.addFlashAttribute("error", "Document must be 5MB or smaller.");
                return "redirect:/marketplace/earn";
            }
            String contentType = proofDocument.getContentType() != null ? proofDocument.getContentType().toLowerCase() : "";
            String name = proofDocument.getOriginalFilename() != null ? proofDocument.getOriginalFilename().toLowerCase() : "";
            boolean okType = contentType.startsWith("image/") || contentType.equals("application/pdf")
                    || name.endsWith(".pdf") || name.endsWith(".png") || name.endsWith(".jpg")
                    || name.endsWith(".jpeg") || name.endsWith(".webp");
            if (!okType) {
                redirectAttributes.addFlashAttribute("error", "Only PDF or image files are allowed.");
                return "redirect:/marketplace/earn";
            }

            String docPath = fileUploadService.saveFile(proofDocument);

            JobApplication application = new JobApplication();
            application.setUser(user);
            application.setJobCategory(jobCategory);
            application.setJobSubCategory(jobSubCategory);
            application.setHourlyRate(hourlyRate);
            application.setDocumentPath(docPath);

            jobApplicationRepo.save(application);

            redirectAttributes.addFlashAttribute("message", "Your application has been sent");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to submit application: " + e.getMessage());
        }

        return "redirect:/marketplace/earn";
    }
}
