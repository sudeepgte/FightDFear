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

import in.sp.main.Entities.Investor;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.InvestorRepository;
import in.sp.main.Util.FundingCatalog;

@Service
public class InvestorProfileService {

    public static final List<String> TICKET_MODES = List.of("Angel", "Seed", "Series", "Grant");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private InvestorRepository investorRepository;

    public void setLifecycleStatus(Investor investor, PartnerProfileStatus status) {
        if (investor == null || status == null) return;
        investor.setPartnerProfileStatus(status);
        investor.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
    }

    public static boolean isApproved(Investor i) {
        if (i == null) return false;
        return i.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
                || i.getVerificationStatus() == in.sp.main.Entities.VerificationStatus.VERIFIED;
    }

    public List<String> missingItems(Investor i) {
        List<String> missing = new ArrayList<>();
        if (i == null) {
            missing.add("1.1 Full name");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(i.getFullName())) missing.add("1.1 Full name");
        if (PartnerLifecycleSupport.blank(i.getDesignation())) missing.add("1.2 Role");
        if (PartnerLifecycleSupport.blank(i.getCompanyName())) missing.add("1.3 Company name");
        if (PartnerLifecycleSupport.blank(i.getPhone()) || !i.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(i.getCredentialNumber())) missing.add("1.8 PAN / SEBI / AIF number");
        if (PartnerLifecycleSupport.blank(i.getAddress())) missing.add("2.1 Address");
        String city = firstNonBlank(i.getCity(), i.getPreferredLocations());
        if (PartnerLifecycleSupport.blank(city)) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(i.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(i.getPincode()) || !i.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(i.getCategoriesOffered()) && PartnerLifecycleSupport.blank(i.getPreferredCategories())) {
            missing.add("3.1 Sectors");
        }
        if (PartnerLifecycleSupport.blank(i.getAudience())) missing.add("4.1 Who I fund");
        if (PartnerLifecycleSupport.blank(i.getOpenDays())) missing.add("6.1 Open days");
        if (i.getOpenTime() == null) missing.add("6.2 Open time");
        if (i.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(firstNonBlank(i.getBio(), i.getInvestmentInterests()))) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(i.getTicketMode()) || i.getTypicalCheque() == null) {
            missing.add("8. Ticket");
        }
        return missing;
    }

    public int calculateCompletionPct(Investor investor) {
        int total = 16;
        int filled = total - missingItems(investor).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public Investor refreshCompletion(Investor investor) {
        List<String> missing = missingItems(investor);
        investor.setProfileCompletionPct(calculateCompletionPct(investor));
        PartnerProfileStatus current = investor.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return investorRepository.save(investor);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(investor, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(investor, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return investorRepository.save(investor);
    }

    public boolean isReadyForVerification(Investor investor) {
        return missingItems(investor).isEmpty();
    }

    public Map<String, Object> profilePayload(Investor investor) {
        refreshCompletion(investor);
        List<String> missing = missingItems(investor);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", investor.getId());
        m.put("fullName", investor.getFullName());
        m.put("email", investor.getEmail());
        m.put("phone", investor.getPhone());
        m.put("companyName", investor.getCompanyName());
        m.put("investmentInterests", investor.getInvestmentInterests());
        m.put("budgetRange", investor.getBudgetRange());
        m.put("preferredLocations", investor.getPreferredLocations());
        m.put("preferredCategories", investor.getPreferredCategories());
        m.put("profilePhoto", investor.getProfilePhoto());
        m.put("verificationStatus", investor.getVerificationStatus() == null
                ? null : investor.getVerificationStatus().name());
        m.put("subscribed", investor.isSubscribed());
        m.put("partnerProfileStatus", investor.getPartnerProfileStatus() == null
                ? null : investor.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(investor.getPartnerProfileStatus()));
        m.put("profileCompletionPct", investor.getProfileCompletionPct() == null
                ? 0 : investor.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(investor, missing));
        m.put("rejectionReason", investor.getRejectionReason());
        m.put("changesRequestedNote", investor.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(investor, missing));
        m.put("approved", isApproved(investor));
        m.put("canInvest", isApproved(investor));
        m.put("categoryOptions", FundingCatalog.categories());
        m.put("cancelPolicy", FundingCareService.CANCEL_POLICY);
        putExtra(m, investor);
        return m;
    }

    public static void putExtra(Map<String, Object> m, Investor i) {
        if (m == null || i == null) return;
        m.put("designation", i.getDesignation());
        m.put("whatsappNumber", i.getWhatsappNumber());
        m.put("address", i.getAddress());
        m.put("city", firstNonBlank(i.getCity(), i.getPreferredLocations()));
        m.put("state", i.getState());
        m.put("pincode", i.getPincode());
        m.put("latitude", i.getLatitude());
        m.put("longitude", i.getLongitude());
        m.put("categoriesOffered", splitCsv(firstNonBlank(i.getCategoriesOffered(), i.getPreferredCategories())));
        m.put("audience", splitCsv(i.getAudience()));
        m.put("doorService", Boolean.TRUE.equals(i.getDoorService()));
        m.put("facilities", splitCsv(i.getFacilities()));
        m.put("openDays", splitCsv(i.getOpenDays()));
        m.put("openTime", i.getOpenTime() == null ? null : i.getOpenTime().format(TIME_FMT));
        m.put("closeTime", i.getCloseTime() == null ? null : i.getCloseTime().format(TIME_FMT));
        m.put("breakStart", i.getBreakStart() == null ? null : i.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", i.getBreakEnd() == null ? null : i.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", i.getBlockedDates());
        m.put("credentialNumber", i.getCredentialNumber());
        m.put("sessionMode", i.getTicketMode());
        m.put("ticketMode", i.getTicketMode());
        m.put("durationMinutes", i.getDurationMinutes());
        m.put("bufferMinutes", i.getBufferMinutes());
        m.put("typicalPrice", i.getTypicalCheque());
        m.put("upiId", i.getUpiId());
        m.put("bankDetails", i.getBankDetails());
        m.put("payoutBalance", i.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(i.getGalleryPhotos()));
        m.put("profileImageUrl", i.getProfilePhoto());
        m.put("rating", i.getRating());
        m.put("reviewCount", i.getReviewCount());
        m.put("bio", firstNonBlank(i.getBio(), i.getInvestmentInterests()));
        m.put("yearsExperience", null);
    }

    @Transactional
    public Investor applyExtraFields(Investor i, Map<String, Object> body) {
        if (i == null || body == null) return i;
        if (body.get("fullName") != null) i.setFullName(blankToNull(str(body.get("fullName"))));
        if (body.get("phone") != null) i.setPhone(blankToNull(str(body.get("phone"))));
        if (body.get("designation") != null) i.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) i.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("companyName") != null) i.setCompanyName(blankToNull(str(body.get("companyName"))));
        if (body.get("address") != null) i.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) {
            i.setCity(blankToNull(str(body.get("city"))));
            i.setPreferredLocations(blankToNull(str(body.get("city"))));
        }
        if (body.get("preferredLocations") != null && body.get("city") == null) {
            i.setPreferredLocations(blankToNull(str(body.get("preferredLocations"))));
            if (PartnerLifecycleSupport.blank(i.getCity())) i.setCity(i.getPreferredLocations());
        }
        if (body.get("state") != null) i.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) i.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { i.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { i.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null || body.get("preferredCategories") != null) {
            String csv = csv(body.get("categoriesOffered") != null ? body.get("categoriesOffered") : body.get("preferredCategories"));
            i.setCategoriesOffered(csv);
            i.setPreferredCategories(csv);
        }
        if (body.get("audience") != null) i.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) i.setDoorService(Boolean.TRUE.equals(body.get("doorService"))
                || "true".equalsIgnoreCase(str(body.get("doorService"))));
        if (body.get("facilities") != null) i.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) i.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) i.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) i.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) i.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) i.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) i.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null || body.get("investmentInterests") != null) {
            String bio = str(body.get("bio") != null ? body.get("bio") : body.get("investmentInterests"));
            i.setBio(blankToNull(bio));
            i.setInvestmentInterests(blankToNull(bio));
        }
        if (body.get("credentialNumber") != null) i.setCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        if (body.get("sessionMode") != null || body.get("ticketMode") != null) {
            i.setTicketMode(blankToNull(str(body.get("ticketMode") != null ? body.get("ticketMode") : body.get("sessionMode"))));
        }
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { i.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { i.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null || body.get("typicalCheque") != null) {
            Object raw = body.get("typicalPrice") != null ? body.get("typicalPrice") : body.get("typicalCheque");
            if (!str(raw).isBlank()) {
                try {
                    i.setTypicalCheque(Double.parseDouble(str(raw)));
                    i.setBudgetRange("₹" + str(raw));
                } catch (Exception ignored) {}
            }
        }
        if (body.get("upiId") != null) i.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) i.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        return i;
    }

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(Investor investor, List<String> missing) {
        PartnerProfileStatus s = investor.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(Investor investor, List<String> missing) {
        PartnerProfileStatus s = investor.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your investor profile is under admin review.";
        }
        if (isApproved(investor)) {
            return "You're approved. Browse the marketplace and express interest.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            String note = investor.getChangesRequestedNote();
            return note == null || note.isBlank()
                    ? "Admin requested changes. Update your profile and resubmit."
                    : "Admin requested changes: " + note;
        }
        if (s == PartnerProfileStatus.REJECTED) {
            String reason = investor.getRejectionReason();
            return reason == null || reason.isBlank()
                    ? "Registration was rejected. Update your profile and resubmit."
                    : "Rejected: " + reason;
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "All required items are ready. Submit for admin verification.";
    }

    private static String firstNonBlank(String a, String b) {
        if (!PartnerLifecycleSupport.blank(a)) return a;
        if (!PartnerLifecycleSupport.blank(b)) return b;
        return null;
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
