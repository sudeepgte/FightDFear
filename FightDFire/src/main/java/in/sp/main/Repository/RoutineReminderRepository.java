package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.RoutineReminder;
import in.sp.main.Entities.User;

public interface RoutineReminderRepository extends JpaRepository<RoutineReminder, Long> {
    List<RoutineReminder> findByUserOrderByIdDesc(User user);
}

