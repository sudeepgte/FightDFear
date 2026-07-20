package in.sp.main.Controller;

import in.sp.main.dto.ScheduleResponseDTO;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ScheduleController {

    @Autowired
    private EnrollmentRepository enrollmentRepository;
    
    @Autowired
    private AttendanceRepository attendanceRepository;
    
    @Autowired
    private TrainingSessionRepository sessionRepository;

    @Autowired
    private OnlineClassRepository onlineClassRepository;

    @Autowired
    private OnlineClassEnrollmentRepository onlineClassEnrollmentRepository;

    @GetMapping("/users/my-schedule")
    public String showMySchedule(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "mySchedule";
    }

    @GetMapping("/api/schedule/my-schedule")
    @ResponseBody
    public ScheduleResponseDTO getMySchedule(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ScheduleResponseDTO(new ArrayList<>(), 0, 0, 0, 0, 0, 0);

        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        List<OnlineClassEnrollment> onlineEnrollments = onlineClassEnrollmentRepository.findByTrainee(user);
        List<Attendance> userAttendances = attendanceRepository.findByUser(user);
        
        List<Map<String, Object>> scheduleData = new ArrayList<>();
        int attended = 0;
        int missed = 0;
        double totalHours = 0;

        for (Attendance a : userAttendances) {
            Map<String, Object> map = new HashMap<>();
            map.put("key", "att-" + a.getId());
            
            if (a.getSession() != null) {
                map.put("date", a.getSession().getDate() != null ? a.getSession().getDate().toString() : "N/A");
                map.put("batch", a.getSession().getBatch() != null ? a.getSession().getBatch().getName() : "Unknown");
                map.put("timeSlot", a.getSession().getStartTime() + " – " + a.getSession().getEndTime());
                map.put("trainer", a.getSession().getTrainer());
                map.put("duration", a.getSession().getDuration());
            } else if (a.getOnlineClass() != null) {
                map.put("date", a.getOnlineClass().getDate() != null ? a.getOnlineClass().getDate().toString() : "N/A");
                map.put("batch", a.getOnlineClass().getTitle());
                map.put("timeSlot", a.getOnlineClass().getStartTime() + " – " + a.getOnlineClass().getEndTime());
                map.put("trainer", a.getOnlineClass().getTrainer() != null ? a.getOnlineClass().getTrainer().getFullName() : "N/A");
                map.put("duration", "1.0"); // Default 1 hr for online
            } else {
                continue;
            }
            
            map.put("status", a.getStatus() != null ? a.getStatus().toString() : "UNKNOWN");
            map.put("notes", a.getNotes());
            scheduleData.add(map);

            if (a.getStatus() == AttendanceStatus.PRESENT || a.getStatus() == AttendanceStatus.LATE) {
                attended++;
                try {
                    String durStr = (String) map.get("duration");
                    if (durStr != null) {
                        String dur = durStr.replaceAll("[^0-9.]", "");
                        if (!dur.isEmpty()) totalHours += Double.parseDouble(dur);
                    }
                } catch (Exception ignored) {}
            } else if (a.getStatus() == AttendanceStatus.ABSENT) {
                missed++;
            }
        }

        int upcoming = 0;
        // Offline Upcoming
        for (Enrollment e : enrollments) {
            if (e.getBatch() == null) continue;
            List<TrainingSession> batchSessions = sessionRepository.findByBatch(e.getBatch());
            for (TrainingSession s : batchSessions) {
                boolean alreadyIn = userAttendances.stream().filter(a -> a.getSession() != null).anyMatch(a -> a.getSession().getId().equals(s.getId()));
                if (!alreadyIn && s.getDate() != null && s.getDate().isAfter(java.time.LocalDate.now().minusDays(1))) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("key", "sess-" + s.getId());
                    map.put("date", s.getDate().toString());
                    map.put("batch", s.getBatch().getName());
                    map.put("timeSlot", s.getStartTime() + " – " + s.getEndTime());
                    map.put("trainer", s.getTrainer());
                    map.put("status", "UPCOMING");
                    map.put("duration", s.getDuration());
                    map.put("notes", s.getNotes());
                    scheduleData.add(map);
                    upcoming++;
                }
            }
        }
        
        // Online Upcoming
        for (OnlineClassEnrollment oce : onlineEnrollments) {
            OnlineClass oc = oce.getOnlineClass();
            if (oc == null) continue;
            boolean alreadyIn = userAttendances.stream().filter(a -> a.getOnlineClass() != null).anyMatch(a -> a.getOnlineClass().getId().equals(oc.getId()));
            if (!alreadyIn && oc.getDate() != null && oc.getDate().isAfter(java.time.LocalDate.now().minusDays(1))) {
                Map<String, Object> map = new HashMap<>();
                map.put("key", "oc-" + oc.getId());
                map.put("date", oc.getDate().toString());
                map.put("batch", oc.getTitle());
                map.put("timeSlot", oc.getStartTime() + " – " + oc.getEndTime());
                map.put("trainer", oc.getTrainer() != null ? oc.getTrainer().getFullName() : "N/A");
                map.put("status", "UPCOMING");
                map.put("duration", "1.0");
                map.put("notes", "Virtual Dojo Session");
                scheduleData.add(map);
                upcoming++;
            }
        }

        double rate = (attended + missed > 0) ? (double) attended / (attended + missed) * 100 : 0;

        return new ScheduleResponseDTO(
            scheduleData, 
            scheduleData.size(),
            attended,
            missed,
            upcoming,
            totalHours,
            Math.round(rate * 10.0) / 10.0
        );
    }
}
