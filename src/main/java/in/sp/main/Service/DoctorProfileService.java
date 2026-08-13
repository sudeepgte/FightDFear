package in.sp.main.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.VerificationStatus;

@Service
public class DoctorProfileService {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final Set<String> VALID_DAYS = Set.of(
            "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY");
    private static final Set<String> VALID_MODES = Set.of(
            "CLINIC", "VIDEO", "ONLINE", "OFFLINE");

    @Autowired
    @Lazy
    private DoctorDraftService doctorDraftService;

    public void setLifecycleStatus(Doctor doctor, DoctorProfileStatus status) {
        if (doctor == null || status == null) {
            return;
        }
        doctor.setDoctorProfileStatus(status);
        syncVerificationStatus(doctor);
    }

    public void markApproved(Doctor doctor) {
        if (doctor == null) {
            return;
        }
        setLifecycleStatus(doctor, DoctorProfileStatus.APPROVED);
        doctor.setRejectionReason(null);
        doctor.setChangesRequestedNote(null);
    }

    public void markRejected(Doctor doctor, String reason) {
        if (doctor == null) {
            return;
        }
        setLifecycleStatus(doctor, DoctorProfileStatus.REJECTED);
        doctor.setRejectionReason(isBlank(reason) ? null : reason.trim());
    }

    public void markChangesRequested(Doctor doctor, String note) {
        if (doctor == null) {
            return;
        }
        setLifecycleStatus(doctor, DoctorProfileStatus.CHANGES_REQUESTED);
        doctor.setChangesRequestedNote(isBlank(note) ? null : note.trim());
        doctor.setRejectionReason(null);
    }

    public void updateProfile(Doctor doctor, Map<String, Object> body) {
        if (doctor == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Doctor login required");
        }
        if (body == null || body.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile data is required");
        }

        // Approved doctors: keep live verified data intact and stage edits in a draft.
        if (doctor.getDoctorProfileStatus() == DoctorProfileStatus.APPROVED) {
            Doctor staged = cloneProfessionalSnapshot(doctor);
            applyLiveUpdates(staged, body);
            doctorDraftService.mergeDraftFields(doctor, snapshotProfessionalFields(staged));
            return;
        }

        applyLiveUpdates(doctor, body);
        refreshCompletion(doctor);
        syncVerificationStatus(doctor);
    }

