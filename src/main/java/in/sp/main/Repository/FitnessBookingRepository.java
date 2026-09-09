package in.sp.main.Repository;

import in.sp.main.Entities.FitnessBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FitnessBookingRepository extends JpaRepository<FitnessBooking, Long> {
    List<FitnessBooking> findByUser_Id(Long userId);
    List<FitnessBooking> findByTrainer_Id(Long trainerId);
    List<FitnessBooking> findByTrainer_IdAndBookingDate(Long trainerId, java.time.LocalDate bookingDate);
    List<FitnessBooking> findByUser_IdAndTrainer_Id(Long userId, Long trainerId);
    List<FitnessBooking> findByStatus(String status);
    List<FitnessBooking> findByFitnessClass_Id(Long classId);

    @org.springframework.data.jpa.repository.Lock(jakarta.persistence.LockModeType.PESSIMISTIC_WRITE)
    @org.springframework.data.jpa.repository.Query("SELECT b FROM FitnessBooking b WHERE b.id = :id")
    java.util.Optional<FitnessBooking> findByIdForUpdate(@org.springframework.data.repository.query.Param("id") Long id);
}
