package in.sp.main.Repository;

import in.sp.main.Entities.JobWorkerReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JobWorkerReviewRepository extends JpaRepository<JobWorkerReview, Long> {
    List<JobWorkerReview> findByJobApplicationIdOrderByCreatedAtDesc(Long jobApplicationId);
}
