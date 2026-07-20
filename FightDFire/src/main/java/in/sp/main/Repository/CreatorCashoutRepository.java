package in.sp.main.Repository;

import in.sp.main.Entities.CreatorCashout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreatorCashoutRepository extends JpaRepository<CreatorCashout, Long> {
    List<CreatorCashout> findByCreator_Id(Long creatorId);
    List<CreatorCashout> findByStatus(String status);
}
