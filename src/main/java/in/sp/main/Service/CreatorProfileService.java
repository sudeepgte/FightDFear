package in.sp.main.Service;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;

@Service
public class CreatorProfileService {

    public static final List<String> CATEGORIES = List.of(
            "Safety Awareness", "Entrepreneurship", "Financial Literacy",
            "Skill Development", "Inspirational", "Entertainment"
    );
    public static final List<String> DESIGNATIONS = List.of("Creator", "Educator", "Influencer", "Other");
    private static final Set<String> CATEGORY_SET = Set.copyOf(CATEGORIES);
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private UserRepository userRepository;

    public void setLifecycleStatus(User user, PartnerProfileStatus status) {
        if (user == null || status == null) return;
        user.setCreatorProfileStatus(status);
        if (status == PartnerProfileStatus.APPROVED) {
            user.setVerifiedCreator(true);
            user.setBannedCreator(false);
        } else if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.SUSPENDED) {
            user.setVerifiedCreator(false);
        }
    }

    public static boolean isApprovedCreator(User user) {
        if (user == null || user.isBanned() || user.isBannedCreator()) return false;
        if (user.isVerifiedCreator()) return true;
        return user.getCreatorProfileStatus() == PartnerProfileStatus.APPROVED;
    }

    public static String normalizeCategory(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String trimmed = raw.trim();
        return CATEGORIES.stream().filter(c -> c.equalsIgnoreCase(trimmed)).findFirst().orElse(null);
    }

    public static boolean isKnownCategory(String category) {
        return category != null && CATEGORY_SET.contains(category);
    }

    public List<String> missingItems(User user) {
        List<String> missing = new ArrayList<>();
        if (user == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(user.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(user.getCreatorDesignation())) missing.add("1.2 Role");
        if (PartnerLifecycleSupport.blank(user.getPhoneNumber()) || !user.getPhoneNumber().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(user.getCreatorCredentialNumber())) missing.add("1.8 PAN / GST / channel ID");
        if (PartnerLifecycleSupport.blank(user.getCreatorAddress())) missing.add("2.1 Address");
        if (PartnerLifecycleSupport.blank(user.getCreatorCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(user.getCreatorState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(user.getCreatorPincode()) || !user.getCreatorPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(user.getCreatorCategory())) missing.add("3.1 Categories");
        if (PartnerLifecycleSupport.blank(user.getCreatorAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(user.getCreatorOpenDays())) missing.add("6.1 Open days");
        if (user.getCreatorOpenTime() == null) missing.add("6.2 Open time");
        if (user.getCreatorCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(user.getCreatorBio())) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(user.getCreatorSessionMode()) || user.getCreatorTypicalPrice() == null) {
            missing.add("8. First offering");
        }
        return missing;
    }

    public int calculateCompletionPct(User user) {
        int total = 16;
        int filled = total - missingItems(user).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public User refreshCompletion(User user) {
        List<String> missing = missingItems(user);
        user.setCreatorProfileCompletionPct(calculateCompletionPct(user));
        PartnerProfileStatus current = user.getCreatorProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return userRepository.save(user);
        }
        if (current == null) {
            return userRepository.save(user);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(user, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(user, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return userRepository.save(user);
    }

    public boolean isReadyForVerification(User user) {
        return missingItems(user).isEmpty();
    }

    public Map<String, Object> profilePayload(User user) {
        refreshCompletion(user);
        List<String> missing = missingItems(user);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", user.getId());
        m.put("fullName", user.getFullName());
        m.put("email", user.getEmail());
        m.put("phone", user.getPhoneNumber());
        m.put("city", user.getCreatorCity());
        m.put("category", user.getCreatorCategory());
        m.put("bio", user.getCreatorBio());
        m.put("handle", user.getCreatorHandle());
        m.put("verifiedCreator", user.isVerifiedCreator());
        m.put("approved", isApprovedCreator(user));
        m.put("bannedCreator", user.isBannedCreator());
        m.put("partnerProfileStatus", user.getCreatorProfileStatus() == null
                ? null : user.getCreatorProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(user.getCreatorProfileStatus()));
        m.put("profileCompletionPct", user.getCreatorProfileCompletionPct() == null
                ? 0 : user.getCreatorProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(user, missing));
        m.put("rejectionReason", user.getCreatorRejectionReason());
        m.put("changesRequestedNote", user.getCreatorChangesRequestedNote());
        m.put("nextStepGuidance", guidance(user, missing));
        m.put("categories", CATEGORIES);
        m.put("cancelPolicy", CreatorCareService.CANCEL_POLICY);
        putExtra(m, user);
        return m;
    }

    public static void putExtra(Map<String, Object> m, User u) {
        if (m == null || u == null) return;
        m.put("designation", u.getCreatorDesignation());
        m.put("whatsappNumber", u.getCreatorWhatsapp());
        m.put("address", u.getCreatorAddress());
        m.put("city", u.getCreatorCity());
        m.put("state", u.getCreatorState());
        m.put("pincode", u.getCreatorPincode());
        m.put("latitude", u.getCreatorLatitude());
        m.put("longitude", u.getCreatorLongitude());
        m.put("categoriesOffered", splitCsv(u.getCreatorCategory()));
        m.put("audience", splitCsv(u.getCreatorAudience()));
        m.put("doorService", Boolean.TRUE.equals(u.getCreatorDoorService()));
        m.put("facilities", splitCsv(u.getCreatorFacilities()));
        m.put("openDays", splitCsv(u.getCreatorOpenDays()));
        m.put("openTime", u.getCreatorOpenTime() == null ? null : u.getCreatorOpenTime().format(TIME_FMT));
        m.put("closeTime", u.getCreatorCloseTime() == null ? null : u.getCreatorCloseTime().format(TIME_FMT));
        m.put("breakStart", u.getCreatorBreakStart() == null ? null : u.getCreatorBreakStart().format(TIME_FMT));
        m.put("breakEnd", u.getCreatorBreakEnd() == null ? null : u.getCreatorBreakEnd().format(TIME_FMT));
        m.put("blockedDates", u.getCreatorBlockedDates());
        m.put("credentialNumber", u.getCreatorCredentialNumber());
        m.put("sessionMode", u.getCreatorSessionMode());
        m.put("durationMinutes", u.getCreatorDurationMinutes());
        m.put("bufferMinutes", u.getCreatorBufferMinutes());
        m.put("typicalPrice", u.getCreatorTypicalPrice());
        m.put("upiId", u.getCreatorUpiId());
        m.put("bankDetails", u.getCreatorBankDetails());
        m.put("payoutBalance", u.getCreatorPayoutBalance());
        m.put("galleryPhotos", splitCsv(u.getCreatorGalleryPhotos()));
        m.put("profileImageUrl", u.getProfilePhoto());
        m.put("rating", u.getCreatorRating());
        m.put("reviewCount", u.getCreatorReviewCount());
    }

    @Transactional
    public User applyExtraFields(User u, Map<String, Object> body) {
        if (u == null || body == null) return u;
        if (body.get("fullName") != null) u.setFullName(blankToNull(str(body.get("fullName"))));
        if (body.get("phone") != null) u.setPhoneNumber(blankToNull(str(body.get("phone"))));
        if (body.get("designation") != null) u.setCreatorDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) u.setCreatorWhatsapp(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("handle") != null) u.setCreatorHandle(blankToNull(str(body.get("handle"))));
        if (body.get("address") != null) u.setCreatorAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) u.setCreatorCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) u.setCreatorState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) u.setCreatorPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { u.setCreatorLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { u.setCreatorLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null || body.get("category") != null || body.get("expertise") != null) {
            Object raw = body.get("categoriesOffered") != null ? body.get("categoriesOffered")
                    : (body.get("category") != null ? body.get("category") : body.get("expertise"));
            String csv = csv(raw);
            u.setCreatorCategory(csv);
        }
        if (body.get("audience") != null) u.setCreatorAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) u.setCreatorDoorService(Boolean.TRUE.equals(body.get("doorService"))
                || "true".equalsIgnoreCase(str(body.get("doorService"))));
        if (body.get("facilities") != null) u.setCreatorFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) u.setCreatorOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) u.setCreatorOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) u.setCreatorCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) u.setCreatorBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) u.setCreatorBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) u.setCreatorBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) u.setCreatorBio(blankToNull(str(body.get("bio"))));
        if (body.get("credentialNumber") != null) u.setCreatorCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        if (body.get("sessionMode") != null) u.setCreatorSessionMode(blankToNull(str(body.get("sessionMode"))));
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { u.setCreatorDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { u.setCreatorBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null && !str(body.get("typicalPrice")).isBlank()) {
            try { u.setCreatorTypicalPrice(Double.parseDouble(str(body.get("typicalPrice")))); } catch (Exception ignored) {}
        }
        if (body.get("upiId") != null) u.setCreatorUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) u.setCreatorBankDetails(blankToNull(str(body.get("bankDetails"))));
        return u;
    }

    private boolean canSubmit(User user, List<String> missing) {
        PartnerProfileStatus s = user.getCreatorProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(User user, List<String> missing) {
        PartnerProfileStatus s = user.getCreatorProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your creator profile is under admin review. You'll be able to publish once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED || user.isVerifiedCreator()) {
            return "You're an approved creator. Publish videos, reels and stories from Studio.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            String note = user.getCreatorChangesRequestedNote();
            return note == null || note.isBlank()
                    ? "Admin requested changes. Update your profile and resubmit."
                    : "Admin requested changes: " + note;
        }
        if (s == PartnerProfileStatus.REJECTED) {
            String reason = user.getCreatorRejectionReason();
            return reason == null || reason.isBlank()
                    ? "Application was rejected. Update your profile and resubmit."
                    : "Rejected: " + reason;
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "Profile looks complete. Submit for admin verification to start publishing.";
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