    private void applyLiveUpdates(Doctor doctor, Map<String, Object> body) {
        if (body.containsKey("fullName")) {
            String fullName = asString(body.get("fullName"));
            if (isBlank(fullName)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Full name is required");
            }
            doctor.setFullName(fullName.trim());
        }
        if (body.containsKey("phone")) {
            String phone = asString(body.get("phone"));
            if (!isBlank(phone)) {
                doctor.setPhone(phone.trim());
            }
        }
        if (body.containsKey("specialization")) {
            doctor.setSpecialization(blankToNull(asString(body.get("specialization"))));
        }
        if (body.containsKey("qualification")) {
            doctor.setQualification(blankToNull(asString(body.get("qualification"))));
        }
        if (body.containsKey("medicalRegNumber")) {
            doctor.setMedicalRegNumber(blankToNull(asString(body.get("medicalRegNumber"))));
        }
        if (body.containsKey("experienceYears")) {
            Integer years = asInteger(body.get("experienceYears"), "Years of experience");
            if (years != null && (years < 0 || years > 50)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Years of experience must be between 0 and 50");
            }
            doctor.setExperienceYears(years);
        }
        if (body.containsKey("hospitalName")) {
            doctor.setHospitalName(blankToNull(asString(body.get("hospitalName"))));
        }
        if (body.containsKey("clinicAddress")) {
            doctor.setClinicAddress(blankToNull(asString(body.get("clinicAddress"))));
        }
        if (body.containsKey("city")) {
            doctor.setCity(blankToNull(asString(body.get("city"))));
        }
        if (body.containsKey("state")) {
            doctor.setState(blankToNull(asString(body.get("state"))));
        }
        if (body.containsKey("pincode")) {
            doctor.setPincode(normalizePincode(asString(body.get("pincode"))));
        }
        if (body.containsKey("googleMapLocation")) {
            doctor.setGoogleMapLocation(blankToNull(asString(body.get("googleMapLocation"))));
        }
        if (body.containsKey("languages")) {
            doctor.setLanguages(normalizeCsv(asString(body.get("languages"))));
        }
        if (body.containsKey("services")) {
            doctor.setServices(normalizeCsv(asString(body.get("services"))));
        }
        if (body.containsKey("bio")) {
            doctor.setBio(blankToNull(asString(body.get("bio"))));
        }
        if (body.containsKey("consultationFee")) {
            doctor.setConsultationFee(asDouble(body.get("consultationFee"), "Consultation fee"));
        }
        if (body.containsKey("chatFee")) {
            doctor.setChatFee(asDouble(body.get("chatFee"), "Chat fee"));
        }
        if (body.containsKey("callFee")) {
            doctor.setCallFee(asDouble(body.get("callFee"), "Call fee"));
        }
        if (body.containsKey("videoFee")) {
            doctor.setVideoFee(asDouble(body.get("videoFee"), "Video fee"));
        }
        if (body.containsKey("emergencyAvailable")) {
            doctor.setEmergencyAvailable(asBoolean(body.get("emergencyAvailable")));
        }
        if (body.containsKey("slotDurationMinutes")) {
            Integer mins = asInteger(body.get("slotDurationMinutes"), "Slot duration");
            if (mins != null && (mins < 10 || mins > 120)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Slot duration must be between 10 and 120 minutes");
            }
            doctor.setSlotDurationMinutes(mins == null ? 30 : mins);
        }
        if (body.containsKey("bufferMinutes")) {
            Integer mins = asInteger(body.get("bufferMinutes"), "Buffer minutes");
            if (mins != null && (mins < 0 || mins > 60)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Buffer must be between 0 and 60 minutes");
            }
            doctor.setBufferMinutes(mins == null ? 0 : mins);
        }
        if (body.containsKey("breakStart")) {
            doctor.setBreakStart(blankToNull(asString(body.get("breakStart"))));
        }
        if (body.containsKey("breakEnd")) {
            doctor.setBreakEnd(blankToNull(asString(body.get("breakEnd"))));
        }
        if (body.containsKey("blockedDates")) {
            doctor.setBlockedDates(normalizeCsv(asString(body.get("blockedDates"))));
        }
        if (body.containsKey("autoConfirm")) {
            doctor.setAutoConfirm(asBoolean(body.get("autoConfirm")));
        }
        if (body.containsKey("upiId")) {
            doctor.setUpiId(blankToNull(asString(body.get("upiId"))));
        }
        if (body.containsKey("bankDetails")) {
            doctor.setBankDetails(blankToNull(asString(body.get("bankDetails"))));
        }
        if (body.containsKey("clinicLat")) {
            doctor.setClinicLat(asDouble(body.get("clinicLat"), "Clinic latitude"));
        }
        if (body.containsKey("clinicLng")) {
            doctor.setClinicLng(asDouble(body.get("clinicLng"), "Clinic longitude"));
        }

        if (body.containsKey("consultationModes") || body.containsKey("consultationType")) {
            applyConsultationModes(doctor, body);
        }

        if (body.containsKey("availabilitySlots")) {
            applyAvailabilitySlots(doctor, body.get("availabilitySlots"));
        } else {
            if (body.containsKey("availableDays")) {
                doctor.setAvailableDays(normalizeDays(asString(body.get("availableDays"))));
            }
            if (body.containsKey("startTime")) {
                doctor.setStartTime(blankToNull(asString(body.get("startTime"))));
            }
            if (body.containsKey("endTime")) {
                doctor.setEndTime(blankToNull(asString(body.get("endTime"))));
            }
        }
    }

