package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.ExpressComment;

@Repository
public interface ExpressCommentRepository extends JpaRepository<ExpressComment, Long> {
    List<ExpressComment> findByPostId(Long postId);
    List<ExpressComment> findByUserId(Long userId);
}
