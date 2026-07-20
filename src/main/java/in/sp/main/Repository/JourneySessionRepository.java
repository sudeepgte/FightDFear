package in.sp.main.Repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.JourneySession;
import in.sp.main.Entities.JourneyStatus;
import in.sp.main.Entities.User;

public interface JourneySessionRepository extends JpaRepository<JourneySession, Long> {

    // Purpose: show the latest active journey for the user.
    JourneySession findTop1ByUserAndStatusOrderByCreatedAtDesc(User user, JourneyStatus status);

    // Purpose: scheduler query to find overdue active journeys.
    List<JourneySession> findByStatusAndExpectedArrivalAtBefore(JourneyStatus status, Date cutoff);
}

