package in.sp.main.Repository;

import in.sp.main.Entities.WomenEventReview;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface WomenEventReviewRepository extends JpaRepository<WomenEventReview, Long> {

    List<WomenEventReview> findByEventOrderByCreatedAtDesc(WomenEvent event);

    Optional<WomenEventReview> findByEventAndUser(WomenEvent event, User user);

    boolean existsByEventAndUser(WomenEvent event, User user);

    @Query("SELECT AVG(r.rating) FROM WomenEventReview r WHERE r.event = :event")
    Double getAverageRating(@Param("event") WomenEvent event);
}
