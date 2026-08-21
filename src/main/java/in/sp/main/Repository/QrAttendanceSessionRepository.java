package in.sp.main.Repository;

import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.QrAttendanceSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface QrAttendanceSessionRepository extends JpaRepository<QrAttendanceSession, Long> {

    Optional<QrAttendanceSession> findByToken(String token);

    Optional<QrAttendanceSession> findByTokenAndActiveTrue(String token);

    List<QrAttendanceSession> findByCenterAndSessionDateAndActiveTrue(MartialArtsCenter center, LocalDate sessionDate);

    List<QrAttendanceSession> findByBatchAndSessionDateAndActiveTrue(MartialArtsBatch batch, LocalDate sessionDate);

    Optional<QrAttendanceSession> findFirstByBatchAndSessionDateAndActiveTrueOrderByCreatedAtDesc(MartialArtsBatch batch, LocalDate sessionDate);

    List<QrAttendanceSession> findByCenter_IdOrderByCreatedAtDesc(Long centerId);
}
