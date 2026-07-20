package in.sp.main.Repository;

import in.sp.main.Entities.UserBlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserBlockRepository extends JpaRepository<UserBlock, Long> {
    boolean existsByUser_IdAndBlockedUser_Id(Long userId, Long blockedUserId);
    List<UserBlock> findByUser_Id(Long userId);
    Optional<UserBlock> findByUser_IdAndBlockedUser_Id(Long userId, Long blockedUserId);
}
