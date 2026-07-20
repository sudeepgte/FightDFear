package in.sp.main.Controller;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.User;
import in.sp.main.Repository.DoctorAppointmentRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/consultation")
public class ConsultationController {

    @Autowired
    private DoctorAppointmentRepository appointmentRepo;

    @GetMapping("/video/{apptId}")
    public String joinVideoCall(@PathVariable Long apptId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Doctor doctor = (Doctor) session.getAttribute("loggedDoctor");

        DoctorAppointment appt = appointmentRepo.findById(apptId).orElse(null);
        if (appt == null) return "redirect:/";

        // Authorization check
        boolean isAuthorized = false;
        if (user != null && appt.getUser().getId().equals(user.getId())) {
            isAuthorized = true;
            model.addAttribute("displayName", user.getFullName());
        } else if (doctor != null && appt.getDoctor().getId().equals(doctor.getId())) {
            isAuthorized = true;
            model.addAttribute("displayName", "Dr. " + doctor.getFullName());
        }

        if (!isAuthorized) {
            return "redirect:/login";
        }

        if (appt.getMeetingRoomId() == null) {
            return "redirect:/";
        }

        model.addAttribute("appointment", appt);
        model.addAttribute("roomName", appt.getMeetingRoomId());
        return "doctor/video-call";
    }
}
