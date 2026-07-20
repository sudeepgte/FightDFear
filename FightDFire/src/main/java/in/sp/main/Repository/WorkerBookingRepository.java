package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.WorkerBooking;

@Repository
public interface WorkerBookingRepository extends JpaRepository<WorkerBooking, Long> {
    List<WorkerBooking> findByClient_Id(Long clientId);
    List<WorkerBooking> findByJobApplication_User_Id(Long workerUserId);
    List<WorkerBooking> findByJobApplication_Id(Long jobApplicationId);
}
