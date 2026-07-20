package in.sp.main.Repository;

import in.sp.main.Entities.CreatorSubscription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CreatorSubscriptionRepository extends JpaRepository<CreatorSubscription, Long> {
    Optional<CreatorSubscription> findBySubscriber_IdAndCreator_Id(Long subscriberId, Long creatorId);
    List<CreatorSubscription> findBySubscriber_Id(Long subscriberId);
    List<CreatorSubscription> findByCreator_Id(Long creatorId);
    boolean existsBySubscriber_IdAndCreator_IdAndEndDateAfter(Long subscriberId, Long creatorId, LocalDateTime time);
    int countByCreator_IdAndEndDateAfter(Long creatorId, LocalDateTime time);
}
