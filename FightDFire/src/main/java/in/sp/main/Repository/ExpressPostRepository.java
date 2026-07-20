package in.sp.main.Repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.ExpressPost;
import in.sp.main.Entities.ExpressPostType;

@Repository
public interface ExpressPostRepository extends JpaRepository<ExpressPost, Long> {
    List<ExpressPost> findByUserId(Long userId);
    List<ExpressPost> findByCreatedAtAfter(LocalDateTime dateTime);

    // Purpose: list community stories/tips by category.
    List<ExpressPost> findByPostTypeOrderByCreatedAtDesc(ExpressPostType postType);

    List<ExpressPost> findTop10ByPostTypeOrderByCreatedAtDesc(ExpressPostType postType);
}
