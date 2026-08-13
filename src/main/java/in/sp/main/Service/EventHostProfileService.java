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

import in.sp.main.Entities.EventHost;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.EventHostRepository;

@Service
public class EventHostProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private EventHostRepository hostRepository;

    public void setLifecycleStatus(EventHost host, PartnerProfileStatus status) {
        if (host == null || status == null) {
            return;
        }
        host.setPartnerProfileStatus(status);
        host.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
    }

    public static boolean isApproved(EventHost host) {
        if (host == null) return false;
        return host.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
                || host.getVerificationStatus() == VerificationStatus.VERIFIED;
    }

    public List<String> missingItems(EventHost host) {
        List<String> missing = new ArrayList<>();
        if (host == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(host.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(host.getOrganizerType())) missing.add("1.2 Organizer type");
        if (PartnerLifecycleSupport.blank(host.getOrganizerName())) missing.add("1.3 Organizer name");
        if (PartnerLifecycleSupport.blank(host.getPhone()) || !host.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(host.getCredentialNumber())) missing.add("1.8 GST / NGO / CIN number");
        if (PartnerLifecycleSupport.blank(host.getOfficeAddress())) missing.add("2.1 Address");
        if (PartnerLifecycleSupport.blank(host.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(host.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(host.getPincode()) || !host.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(host.getEventCategories())) missing.add("3.1 Categories");
        if (PartnerLifecycleSupport.blank(host.getAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(host.getOpenDays())) missing.add("6.1 Open days");
        if (host.getOpenTime() == null) missing.add("6.2 Open time");
        if (host.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(host.getHostBio())) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(host.getSessionMode()) || host.getTypicalPrice() == null) {
            missing.add("8. Typical ticket");
        }
        return missing;
    }

    public int calculateCompletionPct(EventHost host) {
        int total = 16;
        int filled = total - missingItems(host).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public EventHost refreshCompletion(EventHost host) {
        List<String> missing = missingItems(host);
        int pct = calculateCompletionPct(host);
        host.setProfileCompletionPct(pct);

        PartnerProfileStatus current = host.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return hostRepository.save(host);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(host, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(host, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return hostRepository.save(host);
    }

    public boolean isReadyForVerification(EventHost host) {
        return missingItems(host).isEmpty();
    }

    public Map<String, Object> profilePayload(EventHost host) {
        refreshCompletion(host);
        List<String> missing = missingItems(host);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", host.getId());
        m.put("fullName", host.getFullName());
        m.put("email", host.getEmail());
        m.put("phone", host.getPhone());
        m.put("organizerName", host.getOrganizerName());
        m.put("organizerType", host.getOrganizerType());
        m.put("hostContact", host.getHostContact());
        m.put("hostBio", host.getHostBio());
        m.put("city", host.getCity());
        m.put("state", host.getState());
        m.put("officeAddress", host.getOfficeAddress());
        m.put("website", host.getWebsite());
        m.put("instagram", host.getInstagram());
        m.put("facebook", host.getFacebook());
        m.put("linkedin", host.getLinkedin());
        m.put("eventCategories", host.getEventCategories());
        m.put("yearsExperience", host.getYearsExperience());
        m.put("expectedParticipants", host.getExpectedParticipants());
        m.put("logoPath", host.getLogoPath());
        m.put("documentPath", host.getDocumentPath());
        m.put("portfolioPath", host.getPortfolioPath());
        m.put("verificationStatus", host.getVerificationStatus() == null
                ? null : host.getVerificationStatus().name());
        m.put("partnerProfileStatus", host.getPartnerProfileStatus() == null
                ? null : host.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", statusLabel(host.getPartnerProfileStatus()));
        m.put("profileCompletionPct", host.getProfileCompletionPct() == null
                ? 0 : host.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(host, missing));
        m.put("rejectionReason", host.getRejectionReason());
        m.put("changesRequestedNote", host.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(host, missing));
        m.put("approved", isApproved(host));
        m.put("cancelPolicy", EventsCareService.CANCEL_POLICY);
        putExtra(m, host);
        return m;
    }

    public static void putExtra(Map<String, Object> m, EventHost h) {
        if (m == null || h == null) return;
        m.put("designation", h.getOrganizerType());
        m.put("whatsappNumber", h.getWhatsappNumber());
        m.put("address", h.getOfficeAddress());
        m.put("city", h.getCity());
        m.put("state", h.getState());
        m.put("pincode", h.getPincode());
        m.put("latitude", h.getLatitude());
        m.put("longitude", h.getLongitude());
        m.put("categoriesOffered", splitCsv(h.getEventCategories()));
        m.put("audience", splitCsv(h.getAudience()));
        m.put("doorService", Boolean.TRUE.equals(h.getDoorService()));
        m.put("facilities", splitCsv(h.getFacilities()));
        m.put("openDays", splitCsv(h.getOpenDays()));
        m.put("openTime", h.getOpenTime() == null ? null : h.getOpenTime().format(TIME_FMT));
        m.put("closeTime", h.getCloseTime() == null ? null : h.getCloseTime().format(TIME_FMT));
        m.put("breakStart", h.getBreakStart() == null ? null : h.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", h.getBreakEnd() == null ? null : h.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", h.getBlockedDates());
        m.put("credentialNumber", h.getCredentialNumber());
        m.put("sessionMode", h.getSessionMode());
        m.put("durationMinutes", h.getDurationMinutes());
        m.put("bufferMinutes", h.getBufferMinutes());
        m.put("typicalPrice", h.getTypicalPrice());
        m.put("upiId", h.getUpiId());
        m.put("bankDetails", h.getBankDetails());
        m.put("payoutBalance", h.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(h.getGalleryPhotos()));
        m.put("profileImageUrl", h.getLogoPath());
        m.put("rating", h.getRating());
        m.put("reviewCount", h.getReviewCount());
        m.put("bio", h.getHostBio());
    }

    @Transactional
    public EventHost applyExtraFields(EventHost h, Map<String, Object> body) {
        if (h == null || body == null) return h;
        if (body.get("fullName") != null) h.setFullName(blankToNull(str(body.get("fullName"))));
        if (body.get("phone") != null) h.setPhone(blankToNull(str(body.get("phone"))));
        if (body.get("designation") != null || body.get("organizerType") != null) {
            h.setOrganizerType(blankToNull(str(
                    body.get("organizerType") != null ? body.get("organizerType") : body.get("designation"))));
        }
        if (body.get("whatsappNumber") != null) h.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("organizerName") != null) h.setOrganizerName(blankToNull(str(body.get("organizerName"))));
        if (body.get("hostContact") != null) h.setHostContact(blankToNull(str(body.get("hostContact"))));
        if (body.get("address") != null || body.get("officeAddress") != null) {
            h.setOfficeAddress(blankToNull(str(
                    body.get("officeAddress") != null ? body.get("officeAddress") : body.get("address"))));
        }
        if (body.get("city") != null) h.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) h.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) h.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { h.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { h.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null || body.get("eventCategories") != null) {
            h.setEventCategories(csv(body.get("eventCategories") != null
                    ? body.get("eventCategories") : body.get("categoriesOffered")));
        }
        if (body.get("audience") != null) h.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) h.setDoorService(Boolean.TRUE.equals(body.get("doorService"))
                || "true".equalsIgnoreCase(str(body.get("doorService"))));
        if (body.get("facilities") != null) h.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) h.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) h.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) h.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) h.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) h.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) h.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null || body.get("hostBio") != null) {
            h.setHostBio(blankToNull(str(body.get("hostBio") != null ? body.get("hostBio") : body.get("bio"))));
        }
        if (body.get("yearsExperience") != null && !str(body.get("yearsExperience")).isBlank()) {
            try { h.setYearsExperience(Integer.parseInt(str(body.get("yearsExperience")))); } catch (Exception ignored) {}
        }
        if (body.get("expectedParticipants") != null && !str(body.get("expectedParticipants")).isBlank()) {
            try { h.setExpectedParticipants(Integer.parseInt(str(body.get("expectedParticipants")))); } catch (Exception ignored) {}
        }
        if (body.get("credentialNumber") != null) h.setCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        if (body.get("sessionMode") != null) h.setSessionMode(blankToNull(str(body.get("sessionMode"))));
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { h.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { h.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null && !str(body.get("typicalPrice")).isBlank()) {
            try { h.setTypicalPrice(Double.parseDouble(str(body.get("typicalPrice")))); } catch (Exception ignored) {}
        }
        if (body.get("upiId") != null) h.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) h.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (body.get("website") != null) h.setWebsite(blankToNull(str(body.get("website"))));
        if (body.get("instagram") != null) h.setInstagram(blankToNull(str(body.get("instagram"))));
        if (body.get("facebook") != null) h.setFacebook(blankToNull(str(body.get("facebook"))));
        if (body.get("linkedin") != null) h.setLinkedin(blankToNull(str(body.get("linkedin"))));
        return h;
    }

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(EventHost host, List<String> missing) {
        PartnerProfileStatus s = host.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(EventHost host, List<String> missing) {
        PartnerProfileStatus s = host.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. You'll be notified once approved.";
        }
        if (isApproved(host)) {
            return "Your event host profile is approved and you can create events.";
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
