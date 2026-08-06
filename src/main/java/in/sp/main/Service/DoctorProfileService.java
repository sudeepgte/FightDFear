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

    public void updateProfile(Doctor doctor, Map<String, Object> body) {
        if (doctor == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Doctor login required");
        }
        if (body == null || body.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile data is required");
        }

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
            doctor.setExperienceYears(asInteger(body.get("experienceYears"), "Years of experience"));
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
            doctor.setPincode(blankToNull(asString(body.get("pincode"))));
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

        refreshCompletion(doctor);
        syncVerificationStatus(doctor);
    }

    public int calculateCompletionPct(Doctor doctor) {
        if (doctor == null) {
            return 0;
        }
        int filled = 0;
        int total = 10;

        if (notBlank(doctor.getFullName())) filled++;
        if (notBlank(doctor.getSpecialization())) filled++;
        if (notBlank(doctor.getQualification())) filled++;
        if (notBlank(doctor.getMedicalRegNumber())) filled++;
        if (doctor.getExperienceYears() != null && doctor.getExperienceYears() >= 0) filled++;
        if (doctor.getConsultationFee() != null && doctor.getConsultationFee() >= 0) filled++;
        if (notBlank(doctor.getHospitalName())) filled++;
        if (notBlank(doctor.getClinicAddress()) && notBlank(doctor.getCity())) filled++;
        if (notBlank(doctor.getAvailableDays()) && notBlank(doctor.getStartTime())) filled++;
        if (hasRequiredDocuments(doctor)) filled++;

        return (int) Math.round(100.0 * filled / total);
    }

    public List<String> missingItems(Doctor doctor) {
        List<String> missing = new ArrayList<>();
        if (doctor == null) {
            missing.add("Doctor profile not found");
            return missing;
        }
        if (isBlank(doctor.getSpecialization())) missing.add("Specialization");
        if (isBlank(doctor.getQualification())) missing.add("Qualification");
        if (isBlank(doctor.getMedicalRegNumber())) missing.add("Medical registration number");
        if (doctor.getExperienceYears() == null) missing.add("Years of experience");
        if (doctor.getConsultationFee() == null) missing.add("Consultation fee");
        if (isBlank(doctor.getHospitalName())) missing.add("Hospital / clinic name");
        if (isBlank(doctor.getClinicAddress()) || isBlank(doctor.getCity())) missing.add("Clinic address and city");
        if (isBlank(doctor.getAvailableDays()) || isBlank(doctor.getStartTime())) missing.add("Working availability");
        if (!isRealDocument(doctor.getProfilePhotoPath())) missing.add("Profile photo");
        if (!isRealDocument(doctor.getIdProofPath()) && !isRealDocument(doctor.getIdentityDocumentPath())) {
            missing.add("Government ID");
        }
        if (!isRealDocument(doctor.getMedicalLicensePath())) missing.add("Medical license");
        if (!isRealDocument(primaryDocumentPath(doctor.getDegreeCertificatePath()))) {
            missing.add("Medical registration certificate");
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
        payload.put("profileCompletionPct", doctor.getProfileCompletionPct());
        payload.put("missingItems", missingItems(doctor));
        payload.put("canSubmitForVerification", isReadyForVerification(doctor)
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.PENDING_ADMIN_APPROVAL
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.SUSPENDED);
        payload.put("rejectionReason", doctor.getRejectionReason());
        payload.put("changesRequestedNote", doctor.getChangesRequestedNote());
        payload.put("nextStepGuidance", nextStepGuidance(doctor));
        return payload;
    }

    public String nextStepGuidance(Doctor doctor) {
        if (doctor == null) {
            return "Complete your profile to continue.";
        }
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == DoctorProfileStatus.APPROVED) {
            return "Your profile is approved. Patients can now discover and book you.";
        }
        if (status == DoctorProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. We will notify you once verification is complete.";
        }
        if (status == DoctorProfileStatus.REJECTED) {
            return "Your profile was rejected. Update the required details and documents, then resubmit.";
        }
        if (status == DoctorProfileStatus.CHANGES_REQUESTED) {
            return "Admin requested changes. Update the highlighted items and resubmit for verification.";
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

    private List<Map<String, String>> parseAvailabilitySlots(String raw) {
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
