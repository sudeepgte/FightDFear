package in.sp.main.Repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DangerPoint;
import in.sp.main.Entities.User;

public interface DangerPointRepository extends JpaRepository<DangerPoint, Long> {

    // Purpose: keep map payload bounded while showing the most recent reports.
    List<DangerPoint> findTop500ByOrderByCreatedAtDesc();

    // Purpose: basic per-user rate limiting using last-created timestamp.
    DangerPoint findTop1ByUserOrderByCreatedAtDesc(User user);

    // Purpose: optional cleanup/querying of recent points (used for safer defaults later).
    List<DangerPoint> findByCreatedAtAfter(Date cutoff);
    
    List<DangerPoint> findTop500ByVerifiedOrderByCreatedAtDesc(boolean verified);
    List<DangerPoint> findByVerified(boolean verified);
}

