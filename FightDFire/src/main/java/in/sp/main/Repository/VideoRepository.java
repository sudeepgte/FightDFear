package in.sp.main.Repository;



import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Category;
import in.sp.main.Entities.Video;
import in.sp.main.Entities.Videoupload;

public interface VideoRepository extends JpaRepository<Video, Long> {
    List<Video> findByCategory(Category category);
    List<Video> findByIsReel(boolean isReel);
    List<Video> findByCategoryAndIsReel(Category category, boolean isReel);
}
