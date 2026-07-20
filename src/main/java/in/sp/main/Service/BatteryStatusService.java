package in.sp.main.Service;


import java.util.Optional;

import in.sp.main.Entities.BatteryStatus;

public interface BatteryStatusService {
    Optional<BatteryStatus> getLatestBatteryStatus();
    void saveBatteryStatus(BatteryStatus status);
}
