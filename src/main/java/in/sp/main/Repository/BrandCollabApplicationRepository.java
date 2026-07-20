package in.sp.main.Repository;

import in.sp.main.Entities.BrandCollabApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BrandCollabApplicationRepository extends JpaRepository<BrandCollabApplication, Long> {
    List<BrandCollabApplication> findByCreator_Id(Long creatorId);
    List<BrandCollabApplication> findByCollaboration_Id(Long collaborationId);
    boolean existsByCollaboration_IdAndCreator_Id(Long collaborationId, Long creatorId);
}
