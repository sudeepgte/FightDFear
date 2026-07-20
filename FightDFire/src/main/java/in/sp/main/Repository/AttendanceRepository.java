package in.sp.main.Repository;

import in.sp.main.Entities.Attendance;
import in.sp.main.Entities.User;
import in.sp.main.Entities.OnlineClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    List<Attendance> findByUser(User user);
    List<Attendance> findByOnlineClass(OnlineClass onlineClass);
    List<Attendance> findByUserAndOnlineClass(User user, OnlineClass onlineClass);
    List<Attendance> findByBatchAndAttendanceDate(in.sp.main.Entities.MartialArtsBatch batch, java.time.LocalDate date);
    List<Attendance> findByOnlineClassAndAttendanceDate(OnlineClass onlineClass, java.time.LocalDate date);
    List<Attendance> findByUserAndBatchAndAttendanceDate(User user, in.sp.main.Entities.MartialArtsBatch batch, java.time.LocalDate date);
    List<Attendance> findByUserAndOnlineClassAndAttendanceDate(User user, OnlineClass onlineClass, java.time.LocalDate date);
    List<Attendance> findByUserId(Long userId);
    java.util.Optional<Attendance> findFirstByUserIdOrderByAttendanceDateDesc(Long userId);
}
