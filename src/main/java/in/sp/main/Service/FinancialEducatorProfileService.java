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

import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.FinancialEducatorRepository;

@Service
public class FinancialEducatorProfileService {

    public static final List<String> EXPERTISE = List.of(
            "Saving", "Investing", "Loans", "Banking", "Insurance", "Government Schemes"
    );
    public static final List<String> SESSION_MODES = List.of("Live", "Workshop", "1:1");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private FinancialEducatorRepository educatorRepository;

    public void setLifecycleStatus(FinancialEducator e, PartnerProfileStatus status) {
        if (e == null || status == null) return;
        e.setPartnerProfileStatus(status);
        e.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
        if (status == PartnerProfileStatus.SUSPENDED) e.setSuspended(true);
        if (status == PartnerProfileStatus.APPROVED) e.setSuspended(false);
    }

    public static boolean isApproved(FinancialEducator e) {
        if (e == null || e.isSuspended()) return false;
        return e.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
                || e.getVerificationStatus() == in.sp.main.Entities.VerificationStatus.VERIFIED;
    }

    public static String normalizeExpertise(String raw) {
        if (raw == null || raw.isBlank()) return null;
        List<String> parts = splitCsv(raw);
        List<String> kept = new ArrayList<>();
        for (String p : parts) {
            EXPERTISE.stream().filter(c -> c.equalsIgnoreCase(p)).findFirst().ifPresent(kept::add);
        }
        return kept.isEmpty() ? null : String.join(",", kept);
    }

