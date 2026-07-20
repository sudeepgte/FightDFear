package in.sp.main.Service;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.SalonRepository;
import org.springframework.transaction.annotation.Transactional;


import java.util.List;
import java.util.Optional;
 
@Service
public class SalonService {
 
    @Autowired
    private SalonRepository salonRepository;
 
    // ✅ Add or Update Salon
    public void saveSalon(Salon salon) {
        salonRepository.save(salon);
    }
 
    @Transactional
    public void deleteSalon(Long id) {
        salonRepository.deleteById(id);
    }
    // ✅ Get all salons
    public List<Salon> getAllSalons() {
        return salonRepository.findAll();
    }
 
    // ✅ Get salon by ID
    public Salon getSalonById(Long id) {
        Optional<Salon> optionalSalon = salonRepository.findById(id);
        return optionalSalon.orElse(null);
    }
 
    // ✅ Get salon by email (useful for login/profile)
    public Salon getSalonByEmail(String email) {
        return salonRepository.findByEmail(email);
    }
 
    // ✅ Delete salon
  
    // ✅ Search salons by city or area
    public List<Salon> searchSalonByAddress(String location) {
        return salonRepository.findByAddressContainingIgnoreCase(location);
    }
    @Transactional
    public void deleteService(Long serviceId, Long salonId) {
        salonRepository.deleteByIdAndSalonId(serviceId, salonId);
    }
    // ✅ Search salons by name
    public List<Salon> searchSalonByName(String name) {
        return salonRepository.findByNameContainingIgnoreCase(name);
    }
 
 
    // ✅ Check if a salon exists by email
    public boolean existsByEmail(String email) {
        return salonRepository.existsByEmail(email);
    }
}