package in.sp.main.Repository;

import in.sp.main.Entities.EventSpeaker;
import in.sp.main.Entities.WomenEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventSpeakerRepository extends JpaRepository<EventSpeaker, Long> {
    List<EventSpeaker> findByEventOrderBySortOrderAscIdAsc(WomenEvent event);
    void deleteByEvent(WomenEvent event);
}
