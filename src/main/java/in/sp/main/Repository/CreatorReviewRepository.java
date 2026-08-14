package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.CreatorReview;
import in.sp.main.Entities.User;

public interface CreatorReviewRepository extends JpaRepository<CreatorReview, Long> {

    Optional<CreatorReview> findByCreatorAndUser(User creator, User user);

    boolean existsByCreatorAndUser(User creator, User user);

    List<CreatorReview> findByCreatorOrderByCreatedAtDesc(User creator);

    @Query("SELECT AVG(r.rating) FROM CreatorReview r WHERE r.creator = :creator")
    Double getAverageRating(@Param("creator") User creator);
}
