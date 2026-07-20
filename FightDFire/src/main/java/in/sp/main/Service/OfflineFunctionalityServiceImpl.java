package in.sp.main.Service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.OfflineFunctionality;
import in.sp.main.Repository.OfflineFunctionalityRepository;

@Service
public class OfflineFunctionalityServiceImpl implements OfflineFunctionalityService {

    @Autowired
    private OfflineFunctionalityRepository offlineFunctionalityRepository;

    @Override
    public Optional<OfflineFunctionality> getLatestOfflineFunctionality() {
        return offlineFunctionalityRepository.findAll().stream().reduce((first, second) -> second);
    }

    @Override
    public void saveOfflineFunctionality(OfflineFunctionality status) {
        offlineFunctionalityRepository.save(status);
    }
}
