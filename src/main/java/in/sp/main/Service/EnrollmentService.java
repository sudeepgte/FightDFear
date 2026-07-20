package in.sp.main.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.DayAvailable;
import in.sp.main.Entities.Enrollment;
import in.sp.main.Entities.EnrollmentRequest;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.MartialArtsType;
import in.sp.main.Entities.Slot;
import in.sp.main.Entities.TrainingStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.MartialArtsTypeRepository;
import in.sp.main.Repository.SlotRepository;
import in.sp.main.Repository.UserRepository;


@Service
public class EnrollmentService {
    
    @Autowired
    private EnrollmentRepository repository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private MartialArtsCenterRepository centerRepository;
    @Autowired
    private MartialArtsTypeRepository typeRepository;
    @Autowired
    private SlotRepository slotRepository;


    public void enrollUser(EnrollmentRequest request, Long slotId, Set<DayAvailable> preferredDays) {
        User user = userRepository.findById(request.getUserId()).orElseThrow(() -> new RuntimeException("User not found"));
        MartialArtsCenter center = centerRepository.findById(request.getCenterId()).orElseThrow(() -> new RuntimeException("Center not found"));
        MartialArtsType martialArtsType = typeRepository.findById(request.getMartialArtTypeId()).orElseThrow(() -> new RuntimeException("Martial Arts Type not found"));
        Slot slot = slotRepository.findById(slotId).orElseThrow();

        Enrollment enrollment = new Enrollment();
        enrollment.setUser(user);
        enrollment.setCenter(center);
        enrollment.setMartialArtsType(martialArtsType);
        enrollment.setPreferredDays(preferredDays); // Already Set<DayAvailable>
        enrollment.setStatus(TrainingStatus.PENDING);
        enrollment.setSelectedSlot(slot);

        repository.save(enrollment);
    }


    public List<Enrollment> getUserEnrollments(Long userId) {
        return repository.findByUserId(userId);
    }

    public void updateStatus(Long enrollmentId, TrainingStatus status, String certificateDetails) {
        Enrollment enrollment = repository.findById(enrollmentId).orElseThrow();
        enrollment.setStatus(status);
        enrollment.setCertificateDetails(certificateDetails);
        repository.save(enrollment);
    }
}
