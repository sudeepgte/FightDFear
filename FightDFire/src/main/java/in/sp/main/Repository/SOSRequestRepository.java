package in.sp.main.Repository;

import in.sp.main.Entities.SOSRequest;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SOSRequestRepository extends JpaRepository<SOSRequest, Long> {
    
    List<SOSRequest> findByUser(User user);
    
    List<SOSRequest> findByUserOrderByActivatedAtDesc(User user);
    
    Optional<SOSRequest> findTopByUserAndStatusOrderByActivatedAtDesc(User user, SOSRequest.SOSStatus status);
    
    List<SOSRequest> findByStatusAndActivatedAtBefore(SOSRequest.SOSStatus status, LocalDateTime time);
    
    List<SOSRequest> findByIsEscalatedFalseAndStatus(SOSRequest.SOSStatus status);
    
    List<SOSRequest> findByStatus(SOSRequest.SOSStatus status);
}
