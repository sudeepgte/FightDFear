package in.sp.main.Entities;

import java.time.LocalTime;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "routine_reminders")
public class RoutineReminder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: reminder belongs to a user.
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String title;
    private String message;

    // Purpose: scheduled time in user local time.
    private LocalTime timeOfDay;

    // Purpose: allow simple weekly recurrence.
    @Enumerated(EnumType.STRING)
    private DayAvailable dayOfWeek;

    private java.time.LocalDate reminderDate;

    private boolean enabled = true;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalTime getTimeOfDay() {
        return timeOfDay;
    }

    public void setTimeOfDay(LocalTime timeOfDay) {
        this.timeOfDay = timeOfDay;
    }

    public DayAvailable getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(DayAvailable dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public java.time.LocalDate getReminderDate() {
        return reminderDate;
    }

    public void setReminderDate(java.time.LocalDate reminderDate) {
        this.reminderDate = reminderDate;
    }
}

