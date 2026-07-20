package in.sp.main.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.HttpSession;

/**
 * Purpose: handles all /volunteer/** routes that were previously unimplemented,
 * causing 404 Whitelabel Errors. Volunteers are regular Users whose
 * verificationStatus is managed by the admin; there is no separate Volunteer entity.
 */
@Controller
@RequestMapping("/volunteer")
public class VolunteerController {

    @Autowired
    private UserRepository userRepository;

    // ── /volunteer/admin/volunteers ──────────────────────────────────────────
    // Purpose: main volunteer management page — shows all users so admin can
    // verify/reject them as volunteers.
    @GetMapping("/admin/volunteers")
    public String listAllVolunteers(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<User> volunteers = userRepository.findAll();
        model.addAttribute("volunteers", volunteers);
        return "approvedVolunteers";
    }

    // ── /volunteer/approved-volunteers ──────────────────────────────────────
    // Purpose: shows only VERIFIED users (approved volunteers).
    @GetMapping("/approved-volunteers")
    public String listApprovedVolunteers(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<User> volunteers = userRepository.findByVerificationStatus(VerificationStatus.VERIFIED);
        model.addAttribute("volunteers", volunteers);
        return "approvedVolunteers";
    }

    // ── /volunteer/pending-volunteers ────────────────────────────────────────
    // Purpose: shows PENDING users waiting for admin approval.
    @GetMapping("/pending-volunteers")
    public String listPendingVolunteers(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<User> pending = userRepository.findByVerificationStatus(VerificationStatus.PENDING);
        pending.addAll(userRepository.findByVerificationStatusIsNull());
        model.addAttribute("volunteers", pending);
        return "pendingVolunteers";
    }

    // ── /volunteer/reported-volunteers ──────────────────────────────────────
    // Purpose: shows REJECTED users (treated as "reported/blocked" volunteers).
    @GetMapping("/reported-volunteers")
    public String listReportedVolunteers(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<User> rejected = userRepository.findByVerificationStatus(VerificationStatus.REJECTED);
        // Purpose: JSP iterates ${reportedVolunteers} — we pass rejected users here.
        model.addAttribute("reportedVolunteers", rejected);
        return "reportedVolunteers";
    }

    // ── /volunteer/admin/volunteer/{id}/verify  (POST) ───────────────────────
    // Purpose: admin verifies a volunteer by setting their status to VERIFIED.
    @PostMapping("/admin/volunteer/{id}/verify")
    public String verifyVolunteer(@PathVariable Long id,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("error", "Volunteer not found.");
            return "redirect:/volunteer/pending-volunteers";
        }
        u.setVerificationStatus(VerificationStatus.VERIFIED);
        userRepository.save(u);
        redirectAttributes.addFlashAttribute("message", "Volunteer verified successfully.");
        return "redirect:/volunteer/pending-volunteers";
    }

    // ── /admin/rejectvolunteer/{id}  (POST) ──────────────────────────────────
    // Purpose: admin rejects/blocks a volunteer. Mapped under /admin to match
    // the existing form actions in approvedVolunteers.jsp and pendingVolunteers.jsp.
    @PostMapping("/admin/rejectvolunteer/{id}")
    public String rejectVolunteer(@PathVariable Long id,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("error", "Volunteer not found.");
            return "redirect:/volunteer/approved-volunteers";
        }
        u.setVerificationStatus(VerificationStatus.REJECTED);
        userRepository.save(u);
        redirectAttributes.addFlashAttribute("message", "Volunteer rejected.");
        return "redirect:/volunteer/approved-volunteers";
    }

    // ── /volunteer/admin/successReports ─────────────────────────────────────
    // Purpose: placeholder for volunteer success reports page.
    @GetMapping("/admin/successReports")
    public String successReports(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        return "adminAllSucessReports";
    }
}
