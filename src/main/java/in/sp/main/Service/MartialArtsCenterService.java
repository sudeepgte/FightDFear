package in.sp.main.Service;

import java.io.File;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Entities.Enrollment;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.MartialArtsType;
import in.sp.main.Entities.Slot;
import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.MartialArtsTypeRepository;
import in.sp.main.Repository.SlotRepository;
import jakarta.servlet.ServletContext;

@Service
public class MartialArtsCenterService {

    @Autowired
    private MartialArtsCenterRepository centerRepository;

    @Autowired
    private MartialArtsTypeRepository martialArtsTypeRepository;

    @Autowired
    private SlotRepository slotRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private ServletContext servletContext;
    @Autowired
    private FileUploadService fileUploadService;  

    // ================== Register a new center ==================
    @Transactional
    public void register(MartialArtsCenter center,
                         MultipartFile certificate,
                         List<MartialArtsType> types,
                         MultipartFile profile) throws IOException {

        // Duplicate email check (controller also checks; keep as safety net)
        String email = center.getEmail() != null ? center.getEmail().trim().toLowerCase() : "";
        center.setEmail(email);
        if (centerRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email already exists");
        }

        if (types == null || types.isEmpty()) {
            throw new IllegalArgumentException("At least one martial arts program is required");
        }

        // Save certificate
        if (certificate != null && !certificate.isEmpty()) {
            String certPath = fileUploadService.saveFile(certificate);
            center.setTrainerCertificatePath(certPath);
        }

        // Save profile photo
        if (profile != null && !profile.isEmpty()) {
            String profilePath = fileUploadService.saveFile(profile);
            center.setProfilePhoto(profilePath);
        }

        // Needs admin approval
        center.setApproved(false);
        centerRepository.save(center);

        // Save martial arts types & slots
        for (MartialArtsType type : types) {
            type.setCentre(center);
            martialArtsTypeRepository.save(type);

            if (type.getSlots() != null) {
                for (Slot slot : type.getSlots()) {
                    slot.setMartialArtsType(type);
                    slotRepository.save(slot);
                }
            }
        }
    }

    // ================== Approve a center ==================
    @Transactional
    public void approveCenter(Long id) {
        MartialArtsCenter center = centerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Center not found"));
        center.setApproved(true);
        centerRepository.save(center);
    }

