package in.sp.main.Repository;

import in.sp.main.Entities.BrandCollaboration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BrandCollaborationRepository extends JpaRepository<BrandCollaboration, Long> {
    List<BrandCollaboration> findByStatus(String status);
}
