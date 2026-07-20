package in.sp.main.Repository;

import in.sp.main.Entities.CreatorStory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface CreatorStoryRepository extends JpaRepository<CreatorStory, Long> {
    List<CreatorStory> findByUser_Id(Long userId);
    List<CreatorStory> findByUser_IdAndIsDraftFalseAndUploadTimeAfter(Long userId, LocalDateTime time);
    List<CreatorStory> findByIsDraftFalseAndUploadTimeAfter(LocalDateTime time);
}
