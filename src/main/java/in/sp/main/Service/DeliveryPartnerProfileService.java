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

import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.DeliveryPartnerRepository;

@Service
public class DeliveryPartnerProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("H:mm");

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    public void setLifecycleStatus(DeliveryPartner partner, PartnerProfileStatus status) {
        if (partner == null || status == null) return;
        partner.setPartnerProfileStatus(status);
        partner.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
        if (status == PartnerProfileStatus.SUSPENDED) {
            partner.setSuspended(true);
        }
    }

    public List<String> missingItems(DeliveryPartner partner) {
        List<String> missing = new ArrayList<>();
        if (partner == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(partner.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(partner.getVehicleType())) missing.add("1.2 Vehicle");
        if (PartnerLifecycleSupport.blank(partner.getPhone()) || !partner.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        boolean needsLicense = partner.getVehicleType() != null
                && !"Cycle".equalsIgnoreCase(partner.getVehicleType());
        if (needsLicense && PartnerLifecycleSupport.blank(partner.getLicenseNumber())) {
            missing.add("1.8 Driving licence number");
        }
        if (PartnerLifecycleSupport.blank(partner.getAddress())) missing.add("2.1 Base address");
        if (PartnerLifecycleSupport.blank(partner.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(partner.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(partner.getPincode()) || !partner.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(partner.getServiceArea())) missing.add("3.1 Service areas");
        if (PartnerLifecycleSupport.blank(partner.getCapabilities())) missing.add("4.1 Capabilities");
        if (PartnerLifecycleSupport.blank(partner.getOpenDays())) missing.add("6.1 Open days");
        if (partner.getOpenTime() == null) missing.add("6.2 Open time");
        if (partner.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(partner.getBio())) missing.add("7.1 About");
        if (partner.getTypicalRadiusKm() == null) missing.add("8. First offering");
        return missing;
    }

    public int calculateCompletionPct(DeliveryPartner partner) {
        int total = 15;
        int filled = total - missingItems(partner).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public DeliveryPartner refreshCompletion(DeliveryPartner partner) {
        List<String> missing = missingItems(partner);
        partner.setProfileCompletionPct(calculateCompletionPct(partner));
        PartnerProfileStatus current = partner.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return deliveryPartnerRepository.save(partner);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(partner, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(partner, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return deliveryPartnerRepository.save(partner);
    }

    public boolean isReadyForVerification(DeliveryPartner partner) {
        return missingItems(partner).isEmpty();
    }

    public Map<String, Object> profilePayload(DeliveryPartner partner) {
        refreshCompletion(partner);
        List<String> missing = missingItems(partner);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", partner.getId());
        m.put("fullName", partner.getFullName());
        m.put("email", partner.getEmail());
        m.put("phone", partner.getPhone());
        m.put("city", partner.getCity());
        m.put("vehicleType", partner.getVehicleType());
        m.put("licenseNumber", partner.getLicenseNumber());
        m.put("serviceArea", partner.getServiceArea());
        m.put("bio", partner.getBio());
        m.put("rating", partner.getRating());
        m.put("suspended", partner.isSuspended());
        m.put("verificationStatus", partner.getVerificationStatus() == null
                ? null : partner.getVerificationStatus().name());
        m.put("partnerProfileStatus", partner.getPartnerProfileStatus() == null
                ? null : partner.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(partner.getPartnerProfileStatus()));
        m.put("profileCompletionPct", partner.getProfileCompletionPct() == null ? 0 : partner.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(partner, missing));
        m.put("rejectionReason", partner.getRejectionReason());
        m.put("changesRequestedNote", partner.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(partner, missing));
        m.put("cancelPolicy", WomenProductsCareService.CANCEL_POLICY);
        putExtra(m, partner);
        return m;
    }

    public static void putExtra(Map<String, Object> m, DeliveryPartner p) {
        if (m == null || p == null) return;
        m.put("whatsappNumber", p.getWhatsappNumber());
        m.put("address", p.getAddress());
        m.put("state", p.getState());
        m.put("pincode", p.getPincode());
        m.put("latitude", p.getLatitude());
        m.put("longitude", p.getLongitude());
        m.put("capabilities", splitCsv(p.getCapabilities()));
        m.put("facilities", splitCsv(p.getFacilities()));
        m.put("openDays", splitCsv(p.getOpenDays()));
        m.put("openTime", p.getOpenTime() == null ? null : p.getOpenTime().format(TIME_FMT));
        m.put("closeTime", p.getCloseTime() == null ? null : p.getCloseTime().format(TIME_FMT));
        m.put("breakStart", p.getBreakStart() == null ? null : p.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", p.getBreakEnd() == null ? null : p.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", p.getBlockedDates());
        m.put("typicalRadiusKm", p.getTypicalRadiusKm());
        m.put("upiId", p.getUpiId());
        m.put("bankDetails", p.getBankDetails());
        m.put("payoutBalance", p.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(p.getGalleryPhotos()));
        m.put("profileImageUrl", p.getProfilePhotoPath());
        m.put("serviceAreas", splitCsv(p.getServiceArea()));
    }

    @Transactional
    public DeliveryPartner applyExtraFields(DeliveryPartner p, Map<String, Object> body) {
        if (p == null || body == null) return p;
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
        if (body.get("serviceArea") != null) p.setServiceArea(csv(body.get("serviceArea")));
        if (body.get("serviceAreas") != null) p.setServiceArea(csv(body.get("serviceAreas")));
        if (body.get("capabilities") != null) p.setCapabilities(csv(body.get("capabilities")));
        if (body.get("facilities") != null) p.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) p.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) p.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) p.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) p.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) p.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) p.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) p.setBio(blankToNull(str(body.get("bio"))));
        if (body.get("typicalRadiusKm") != null && !str(body.get("typicalRadiusKm")).isBlank()) {
            try { p.setTypicalRadiusKm(Integer.parseInt(str(body.get("typicalRadiusKm")))); } catch (Exception ignored) {}
        }
        if (body.get("upiId") != null) p.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) p.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (body.get("licenseNumber") != null) p.setLicenseNumber(blankToNull(str(body.get("licenseNumber"))));
        return p;
    }

    private boolean canSubmit(DeliveryPartner partner, List<String> missing) {
        PartnerProfileStatus s = partner.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(DeliveryPartner partner, List<String> missing) {
        PartnerProfileStatus s = partner.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. You'll be notified once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED) {
            return "You are approved. Accept ready orders and deliver to customers.";
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
