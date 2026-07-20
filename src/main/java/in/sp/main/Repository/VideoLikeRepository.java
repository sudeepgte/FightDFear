package in.sp.main.Repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VideoLike;
import in.sp.main.Entities.Videoupload;

@Repository
public interface VideoLikeRepository extends JpaRepository<VideoLike, Long> {

    Optional<VideoLike> findByUserIdAndVideoId(Long userId, Long videoId);

    long countByVideoId(Long videoId);

	 int countByVideo(Videoupload video);
	

	Optional<VideoLike> findByUserAndVideo(User user, Videoupload video);
	
	 boolean existsByUserAndVideo(User user, Videoupload video);

	Optional<VideoLike> findByVideoAndUser(Videoupload video, User user);

	boolean existsByVideoAndUser(Videoupload v, User currentUser);
	
	// Bulk delete likes when a video is removed
	void deleteByVideo(Videoupload video);

	// Bulk delete likes by a specific user
	void deleteByUserId(Long userId);

	// Bulk delete all likes on a user's videos
	void deleteByVideo_User_Id(Long userId);
}
