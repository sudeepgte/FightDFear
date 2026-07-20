package in.sp.main.Repository;

import in.sp.main.Entities.OnlineClassEnrollment;
import in.sp.main.Entities.User;
import in.sp.main.Entities.OnlineClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface OnlineClassEnrollmentRepository extends JpaRepository<OnlineClassEnrollment, Long> {
    List<OnlineClassEnrollment> findByTrainee(User trainee);
    Optional<OnlineClassEnrollment> findFirstByTraineeAndOnlineClassOrderByIdDesc(User trainee, OnlineClass onlineClass);
    List<OnlineClassEnrollment> findByOnlineClass(OnlineClass onlineClass);
}
