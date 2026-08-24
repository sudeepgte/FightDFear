package in.sp.main.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorChatMessage;
import in.sp.main.Entities.User;

public interface DoctorChatRepository extends JpaRepository<DoctorChatMessage, Long> {
    List<DoctorChatMessage> findByUserAndDoctorOrderByTimestampAsc(User user, Doctor doctor);
    List<DoctorChatMessage> findByDoctorOrderByTimestampDesc(Doctor doctor);

    long countByDoctorAndSenderTypeAndReadByDoctorFalse(Doctor doctor, String senderType);

    List<DoctorChatMessage> findByDoctorAndSenderTypeAndReadByDoctorFalse(Doctor doctor, String senderType);

    List<DoctorChatMessage> findByDoctorAndUserAndSenderTypeAndReadByDoctorFalse(Doctor doctor, User user, String senderType);

    @org.springframework.data.jpa.repository.Query("SELECT DISTINCT m.doctor FROM DoctorChatMessage m WHERE m.user.id = :userId")
    List<Doctor> findChattedDoctorsByUser(@org.springframework.data.repository.query.Param("userId") Long userId);
}
