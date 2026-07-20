package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Comment;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByQuestionId(Long questionId);
}