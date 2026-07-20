package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.ReminderLog;

public interface ReminderLogRepository extends JpaRepository<ReminderLog, Long> {
    boolean existsByReminderIdAndShownOn(Long reminderId, java.time.LocalDate shownOn);
}

