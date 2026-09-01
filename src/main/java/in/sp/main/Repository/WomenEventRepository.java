package in.sp.main.Repository;

import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventCategory;
import in.sp.main.Entities.EventHost;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface WomenEventRepository extends JpaRepository<WomenEvent, Long> {

    List<WomenEvent> findByStatusOrderByCreatedAtDesc(String status);

    List<WomenEvent> findByStatusAndCategoryOrderByEventDateAsc(String status, WomenEventCategory category);

    List<WomenEvent> findByStatusAndCityIgnoreCaseOrderByEventDateAsc(String status, String city);

    List<WomenEvent> findByStatusAndFeaturedTrueOrderByEventDateAsc(String status);

    List<WomenEvent> findByOrganizerOrderByCreatedAtDesc(EventHost organizer);

    List<WomenEvent> findByOrganizerAndStatusOrderByCreatedAtDesc(EventHost organizer, String status);

    @Query("SELECT e FROM WomenEvent e WHERE e.status IN ('APPROVED', 'PUBLISHED', 'SOLD_OUT', 'ONGOING') AND " +
           "(:city IS NULL OR LOWER(e.city) LIKE LOWER(CONCAT('%', :city, '%'))) AND " +
           "(:category IS NULL OR e.category = :category) " +
           "ORDER BY e.eventDate ASC")
    List<WomenEvent> searchApprovedEvents(@Param("city") String city,
                                          @Param("category") WomenEventCategory category);

    @Query("SELECT e FROM WomenEvent e WHERE e.status IN ('APPROVED', 'PUBLISHED', 'SOLD_OUT', 'ONGOING') "
            + "ORDER BY e.createdAt DESC")
    List<WomenEvent> findListedEvents();

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT e FROM WomenEvent e WHERE e.id = :id")
    Optional<WomenEvent> findByIdForUpdate(@Param("id") Long id);

    long countByStatus(String status);
    long countByOrganizerAndStatus(EventHost organizer, String status);
}
