package in.sp.main.Service;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.FitnessTrainerRepository;

@Service
public class FitnessTrainerProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private FitnessTrainerRepository trainerRepository;

    public void setLifecycleStatus(FitnessTrainer trainer, PartnerProfileStatus status) {
        if (trainer == null || status == null) {
            return;
        }
        trainer.setPartnerProfileStatus(status);
        trainer.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
        if (status == PartnerProfileStatus.SUSPENDED) {
            trainer.setSuspended(true);
        }
    }

    public static boolean isApproved(FitnessTrainer trainer) {
        if (trainer == null || trainer.isSuspended()) return false;
        return trainer.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
                || trainer.getVerificationStatus() == VerificationStatus.VERIFIED;
    }

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
        return missing;
    }

    public int calculateCompletionPct(FitnessTrainer trainer) {
        int total = 16;
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
        m.put("upiId", t.getUpiId());
        m.put("bankDetails", t.getBankDetails());
        m.put("payoutBalance", t.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(t.getGalleryPhotos()));
        m.put("profileImageUrl", t.getProfilePhotoPath());
        m.put("rating", t.getRating());
        m.put("reviewCount", t.getReviewCount());
        m.put("bio", t.getBio());
    }

    @Transactional
    public FitnessTrainer applyExtraFields(FitnessTrainer t, Map<String, Object> body) {
        if (t == null || body == null) return t;
        if (body.get("fullName") != null) t.setFullName(blankToNull(str(body.get("fullName"))));
        if (body.get("phone") != null) t.setPhone(blankToNull(str(body.get("phone"))));
        if (body.get("designation") != null) t.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) t.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("address") != null) t.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) t.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) t.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) t.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { t.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { t.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("specializations") != null || body.get("categoriesOffered") != null) {
            t.setSpecializations(csv(body.get("specializations") != null
                    ? body.get("specializations") : body.get("categoriesOffered")));
        }
        if (body.get("audience") != null) t.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) t.setDoorService(Boolean.TRUE.equals(body.get("doorService"))
                || "true".equalsIgnoreCase(str(body.get("doorService"))));
        if (body.get("facilities") != null) t.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) t.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) t.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) t.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) t.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) t.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) t.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) t.setBio(blankToNull(str(body.get("bio"))));
        if (body.get("experience") != null || body.get("yearsExperience") != null || body.get("experienceYears") != null) {
            Object raw = body.get("experience") != null ? body.get("experience")
                    : (body.get("yearsExperience") != null ? body.get("yearsExperience") : body.get("experienceYears"));
            if (raw == null || str(raw).isBlank()) {
                t.setExperience(null);
            } else {
                try { t.setExperience(Integer.parseInt(str(raw))); } catch (Exception ignored) {}
            }
        }
        if (body.get("credentialNumber") != null) t.setCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        if (body.get("sessionMode") != null) {
            t.setSessionMode(blankToNull(str(body.get("sessionMode"))));
            t.setServiceType(blankToNull(str(body.get("sessionMode"))));
        }
        if (body.get("serviceType") != null) t.setServiceType(blankToNull(str(body.get("serviceType"))));
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { t.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { t.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null || body.get("sessionFees") != null) {
            Object raw = body.get("typicalPrice") != null ? body.get("typicalPrice") : body.get("sessionFees");
            if (raw == null || str(raw).isBlank()) {
                t.setTypicalPrice(null);
                t.setSessionFees(null);
            } else {
                try {
                    double fee = Double.parseDouble(str(raw));
                    t.setTypicalPrice(fee);
                    t.setSessionFees(fee);
                } catch (Exception ignored) {}
            }
        }
        if (body.get("upiId") != null) t.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) t.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (body.get("availableTimings") != null) {
            t.setAvailableTimings(blankToNull(str(body.get("availableTimings"))));
        } else if (t.getOpenTime() != null && t.getCloseTime() != null) {
            t.setAvailableTimings(t.getOpenTime().format(TIME_FMT) + " - " + t.getCloseTime().format(TIME_FMT));
        }
        return t;
    }

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(FitnessTrainer trainer, List<String> missing) {
        PartnerProfileStatus s = trainer.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(FitnessTrainer trainer, List<String> missing) {
        PartnerProfileStatus s = trainer.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. You'll be notified once approved.";
        }
        if (isApproved(trainer)) {
            return "Your trainer profile is approved and visible to clients.";
        }
        if (s == PartnerProfileStatus.REJECTED) {
            return "Registration was rejected. Update your profile and resubmit.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            return "Admin requested changes. Update the highlighted items and resubmit.";
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "All required items are ready. Submit for admin verification.";
    }

    private static String str(Object v) { return v == null ? "" : String.valueOf(v).trim(); }
    private static String blankToNull(String v) { return v == null || v.isBlank() ? null : v.trim(); }

    private static String csv(Object v) {
        if (v instanceof List<?> list) {
            return list.stream().map(String::valueOf).map(String::trim).filter(s -> !s.isEmpty())
                    .reduce((a, b) -> a + "," + b).orElse("");
        }
        return str(v);
    }

    private static List<String> splitCsv(String v) {
        if (v == null || v.isBlank()) return List.of();
        List<String> out = new ArrayList<>();
        for (String p : v.split("[,|]")) {
            String t = p.trim();
            if (!t.isEmpty()) out.add(t);
        }
        return out;
    }

    private static LocalTime parseTime(Object v) {
        String s = str(v);
        if (s.isBlank()) return null;
        try {
            if (s.length() >= 5) return LocalTime.parse(s.substring(0, 5));
            return LocalTime.parse(s, TIME_FMT);
        } catch (Exception e) {
            try { return LocalTime.parse(s); } catch (Exception ignored) { return null; }
        }
    }
}
