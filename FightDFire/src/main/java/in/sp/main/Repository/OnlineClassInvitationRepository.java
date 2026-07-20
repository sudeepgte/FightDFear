package in.sp.main.Repository;

import in.sp.main.Entities.OnlineClassInvitation;
import in.sp.main.Entities.User;
import in.sp.main.Entities.OnlineClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface OnlineClassInvitationRepository extends JpaRepository<OnlineClassInvitation, Long> {
    List<OnlineClassInvitation> findByTraineeAndStatus(User trainee, OnlineClassInvitation.InviteStatus status);
    Optional<OnlineClassInvitation> findFirstByTraineeAndOnlineClassOrderByIdDesc(User trainee, OnlineClass onlineClass);
    List<OnlineClassInvitation> findByOnlineClass(OnlineClass onlineClass);
    long countByTraineeAndStatus(User trainee, OnlineClassInvitation.InviteStatus status);
}
