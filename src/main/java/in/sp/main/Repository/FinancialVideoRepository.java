package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.FinancialVideo;

public interface FinancialVideoRepository extends JpaRepository<FinancialVideo, Long> {
    List<FinancialVideo> findByPublishedTrueOrderByCreatedAtDesc();
    List<FinancialVideo> findByEducator_IdOrderByCreatedAtDesc(Long educatorId);
}
