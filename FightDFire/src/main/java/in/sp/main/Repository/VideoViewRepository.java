package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VideoView;
import in.sp.main.Entities.Videoupload;

@Repository
public interface VideoViewRepository extends JpaRepository<VideoView, Long> {

    boolean existsByVideoAndUser(Videoupload video, User user);

    int countByVideo(Videoupload video);
    
    // Bulk delete views when a video is removed
    void deleteByVideo(Videoupload video);

    // Bulk delete views by a specific user
    void deleteByUserId(Long userId);

    // Bulk delete all views on a user's videos
    void deleteByVideo_User_Id(Long userId);
}
