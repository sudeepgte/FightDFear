package in.sp.main.Repository;

import in.sp.main.Entities.EventTicketType;
import in.sp.main.Entities.WomenEvent;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface EventTicketTypeRepository extends JpaRepository<EventTicketType, Long> {

    List<EventTicketType> findByEventOrderByIdAsc(WomenEvent event);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT t FROM EventTicketType t WHERE t.id = :id")
    Optional<EventTicketType> findByIdForUpdate(@Param("id") Long id);
}
