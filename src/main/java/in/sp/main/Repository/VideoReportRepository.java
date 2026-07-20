package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import in.sp.main.Entities.VideoReport;
import java.util.List;

public interface VideoReportRepository extends JpaRepository<VideoReport, Long> {
	
	 List<VideoReport> findAllByOrderByReportedAtDesc();

	 // Bulk delete reports by a specific user
	 void deleteByReportedBy_Id(Long userId);

	 // Bulk delete all reports on a user's videos
	 void deleteByVideo_User_Id(Long userId);
}
