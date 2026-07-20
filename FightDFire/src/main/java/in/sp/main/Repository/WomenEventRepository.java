package in.sp.main.Repository;

import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventCategory;
import in.sp.main.Entities.User;
import in.sp.main.Entities.EventHost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface WomenEventRepository extends JpaRepository<WomenEvent, Long> {

    List<WomenEvent> findByStatusOrderByCreatedAtDesc(String status);

    List<WomenEvent> findByStatusAndCategoryOrderByEventDateAsc(String status, WomenEventCategory category);

    List<WomenEvent> findByStatusAndCityIgnoreCaseOrderByEventDateAsc(String status, String city);

    List<WomenEvent> findByStatusAndFeaturedTrueOrderByEventDateAsc(String status);

    List<WomenEvent> findByOrganizerOrderByCreatedAtDesc(EventHost organizer);

    @Query("SELECT e FROM WomenEvent e WHERE e.status = 'APPROVED' AND " +
           "(:city IS NULL OR LOWER(e.city) LIKE LOWER(CONCAT('%', :city, '%'))) AND " +
           "(:category IS NULL OR e.category = :category) " +
           "ORDER BY e.eventDate ASC")
    List<WomenEvent> searchApprovedEvents(@Param("city") String city,
                                          @Param("category") WomenEventCategory category);

    long countByStatus(String status);
}