    // ================== Reject a center ==================
    @Transactional
    public boolean rejectCenter(Long id) {
        if (centerRepository.existsById(id)) {
            enrollmentRepository.deleteByCenterId(id);
            centerRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // ================== Get centers by approval ==================
    @Transactional(readOnly = true)
    public List<MartialArtsCenter> getCentresByApprovalStatus(boolean approved) {
        List<MartialArtsCenter> centers = centerRepository.findByApproved(approved);
        initializeLazyCollections(centers);
        return centers;
    }

    @Transactional(readOnly = true)
    public List<MartialArtsCenter> getApprovedCenters() {
        return getApprovedCentersForDiscovery();
    }

    /** Approved centres with programs and batches loaded for user browse/enroll UI. */
    @Transactional(readOnly = true)
    public List<MartialArtsCenter> getApprovedCentersForDiscovery() {
        List<MartialArtsCenter> centers = centerRepository.findByApproved(true);
        for (MartialArtsCenter center : centers) {
            initializeLazyCollections(center);
        }
        return centers;
    }

    @Transactional(readOnly = true)
    public MartialArtsCenter getApprovedCenterById(Long id) {
        MartialArtsCenter center = centerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Center not found"));
        if (!center.isApproved()) {
            throw new IllegalStateException("This training centre is not available for booking yet.");
        }
        initializeLazyCollections(center);
        return center;
    }

    @Transactional(readOnly = true)
    public List<MartialArtsCenter> getAllCenters() {
        List<MartialArtsCenter> centers = centerRepository.findAll();
        initializeLazyCollections(centers);
        return centers;
    }

    // ================== Get centers by location ==================
    @Transactional(readOnly = true)
    public List<MartialArtsCenter> getCentersByLocation(String location) {
        List<MartialArtsCenter> centers = centerRepository.findByLocation(location);
        initializeLazyCollections(centers);
        return centers;
    }

    // ================== Get single center by email ==================
    @Transactional(readOnly = true)
    public MartialArtsCenter getCenterByEmail(String email) {
        MartialArtsCenter center = centerRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Center not found with email: " + email));
        initializeLazyCollections(center);
        return center;
    }

    // ================== Get single center by id ==================
    @Transactional(readOnly = true)
    public MartialArtsCenter getCenterById(Long id) {
        MartialArtsCenter center = centerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Center not found"));
        initializeLazyCollections(center);
        return center;
    }

    // ================== Get certificate path ==================
    @Transactional(readOnly = true)
    public String getCertificatePath(Long id) {
        MartialArtsCenter center = centerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Center not found"));
        return center.getTrainerCertificatePath();
    }

    // ================== Get martial arts types ==================
    @Transactional(readOnly = true)
    public List<MartialArtsType> getMartialArtsTypes(Long centerId) {
        return martialArtsTypeRepository.findByCentreId(centerId);
    }

    // ================== Update center ==================
   

    // ================== Delete center ==================
    @Transactional
    public boolean deleteCenter(Long id) {
        if (centerRepository.existsById(id)) {
            enrollmentRepository.deleteByCenterId(id);
            centerRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // ================== Get enrollments ==================
    @Transactional(readOnly = true)
    public List<Enrollment> getEnrolledUsersByCenter(Long centerId) {
        MartialArtsCenter center = centerRepository.findById(centerId)
                .orElseThrow(() -> new RuntimeException("Center not found"));
        initializeLazyCollections(center);
        return enrollmentRepository.findByCenter(center);
    }

    // ================== Helper methods ==================
    private String saveFile(MultipartFile file) throws IOException {
        String uploadDir = servletContext.getRealPath("/uploads/");
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        String filePath = uploadDir + File.separator + fileName;
        file.transferTo(new File(filePath));

        return "/uploads/" + fileName;
    }

    private void initializeLazyCollections(List<MartialArtsCenter> centers) {
        centers.forEach(this::initializeLazyCollections);
    }

    private void initializeLazyCollections(MartialArtsCenter center) {
        center.getMartialArtsTypes().size();
        center.getAvailableDays().size();
        if (center.getBatches() != null) {
            center.getBatches().size();
        }
    }
    @Transactional
    public void updateCenterDetails(Long centerId, MartialArtsCenter updatedCenter, MultipartFile file,
                                    MultipartFile[] galleryPhotos,
                                    List<Long> typeIds) throws IOException {
        MartialArtsCenter existingCenter =centerRepository.findById(centerId)
                .orElseThrow(() -> new RuntimeException("Center not found"));

        existingCenter.setName(updatedCenter.getName());
        existingCenter.setEmail(updatedCenter.getEmail());
        existingCenter.setPhoneNumber(updatedCenter.getPhoneNumber());
        existingCenter.setLocation(updatedCenter.getLocation());
        existingCenter.setPassword(updatedCenter.getPassword());
        existingCenter.setAbout(updatedCenter.getAbout());
        existingCenter.setHowWeTeach(updatedCenter.getHowWeTeach());
        existingCenter.setWhatWeOffer(updatedCenter.getWhatWeOffer());

        // File upload
        if (file != null && !file.isEmpty()) {
            String photoUrl = fileUploadService.saveFile(file);
            existingCenter.setTrainerCertificatePath(photoUrl);
        }

        // Gallery photos upload
        if (galleryPhotos != null) {
            for (MultipartFile photo : galleryPhotos) {
                if (!photo.isEmpty()) {
                    String photoUrl = fileUploadService.saveFile(photo);
                    existingCenter.getGalleryPhotos().add(photoUrl);
                }
            }
        }

        centerRepository.save(existingCenter);

        // Update types from IDs
        if (typeIds != null && !typeIds.isEmpty()) {
            martialArtsTypeRepository.deleteAll(existingCenter.getMartialArtsTypes());
            List<MartialArtsType> types = martialArtsTypeRepository.findAllById(typeIds);
            for (MartialArtsType type : types) {
                type.setCentre(existingCenter);
                martialArtsTypeRepository.save(type);
                for (Slot slot : type.getSlots()) {
                    slot.setMartialArtsType(type);
                    slotRepository.save(slot);
                }
            }
        } else {
            existingCenter.getMartialArtsTypes().clear();
        }
    }

}
