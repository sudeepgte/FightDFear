package in.sp.main.Service;


import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.BatteryStatus;
import in.sp.main.Repository.BatteryStatusRepository;

@Service
public class BatteryStatusServiceImpl implements BatteryStatusService {
    
    @Autowired
    private BatteryStatusRepository batteryStatusRepository;

    @Override
    public Optional<BatteryStatus> getLatestBatteryStatus() {
        return batteryStatusRepository.findAll().stream().reduce((first, second) -> second);
    }

    @Override
    public void saveBatteryStatus(BatteryStatus status) {
        batteryStatusRepository.save(status);
    }
}
