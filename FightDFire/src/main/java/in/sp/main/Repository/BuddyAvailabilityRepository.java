package in.sp.main.Repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.BuddyAvailability;
import in.sp.main.Entities.User;

public interface BuddyAvailabilityRepository extends JpaRepository<BuddyAvailability, Long> {

    // Purpose: allow showing/stopping the current user's active availability.
    BuddyAvailability findTop1ByUserAndActiveOrderByCreatedAtDesc(User user, boolean active);

    // Purpose: list active, non-expired availabilities for matching.
    List<BuddyAvailability> findByActiveTrueAndExpiresAtAfter(Date now);
}

