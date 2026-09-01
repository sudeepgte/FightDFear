package in.sp.main.Repository;

import in.sp.main.Entities.EventAgendaItem;
import in.sp.main.Entities.WomenEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventAgendaItemRepository extends JpaRepository<EventAgendaItem, Long> {
    List<EventAgendaItem> findByEventOrderBySortOrderAscStartTimeAsc(WomenEvent event);
    void deleteByEvent(WomenEvent event);
}
