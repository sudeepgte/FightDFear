package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.BatteryStatus;

@Repository
public interface BatteryStatusRepository extends JpaRepository<BatteryStatus, Long> {
}