    public List<String> missingItems(FinancialEducator e) {
        List<String> missing = new ArrayList<>();
        if (e == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(e.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(e.getDesignation())) missing.add("1.2 Role");
        if (PartnerLifecycleSupport.blank(e.getPhone()) || !e.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(e.getCredentialNumber())) missing.add("1.8 NISM / SEBI / IRDAI / CFP number");
        if (PartnerLifecycleSupport.blank(e.getAddress())) missing.add("2.1 Address");
        if (PartnerLifecycleSupport.blank(e.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(e.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(e.getPincode()) || !e.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(e.getCategoriesOffered()) && PartnerLifecycleSupport.blank(e.getExpertise())) {
            missing.add("3.1 Expertise");
        }
        if (PartnerLifecycleSupport.blank(e.getAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(e.getOpenDays())) missing.add("6.1 Open days");
        if (e.getOpenTime() == null) missing.add("6.2 Open time");
        if (e.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(e.getBio())) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(e.getSessionMode()) || e.getDurationMinutes() == null || e.getTypicalPrice() == null) {
            missing.add("8. First offering");
        }
        return missing;
    }

    public int calculateCompletionPct(FinancialEducator e) {
        int total = 15;
        int filled = total - missingItems(e).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public FinancialEducator refreshCompletion(FinancialEducator e) {
        List<String> missing = missingItems(e);
        e.setProfileCompletionPct(calculateCompletionPct(e));
        PartnerProfileStatus current = e.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return educatorRepository.save(e);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(e, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(e, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return educatorRepository.save(e);
    }

    public boolean isReadyForVerification(FinancialEducator e) {
        return missingItems(e).isEmpty();
    }

    public Map<String, Object> profilePayload(FinancialEducator e) {
        refreshCompletion(e);
        List<String> missing = missingItems(e);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("fullName", e.getFullName());
        m.put("email", e.getEmail());
        m.put("phone", e.getPhone());
        m.put("city", e.getCity());
        m.put("expertise", e.getExpertise());
        m.put("organization", e.getOrganization());
        m.put("yearsExperience", e.getYearsExperience());
        m.put("bio", e.getBio());
        m.put("approved", isApproved(e));
        m.put("suspended", e.isSuspended());
        m.put("verificationStatus", e.getVerificationStatus() == null ? null : e.getVerificationStatus().name());
        m.put("partnerProfileStatus", e.getPartnerProfileStatus() == null ? null : e.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(e.getPartnerProfileStatus()));
        m.put("profileCompletionPct", e.getProfileCompletionPct() == null ? 0 : e.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(e, missing));
        m.put("rejectionReason", e.getRejectionReason());
        m.put("changesRequestedNote", e.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(e, missing));
        m.put("expertiseOptions", EXPERTISE);
        m.put("cancelPolicy", FinancialLiteracyCareService.CANCEL_POLICY);
        putExtra(m, e);
        return m;
    }

    public static void putExtra(Map<String, Object> m, FinancialEducator e) {
        if (m == null || e == null) return;
        m.put("designation", e.getDesignation());
        m.put("whatsappNumber", e.getWhatsappNumber());
        m.put("address", e.getAddress());
        m.put("state", e.getState());
        m.put("pincode", e.getPincode());
        m.put("latitude", e.getLatitude());
        m.put("longitude", e.getLongitude());
        m.put("categoriesOffered", splitCsv(e.getCategoriesOffered() != null ? e.getCategoriesOffered() : e.getExpertise()));
        m.put("audience", splitCsv(e.getAudience()));
        m.put("doorService", Boolean.TRUE.equals(e.getDoorService()));
        m.put("facilities", splitCsv(e.getFacilities()));
        m.put("openDays", splitCsv(e.getOpenDays()));
        m.put("openTime", e.getOpenTime() == null ? null : e.getOpenTime().format(TIME_FMT));
        m.put("closeTime", e.getCloseTime() == null ? null : e.getCloseTime().format(TIME_FMT));
        m.put("breakStart", e.getBreakStart() == null ? null : e.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", e.getBreakEnd() == null ? null : e.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", e.getBlockedDates());
        m.put("credentialNumber", e.getCredentialNumber());
        m.put("sessionMode", e.getSessionMode());
        m.put("durationMinutes", e.getDurationMinutes());
        m.put("bufferMinutes", e.getBufferMinutes());
        m.put("typicalPrice", e.getTypicalPrice());
        m.put("upiId", e.getUpiId());
        m.put("bankDetails", e.getBankDetails());
        m.put("payoutBalance", e.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(e.getGalleryPhotos()));
        m.put("profileImageUrl", e.getProfilePhotoPath());
        m.put("rating", e.getRating());
        m.put("reviewCount", e.getReviewCount());
    }

    @Transactional
    public FinancialEducator applyExtraFields(FinancialEducator e, Map<String, Object> body) {
        if (e == null || body == null) return e;
        if (body.get("designation") != null) e.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) e.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("address") != null) e.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) e.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) e.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) e.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { e.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { e.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null || body.get("expertise") != null) {
            String csv = csv(body.get("categoriesOffered") != null ? body.get("categoriesOffered") : body.get("expertise"));
            String norm = normalizeExpertise(csv);
            e.setCategoriesOffered(norm);
            e.setExpertise(norm);
        }
        if (body.get("audience") != null) e.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) e.setDoorService(Boolean.TRUE.equals(body.get("doorService"))
                || "true".equalsIgnoreCase(str(body.get("doorService"))));
        if (body.get("facilities") != null) e.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) e.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) e.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) e.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) e.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) e.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) e.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) e.setBio(blankToNull(str(body.get("bio"))));
        if (body.get("organization") != null) e.setOrganization(blankToNull(str(body.get("organization"))));
        if (body.get("yearsExperience") != null && !str(body.get("yearsExperience")).isBlank()) {
            try { e.setYearsExperience(Integer.parseInt(str(body.get("yearsExperience")))); } catch (Exception ignored) {}
        }
        if (body.get("credentialNumber") != null) e.setCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        if (body.get("sessionMode") != null) e.setSessionMode(blankToNull(str(body.get("sessionMode"))));
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { e.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { e.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null && !str(body.get("typicalPrice")).isBlank()) {
            try { e.setTypicalPrice(Double.parseDouble(str(body.get("typicalPrice")))); } catch (Exception ignored) {}
        }
        if (body.get("upiId") != null) e.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) e.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        return e;
    }

    private boolean canSubmit(FinancialEducator e, List<String> missing) {
        PartnerProfileStatus s = e.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(FinancialEducator e, List<String> missing) {
        PartnerProfileStatus s = e.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your educator profile is under admin review.";
        }
        if (isApproved(e)) {
            return "You're approved. Publish videos, live sessions and workshops from Studio.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            String note = e.getChangesRequestedNote();
            return note == null || note.isBlank()
                    ? "Admin requested changes. Update your profile and resubmit."
                    : "Admin requested changes: " + note;
        }
        if (s == PartnerProfileStatus.REJECTED) {
            String reason = e.getRejectionReason();
            return reason == null || reason.isBlank()
                    ? "Application was rejected. Update your profile and resubmit."
                    : "Rejected: " + reason;
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "Profile looks complete. Submit for admin verification.";
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
