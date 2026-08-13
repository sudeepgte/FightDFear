package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.FinancialLiveSession;

public interface FinancialLiveSessionRepository extends JpaRepository<FinancialLiveSession, Long> {
    List<FinancialLiveSession> findByPublishedTrueOrderByCreatedAtDesc();
    List<FinancialLiveSession> findByEducator_IdOrderByCreatedAtDesc(Long educatorId);
}
