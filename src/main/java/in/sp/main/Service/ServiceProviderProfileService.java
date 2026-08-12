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

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Util.LawyerCategories;

@Service
public class ServiceProviderProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("H:mm");

    @Autowired
    private ServiceProviderRepository providerRepository;

    public void setLifecycleStatus(ServiceProvider provider, PartnerProfileStatus status) {
        if (provider == null || status == null) {
            return;
        }
        provider.setPartnerProfileStatus(status);
        provider.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
    }

    public boolean isLawyer(ServiceProvider provider) {
        return provider != null && provider.getCategory() == ProviderCategory.WOMEN_LAWYER;
    }

    public List<String> missingItems(ServiceProvider provider) {
        List<String> missing = new ArrayList<>();
        if (provider == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (!isLawyer(provider)) {
            if (PartnerLifecycleSupport.blank(provider.getFullName())) missing.add("fullName");
            if (PartnerLifecycleSupport.blank(provider.getDescription())) missing.add("description");
            if (PartnerLifecycleSupport.blank(provider.getLocationText())) missing.add("locationText");
            if (provider.getCategory() == null) missing.add("category");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(provider.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(provider.getDesignation())) missing.add("1.2 Designation");
        if (PartnerLifecycleSupport.blank(provider.getPhone()) || !provider.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(provider.getBarCouncilId())) missing.add("1.8 Bar council ID");
        if (PartnerLifecycleSupport.blank(provider.getAddress())) missing.add("2.1 Chamber address");
        if (PartnerLifecycleSupport.blank(provider.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(provider.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(provider.getPincode()) || !provider.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(provider.getPracticeAreas())) missing.add("3.1 Practice areas");
        if (PartnerLifecycleSupport.blank(provider.getAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(provider.getOpenDays())) missing.add("6.1 Open days");
        if (provider.getOpenTime() == null) missing.add("6.2 Open time");
        if (provider.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(provider.getBio()) && PartnerLifecycleSupport.blank(provider.getDescription())) {
            missing.add("7.1 About");
        }
        if (provider.getConsultationFee() == null || provider.getConsultationFee() < 0
                || PartnerLifecycleSupport.blank(provider.getServiceMode())
                || provider.getDurationMinutes() == null) {
            missing.add("8. First offering");
        }
        return missing;
    }

    public int calculateCompletionPct(ServiceProvider provider) {
        int total = isLawyer(provider) ? 15 : 4;
        int filled = total - missingItems(provider).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public ServiceProvider refreshCompletion(ServiceProvider provider) {
        List<String> missing = missingItems(provider);
        int pct = calculateCompletionPct(provider);
        provider.setProfileCompletionPct(pct);

        PartnerProfileStatus current = provider.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return providerRepository.save(provider);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(provider, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(provider, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return providerRepository.save(provider);
    }

    public boolean isReadyForVerification(ServiceProvider provider) {
        return missingItems(provider).isEmpty();
    }

    public Map<String, Object> profilePayload(ServiceProvider provider) {
        refreshCompletion(provider);
        List<String> missing = missingItems(provider);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", provider.getId());
        m.put("fullName", provider.getFullName());
        m.put("email", provider.getEmail());
        m.put("phone", provider.getPhone());
        m.put("category", provider.getCategory() == null ? null : provider.getCategory().name());
        m.put("description", provider.getDescription());
        m.put("locationText", provider.getLocationText());
        m.put("identityDocumentPath", provider.getIdentityDocumentPath());
        m.put("rating", provider.getRating());
        m.put("verificationStatus", provider.getVerificationStatus() == null
                ? null : provider.getVerificationStatus().name());
        m.put("partnerProfileStatus", provider.getPartnerProfileStatus() == null
                ? null : provider.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", statusLabel(provider.getPartnerProfileStatus()));
        m.put("profileCompletionPct", provider.getProfileCompletionPct() == null
                ? 0 : provider.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(provider, missing));
        m.put("canCreateClass", provider.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        m.put("rejectionReason", provider.getRejectionReason());
        m.put("changesRequestedNote", provider.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(provider, missing));
        m.put("cancelPolicy", WomenLawyerCareService.CANCEL_POLICY);
        putLawyerFields(m, provider);
        return m;
    }

    @Transactional
    public ServiceProvider applyExtraFields(ServiceProvider p, Map<String, Object> body) {
        if (p == null || body == null) return p;
        if (body.get("designation") != null) p.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) p.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("address") != null) p.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) p.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) p.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) p.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { p.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { p.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("audience") != null) p.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) p.setDoorService(bool(body.get("doorService")));
        if (body.get("facilities") != null) p.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) p.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) p.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) p.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) p.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) p.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) p.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) {
            p.setBio(blankToNull(str(body.get("bio"))));
            if (PartnerLifecycleSupport.blank(p.getDescription())) p.setDescription(p.getBio());
        }
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { p.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { p.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("serviceMode") != null) p.setServiceMode(blankToNull(str(body.get("serviceMode")).toUpperCase()));
        if (body.get("upiId") != null) p.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) p.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (!PartnerLifecycleSupport.blank(p.getCity()) || !PartnerLifecycleSupport.blank(p.getAddress())) {
            String loc = (p.getAddress() == null ? "" : p.getAddress());
            if (p.getCity() != null && !p.getCity().isBlank()) {
                loc = loc.isBlank() ? p.getCity() : loc + ", " + p.getCity();
            }
            if (!loc.isBlank()) p.setLocationText(loc);
        }
        return p;
    }

    public static void putLawyerFields(Map<String, Object> m, ServiceProvider provider) {
        if (m == null || provider == null) return;
        m.put("practiceAreas", provider.getPracticeAreas());
        m.put("barCouncilId", provider.getBarCouncilId());
        m.put("experienceYears", provider.getExperienceYears());
        m.put("languages", provider.getLanguages());
        m.put("consultationFee", provider.getConsultationFee());
        m.put("consultationMode", provider.getConsultationMode() == null
                ? LawyerCategories.normalizeMode(null)
                : provider.getConsultationMode());
        m.put("isLawyer", provider.getCategory() == ProviderCategory.WOMEN_LAWYER);
        m.put("designation", provider.getDesignation());
        m.put("whatsappNumber", provider.getWhatsappNumber());
        m.put("address", provider.getAddress());
        m.put("city", provider.getCity());
        m.put("state", provider.getState());
        m.put("pincode", provider.getPincode());
        m.put("latitude", provider.getLatitude());
        m.put("longitude", provider.getLongitude());
        m.put("audience", splitCsv(provider.getAudience()));
        m.put("doorService", Boolean.TRUE.equals(provider.getDoorService()));
        m.put("facilities", splitCsv(provider.getFacilities()));
        m.put("openDays", splitCsv(provider.getOpenDays()));
        m.put("openTime", provider.getOpenTime() == null ? null : provider.getOpenTime().format(TIME_FMT));
        m.put("closeTime", provider.getCloseTime() == null ? null : provider.getCloseTime().format(TIME_FMT));
        m.put("breakStart", provider.getBreakStart() == null ? null : provider.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", provider.getBreakEnd() == null ? null : provider.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", provider.getBlockedDates());
        m.put("bio", provider.getBio() != null ? provider.getBio() : provider.getDescription());
        m.put("durationMinutes", provider.getDurationMinutes());
        m.put("bufferMinutes", provider.getBufferMinutes());
        m.put("serviceMode", provider.getServiceMode());
        m.put("upiId", provider.getUpiId());
        m.put("bankDetails", provider.getBankDetails());
        m.put("payoutBalance", provider.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(provider.getGalleryPhotos()));
        m.put("profileImageUrl", provider.getProfileImageUrl());
    }

    private static String str(Object v) {
        return v == null ? "" : String.valueOf(v).trim();
    }

    private static String blankToNull(String v) {
        return v == null || v.isBlank() ? null : v.trim();
    }

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

    private static boolean bool(Object v) {
        if (v instanceof Boolean b) return b;
        return "true".equalsIgnoreCase(str(v)) || "1".equals(str(v));
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

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(ServiceProvider provider, List<String> missing) {
        PartnerProfileStatus s = provider.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(ServiceProvider provider, List<String> missing) {
        PartnerProfileStatus s = provider.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. You'll be notified once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED) {
            return "Your provider profile is approved and visible to clients.";
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
}
