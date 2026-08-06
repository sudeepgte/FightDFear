package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.stereotype.Service;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.VerificationStatus;

@Service
public class DoctorProfileService {

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
        if (!isRealDocument(doctor.getDegreeCertificatePath())) missing.add("Medical registration certificate");
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
        payload.put("consultationFee", doctor.getConsultationFee());
        payload.put("chatFee", doctor.getChatFee());
        payload.put("callFee", doctor.getCallFee());
        payload.put("videoFee", doctor.getVideoFee());
        payload.put("consultationType", doctor.getConsultationType() == null ? null : doctor.getConsultationType().name());
        payload.put("availableDays", doctor.getAvailableDays());
        payload.put("startTime", doctor.getStartTime());
        payload.put("endTime", doctor.getEndTime());
        payload.put("profilePhotoPath", doctor.getProfilePhotoPath());
        payload.put("identityDocumentPath", doctor.getIdentityDocumentPath());
        payload.put("idProofPath", doctor.getIdProofPath());
        payload.put("medicalLicensePath", doctor.getMedicalLicensePath());
        payload.put("degreeCertificatePath", doctor.getDegreeCertificatePath());
        payload.put("verificationStatus", doctor.getVerificationStatus() == null ? null : doctor.getVerificationStatus().name());
        payload.put("doctorProfileStatus", doctor.getDoctorProfileStatus() == null ? null : doctor.getDoctorProfileStatus().name());
        payload.put("profileCompletionPct", doctor.getProfileCompletionPct());
        payload.put("missingItems", missingItems(doctor));
        payload.put("canSubmitForVerification", isReadyForVerification(doctor)
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.PENDING_ADMIN_APPROVAL
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED);
        payload.put("rejectionReason", doctor.getRejectionReason());
        payload.put("changesRequestedNote", doctor.getChangesRequestedNote());
        return payload;
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
            doctor.setDoctorProfileStatus(DoctorProfileStatus.PROFILE_INCOMPLETE);
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

    private static boolean hasRequiredDocuments(Doctor doctor) {
        return isRealDocument(doctor.getProfilePhotoPath())
                && (isRealDocument(doctor.getIdProofPath()) || isRealDocument(doctor.getIdentityDocumentPath()))
                && isRealDocument(doctor.getMedicalLicensePath())
                && isRealDocument(doctor.getDegreeCertificatePath());
    }

    private static boolean notBlank(String value) {
        return !isBlank(value);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
