package in.sp.main.Service;

import java.io.IOException;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorDocumentType;
import in.sp.main.Entities.DoctorProfileStatus;

@Service
public class DoctorDocumentService {

    private static final long MAX_BYTES = 5L * 1024 * 1024;
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/jpg",
            "image/png",
            "application/pdf");

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private DoctorProfileService doctorProfileService;

    @Autowired
    @org.springframework.context.annotation.Lazy
    private DoctorDraftService doctorDraftService;

    @Transactional
    public String uploadDocument(Doctor doctor, DoctorDocumentType type, MultipartFile file) {
        validateFile(file);
        try {
            String path = fileUploadService.saveFile(file);
            if (doctor.getDoctorProfileStatus() == DoctorProfileStatus.APPROVED) {
                Map<String, Object> changes = new java.util.LinkedHashMap<>();
                switch (type) {
                    case PROFILE_PHOTO -> changes.put("profilePhotoPath", path);
                    case GOVERNMENT_ID -> {
                        changes.put("idProofPath", path);
                        changes.put("identityDocumentPath", path);
                    }
                    case MEDICAL_REGISTRATION -> changes.put("degreeCertificatePath", path);
                    case MEDICAL_LICENSE -> changes.put("medicalLicensePath", path);
                    case ADDITIONAL_CERTIFICATE -> changes.put("additionalCertificatePath", path);
                    default -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unsupported document type");
                }
                doctorDraftService.mergeDraftFields(doctor, changes);
                return path;
            }
            applyDocumentPath(doctor, type, path);
            doctorProfileService.refreshCompletion(doctor);
            doctorProfileService.syncVerificationStatus(doctor);
            return path;
        } catch (IOException ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to upload document");
        }
    }

    @Transactional
    public void deleteDocument(Doctor doctor, DoctorDocumentType type) {
        if (doctor.getDoctorProfileStatus() == DoctorProfileStatus.APPROVED) {
            Map<String, Object> changes = new java.util.LinkedHashMap<>();
            switch (type) {
                case PROFILE_PHOTO -> changes.put("profilePhotoPath", null);
                case GOVERNMENT_ID -> {
                    changes.put("idProofPath", null);
                    changes.put("identityDocumentPath", null);
                }
                case MEDICAL_REGISTRATION -> changes.put("degreeCertificatePath", null);
                case MEDICAL_LICENSE -> changes.put("medicalLicensePath", null);
                case ADDITIONAL_CERTIFICATE -> changes.put("additionalCertificatePath", null);
                default -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unsupported document type");
            }
            doctorDraftService.mergeDraftFields(doctor, changes);
            return;
        }
        applyDocumentPath(doctor, type, null);
        doctorProfileService.refreshCompletion(doctor);
        doctorProfileService.syncVerificationStatus(doctor);
    }

    public DoctorDocumentType parseType(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Document type is required");
        }
        String normalized = raw.trim().toUpperCase(Locale.ROOT).replace('-', '_');
        try {
            return DoctorDocumentType.valueOf(normalized);
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unsupported document type: " + raw);
        }
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "File is required");
        }
        if (file.getSize() > MAX_BYTES) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "File must be 5 MB or smaller");
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Only JPG, PNG, or PDF files are allowed");
        }
    }

    private void applyDocumentPath(Doctor doctor, DoctorDocumentType type, String path) {
        switch (type) {
            case PROFILE_PHOTO -> doctor.setProfilePhotoPath(path);
            case GOVERNMENT_ID -> {
                doctor.setIdProofPath(path);
                doctor.setIdentityDocumentPath(path);
            }
            case MEDICAL_REGISTRATION -> doctor.setDegreeCertificatePath(path);
            case MEDICAL_LICENSE -> doctor.setMedicalLicensePath(path);
            case ADDITIONAL_CERTIFICATE -> doctor.setAdditionalCertificatePath(path);
            default -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unsupported document type");
        }
    }
}
