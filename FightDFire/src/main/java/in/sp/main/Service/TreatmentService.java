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