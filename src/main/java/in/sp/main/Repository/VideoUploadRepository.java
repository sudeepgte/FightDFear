package in.sp.main.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Video;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Entities.User;

@Repository
public interface VideoUploadRepository extends JpaRepository<Videoupload, Long> {
	List<Videoupload> findByUser_Id(Long userId);
	
	List<Videoupload> findByUserId(Long userId);
	
	List<Videoupload> findByUser_IdAndIsReel(Long userId, boolean isReel);
	
	List<Videoupload> findByIsReel(boolean isReel);

	// Bulk delete all videos uploaded by a user
	void deleteByUserId(Long userId);
}
