package in.sp.main.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.DayAvailable;
import in.sp.main.Entities.ReminderLog;
import in.sp.main.Entities.RoutineReminder;
import in.sp.main.Entities.User;
import in.sp.main.Repository.ReminderLogRepository;
import in.sp.main.Repository.RoutineReminderRepository;

@Service
public class RoutineReminderService {

    @Autowired
    private RoutineReminderRepository reminderRepo;

    @Autowired
    private ReminderLogRepository logRepo;

    public List<RoutineReminder> list(User user) {
        return reminderRepo.findByUserOrderByIdDesc(user);
    }

    public RoutineReminder add(User user, String title, String message, DayAvailable day, java.time.LocalDate date, LocalTime time) {
        RoutineReminder r = new RoutineReminder();
        r.setUser(user);
        r.setTitle(title == null ? "" : title.trim());
        r.setMessage(message == null ? "" : message.trim());
        r.setDayOfWeek(day);
        r.setReminderDate(date);
        r.setTimeOfDay(time);
        r.setEnabled(true);
        return reminderRepo.save(r);
    }

    public void delete(User user, Long id) {
        RoutineReminder r = reminderRepo.findById(id).orElse(null);
        if (r != null && r.getUser() != null && r.getUser().getId().equals(user.getId())) {
            reminderRepo.deleteById(id);
        }
    }

    public void toggle(User user, Long id) {
        RoutineReminder r = reminderRepo.findById(id).orElse(null);
        if (r != null && r.getUser() != null && r.getUser().getId().equals(user.getId())) {
            r.setEnabled(!r.isEnabled());
            reminderRepo.save(r);
        }
    }

    public List<RoutineReminder> triggeredNow(User user) {
        // Purpose: web-only reminders are evaluated when user is online and dashboard loads.
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        DayAvailable day = mapDay(DayOfWeek.from(today));

        List<RoutineReminder> all = reminderRepo.findByUserOrderByIdDesc(user);
        List<RoutineReminder> out = new ArrayList<>();

        for (RoutineReminder r : all) {
            if (!r.isEnabled()) continue;
            
            // Priority: if date is set, it must match today. If not set, check dayOfWeek.
            if (r.getReminderDate() != null) {
                if (!r.getReminderDate().equals(today)) continue;
            } else if (r.getDayOfWeek() != null) {
                if (r.getDayOfWeek() != day) continue;
            } else {
                // if neither is set, skip.
                continue;
            }

            if (r.getTimeOfDay() == null) continue;

            // Purpose: show within 30 minutes after scheduled time.
            LocalTime start = r.getTimeOfDay();
            LocalTime end = start.plusMinutes(30);
            if (now.isBefore(start) || now.isAfter(end)) continue;

            if (logRepo.existsByReminderIdAndShownOn(r.getId(), today)) continue;
            out.add(r);
        }
        return out;
    }

    public void markShown(Long reminderId) {
        RoutineReminder r = reminderRepo.findById(reminderId).orElse(null);
        if (r == null) return;
        LocalDate today = LocalDate.now();
        if (logRepo.existsByReminderIdAndShownOn(reminderId, today)) return;

        ReminderLog log = new ReminderLog();
        log.setReminder(r);
        log.setShownOn(today);
        logRepo.save(log);
    }

    private static DayAvailable mapDay(DayOfWeek d) {
        return switch (d) {
            case MONDAY -> DayAvailable.MONDAY;
            case TUESDAY -> DayAvailable.TUESDAY;
            case WEDNESDAY -> DayAvailable.WEDNESDAY;
            case THURSDAY -> DayAvailable.THURSDAY;
            case FRIDAY -> DayAvailable.FRIDAY;
            case SATURDAY -> DayAvailable.SATURDAY;
            case SUNDAY -> DayAvailable.SUNDAY;
        };
    }
}

