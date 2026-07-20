package in.sp.main.Repository;

import in.sp.main.Entities.SOSContactResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SOSContactResponseRepository extends JpaRepository<SOSContactResponse, Long> {
    
    List<SOSContactResponse> findBySosRequestId(Long sosRequestId);
    
    Optional<SOSContactResponse> findByUniqueToken(String uniqueToken);
    
    List<SOSContactResponse> findBySosRequestIdAndResponseStatus(Long sosRequestId, SOSContactResponse.ResponseStatus status);
    
    long countBySosRequestIdAndResponseStatus(Long sosRequestId, SOSContactResponse.ResponseStatus status);
    
    List<SOSContactResponse> findByResponseStatusAndNotifiedAtBefore(SOSContactResponse.ResponseStatus status, java.time.LocalDateTime time);
}