    private static Doctor cloneProfessionalSnapshot(Doctor source) {
        Doctor d = new Doctor();
        d.setFullName(source.getFullName());
        d.setPhone(source.getPhone());
        d.setSpecialization(source.getSpecialization());
        d.setQualification(source.getQualification());
        d.setMedicalRegNumber(source.getMedicalRegNumber());
        d.setExperienceYears(source.getExperienceYears());
        d.setHospitalName(source.getHospitalName());
        d.setClinicAddress(source.getClinicAddress());
        d.setCity(source.getCity());
        d.setState(source.getState());
        d.setPincode(source.getPincode());
        d.setGoogleMapLocation(source.getGoogleMapLocation());
        d.setLanguages(source.getLanguages());
        d.setServices(source.getServices());
        d.setBio(source.getBio());
        d.setConsultationFee(source.getConsultationFee());
        d.setChatFee(source.getChatFee());
        d.setCallFee(source.getCallFee());
        d.setVideoFee(source.getVideoFee());
        d.setEmergencyAvailable(source.getEmergencyAvailable());
        d.setConsultationType(source.getConsultationType());
        d.setConsultationModes(source.getConsultationModes());
        d.setAvailableDays(source.getAvailableDays());
        d.setStartTime(source.getStartTime());
        d.setEndTime(source.getEndTime());
        d.setAvailabilitySlots(source.getAvailabilitySlots());
        d.setProfilePhotoPath(source.getProfilePhotoPath());
        d.setIdProofPath(source.getIdProofPath());
        d.setIdentityDocumentPath(source.getIdentityDocumentPath());
        d.setMedicalLicensePath(source.getMedicalLicensePath());
        d.setDegreeCertificatePath(source.getDegreeCertificatePath());
        d.setAdditionalCertificatePath(source.getAdditionalCertificatePath());
        return d;
    }

