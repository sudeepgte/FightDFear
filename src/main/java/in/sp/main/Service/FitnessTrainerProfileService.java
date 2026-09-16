package in.sp.main.Service;

import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.FitnessTrainerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class FitnessTrainerProfileService {

    @Autowired
    private FitnessTrainerRepository trainerRepository;

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    public List<String> missingItems(FitnessTrainer trainer) {
        List<String> missing = new ArrayList<>();
        if (trainer == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(trainer.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(trainer.getDesignation())) missing.add("1.2 Designation");
        if (PartnerLifecycleSupport.blank(trainer.getPhone()) || !trainer.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (trainer.getExperience() == null) missing.add("1.7 Years of experience");
        if (PartnerLifecycleSupport.blank(trainer.getCredentialNumber())) {
            missing.add("1.8 ACE / NASM / Yoga Alliance / cert number");
        }
        if (PartnerLifecycleSupport.blank(trainer.getAddress())) missing.add("2.1 Address");
        if (PartnerLifecycleSupport.blank(trainer.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(trainer.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(trainer.getPincode()) || !trainer.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(trainer.getSpecializations())) missing.add("3.1 Specializations");
        if (PartnerLifecycleSupport.blank(trainer.getAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(trainer.getOpenDays())) missing.add("6.1 Open days");
        if (trainer.getOpenTime() == null) missing.add("6.2 Open time");
        if (trainer.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(trainer.getBio())) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(trainer.getSessionMode()) || trainer.getTypicalPrice() == null) {
            missing.add("8. Typical session");
        }
        if (PartnerLifecycleSupport.blank(trainer.getCertificationsPath())) {
            missing.add("10. Documents & Certification");
        }
        if (PartnerLifecycleSupport.blank(trainer.getGalleryPhotos())) {
            missing.add("11. Studio photos");
        }
        return missing;
    }

    public int calculateCompletionPct(FitnessTrainer trainer) {
        int total = 18;
        int filled = total - missingItems(trainer).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public FitnessTrainer refreshCompletion(FitnessTrainer trainer) {
        List<String> missing = missingItems(trainer);
        int pct = calculateCompletionPct(trainer);
        trainer.setProfileCompletionPct(pct);

        PartnerProfileStatus current = trainer.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return trainerRepository.save(trainer);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(trainer, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(trainer, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return trainerRepository.save(trainer);
    }

    public boolean isReadyForVerification(FitnessTrainer trainer) {
        return missingItems(trainer).isEmpty();
    }

    public Map<String, Object> profilePayload(FitnessTrainer trainer) {
        refreshCompletion(trainer);
        List<String> missing = missingItems(trainer);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", trainer.getId());
        m.put("fullName", trainer.getFullName());
        m.put("email", trainer.getEmail());
        m.put("phone", trainer.getPhone());
        m.put("experience", trainer.getExperience());
        m.put("specializations", trainer.getSpecializations());
        m.put("availableTimings", trainer.getAvailableTimings());
        m.put("sessionFees", trainer.getSessionFees());
        m.put("city", trainer.getCity());
        m.put("bio", trainer.getBio());
        m.put("serviceType", trainer.getServiceType());
        m.put("profilePhotoPath", trainer.getProfilePhotoPath());
        m.put("certificationsPath", trainer.getCertificationsPath());
        m.put("rating", trainer.getRating());
        m.put("verificationStatus", trainer.getVerificationStatus() == null
                ? null : trainer.getVerificationStatus().name());
        m.put("suspended", trainer.isSuspended());
        m.put("partnerProfileStatus", trainer.getPartnerProfileStatus() == null
                ? null : trainer.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", statusLabel(trainer.getPartnerProfileStatus()));
        m.put("profileCompletionPct", trainer.getProfileCompletionPct() == null
                ? 0 : trainer.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(trainer, missing));
        m.put("rejectionReason", trainer.getRejectionReason());
        m.put("changesRequestedNote", trainer.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(trainer, missing));
        m.put("approved", isApproved(trainer));
        m.put("cancelPolicy", FitnessCareService.CANCEL_POLICY);
        putExtra(m, trainer);
        return m;
    }

    public static void putExtra(Map<String, Object> m, FitnessTrainer t) {
        if (m == null || t == null) return;
        m.put("designation", t.getDesignation());
        m.put("whatsappNumber", t.getWhatsappNumber());
        m.put("address", t.getAddress());
        m.put("city", t.getCity());
        m.put("state", t.getState());
        m.put("pincode", t.getPincode());
        m.put("latitude", t.getLatitude());
        m.put("longitude", t.getLongitude());
        m.put("categoriesOffered", splitCsv(t.getSpecializations()));
        m.put("audience", splitCsv(t.getAudience()));
        m.put("doorService", Boolean.TRUE.equals(t.getDoorService()));
        m.put("facilities", splitCsv(t.getFacilities()));
        m.put("openDays", splitCsv(t.getOpenDays()));
        m.put("openTime", t.getOpenTime() == null ? null : t.getOpenTime().format(TIME_FMT));
        m.put("closeTime", t.getCloseTime() == null ? null : t.getCloseTime().format(TIME_FMT));
        m.put("breakStart", t.getBreakStart() == null ? null : t.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", t.getBreakEnd() == null ? null : t.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", t.getBlockedDates());
        m.put("credentialNumber", t.getCredentialNumber());
        m.put("sessionMode", t.getSessionMode());
        m.put("durationMinutes", t.getDurationMinutes());
        m.put("bufferMinutes", t.getBufferMinutes());
        m.put("typicalPrice", t.getTypicalPrice() != null ? t.getTypicalPrice() : t.getSessionFees());
    }

    private static List<String> splitCsv(String s) {
        if (s == null || s.trim().isEmpty()) return Collections.emptyList();
        List<String> list = new ArrayList<>();
        for (String x : s.split(",")) {
            String trimmed = x.trim();
            if (!trimmed.isEmpty()) list.add(trimmed);
        }
        return list;
    }

    public void setLifecycleStatus(FitnessTrainer trainer, PartnerProfileStatus status) {
        trainer.setPartnerProfileStatus(status);
        if (status == PartnerProfileStatus.READY_FOR_VERIFICATION) {
            trainer.setVerificationStatus(in.sp.main.Entities.VerificationStatus.PENDING);
        } else if (status == PartnerProfileStatus.APPROVED) {
            trainer.setVerificationStatus(in.sp.main.Entities.VerificationStatus.VERIFIED);
        }
    }

    public static String statusLabel(PartnerProfileStatus status) {
        if (status == null) return "Registered";
        switch (status) {
            case REGISTERED: return "Registered";
            case PROFILE_INCOMPLETE: return "Profile Incomplete";
            case READY_FOR_VERIFICATION: return "Under Verification";
            case PENDING_ADMIN_APPROVAL: return "Awaiting Approval";
            case CHANGES_REQUESTED: return "Action Required";
            case APPROVED: return "Verified";
            case REJECTED: return "Rejected";
            case SUSPENDED: return "Suspended";
            default: return status.name();
        }
    }

    private boolean canSubmit(FitnessTrainer trainer, List<String> missing) {
        if (trainer == null) return false;
        if (!missing.isEmpty()) return false;
        PartnerProfileStatus status = trainer.getPartnerProfileStatus();
        return status == PartnerProfileStatus.PROFILE_INCOMPLETE
                || status == PartnerProfileStatus.CHANGES_REQUESTED
                || status == PartnerProfileStatus.REGISTERED
                || status == PartnerProfileStatus.READY_FOR_VERIFICATION;
    }

    private String guidance(FitnessTrainer trainer, List<String> missing) {
        if (trainer == null) return "";
        PartnerProfileStatus status = trainer.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.SUSPENDED) return "Your account is suspended.";
        if (status == PartnerProfileStatus.APPROVED) return "Your profile is live.";
        if (status == PartnerProfileStatus.REJECTED) return "Your application was rejected.";
        if (status == PartnerProfileStatus.CHANGES_REQUESTED) return "Please update the requested details and submit.";
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || status == PartnerProfileStatus.READY_FOR_VERIFICATION) {
            return "Your profile is under review by our admin team.";
        }
        if (!missing.isEmpty()) {
            return "Complete all missing items (" + missing.size() + ") to submit for verification.";
        }
        return "You can now submit your profile for verification.";
    }

    public static boolean isApproved(FitnessTrainer trainer) {
        return trainer != null && trainer.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED;
    }

    public void applyExtraFields(FitnessTrainer trainer, Map<String, Object> m) {
        putExtra(m, trainer);
    }
}
