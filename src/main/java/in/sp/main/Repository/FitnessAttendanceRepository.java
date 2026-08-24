package in.sp.main.Repository;

import in.sp.main.Entities.FitnessAttendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface FitnessAttendanceRepository extends JpaRepository<FitnessAttendance, Long> {
    List<FitnessAttendance> findByBooking_IdOrderBySessionDateDesc(Long bookingId);
    List<FitnessAttendance> findByUser_IdOrderBySessionDateDesc(Long userId);
    List<FitnessAttendance> findByTrainer_IdOrderBySessionDateDesc(Long trainerId);
    List<FitnessAttendance> findByTrainer_IdAndSessionDate(Long trainerId, LocalDate sessionDate);
    boolean existsByBooking_IdAndSessionDate(Long bookingId, LocalDate sessionDate);
    long countByUser_IdAndStatus(Long userId, String status);
    long countByTrainer_Id(Long trainerId);
}
