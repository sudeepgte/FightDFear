package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorDraftStatus;
import in.sp.main.Entities.DoctorProfileDraft;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Repository.DoctorProfileDraftRepository;

@Service
public class DoctorDraftService {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Autowired
    private DoctorProfileDraftRepository draftRepository;

    public Optional<DoctorProfileDraft> findDraft(Long doctorId) {
        return draftRepository.findById(doctorId);
    }

    public Map<String, Object> readDraftMap(DoctorProfileDraft draft) {
        if (draft == null || draft.getDraftJson() == null || draft.getDraftJson().isBlank()) {
            return new LinkedHashMap<>();
        }
        try {
            Map<String, Object> map = MAPPER.readValue(draft.getDraftJson(), new TypeReference<Map<String, Object>>() {});
            return map == null ? new LinkedHashMap<>() : new LinkedHashMap<>(map);
        } catch (Exception ex) {
            return new LinkedHashMap<>();
        }
    }

    public Map<String, Object> draftPayload(Doctor doctor) {
        Optional<DoctorProfileDraft> opt = findDraft(doctor.getId());
        if (opt.isEmpty()) {
            return null;
        }
        DoctorProfileDraft draft = opt.get();
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("status", draft.getStatus() == null ? null : draft.getStatus().name());
        payload.put("adminNotes", draft.getAdminNotes());
        payload.put("submittedAt", draft.getSubmittedAt() == null ? null : draft.getSubmittedAt().toString());
        payload.put("updatedAt", draft.getUpdatedAt() == null ? null : draft.getUpdatedAt().toString());
        payload.put("fields", readDraftMap(draft));
        return payload;
    }

    @Transactional
    public DoctorProfileDraft mergeDraftFields(Doctor doctor, Map<String, Object> changes) {
        if (doctor.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Draft updates are only for approved doctors");
        }
        DoctorProfileDraft draft = draftRepository.findById(doctor.getId()).orElseGet(() -> {
            DoctorProfileDraft created = new DoctorProfileDraft();
            created.setDoctorId(doctor.getId());
            created.setDraftJson("{}");
            created.setStatus(DoctorDraftStatus.DRAFT);
            return created;
        });

        Map<String, Object> current = readDraftMap(draft);
        current.putAll(changes);
        try {
            draft.setDraftJson(MAPPER.writeValueAsString(current));
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to save draft changes");
        }
        if (draft.getStatus() != DoctorDraftStatus.PENDING_REVIEW) {
            draft.setStatus(DoctorDraftStatus.DRAFT);
        }
        doctor.setHasPendingReverification(true);
        return draftRepository.save(draft);
    }

