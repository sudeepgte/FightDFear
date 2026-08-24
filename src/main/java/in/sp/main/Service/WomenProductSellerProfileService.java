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
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.WomenProductSellerRepository;

@Service
public class WomenProductSellerProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("H:mm");

    @Autowired
    private WomenProductSellerRepository sellerRepository;

    public void setLifecycleStatus(WomenProductSeller seller, PartnerProfileStatus status) {
        if (seller == null || status == null) return;
        seller.setPartnerProfileStatus(status);
        seller.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
    }

    public List<String> missingItems(WomenProductSeller seller) {
        List<String> missing = new ArrayList<>();
        if (seller == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(seller.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(seller.getDesignation())) missing.add("1.2 Role");
        if (PartnerLifecycleSupport.blank(seller.getPhone()) || !seller.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(seller.getAddress())) missing.add("2.1 Shop address");
        if (PartnerLifecycleSupport.blank(seller.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(seller.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(seller.getPincode()) || !seller.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(seller.getCategoriesOffered())) missing.add("3.1 Categories you sell");
        if (PartnerLifecycleSupport.blank(seller.getBrandType())) missing.add("4.1 Brand type");
        if (PartnerLifecycleSupport.blank(seller.getOpenDays())) missing.add("6.1 Open days");
        if (seller.getOpenTime() == null) missing.add("6.2 Open time");
        if (seller.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(seller.getBio()) && PartnerLifecycleSupport.blank(seller.getDescription())) {
            missing.add("7.1 About");
        }
        if (PartnerLifecycleSupport.blank(seller.getPrimaryCategory())
                || seller.getTypicalPrice() == null
                || seller.getDispatchHours() == null) {
            missing.add("8. First listing defaults");
        }
        if (PartnerLifecycleSupport.blank(seller.getBusinessName())) missing.add("1. Shop name");
        return missing;
    }

    public int calculateCompletionPct(WomenProductSeller seller) {
        int total = 16;
        int filled = total - missingItems(seller).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public WomenProductSeller refreshCompletion(WomenProductSeller seller) {
        List<String> missing = missingItems(seller);
        seller.setProfileCompletionPct(calculateCompletionPct(seller));
        PartnerProfileStatus current = seller.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return sellerRepository.save(seller);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(seller, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(seller, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return sellerRepository.save(seller);
    }

    public boolean isReadyForVerification(WomenProductSeller seller) {
        return missingItems(seller).isEmpty();
    }

    public Map<String, Object> profilePayload(WomenProductSeller seller) {
        refreshCompletion(seller);
        List<String> missing = missingItems(seller);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", seller.getId());
        m.put("fullName", seller.getFullName());
        m.put("email", seller.getEmail());
        m.put("phone", seller.getPhone());
        m.put("businessName", seller.getBusinessName());
        m.put("description", seller.getDescription());
        m.put("address", seller.getAddress());
        m.put("profilePhotoPath", seller.getProfilePhotoPath());
        m.put("identityDocPath", seller.getIdentityDocPath());
        m.put("rating", seller.getRating());
        m.put("verificationStatus", seller.getVerificationStatus() == null
                ? null : seller.getVerificationStatus().name());
        m.put("partnerProfileStatus", seller.getPartnerProfileStatus() == null
                ? null : seller.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", statusLabel(seller.getPartnerProfileStatus()));
        m.put("profileCompletionPct", seller.getProfileCompletionPct() == null
                ? 0 : seller.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(seller, missing));
        m.put("rejectionReason", seller.getRejectionReason());
        m.put("changesRequestedNote", seller.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(seller, missing));
        m.put("cancelPolicy", WomenProductsCareService.CANCEL_POLICY);
        putExtra(m, seller);
        return m;
    }

    public static void putExtra(Map<String, Object> m, WomenProductSeller s) {
        if (m == null || s == null) return;
        m.put("designation", s.getDesignation());
        m.put("whatsappNumber", s.getWhatsappNumber());
        m.put("city", s.getCity());
        m.put("state", s.getState());
        m.put("pincode", s.getPincode());
        m.put("latitude", s.getLatitude());
        m.put("longitude", s.getLongitude());
        m.put("categoriesOffered", splitCsv(s.getCategoriesOffered()));
        m.put("brandType", s.getBrandType());
        m.put("audience", splitCsv(s.getAudience()));
        m.put("facilities", splitCsv(s.getFacilities()));
        m.put("openDays", splitCsv(s.getOpenDays()));
        m.put("openTime", s.getOpenTime() == null ? null : s.getOpenTime().format(TIME_FMT));
        m.put("closeTime", s.getCloseTime() == null ? null : s.getCloseTime().format(TIME_FMT));
        m.put("breakStart", s.getBreakStart() == null ? null : s.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", s.getBreakEnd() == null ? null : s.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", s.getBlockedDates());
        m.put("bio", s.getBio() != null ? s.getBio() : s.getDescription());
        m.put("dispatchHours", s.getDispatchHours());
        m.put("typicalPrice", s.getTypicalPrice());
        m.put("primaryCategory", s.getPrimaryCategory());
        m.put("gstin", s.getGstin());
        m.put("upiId", s.getUpiId());
        m.put("bankDetails", s.getBankDetails());
        m.put("payoutBalance", s.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(s.getGalleryPhotos()));
        m.put("profileImageUrl", s.getProfilePhotoPath());
    }

    @Transactional
    public WomenProductSeller applyExtraFields(WomenProductSeller s, Map<String, Object> body) {
        if (s == null || body == null) return s;
        if (body.get("designation") != null) s.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) s.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("address") != null) s.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) s.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) s.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) s.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { s.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { s.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null) s.setCategoriesOffered(csv(body.get("categoriesOffered")));
        if (body.get("brandType") != null) s.setBrandType(blankToNull(str(body.get("brandType"))));
        if (body.get("audience") != null) s.setAudience(csv(body.get("audience")));
        if (body.get("facilities") != null) s.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) s.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) s.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) s.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) s.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) s.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) s.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) {
            s.setBio(blankToNull(str(body.get("bio"))));
            if (PartnerLifecycleSupport.blank(s.getDescription())) s.setDescription(s.getBio());
        }
        if (body.get("dispatchHours") != null && !str(body.get("dispatchHours")).isBlank()) {
            try { s.setDispatchHours(Integer.parseInt(str(body.get("dispatchHours")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null && !str(body.get("typicalPrice")).isBlank()) {
            try { s.setTypicalPrice(Double.parseDouble(str(body.get("typicalPrice")))); } catch (Exception ignored) {}
        }
        if (body.get("primaryCategory") != null) s.setPrimaryCategory(blankToNull(str(body.get("primaryCategory"))));
        if (body.get("gstin") != null) s.setGstin(blankToNull(str(body.get("gstin"))));
        if (body.get("upiId") != null) s.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) s.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        return s;
    }

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(WomenProductSeller seller, List<String> missing) {
        PartnerProfileStatus s = seller.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(WomenProductSeller seller, List<String> missing) {
        PartnerProfileStatus s = seller.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your shop is under admin review. You'll be notified once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED) {
            return "Your seller profile is approved and you can list products.";
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
