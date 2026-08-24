package in.sp.main.Repository;

import in.sp.main.Entities.FitnessQrAttendanceSession;
import in.sp.main.Entities.FitnessTrainer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface FitnessQrAttendanceSessionRepository extends JpaRepository<FitnessQrAttendanceSession, Long> {

    Optional<FitnessQrAttendanceSession> findByToken(String token);

    Optional<FitnessQrAttendanceSession> findFirstByTrainerAndSessionDateAndActiveTrueOrderByCreatedAtDesc(
            FitnessTrainer trainer, LocalDate sessionDate);

    List<FitnessQrAttendanceSession> findByTrainerOrderByCreatedAtDesc(FitnessTrainer trainer);
}