    @Transactional
    public DoctorProfileDraft submitDraftForReview(Doctor doctor) {
        DoctorProfileDraft draft = draftRepository.findById(doctor.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No pending profile changes to submit"));
        Map<String, Object> fields = readDraftMap(draft);
        if (fields.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No pending profile changes to submit");
        }
        draft.setStatus(DoctorDraftStatus.PENDING_REVIEW);
        draft.setSubmittedAt(LocalDateTime.now());
        draft.setAdminNotes(null);
        doctor.setHasPendingReverification(true);
        return draftRepository.save(draft);
    }

    @Transactional
    public void applyDraftToLive(Doctor doctor) {
        DoctorProfileDraft draft = draftRepository.findById(doctor.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No pending draft found"));
        Map<String, Object> fields = readDraftMap(draft);
        applyFieldsToDoctor(doctor, fields);
        draftRepository.delete(draft);
        doctor.setHasPendingReverification(false);
    }

    @Transactional
    public void rejectDraft(Doctor doctor, String notes) {
        DoctorProfileDraft draft = draftRepository.findById(doctor.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No pending draft found"));
        draft.setStatus(DoctorDraftStatus.DRAFT);
        draft.setAdminNotes(notes);
        draft.setSubmittedAt(null);
        draftRepository.save(draft);
        doctor.setHasPendingReverification(true);
    }

    @Transactional
    public void clearDraft(Doctor doctor) {
        draftRepository.findById(doctor.getId()).ifPresent(draftRepository::delete);
        doctor.setHasPendingReverification(false);
    }

    private void applyFieldsToDoctor(Doctor doctor, Map<String, Object> fields) {
        if (fields.containsKey("fullName")) doctor.setFullName(asString(fields.get("fullName")));
        if (fields.containsKey("phone")) doctor.setPhone(asString(fields.get("phone")));
        if (fields.containsKey("specialization")) doctor.setSpecialization(blankToNull(asString(fields.get("specialization"))));
        if (fields.containsKey("qualification")) doctor.setQualification(blankToNull(asString(fields.get("qualification"))));
        if (fields.containsKey("medicalRegNumber")) doctor.setMedicalRegNumber(blankToNull(asString(fields.get("medicalRegNumber"))));
        if (fields.containsKey("experienceYears")) doctor.setExperienceYears(asInteger(fields.get("experienceYears")));
        if (fields.containsKey("hospitalName")) doctor.setHospitalName(blankToNull(asString(fields.get("hospitalName"))));
        if (fields.containsKey("clinicAddress")) doctor.setClinicAddress(blankToNull(asString(fields.get("clinicAddress"))));
        if (fields.containsKey("city")) doctor.setCity(blankToNull(asString(fields.get("city"))));
        if (fields.containsKey("state")) doctor.setState(blankToNull(asString(fields.get("state"))));
        if (fields.containsKey("pincode")) doctor.setPincode(blankToNull(asString(fields.get("pincode"))));
        if (fields.containsKey("googleMapLocation")) doctor.setGoogleMapLocation(blankToNull(asString(fields.get("googleMapLocation"))));
        if (fields.containsKey("languages")) doctor.setLanguages(blankToNull(asString(fields.get("languages"))));
        if (fields.containsKey("services")) doctor.setServices(blankToNull(asString(fields.get("services"))));
        if (fields.containsKey("bio")) doctor.setBio(blankToNull(asString(fields.get("bio"))));
        if (fields.containsKey("consultationFee")) doctor.setConsultationFee(asDouble(fields.get("consultationFee")));
        if (fields.containsKey("chatFee")) doctor.setChatFee(asDouble(fields.get("chatFee")));
        if (fields.containsKey("callFee")) doctor.setCallFee(asDouble(fields.get("callFee")));
        if (fields.containsKey("videoFee")) doctor.setVideoFee(asDouble(fields.get("videoFee")));
        if (fields.containsKey("availableDays")) doctor.setAvailableDays(blankToNull(asString(fields.get("availableDays"))));
        if (fields.containsKey("startTime")) doctor.setStartTime(blankToNull(asString(fields.get("startTime"))));
        if (fields.containsKey("endTime")) doctor.setEndTime(blankToNull(asString(fields.get("endTime"))));
        if (fields.containsKey("availabilitySlots")) doctor.setAvailabilitySlots(blankToNull(asString(fields.get("availabilitySlots"))));
        if (fields.containsKey("consultationModes")) doctor.setConsultationModes(blankToNull(asString(fields.get("consultationModes"))));
        if (fields.containsKey("consultationType")) {
            String type = asString(fields.get("consultationType"));
            if (!type.isBlank()) {
                doctor.setConsultationType(ConsultationType.valueOf(type.trim().toUpperCase()));
            }
        }
        if (fields.containsKey("emergencyAvailable")) {
            doctor.setEmergencyAvailable(Boolean.parseBoolean(asString(fields.get("emergencyAvailable"))));
        }
        if (fields.containsKey("profilePhotoPath")) doctor.setProfilePhotoPath(blankToNull(asString(fields.get("profilePhotoPath"))));
        if (fields.containsKey("idProofPath")) {
            String path = blankToNull(asString(fields.get("idProofPath")));
            doctor.setIdProofPath(path);
            doctor.setIdentityDocumentPath(path);
        }
        if (fields.containsKey("identityDocumentPath")) doctor.setIdentityDocumentPath(blankToNull(asString(fields.get("identityDocumentPath"))));
        if (fields.containsKey("medicalLicensePath")) doctor.setMedicalLicensePath(blankToNull(asString(fields.get("medicalLicensePath"))));
        if (fields.containsKey("degreeCertificatePath")) doctor.setDegreeCertificatePath(blankToNull(asString(fields.get("degreeCertificatePath"))));
        if (fields.containsKey("additionalCertificatePath")) {
            doctor.setAdditionalCertificatePath(blankToNull(asString(fields.get("additionalCertificatePath"))));
        }
        if (fields.containsKey("clinicPhotos")) doctor.setClinicPhotos(blankToNull(asString(fields.get("clinicPhotos"))));
        if (fields.containsKey("clinicLat")) doctor.setClinicLat(asDouble(fields.get("clinicLat")));
        if (fields.containsKey("clinicLng")) doctor.setClinicLng(asDouble(fields.get("clinicLng")));
    }

    private static String asString(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private static String blankToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private static Integer asInteger(Object value) {
        if (value == null || asString(value).isBlank()) return null;
        if (value instanceof Number n) return n.intValue();
        return Integer.parseInt(asString(value).trim());
    }

    private static Double asDouble(Object value) {
        if (value == null || asString(value).isBlank()) return null;
        if (value instanceof Number n) return n.doubleValue();
        return Double.parseDouble(asString(value).trim());
    }
}
