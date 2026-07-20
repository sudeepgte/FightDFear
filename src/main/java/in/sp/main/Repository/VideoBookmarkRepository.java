package in.sp.main.Repository;

import in.sp.main.Entities.VideoBookmark;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VideoBookmarkRepository extends JpaRepository<VideoBookmark, Long> {
    boolean existsByUser_IdAndVideo_Id(Long userId, Long videoId);
    Optional<VideoBookmark> findByUser_IdAndVideo_Id(Long userId, Long videoId);
    List<VideoBookmark> findByUser_Id(Long userId);
}
