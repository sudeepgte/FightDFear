package in.sp.main.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.VideoComment;

public interface VideoCommentRepository extends JpaRepository<VideoComment, Long> {
    List<VideoComment> findByVideoId(Long videoId);

	List<VideoComment> findByVideo_Id(Long videoId);

	@Query("SELECT c FROM VideoComment c LEFT JOIN FETCH c.user WHERE c.video.id = :videoId AND c.parent IS NULL ORDER BY c.id ASC")
	List<VideoComment> findTopLevelWithUserByVideoId(@Param("videoId") Long videoId);

	@Query("SELECT r FROM VideoComment r LEFT JOIN FETCH r.user WHERE r.parent.id = :parentId ORDER BY r.id ASC")
	List<VideoComment> findRepliesWithUserByParentId(@Param("parentId") Long parentId);
	
	// Bulk delete comments when a video is removed
	void deleteByVideoId(Long videoId);

	// Bulk delete comments made by a specific user (called before user deletion)
	void deleteByUser_Id(Long userId);

	// Bulk delete all comments on a user's videos
	void deleteByVideo_User_Id(Long userId);
	
}
