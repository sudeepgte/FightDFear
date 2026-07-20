package in.sp.main.Service;
 
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
import in.sp.main.Entities.Service1;
import in.sp.main.Repository.ServiceRepository;
 
@Service
public class ServiceService {
 
	 @Autowired
    private ServiceRepository serviceRepository;
 
    public ServiceService(ServiceRepository serviceRepository) {
        this.serviceRepository = serviceRepository;
    }
 
    public List<Service1> getAllServicesWithSalonDetails() {
        return serviceRepository.getAllServicesWithSalonDetails();
    }

    public Service1 getServiceById(Long serviceId) {
        return serviceRepository.findById(serviceId).orElse(null);
    }

 
}