package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.BuddyRequest;
import in.sp.main.Entities.BuddyRequestStatus;
import in.sp.main.Entities.User;

public interface BuddyRequestRepository extends JpaRepository<BuddyRequest, Long> {

    // Purpose: show incoming requests to the receiver.
    List<BuddyRequest> findByToUserAndStatusOrderByCreatedAtDesc(User toUser, BuddyRequestStatus status);

    // Purpose: show outgoing requests to the sender.
    List<BuddyRequest> findByFromUserAndStatusOrderByCreatedAtDesc(User fromUser, BuddyRequestStatus status);

    // Purpose: basic rate limiting for request spam.
    BuddyRequest findTop1ByFromUserOrderByCreatedAtDesc(User fromUser);

    // Purpose: prevent duplicate pending requests to the same user.
    BuddyRequest findTop1ByFromUserAndToUserAndStatusOrderByCreatedAtDesc(
            User fromUser, User toUser, BuddyRequestStatus status);
}

