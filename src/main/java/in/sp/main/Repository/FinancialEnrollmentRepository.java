package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.FinancialEnrollment;

public interface FinancialEnrollmentRepository extends JpaRepository<FinancialEnrollment, Long> {
    List<FinancialEnrollment> findByLiveSession_IdOrderByCreatedAtDesc(Long liveSessionId);
    List<FinancialEnrollment> findByWorkshop_IdOrderByCreatedAtDesc(Long workshopId);
    List<FinancialEnrollment> findByUser_IdOrderByCreatedAtDesc(Long userId);
    List<FinancialEnrollment> findByKindOrderByCreatedAtDesc(String kind);
    long countByLiveSession_IdAndStatusIn(Long liveSessionId, List<String> statuses);
    long countByWorkshop_IdAndStatusIn(Long workshopId, List<String> statuses);
    boolean existsByUser_IdAndLiveSession_IdAndStatusIn(Long userId, Long liveSessionId, List<String> statuses);
    boolean existsByUser_IdAndWorkshop_IdAndStatusIn(Long userId, Long workshopId, List<String> statuses);
}
