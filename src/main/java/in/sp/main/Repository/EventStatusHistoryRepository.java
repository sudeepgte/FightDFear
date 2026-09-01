package in.sp.main.Repository;

import in.sp.main.Entities.EventStatusHistory;
import in.sp.main.Entities.WomenEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventStatusHistoryRepository extends JpaRepository<EventStatusHistory, Long> {
    List<EventStatusHistory> findByEventOrderByCreatedAtDesc(WomenEvent event);
}
