package in.sp.main.Service;
 
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Treatment;
import in.sp.main.Repository.TreatmentRepository;
 
@Service
public class TreatmentService {
 
    @Autowired
    private TreatmentRepository treatmentRepository;
 
    public void saveTreatment(Treatment treatment) {
        if (treatment == null) {
            throw new IllegalArgumentException("Treatment is required.");
        }
        if (treatment.getCategory() == null || treatment.getCategory().isBlank()) {
            throw new IllegalArgumentException("Category is required.");
        }
        if (treatment.getServiceName() == null || treatment.getServiceName().isBlank()) {
            throw new IllegalArgumentException("Service Name is required.");
        }
        if (treatment.getPrice() < 0) {
            throw new IllegalArgumentException("Base Price cannot be negative. Please enter zero or a positive amount.");
        }
        if (treatment.getDuration() <= 0) {
            throw new IllegalArgumentException("Duration must be a positive value (at least 1 minute).");
        }
        String description = treatment.getDescription();
        if (description == null || description.isBlank()) {
            throw new IllegalArgumentException("Detailed Description is required.");
        }
        treatment.setDescription(description.trim());
        treatmentRepository.save(treatment);
    }
 
    public List<Treatment> getTreatmentsBySalon(Long salonId) {
        return treatmentRepository.findBySalonId(salonId);
    }
    public List<Treatment> getTreatmentsBySalon(Salon salon) {
        return treatmentRepository.findBySalon(salon);
    }
 
    public Treatment getTreatmentById(Long id) {
        return treatmentRepository.findById(id).orElse(null);
    }
 
   
    public List<Treatment> getAllTreatments() {
        return treatmentRepository.findAll();
    }
    public void deleteTreatment(Long id) {
        treatmentRepository.deleteById(id);
    }
}