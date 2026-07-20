package in.sp.main.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorChatMessage;
import in.sp.main.Entities.User;

public interface DoctorChatRepository extends JpaRepository<DoctorChatMessage, Long> {
    List<DoctorChatMessage> findByUserAndDoctorOrderByTimestampAsc(User user, Doctor doctor);
    List<DoctorChatMessage> findByDoctorOrderByTimestampDesc(Doctor doctor);
}
