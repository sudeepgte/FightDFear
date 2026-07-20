package in.sp.main.Repository;

import in.sp.main.Entities.MartialArtsBatch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MartialArtsBatchRepository extends JpaRepository<MartialArtsBatch, Long> {
    List<MartialArtsBatch> findByCenterId(Long centerId);
}
