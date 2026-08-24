package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.FinancialWorkshop;

public interface FinancialWorkshopRepository extends JpaRepository<FinancialWorkshop, Long> {
    List<FinancialWorkshop> findByPublishedTrueOrderByCreatedAtDesc();
    List<FinancialWorkshop> findByEducator_IdOrderByCreatedAtDesc(Long educatorId);
}
