package in.sp.main.Entities;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "reminder_logs")
public class ReminderLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: which reminder was shown.
    @ManyToOne
    @JoinColumn(name = "reminder_id")
    private RoutineReminder reminder;

    // Purpose: prevent re-showing multiple times per day.
    private LocalDate shownOn;

    private LocalDateTime shownAt = LocalDateTime.now();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public RoutineReminder getReminder() {
        return reminder;
    }

    public void setReminder(RoutineReminder reminder) {
        this.reminder = reminder;
    }

    public LocalDate getShownOn() {
        return shownOn;
    }

    public void setShownOn(LocalDate shownOn) {
        this.shownOn = shownOn;
    }

    public LocalDateTime getShownAt() {
        return shownAt;
    }

    public void setShownAt(LocalDateTime shownAt) {
        this.shownAt = shownAt;
    }
}