    private static Map<String, Object> snapshotProfessionalFields(Doctor doctor) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("fullName", doctor.getFullName());
        map.put("phone", doctor.getPhone());
        map.put("specialization", doctor.getSpecialization());
        map.put("qualification", doctor.getQualification());
        map.put("medicalRegNumber", doctor.getMedicalRegNumber());
        map.put("experienceYears", doctor.getExperienceYears());
        map.put("hospitalName", doctor.getHospitalName());
        map.put("clinicAddress", doctor.getClinicAddress());
        map.put("city", doctor.getCity());
        map.put("state", doctor.getState());
        map.put("pincode", doctor.getPincode());
        map.put("googleMapLocation", doctor.getGoogleMapLocation());
        map.put("languages", doctor.getLanguages());
        map.put("services", doctor.getServices());
        map.put("bio", doctor.getBio());
        map.put("consultationFee", doctor.getConsultationFee());
        map.put("chatFee", doctor.getChatFee());
        map.put("callFee", doctor.getCallFee());
        map.put("videoFee", doctor.getVideoFee());
        map.put("emergencyAvailable", doctor.getEmergencyAvailable());
        map.put("consultationType", doctor.getConsultationType() == null ? null : doctor.getConsultationType().name());
        map.put("consultationModes", doctor.getConsultationModes());
        map.put("availableDays", doctor.getAvailableDays());
        map.put("startTime", doctor.getStartTime());
        map.put("endTime", doctor.getEndTime());
        map.put("availabilitySlots", doctor.getAvailabilitySlots());
        map.put("profilePhotoPath", doctor.getProfilePhotoPath());
        map.put("idProofPath", doctor.getIdProofPath());
        map.put("identityDocumentPath", doctor.getIdentityDocumentPath());
        map.put("medicalLicensePath", doctor.getMedicalLicensePath());
        map.put("degreeCertificatePath", doctor.getDegreeCertificatePath());
        map.put("additionalCertificatePath", doctor.getAdditionalCertificatePath());
        return map;
    }

    public int calculateCompletionPct(Doctor doctor) {
        if (doctor == null) {
            return 0;
        }
        int filled = 0;
        int total = 13;

        if (notBlank(doctor.getFullName())) filled++;
        if (notBlank(doctor.getSpecialization())) filled++;
        if (notBlank(doctor.getQualification())) filled++;
        if (notBlank(doctor.getMedicalRegNumber())) filled++;
        if (doctor.getExperienceYears() != null && doctor.getExperienceYears() >= 0) filled++;
        if (doctor.getConsultationFee() != null && doctor.getConsultationFee() >= 0) filled++;
        if (notBlank(doctor.getHospitalName())) filled++;
        if (notBlank(doctor.getClinicAddress()) && notBlank(doctor.getCity())) filled++;
        if (notBlank(doctor.getState())) filled++;
        if (isValidPincode(doctor.getPincode())) filled++;
        if (notBlank(doctor.getAvailableDays()) && notBlank(doctor.getStartTime())) filled++;
        if (notBlank(doctor.getConsultationModes()) || doctor.getConsultationType() != null) filled++;
        if (notBlank(doctor.getLanguages())) filled++;

        return (int) Math.round(100.0 * filled / total);
    }

    public List<String> missingItems(Doctor doctor) {
        List<String> missing = new ArrayList<>();
        if (doctor == null) {
            missing.add("Doctor profile not found");
            return missing;
        }
        if (isBlank(doctor.getFullName())) missing.add("1.1 Doctor name");
        if (isBlank(doctor.getSpecialization())) missing.add("1.2 Specialization");
        if (isBlank(doctor.getQualification())) missing.add("1.3 Qualification");
        if (isBlank(doctor.getMedicalRegNumber())) missing.add("1.4 Medical registration number");
        if (doctor.getExperienceYears() == null) missing.add("1.5 Years of experience");
        if (isBlank(doctor.getHospitalName())) missing.add("2.1 Hospital / clinic name");
        if (isBlank(doctor.getClinicAddress()) || isBlank(doctor.getCity())) missing.add("2.2 Clinic address and city");
        if (isBlank(doctor.getState())) missing.add("2.4 State");
        if (!isValidPincode(doctor.getPincode())) missing.add("2.5 Pincode");
        if (isBlank(doctor.getConsultationModes()) && doctor.getConsultationType() == null) {
            missing.add("3. Consultation mode");
        }
        if (isBlank(doctor.getAvailableDays()) || isBlank(doctor.getStartTime())) missing.add("4. Working availability");
        if (isBlank(doctor.getLanguages())) missing.add("5. Languages");
        if (doctor.getConsultationFee() == null) missing.add("7.1 Consultation fee");
        String modes = doctor.getConsultationModes() == null ? "" : doctor.getConsultationModes().toUpperCase(Locale.ROOT);
        if (modes.contains("VIDEO") && doctor.getVideoFee() == null && doctor.getConsultationFee() == null) {
            missing.add("7.4 Video fee");
        }
        if (modes.contains("ONLINE") && doctor.getChatFee() == null && doctor.getConsultationFee() == null) {
            missing.add("7.2 Chat fee");
        }
        return missing;
    }

    public boolean isReadyForVerification(Doctor doctor) {
        return doctor != null && missingItems(doctor).isEmpty();
    }

    public Map<String, Object> profilePayload(Doctor doctor) {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("id", doctor.getId());
        payload.put("fullName", doctor.getFullName());
        payload.put("email", doctor.getEmail());
        payload.put("phone", doctor.getPhone());
        payload.put("specialization", doctor.getSpecialization());
        payload.put("qualification", doctor.getQualification());
        payload.put("medicalRegNumber", doctor.getMedicalRegNumber());
        payload.put("experienceYears", doctor.getExperienceYears());
        payload.put("hospitalName", doctor.getHospitalName());
        payload.put("clinicAddress", doctor.getClinicAddress());
        payload.put("city", doctor.getCity());
        payload.put("state", doctor.getState());
        payload.put("pincode", doctor.getPincode());
        payload.put("googleMapLocation", doctor.getGoogleMapLocation());
        payload.put("consultationFee", doctor.getConsultationFee());
        payload.put("chatFee", doctor.getChatFee());
        payload.put("callFee", doctor.getCallFee());
        payload.put("videoFee", doctor.getVideoFee());
        payload.put("consultationType", doctor.getConsultationType() == null ? null : doctor.getConsultationType().name());
        payload.put("consultationModes", splitCsv(doctor.getConsultationModes()));
        payload.put("availableDays", doctor.getAvailableDays());
        payload.put("startTime", doctor.getStartTime());
        payload.put("endTime", doctor.getEndTime());
        payload.put("availabilitySlots", parseAvailabilitySlots(doctor.getAvailabilitySlots()));
        payload.put("emergencyAvailable", doctor.getEmergencyAvailable());
        payload.put("slotDurationMinutes", doctor.getSlotDurationMinutes() == null ? 30 : doctor.getSlotDurationMinutes());
        payload.put("bufferMinutes", doctor.getBufferMinutes() == null ? 0 : doctor.getBufferMinutes());
        payload.put("breakStart", doctor.getBreakStart());
        payload.put("breakEnd", doctor.getBreakEnd());
        payload.put("blockedDates", splitCsv(doctor.getBlockedDates()));
        payload.put("autoConfirm", Boolean.TRUE.equals(doctor.getAutoConfirm()));
        payload.put("upiId", doctor.getUpiId());
        payload.put("bankDetails", doctor.getBankDetails());
        payload.put("payoutBalance", doctor.getPayoutBalance());
        payload.put("clinicPhotos", splitCsv(doctor.getClinicPhotos()));
        payload.put("clinicLat", doctor.getClinicLat());
        payload.put("clinicLng", doctor.getClinicLng());
        payload.put("languages", splitCsv(doctor.getLanguages()));
        payload.put("services", splitCsv(doctor.getServices()));
        payload.put("bio", doctor.getBio());
        payload.put("profilePhotoPath", doctor.getProfilePhotoPath());
        payload.put("identityDocumentPath", doctor.getIdentityDocumentPath());
        payload.put("idProofPath", doctor.getIdProofPath());
        payload.put("medicalLicensePath", doctor.getMedicalLicensePath());
        payload.put("degreeCertificatePath", primaryDocumentPath(doctor.getDegreeCertificatePath()));
        payload.put("additionalCertificatePath", doctor.getAdditionalCertificatePath());
        payload.put("verificationStatus", doctor.getVerificationStatus() == null ? null : doctor.getVerificationStatus().name());
        payload.put("doctorProfileStatus", doctor.getDoctorProfileStatus() == null ? null : doctor.getDoctorProfileStatus().name());
        payload.put("doctorProfileStatusLabel", DoctorVerificationService.friendlyStatusLabel(doctor.getDoctorProfileStatus()));
        payload.put("profileCompletionPct", doctor.getProfileCompletionPct());
        payload.put("missingItems", missingItems(doctor));
        payload.put("canSubmitForVerification", canSubmitForVerification(doctor));
        payload.put("hasPendingReverification", Boolean.TRUE.equals(doctor.getHasPendingReverification()));
        payload.put("pendingDraft", doctorDraftService == null ? null : doctorDraftService.draftPayload(doctor));
        payload.put("rejectionReason", doctor.getRejectionReason());
        payload.put("changesRequestedNote", doctor.getChangesRequestedNote());
        payload.put("nextStepGuidance", nextStepGuidance(doctor));
        return payload;
    }

    public boolean canSubmitForVerification(Doctor doctor) {
        if (doctor == null) {
            return false;
        }
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == DoctorProfileStatus.PENDING_ADMIN_APPROVAL || status == DoctorProfileStatus.SUSPENDED) {
            return false;
        }
        if (status == DoctorProfileStatus.APPROVED) {
            return Boolean.TRUE.equals(doctor.getHasPendingReverification())
                    && doctorDraftService.findDraft(doctor.getId())
                    .map(d -> d.getStatus() != in.sp.main.Entities.DoctorDraftStatus.PENDING_REVIEW
                            && !doctorDraftService.readDraftMap(d).isEmpty())
                    .orElse(false);
        }
        return isReadyForVerification(doctor)
                && (status == DoctorProfileStatus.READY_FOR_VERIFICATION
                || status == DoctorProfileStatus.PROFILE_INCOMPLETE
                || status == DoctorProfileStatus.REGISTERED
                || status == DoctorProfileStatus.CHANGES_REQUESTED
                || status == DoctorProfileStatus.REJECTED);
    }

    public String nextStepGuidance(Doctor doctor) {
        if (doctor == null) {
            return "Complete your profile to continue.";
        }
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == DoctorProfileStatus.APPROVED) {
            if (Boolean.TRUE.equals(doctor.getHasPendingReverification())) {
                return "You have profile changes pending admin approval. Your currently approved profile remains visible to patients.";
            }
            return "Your profile is approved. Patients can now discover and book you.";
        }
        if (status == DoctorProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. We will notify you once verification is complete.";
        }
        if (status == DoctorProfileStatus.REJECTED) {
            String reason = doctor.getRejectionReason();
            return "Your profile was rejected. "
                    + (isBlank(reason) ? "Update the required details and documents, then resubmit." : reason);
        }
        if (status == DoctorProfileStatus.CHANGES_REQUESTED) {
            String note = doctor.getChangesRequestedNote();
            return "Admin requested changes. "
                    + (isBlank(note) ? "Update the highlighted items and resubmit for verification." : note);
        }
        if (status == DoctorProfileStatus.SUSPENDED) {
            return "Your account is suspended. Contact support for assistance.";
        }
        if (isReadyForVerification(doctor)) {
            return "All mandatory items are complete. Submit your profile for admin verification.";
        }
        List<String> missing = missingItems(doctor);
        if (missing.isEmpty()) {
            return "Complete your professional profile to continue.";
        }
        return "Complete the remaining required items: " + String.join(", ", missing);
    }

    public void refreshCompletion(Doctor doctor) {
        int pct = calculateCompletionPct(doctor);
        doctor.setProfileCompletionPct(pct);
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == null) {
            status = DoctorProfileStatus.REGISTERED;
        }
        if (status == DoctorProfileStatus.REGISTERED || status == DoctorProfileStatus.PROFILE_INCOMPLETE) {
            if (isReadyForVerification(doctor)) {
                doctor.setDoctorProfileStatus(DoctorProfileStatus.READY_FOR_VERIFICATION);
            } else {
                doctor.setDoctorProfileStatus(DoctorProfileStatus.PROFILE_INCOMPLETE);
            }
        } else if (status == DoctorProfileStatus.CHANGES_REQUESTED && isReadyForVerification(doctor)) {
            doctor.setDoctorProfileStatus(DoctorProfileStatus.READY_FOR_VERIFICATION);
        }
    }

    public void syncVerificationStatus(Doctor doctor) {
        DoctorProfileStatus profileStatus = doctor.getDoctorProfileStatus();
        if (profileStatus == null) {
            return;
        }
        switch (profileStatus) {
            case APPROVED -> doctor.setVerificationStatus(VerificationStatus.VERIFIED);
            case REJECTED -> doctor.setVerificationStatus(VerificationStatus.REJECTED);
            case PENDING_ADMIN_APPROVAL, READY_FOR_VERIFICATION, PROFILE_INCOMPLETE, REGISTERED, CHANGES_REQUESTED ->
                    doctor.setVerificationStatus(VerificationStatus.PENDING);
            case SUSPENDED -> {
                if (doctor.getVerificationStatus() == VerificationStatus.VERIFIED) {
                    doctor.setVerificationStatus(VerificationStatus.PENDING);
                }
            }
            default -> {
            }
        }
    }

    public void ensureLoginProfileState(Doctor doctor) {
        if (doctor.getDoctorProfileStatus() == DoctorProfileStatus.REGISTERED) {
            setLifecycleStatus(doctor, DoctorProfileStatus.PROFILE_INCOMPLETE);
        }
        refreshCompletion(doctor);
        syncVerificationStatus(doctor);
    }

    public static boolean isRealDocument(String path) {
        if (isBlank(path)) {
            return false;
        }
        String normalized = path.trim().toLowerCase(Locale.ROOT);
        return !normalized.equals("mobile-pending") && !normalized.startsWith("mobile:");
    }

    public static String primaryDocumentPath(String path) {
        if (isBlank(path)) {
            return null;
        }
        int pipe = path.indexOf('|');
        return pipe < 0 ? path.trim() : path.substring(0, pipe).trim();
    }

    private void applyConsultationModes(Doctor doctor, Map<String, Object> body) {
        List<String> modes = new ArrayList<>();
        Object rawModes = body.get("consultationModes");
        if (rawModes instanceof List<?> list) {
            for (Object item : list) {
                String mode = asString(item);
                if (!isBlank(mode)) {
                    modes.add(mode.trim().toUpperCase(Locale.ROOT));
                }
            }
        } else if (rawModes != null) {
            modes.addAll(splitCsv(asString(rawModes)));
        }

        if (modes.isEmpty() && body.containsKey("consultationType")) {
            String type = asString(body.get("consultationType"));
            if (!isBlank(type)) {
                modes.add(type.trim().toUpperCase(Locale.ROOT));
            }
        }

        LinkedHashSet<String> unique = new LinkedHashSet<>();
        for (String mode : modes) {
            if ("BOTH".equals(mode)) {
                unique.add("CLINIC");
                unique.add("VIDEO");
                continue;
            }
            if (!VALID_MODES.contains(mode)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid consultation mode: " + mode);
            }
            unique.add(mode);
        }

        if (unique.isEmpty()) {
            doctor.setConsultationModes(null);
            doctor.setConsultationType(null);
            return;
        }

        doctor.setConsultationModes(String.join(",", unique));
        if (unique.size() == 1) {
            doctor.setConsultationType(ConsultationType.valueOf(unique.iterator().next()));
        } else {
            doctor.setConsultationType(ConsultationType.BOTH);
        }
    }

    @SuppressWarnings("unchecked")
    private void applyAvailabilitySlots(Doctor doctor, Object raw) {
        List<Map<String, Object>> slots = new ArrayList<>();
        if (raw instanceof List<?> list) {
            for (Object item : list) {
                if (item instanceof Map<?, ?> map) {
                    slots.add((Map<String, Object>) map);
                }
            }
        } else if (raw instanceof String s && notBlank(s)) {
            try {
                slots = MAPPER.readValue(s, new TypeReference<List<Map<String, Object>>>() {});
            } catch (Exception ex) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid availability slots format");
            }
        } else if (raw != null && !(raw instanceof String)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid availability slots format");
        }

        if (slots.isEmpty()) {
            doctor.setAvailabilitySlots(null);
            doctor.setAvailableDays(null);
            doctor.setStartTime(null);
            doctor.setEndTime(null);
            return;
        }

        LinkedHashSet<String> days = new LinkedHashSet<>();
        String earliest = null;
        String latest = null;
        List<Map<String, String>> normalized = new ArrayList<>();

        for (Map<String, Object> slot : slots) {
            String day = asString(slot.get("day")).trim().toUpperCase(Locale.ROOT);
            String start = asString(slot.get("start")).trim();
            String end = asString(slot.get("end")).trim();
            if (!VALID_DAYS.contains(day)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid availability day: " + day);
            }
            if (isBlank(start) || isBlank(end)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Each availability slot needs start and end time");
            }
            if (start.compareTo(end) >= 0) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Slot end time must be after start time");
            }
            days.add(day);
            if (earliest == null || start.compareTo(earliest) < 0) {
                earliest = start;
            }
            if (latest == null || end.compareTo(latest) > 0) {
                latest = end;
            }
            Map<String, String> row = new LinkedHashMap<>();
            row.put("day", day);
            row.put("start", start);
            row.put("end", end);
            normalized.add(row);
        }

        try {
            doctor.setAvailabilitySlots(MAPPER.writeValueAsString(normalized));
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to save availability slots");
        }
        doctor.setAvailableDays(String.join(",", days));
        doctor.setStartTime(earliest);
        doctor.setEndTime(latest);
    }

    public List<Map<String, String>> readAvailabilitySlots(Doctor doctor) {
        return parseAvailabilitySlots(doctor == null ? null : doctor.getAvailabilitySlots());
    }

    public List<Map<String, String>> parseAvailabilitySlots(String raw) {
        if (isBlank(raw)) {
            return List.of();
        }
        try {
            List<Map<String, String>> slots = MAPPER.readValue(raw, new TypeReference<List<Map<String, String>>>() {});
            return slots == null ? List.of() : slots;
        } catch (Exception ex) {
            return List.of();
        }
    }

    private static boolean hasRequiredDocuments(Doctor doctor) {
        return isRealDocument(doctor.getProfilePhotoPath())
                && (isRealDocument(doctor.getIdProofPath()) || isRealDocument(doctor.getIdentityDocumentPath()))
                && isRealDocument(doctor.getMedicalLicensePath())
                && isRealDocument(primaryDocumentPath(doctor.getDegreeCertificatePath()));
    }

    private static String normalizeDays(String raw) {
        List<String> days = splitCsv(raw).stream()
                .map(d -> d.toUpperCase(Locale.ROOT))
                .filter(VALID_DAYS::contains)
                .collect(Collectors.toCollection(LinkedHashSet::new))
                .stream()
                .toList();
        return days.isEmpty() ? null : String.join(",", days);
    }

    private static String normalizeCsv(String raw) {
        List<String> parts = splitCsv(raw);
        return parts.isEmpty() ? null : String.join(", ", parts);
    }

    private static String normalizePincode(String raw) {
        String pin = blankToNull(raw);
        if (pin == null) {
            return null;
        }
        if (!isValidPincode(pin)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pincode must be exactly 6 digits");
        }
        return pin;
    }

    private static boolean isValidPincode(String raw) {
        return raw != null && raw.trim().matches("\\d{6}");
    }

    private static List<String> splitCsv(String raw) {
        if (isBlank(raw)) {
            return List.of();
        }
        return Arrays.stream(raw.split("[,|]"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toCollection(ArrayList::new));
    }

    private static String asString(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private static Integer asInteger(Object value, String label) {
        if (value == null || asString(value).isBlank()) {
            return null;
        }
        try {
            if (value instanceof Number n) {
                return n.intValue();
            }
            return Integer.parseInt(asString(value).trim());
        } catch (NumberFormatException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, label + " must be a number");
        }
    }

    private static Double asDouble(Object value, String label) {
        if (value == null || asString(value).isBlank()) {
            return null;
        }
        try {
            if (value instanceof Number n) {
                return n.doubleValue();
            }
            return Double.parseDouble(asString(value).trim());
        } catch (NumberFormatException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, label + " must be a number");
        }
    }

    private static boolean asBoolean(Object value) {
        if (value instanceof Boolean b) {
            return b;
        }
        return Boolean.parseBoolean(asString(value));
    }

    private static String blankToNull(String value) {
        return isBlank(value) ? null : value.trim();
    }

    private static boolean notBlank(String value) {
        return !isBlank(value);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
