package in.sp.main.Repository;

import in.sp.main.Entities.JobWorkerFavorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface JobWorkerFavoriteRepository extends JpaRepository<JobWorkerFavorite, Long> {
    List<JobWorkerFavorite> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<JobWorkerFavorite> findByUserIdAndJobApplicationId(Long userId, Long jobApplicationId);
    boolean existsByUserIdAndJobApplicationId(Long userId, Long jobApplicationId);
}
