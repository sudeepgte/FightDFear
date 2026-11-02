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

import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Util.FundingCatalog;

@Service
public class EntrepreneurProfileService {

    public static final List<String> RAISE_MODES = List.of("Equity", "Debt", "Grant", "Revenue share");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    public void setLifecycleStatus(Entrepreneur entrepreneur, PartnerProfileStatus status) {
        if (entrepreneur == null || status == null) return;
        entrepreneur.setPartnerProfileStatus(status);
        entrepreneur.setVerificationStatus(PartnerLifecycleSupport.toVerificationStatus(status));
    }

    public static boolean isApproved(Entrepreneur e) {
        if (e == null) return false;
        return e.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
                || e.getVerificationStatus() == in.sp.main.Entities.VerificationStatus.VERIFIED;
    }

    public List<String> missingItems(Entrepreneur e) {
        List<String> missing = new ArrayList<>();
        if (e == null) {
            missing.add("0. Profile photo");
            missing.add("1.1 Full name");
            return missing;
        }
        // 1. Profile photo / founder portrait
        if (PartnerLifecycleSupport.blank(e.getProfilePhoto())) missing.add("0. Profile photo");
        // 2. Full name (min 2 chars)
        if (PartnerLifecycleSupport.blank(e.getFullName()) || e.getFullName().trim().length() < 2) missing.add("1.1 Full name");
        // 3. Business / venture name (min 2 chars, not placeholder)
        if (PartnerLifecycleSupport.blank(e.getBusinessName()) || e.getBusinessName().trim().length() < 2
                || "Pending Profile Completion".equalsIgnoreCase(e.getBusinessName().trim())) missing.add("1.2 Business name");
        // 4. Business category
        if (PartnerLifecycleSupport.blank(e.getBusinessCategory()) && PartnerLifecycleSupport.blank(e.getCategoriesOffered())) missing.add("1.3 Business category");
        // 5. Account email (valid email format)
        if (PartnerLifecycleSupport.blank(e.getEmail()) || !e.getEmail().trim().matches("^[A-Za-z0-9+_.-]+@(.+)$")) missing.add("1.5 Account email");
        // 6. Mobile phone (10 digits)
        if (PartnerLifecycleSupport.blank(e.getPhone()) || !e.getPhone().trim().matches("^[0-9]{10}$")) missing.add("1.6 Mobile phone");
        // 7. Street address / landmark (min 3 chars, not placeholder)
        String location = firstNonBlank(e.getBusinessLocation(), e.getAddress());
        if (PartnerLifecycleSupport.blank(location) || location.trim().length() < 3 || "Pending".equalsIgnoreCase(location.trim())) missing.add("2.1 Street address / Landmark");
        // 8. State
        if (PartnerLifecycleSupport.blank(e.getState())) missing.add("2.2 State");
        // 9. City
        String city = firstNonBlank(e.getCity(), e.getBusinessLocation());
        if (PartnerLifecycleSupport.blank(city)) missing.add("2.3 City");
        // 10. Pincode (6 digits)
        if (PartnerLifecycleSupport.blank(e.getPincode()) || !e.getPincode().trim().matches("^[0-9]{6}$")) missing.add("2.4 Pincode");
        // 11. Investment / funding required (> 0)
        if (e.getInvestmentNeeded() == null || e.getInvestmentNeeded() <= 0) missing.add("3.1 Funding required");
        // 12. Expected monthly income (> 0)
        if (e.getExpectedMonthlyIncome() == null || e.getExpectedMonthlyIncome() <= 0) missing.add("3.2 Expected monthly revenue");
        // 13. Business experience (>= 0)
        if (e.getBusinessExperience() == null || e.getBusinessExperience() < 0) missing.add("3.3 Business experience");
        // 14. Aadhaar number (12 digits)
        if (PartnerLifecycleSupport.blank(e.getAadhaarNumber()) || !e.getAadhaarNumber().trim().matches("^[0-9]{12}$")) missing.add("4.1 Aadhaar number");
        // 15. Business description & vision (min 10 chars, not placeholder)
        String desc = e.getBusinessDescription();
        if (PartnerLifecycleSupport.blank(desc) || desc.trim().length() < 10 || "Profile pending completion by entrepreneur.".equalsIgnoreCase(desc.trim())) missing.add("5.1 Business description");
        // 16. Payout info: valid UPI ID OR complete valid Bank Details
        boolean hasUpi = e.getUpiId() != null && e.getUpiId().trim().matches("^[a-zA-Z0-9.\\-_]{2,256}@[a-zA-Z]{2,64}$");
        boolean hasBank = e.getAccountNumber() != null && e.getAccountNumber().trim().matches("^[0-9]{9,18}$") &&
                e.getIfscCode() != null && e.getIfscCode().trim().matches("^[A-Z]{4}0[A-Z0-9]{6}$");
        if (!hasUpi && !hasBank) missing.add("6.1 Payout UPI or Bank Account");
        return missing;
    }

