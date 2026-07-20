package in.sp.main.Service;

import java.util.Optional;

import in.sp.main.Entities.OfflineFunctionality;

public interface OfflineFunctionalityService {
    Optional<OfflineFunctionality> getLatestOfflineFunctionality();
    void saveOfflineFunctionality(OfflineFunctionality status);
}
