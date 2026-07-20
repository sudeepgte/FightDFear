package in.sp.main.Repository;

import in.sp.main.Entities.sosAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SOSAlertRepository extends JpaRepository<sosAlert, Long> {
    List<sosAlert> findByStatusOrderByTimeOfActivationDesc(String status);
    List<sosAlert> findAllByOrderByTimeOfActivationDesc();
}
