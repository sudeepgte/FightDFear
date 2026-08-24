package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.CentreReview;

public interface CentreReviewRepository extends JpaRepository<CentreReview, Long> {
    List<CentreReview> findByCentre_IdOrderByCreatedAtDesc(Long centreId);
    boolean existsByUser_IdAndCentre_Id(Long userId, Long centreId);
}