    public int calculateCompletionPct(Entrepreneur e) {
        int total = 16;
        int filled = total - missingItems(e).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public Entrepreneur refreshCompletion(Entrepreneur entrepreneur) {
        List<String> missing = missingItems(entrepreneur);
        entrepreneur.setProfileCompletionPct(calculateCompletionPct(entrepreneur));
        PartnerProfileStatus current = entrepreneur.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return entrepreneurRepository.save(entrepreneur);
        }
        if (missing.isEmpty()) {
            setLifecycleStatus(entrepreneur, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(entrepreneur, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return entrepreneurRepository.save(entrepreneur);
    }

    public boolean isReadyForVerification(Entrepreneur entrepreneur) {
        return missingItems(entrepreneur).isEmpty();
    }

    public Map<String, Object> profilePayload(Entrepreneur entrepreneur) {
        refreshCompletion(entrepreneur);
        List<String> missing = missingItems(entrepreneur);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", entrepreneur.getId());
        m.put("fullName", entrepreneur.getFullName());
        m.put("email", entrepreneur.getEmail());
        m.put("phone", entrepreneur.getPhone());
        m.put("businessName", entrepreneur.getBusinessName());
        m.put("businessCategory", entrepreneur.getBusinessCategory());
        m.put("businessLocation", firstNonBlank(entrepreneur.getCity(), entrepreneur.getBusinessLocation()));
        m.put("businessDescription", entrepreneur.getBusinessDescription());
        m.put("investmentNeeded", entrepreneur.getInvestmentNeeded());
        m.put("expectedMonthlyIncome", entrepreneur.getExpectedMonthlyIncome());
        m.put("businessExperience", entrepreneur.getBusinessExperience());
        m.put("profilePhoto", entrepreneur.getProfilePhoto());
        m.put("verificationStatus", entrepreneur.getVerificationStatus() == null
                ? null : entrepreneur.getVerificationStatus().name());
        m.put("verificationFeePaid", entrepreneur.isVerificationFeePaid());
        m.put("partnerProfileStatus", entrepreneur.getPartnerProfileStatus() == null
                ? null : entrepreneur.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(entrepreneur.getPartnerProfileStatus()));
        m.put("profileCompletionPct", entrepreneur.getProfileCompletionPct() == null
                ? 0 : entrepreneur.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(entrepreneur, missing));
        m.put("rejectionReason", entrepreneur.getRejectionReason());
        m.put("changesRequestedNote", entrepreneur.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(entrepreneur, missing));
        m.put("approved", isApproved(entrepreneur));
        m.put("categoryOptions", FundingCatalog.categories());
        m.put("cancelPolicy", FundingCareService.CANCEL_POLICY);
        putExtra(m, entrepreneur);
        return m;
    }

    public static void putExtra(Map<String, Object> m, Entrepreneur e) {
        if (m == null || e == null) return;
        m.put("dob", e.getDob());
        m.put("gender", e.getGender() == null ? null : e.getGender().name());
        m.put("aadhaarNumber", e.getAadhaarNumber());
        m.put("panNumber", e.getCredentialNumber());
        m.put("gstNumber", e.getCredentialNumber());
        m.put("designation", e.getDesignation());
        m.put("whatsappNumber", e.getWhatsappNumber());
        m.put("address", e.getAddress());
        m.put("city", firstNonBlank(e.getCity(), e.getBusinessLocation()));
        m.put("state", e.getState());
        m.put("pincode", e.getPincode());
        m.put("latitude", e.getLatitude());
        m.put("longitude", e.getLongitude());
        m.put("categoriesOffered", splitCsv(firstNonBlank(e.getCategoriesOffered(), e.getBusinessCategory())));
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
        m.put("sessionMode", e.getRaiseMode());
        m.put("raiseMode", e.getRaiseMode());
        m.put("durationMinutes", e.getDurationMinutes());
        m.put("bufferMinutes", e.getBufferMinutes());
        m.put("typicalPrice", e.getInvestmentNeeded());
        m.put("upiId", e.getUpiId());
        m.put("bankName", e.getBankName());
        m.put("accountNumber", e.getAccountNumber());
        m.put("ifscCode", e.getIfscCode());
        m.put("bankDetails", firstNonBlank(e.getBankDetails(), composeBank(e)));
        m.put("payoutBalance", e.getPayoutBalance());
        m.put("documentsPath", e.getDocumentsPath());
        m.put("photosPath", e.getPhotosPath());
        m.put("pitchDeckPath", e.getDocumentsPath());
        m.put("galleryPhotos", splitCsv(firstNonBlank(e.getGalleryPhotos(), e.getPhotosPath())));
        m.put("profileImageUrl", e.getProfilePhoto());
        m.put("rating", e.getRating());
        m.put("reviewCount", e.getReviewCount());
        m.put("bio", e.getBusinessDescription());
        m.put("yearsExperience", e.getBusinessExperience());
    }

    @Transactional
    public Entrepreneur applyExtraFields(Entrepreneur e, Map<String, Object> body) {
        if (e == null || body == null) return e;
        if (body.get("fullName") != null) e.setFullName(blankToNull(str(body.get("fullName"))));
        if (body.get("phone") != null) e.setPhone(blankToNull(str(body.get("phone"))));
        if (body.get("dob") != null) e.setDob(blankToNull(str(body.get("dob"))));
        if (body.get("gender") != null && !str(body.get("gender")).isBlank()) {
            try {
                e.setGender(in.sp.main.Entities.Gender.valueOf(str(body.get("gender")).toUpperCase()));
            } catch (Exception ignored) {}
        }
        if (body.get("aadhaarNumber") != null) e.setAadhaarNumber(blankToNull(str(body.get("aadhaarNumber"))));
        if (body.get("designation") != null) e.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) e.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("businessName") != null) e.setBusinessName(blankToNull(str(body.get("businessName"))));
        if (body.get("address") != null) e.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) {
            e.setCity(blankToNull(str(body.get("city"))));
            e.setBusinessLocation(blankToNull(str(body.get("city"))));
        }
        if (body.get("businessLocation") != null && body.get("city") == null) {
            e.setBusinessLocation(blankToNull(str(body.get("businessLocation"))));
            if (PartnerLifecycleSupport.blank(e.getCity())) e.setCity(e.getBusinessLocation());
        }
        if (body.get("state") != null) e.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) e.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { e.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { e.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null || body.get("businessCategory") != null) {
            String csv = csv(body.get("categoriesOffered") != null ? body.get("categoriesOffered") : body.get("businessCategory"));
            String norm = FundingCatalog.normalize(csv == null ? null : csv.split(",")[0]);
            e.setCategoriesOffered(csv);
            e.setBusinessCategory(norm);
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
        if (body.get("bio") != null || body.get("businessDescription") != null) {
            String bio = str(body.get("bio") != null ? body.get("bio") : body.get("businessDescription"));
            e.setBusinessDescription(blankToNull(bio));
        }
        if (body.get("yearsExperience") != null || body.get("businessExperience") != null) {
            Object raw = body.get("yearsExperience") != null ? body.get("yearsExperience") : body.get("businessExperience");
            if (!str(raw).isBlank()) {
                try { e.setBusinessExperience(Integer.parseInt(str(raw))); } catch (Exception ignored) {}
            }
        }
        if (body.get("credentialNumber") != null) {
            e.setCredentialNumber(blankToNull(str(body.get("credentialNumber"))));
        } else if (body.get("panNumber") != null) {
            e.setCredentialNumber(blankToNull(str(body.get("panNumber"))));
        } else if (body.get("gstNumber") != null) {
            e.setCredentialNumber(blankToNull(str(body.get("gstNumber"))));
        }
        if (body.get("sessionMode") != null || body.get("raiseMode") != null) {
            e.setRaiseMode(blankToNull(str(body.get("raiseMode") != null ? body.get("raiseMode") : body.get("sessionMode"))));
        }
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { e.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { e.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("typicalPrice") != null || body.get("investmentNeeded") != null) {
            Object raw = body.get("typicalPrice") != null ? body.get("typicalPrice") : body.get("investmentNeeded");
            if (!str(raw).isBlank()) {
                try { e.setInvestmentNeeded(Double.parseDouble(str(raw))); } catch (Exception ignored) {}
            }
        }
        if (body.get("expectedMonthlyIncome") != null && !str(body.get("expectedMonthlyIncome")).isBlank()) {
            try { e.setExpectedMonthlyIncome(Double.parseDouble(str(body.get("expectedMonthlyIncome")))); } catch (Exception ignored) {}
        }
        if (body.get("upiId") != null) e.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankName") != null) e.setBankName(blankToNull(str(body.get("bankName"))));
        if (body.get("bankAccountNumber") != null || body.get("accountNumber") != null) {
            String acc = str(body.get("bankAccountNumber") != null ? body.get("bankAccountNumber") : body.get("accountNumber"));
            e.setAccountNumber(blankToNull(acc));
        }
        if (body.get("bankIfsc") != null || body.get("ifscCode") != null) {
            String ifsc = str(body.get("bankIfsc") != null ? body.get("bankIfsc") : body.get("ifscCode"));
            e.setIfscCode(blankToNull(ifsc == null ? null : ifsc.toUpperCase()));
        }
        if (body.get("bankDetails") != null) {
            e.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        } else if (e.getAccountNumber() != null && !e.getAccountNumber().isBlank()) {
            String holder = str(body.get("bankAccountHolder"));
            String branch = str(body.get("bankBranch"));
            String serialized = "Account Holder: " + holder
                    + " | Bank: " + (e.getBankName() != null ? e.getBankName() : "")
                    + " | A/C: " + e.getAccountNumber()
                    + " | IFSC: " + (e.getIfscCode() != null ? e.getIfscCode() : "")
                    + " | Branch: " + branch;
            e.setBankDetails(serialized);
        }
        if (body.get("documentsPath") != null || body.get("pitchDeckPath") != null) {
            String path = str(body.get("pitchDeckPath") != null ? body.get("pitchDeckPath") : body.get("documentsPath"));
            e.setDocumentsPath(blankToNull(path));
        }
        if (body.get("photosPath") != null) {
            e.setPhotosPath(blankToNull(str(body.get("photosPath"))));
        }
        return e;
    }

    public static String statusLabel(PartnerProfileStatus status) {
        return PartnerLifecycleSupport.statusLabel(status);
    }

    private boolean canSubmit(Entrepreneur entrepreneur, List<String> missing) {
        PartnerProfileStatus s = entrepreneur.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED
                || s == PartnerProfileStatus.APPROVED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(Entrepreneur entrepreneur, List<String> missing) {
        PartnerProfileStatus s = entrepreneur.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your entrepreneur profile is under admin review.";
        }
        if (isApproved(entrepreneur)) {
            return "You're approved. Publish pitches from Proposals.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            String note = entrepreneur.getChangesRequestedNote();
            return note == null || note.isBlank()
                    ? "Admin requested changes. Update your profile and resubmit."
                    : "Admin requested changes: " + note;
        }
        if (s == PartnerProfileStatus.REJECTED) {
            String reason = entrepreneur.getRejectionReason();
            return reason == null || reason.isBlank()
                    ? "Registration was rejected. Update your profile and resubmit."
                    : "Rejected: " + reason;
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "All required items are ready. Submit for admin verification.";
    }

    private static String composeBank(Entrepreneur e) {
        List<String> parts = new ArrayList<>();
        if (!PartnerLifecycleSupport.blank(e.getBankName())) parts.add(e.getBankName());
        if (!PartnerLifecycleSupport.blank(e.getAccountNumber())) parts.add(e.getAccountNumber());
        if (!PartnerLifecycleSupport.blank(e.getIfscCode())) parts.add(e.getIfscCode());
        return parts.isEmpty() ? null : String.join(" · ", parts);
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
