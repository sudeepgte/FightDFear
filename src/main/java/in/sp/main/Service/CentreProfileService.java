package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.CentreProfileStatus;
import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;

@Service
public class CentreProfileService {

    @Autowired
    private MartialArtsCenterRepository centreRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    public void setLifecycleStatus(MartialArtsCenter centre, CentreProfileStatus status) {
        centre.setCentreProfileStatus(status);
        if (status == CentreProfileStatus.APPROVED) {
            centre.setApproved(true);
        } else if (status == CentreProfileStatus.PENDING_ADMIN_APPROVAL
                || status == CentreProfileStatus.PROFILE_INCOMPLETE
                || status == CentreProfileStatus.REGISTERED
                || status == CentreProfileStatus.READY_FOR_VERIFICATION
                || status == CentreProfileStatus.REJECTED
                || status == CentreProfileStatus.SUSPENDED) {
            centre.setApproved(false);
        }
        // CHANGES_REQUESTED: keep current approved flag (usually false until re-approved)
    }

    @Transactional
    public MartialArtsCenter refreshCompletion(MartialArtsCenter centre) {
        List<String> missing = missingItems(centre);
        int pct = calculateCompletionPct(centre);
        centre.setProfileCompletionPct(pct);

        CentreProfileStatus current = centre.getCentreProfileStatus();
        if (current == CentreProfileStatus.SUSPENDED
                || current == CentreProfileStatus.PENDING_ADMIN_APPROVAL
                || current == CentreProfileStatus.APPROVED
                || current == CentreProfileStatus.CHANGES_REQUESTED) {
            return centreRepository.save(centre);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(centre, CentreProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == CentreProfileStatus.REGISTERED
                || current == CentreProfileStatus.READY_FOR_VERIFICATION
                || current == CentreProfileStatus.REJECTED) {
            setLifecycleStatus(centre, CentreProfileStatus.PROFILE_INCOMPLETE);
        }
        return centreRepository.save(centre);
    }

    public boolean isReadyForVerification(MartialArtsCenter centre) {
        return missingItems(centre).isEmpty();
    }

    public List<String> missingItems(MartialArtsCenter centre) {
        List<String> missing = new ArrayList<>();
        if (blank(centre.getName())) missing.add("1.1 Centre name");
        if (blank(centre.getCentreType())) missing.add("1.2 Centre type");
        if (blank(centre.getContactPerson())) missing.add("1.3 Owner / manager");
        if (blank(centre.getPhoneNumber()) || !centre.getPhoneNumber().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (blank(centre.getLocation()) && blank(centre.getArea())) missing.add("2.1 Hall / landmark");
        if (blank(centre.getCity())) missing.add("2.3 City");
        if (blank(centre.getState())) missing.add("2.4 State");
        if (blank(centre.getPincode()) || !centre.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (blank(centre.getStylesTaught())) missing.add("3.1 Styles taught");
        if (blank(centre.getAudience())) missing.add("4.1 Who can join");
        if (centre.getAvailableDays() == null || centre.getAvailableDays().isEmpty()) {
            missing.add("6.1 Open days");
        }
        if (blank(centre.getOpenTime())) missing.add("6.2 Open time");
        if (blank(centre.getCloseTime())) missing.add("6.3 Close time");
        if (blank(centre.getAbout())) missing.add("7.1 About the centre");
        if (blank(centre.getHowWeTeach())) missing.add("7.2 How we teach");
        if (blank(centre.getWhatWeOffer())) missing.add("7.3 What we offer");
        List<MartialArtsBatch> batches = centre.getId() == null
                ? List.of()
                : batchRepository.findByCenterId(centre.getId());
        if (batches == null || batches.isEmpty()) {
            missing.add("8. First program / batch");
        }
        return missing;
    }

    public int calculateCompletionPct(MartialArtsCenter centre) {
        int filled = 0;
        int total = 16;
        if (!blank(centre.getName())) filled++;
        if (!blank(centre.getCentreType())) filled++;
        if (!blank(centre.getContactPerson())) filled++;
        if (!blank(centre.getPhoneNumber())) filled++;
        if (!blank(centre.getCity())) filled++;
        if (!blank(centre.getState())) filled++;
        if (!blank(centre.getPincode())) filled++;
        if (!blank(centre.getStylesTaught())) filled++;
        if (!blank(centre.getAudience())) filled++;
        if (centre.getAvailableDays() != null && !centre.getAvailableDays().isEmpty()) filled++;
        if (!blank(centre.getOpenTime())) filled++;
        if (!blank(centre.getCloseTime())) filled++;
        if (!blank(centre.getAbout())) filled++;
        if (!blank(centre.getHowWeTeach())) filled++;
        if (!blank(centre.getWhatWeOffer())) filled++;
        List<MartialArtsBatch> batches = centre.getId() == null
                ? List.of()
                : batchRepository.findByCenterId(centre.getId());
        if (batches != null && !batches.isEmpty()) filled++;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public void applyFields(MartialArtsCenter centre, Map<String, Object> body) {
        if (body == null) return;
        if (body.get("name") != null) centre.setName(str(body.get("name")));
        if (body.get("centreType") != null) centre.setCentreType(str(body.get("centreType")));
        if (body.get("contactPerson") != null) centre.setContactPerson(str(body.get("contactPerson")));
        if (body.get("designation") != null) centre.setDesignation(str(body.get("designation")));
        if (body.get("phoneNumber") != null) centre.setPhoneNumber(str(body.get("phoneNumber")));
        if (body.get("whatsappNumber") != null) centre.setWhatsappNumber(str(body.get("whatsappNumber")));
        if (body.get("yearStarted") != null && !str(body.get("yearStarted")).isBlank()) {
            try { centre.setYearStarted(Integer.parseInt(str(body.get("yearStarted")))); } catch (Exception ignored) {}
        }
        if (body.get("affiliation") != null) centre.setAffiliation(str(body.get("affiliation")));
        if (body.get("location") != null) centre.setLocation(str(body.get("location")));
        if (body.get("area") != null) centre.setArea(str(body.get("area")));
        if (body.get("city") != null) centre.setCity(str(body.get("city")));
        if (body.get("state") != null) centre.setState(str(body.get("state")));
        if (body.get("pincode") != null) centre.setPincode(str(body.get("pincode")));
        if (body.get("googleMapLocation") != null) centre.setGoogleMapLocation(str(body.get("googleMapLocation")));
        if (body.get("centreLat") != null && !str(body.get("centreLat")).isBlank()) {
            try { centre.setCentreLat(Double.parseDouble(str(body.get("centreLat")))); } catch (Exception ignored) {}
        }
        if (body.get("centreLng") != null && !str(body.get("centreLng")).isBlank()) {
            try { centre.setCentreLng(Double.parseDouble(str(body.get("centreLng")))); } catch (Exception ignored) {}
        }
        if (body.get("stylesTaught") != null) centre.setStylesTaught(csv(body.get("stylesTaught")));
        if (body.get("audience") != null) centre.setAudience(csv(body.get("audience")));
        if (body.get("womenOnlyBatches") != null) centre.setWomenOnlyBatches(bool(body.get("womenOnlyBatches")));
        if (body.get("femaleInstructor") != null) centre.setFemaleInstructor(bool(body.get("femaleInstructor")));
        if (body.get("ageGroups") != null) centre.setAgeGroups(csv(body.get("ageGroups")));
        if (body.get("facilities") != null) centre.setFacilities(csv(body.get("facilities")));
        if (body.get("openTime") != null) centre.setOpenTime(str(body.get("openTime")));
        if (body.get("closeTime") != null) centre.setCloseTime(str(body.get("closeTime")));
        if (body.get("breakStart") != null) centre.setBreakStart(str(body.get("breakStart")));
        if (body.get("breakEnd") != null) centre.setBreakEnd(str(body.get("breakEnd")));
        if (body.get("blockedDates") != null) centre.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("about") != null) centre.setAbout(str(body.get("about")));
        if (body.get("howWeTeach") != null) centre.setHowWeTeach(str(body.get("howWeTeach")));
        if (body.get("whatWeOffer") != null) centre.setWhatWeOffer(csv(body.get("whatWeOffer")));
        if (body.get("startingFee") != null && !str(body.get("startingFee")).isBlank()) {
            try { centre.setStartingFee(Double.parseDouble(str(body.get("startingFee")))); } catch (Exception ignored) {}
        }
        if (body.get("trialAvailable") != null) centre.setTrialAvailable(bool(body.get("trialAvailable")));
        if (body.get("upiId") != null) centre.setUpiId(str(body.get("upiId")));
        if (body.get("bankDetails") != null) centre.setBankDetails(str(body.get("bankDetails")));
        if (body.get("availableDays") instanceof List<?> days) {
            java.util.Set<in.sp.main.Entities.DayAvailable> set = new java.util.TreeSet<>();
            for (Object d : days) {
                try {
                    set.add(in.sp.main.Entities.DayAvailable.valueOf(String.valueOf(d).trim().toUpperCase()));
                } catch (Exception ignored) {}
            }
            centre.setAvailableDays(set);
        }
        if (blank(centre.getLocation())) {
            String composed = joinNonBlank(centre.getArea(), centre.getCity(), centre.getState(), centre.getPincode());
            if (!composed.isBlank()) centre.setLocation(composed);
        }
    }

    private static String str(Object v) {
        return v == null ? "" : String.valueOf(v).trim();
    }

    private static String csv(Object v) {
        if (v instanceof List<?> list) {
            return list.stream().map(String::valueOf).map(String::trim).filter(s -> !s.isEmpty()).reduce((a, b) -> a + ", " + b).orElse("");
        }
        return str(v);
    }

    private static boolean bool(Object v) {
        if (v instanceof Boolean b) return b;
        return "true".equalsIgnoreCase(str(v)) || "1".equals(str(v));
    }

    private static String joinNonBlank(String... parts) {
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p == null || p.isBlank()) continue;
            if (sb.length() > 0) sb.append(", ");
            sb.append(p.trim());
        }
        return sb.toString();
    }

    public Map<String, Object> profilePayload(MartialArtsCenter centre) {
        refreshCompletion(centre);
        List<String> missing = missingItems(centre);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", centre.getId());
        m.put("name", centre.getName());
        m.put("email", centre.getEmail());
        m.put("phoneNumber", centre.getPhoneNumber());
        m.put("contactPerson", centre.getContactPerson());
        m.put("location", centre.getLocation());
        m.put("about", centre.getAbout());
        m.put("howWeTeach", centre.getHowWeTeach());
        m.put("whatWeOffer", centre.getWhatWeOffer());
        m.put("profilePhoto", centre.getProfilePhoto());
        m.put("certificatePath", centre.getTrainerCertificatePath());
        m.put("galleryPhotos", centre.getGalleryPhotos() == null ? List.of() : centre.getGalleryPhotos());
        m.put("centreType", centre.getCentreType());
        m.put("designation", centre.getDesignation());
        m.put("whatsappNumber", centre.getWhatsappNumber());
        m.put("yearStarted", centre.getYearStarted());
        m.put("affiliation", centre.getAffiliation());
        m.put("area", centre.getArea());
        m.put("city", centre.getCity());
        m.put("state", centre.getState());
        m.put("pincode", centre.getPincode());
        m.put("googleMapLocation", centre.getGoogleMapLocation());
        m.put("centreLat", centre.getCentreLat());
        m.put("centreLng", centre.getCentreLng());
        m.put("stylesTaught", centre.getStylesTaught());
        m.put("audience", centre.getAudience());
        m.put("womenOnlyBatches", Boolean.TRUE.equals(centre.getWomenOnlyBatches()));
        m.put("femaleInstructor", Boolean.TRUE.equals(centre.getFemaleInstructor()));
        m.put("ageGroups", centre.getAgeGroups());
        m.put("facilities", centre.getFacilities());
        m.put("openTime", centre.getOpenTime());
        m.put("closeTime", centre.getCloseTime());
        m.put("breakStart", centre.getBreakStart());
        m.put("breakEnd", centre.getBreakEnd());
        m.put("blockedDates", centre.getBlockedDates());
        m.put("startingFee", centre.getStartingFee());
        m.put("trialAvailable", Boolean.TRUE.equals(centre.getTrialAvailable()));
        m.put("upiId", centre.getUpiId());
        m.put("bankDetails", centre.getBankDetails());
        m.put("payoutBalance", centre.getPayoutBalance() == null ? 0 : centre.getPayoutBalance());
        m.put("rating", centre.getRating() == null ? 0 : centre.getRating());
        m.put("availableDays", centre.getAvailableDays() == null
                ? List.of()
                : centre.getAvailableDays().stream().map(Enum::name).toList());
        m.put("approved", centre.isApproved());
        m.put("centreProfileStatus", centre.getCentreProfileStatus() == null
                ? null : centre.getCentreProfileStatus().name());
        m.put("centreProfileStatusLabel", statusLabel(centre.getCentreProfileStatus()));
        m.put("profileCompletionPct", centre.getProfileCompletionPct() == null
                ? 0 : centre.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(centre, missing));
        m.put("rejectionReason", centre.getRejectionReason());
        m.put("changesRequestedNote", centre.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(centre, missing));
        return m;
    }

    private boolean canSubmit(MartialArtsCenter centre, List<String> missing) {
        CentreProfileStatus s = centre.getCentreProfileStatus();
        if (s == CentreProfileStatus.PENDING_ADMIN_APPROVAL || s == CentreProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(MartialArtsCenter centre, List<String> missing) {
        CentreProfileStatus s = centre.getCentreProfileStatus();
        if (s == CentreProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your profile is under admin review. You'll be notified once approved.";
        }
        if (s == CentreProfileStatus.APPROVED) {
            return "Your centre is approved and visible to students.";
        }
        if (s == CentreProfileStatus.REJECTED) {
            return "Registration was rejected. Update your profile and resubmit.";
        }
        if (s == CentreProfileStatus.CHANGES_REQUESTED) {
            return "Admin requested changes. Update the highlighted items and resubmit.";
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "All required items are ready. Submit for admin verification.";
    }

    public static String statusLabel(CentreProfileStatus status) {
        if (status == null) return "Profile Incomplete";
        return switch (status) {
            case REGISTERED -> "Registered";
            case PROFILE_INCOMPLETE -> "Profile Incomplete";
            case READY_FOR_VERIFICATION -> "Ready to Submit";
            case PENDING_ADMIN_APPROVAL -> "Pending Approval";
            case APPROVED -> "Approved";
            case CHANGES_REQUESTED -> "Changes Requested";
            case REJECTED -> "Rejected";
            case SUSPENDED -> "Suspended";
        };
    }

    private static boolean blank(String v) {
        return v == null || v.isBlank();
    }
}
