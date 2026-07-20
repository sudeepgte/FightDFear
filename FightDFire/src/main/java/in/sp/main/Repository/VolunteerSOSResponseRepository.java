package in.sp.main.Repository;

import in.sp.main.Entities.VolunteerSOSResponse;
import in.sp.main.Entities.SOSRequest;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VolunteerSOSResponseRepository extends JpaRepository<VolunteerSOSResponse, Long> {
    List<VolunteerSOSResponse> findBySosRequest(SOSRequest sosRequest);
    Optional<VolunteerSOSResponse> findBySosRequestAndVolunteer(SOSRequest sosRequest, User volunteer);
}