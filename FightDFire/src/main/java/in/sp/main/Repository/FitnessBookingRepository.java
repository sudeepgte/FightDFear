package in.sp.main.Repository;

import in.sp.main.Entities.FitnessBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FitnessBookingRepository extends JpaRepository<FitnessBooking, Long> {
    List<FitnessBooking> findByUser_Id(Long userId);
    List<FitnessBooking> findByTrainer_Id(Long trainerId);
    List<FitnessBooking> findByStatus(String status);
    List<FitnessBooking> findByFitnessClass_Id(Long classId);
}
