package in.sp.main.Repository;

import in.sp.main.Entities.PaidContentUnlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaidContentUnlockRepository extends JpaRepository<PaidContentUnlock, Long> {
    boolean existsByUser_IdAndVideo_Id(Long userId, Long videoId);
    List<PaidContentUnlock> findByUser_Id(Long userId);
    List<PaidContentUnlock> findByVideo_Id(Long videoId);
}
