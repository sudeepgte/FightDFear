package in.sp.main.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import in.sp.main.Entities.StylistService;
import in.sp.main.Repository.StylistServiceRepository;

@Service
public class StylistServiceManager {

    @Autowired
    private StylistServiceRepository serviceRepo;

    // Add or update a service
    public StylistService save(StylistService service) {
        return serviceRepo.save(service);
    }

    // Find service by ID
    public Optional<StylistService> findById(Long id) {
        return serviceRepo.findById(id);
    }

    // Find all services of a stylist
    public List<StylistService> findByStylist(Long stylistId) {
        return serviceRepo.findByStylistId(stylistId);
    }

    // Delete a service
    public void delete(Long id) {
        serviceRepo.deleteById(id);
    }

    // Find all services
    public List<StylistService> findAll() {
        return serviceRepo.findAll();
    }
}
