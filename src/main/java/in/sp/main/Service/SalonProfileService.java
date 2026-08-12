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
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.ServiceCategory;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceRepository;

@Service
public class SalonProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("H:mm");

    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private ServiceRepository serviceRepository;

    public void setLifecycleStatus(Salon salon, PartnerProfileStatus status) {
        if (salon == null || status == null) {
            return;
        }
        salon.setPartnerProfileStatus(status);
        if (status == PartnerProfileStatus.APPROVED) {
            salon.setApproved(true);
        } else if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || status == PartnerProfileStatus.PROFILE_INCOMPLETE
                || status == PartnerProfileStatus.REGISTERED
                || status == PartnerProfileStatus.READY_FOR_VERIFICATION
                || status == PartnerProfileStatus.REJECTED
                || status == PartnerProfileStatus.SUSPENDED) {
            salon.setApproved(false);
        }
    }

    public List<String> missingItems(Salon salon) {
        List<String> missing = new ArrayList<>();
        if (PartnerLifecycleSupport.blank(salon.getName())) missing.add("1.1 Salon name");
        if (PartnerLifecycleSupport.blank(salon.getSalonType())) missing.add("1.2 Salon type");
        if (PartnerLifecycleSupport.blank(salon.getContactPerson())) missing.add("1.3 Owner / manager");
        if (PartnerLifecycleSupport.blank(salon.getPhone()) || !salon.getPhone().trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(salon.getAddress())) missing.add("2.1 Landmark / address");
        if (PartnerLifecycleSupport.blank(salon.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(salon.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(salon.getPincode()) || !salon.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(salon.getCategoriesOffered())) missing.add("3.1 Categories");
        if (PartnerLifecycleSupport.blank(salon.getAudience())) missing.add("4.1 Who we serve");
        if (PartnerLifecycleSupport.blank(salon.getOpenDays())) missing.add("6.1 Open days");
        if (salon.getOpenTime() == null) missing.add("6.2 Open time");
        if (salon.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(salon.getBio())) missing.add("7.1 About the salon");
        List<Service1> services = salon.getId() == null
                ? List.of()
                : serviceRepository.findBySalonId(salon.getId());
        if (services == null || services.isEmpty()) {
            missing.add("8. First service");
        }
        return missing;
    }

    public int calculateCompletionPct(Salon salon) {
        int filled = 0;
        int total = 14;
        if (!PartnerLifecycleSupport.blank(salon.getName())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getSalonType())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getContactPerson())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getPhone())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getCity())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getState())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getPincode())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getCategoriesOffered())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getAudience())) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getOpenDays())) filled++;
        if (salon.getOpenTime() != null) filled++;
        if (salon.getCloseTime() != null) filled++;
        if (!PartnerLifecycleSupport.blank(salon.getBio())) filled++;
        List<Service1> services = salon.getId() == null
                ? List.of()
                : serviceRepository.findBySalonId(salon.getId());
        if (services != null && !services.isEmpty()) filled++;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public Salon refreshCompletion(Salon salon) {
        List<String> missing = missingItems(salon);
        int pct = calculateCompletionPct(salon);
        salon.setProfileCompletionPct(pct);

        PartnerProfileStatus current = salon.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return salonRepository.save(salon);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(salon, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(salon, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return salonRepository.save(salon);
    }

    public boolean isReadyForVerification(Salon salon) {
        return missingItems(salon).isEmpty();
    }

    @Transactional
    public void applyFields(Salon salon, Map<String, Object> body) {
        if (salon == null || body == null) return;
        if (body.get("name") != null) salon.setName(blankToNull(str(body.get("name"))));
        if (body.get("salonType") != null) salon.setSalonType(blankToNull(str(body.get("salonType"))));
        if (body.get("contactPerson") != null) salon.setContactPerson(blankToNull(str(body.get("contactPerson"))));
        if (body.get("designation") != null) salon.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("phone") != null) salon.setPhone(blankToNull(str(body.get("phone"))));
        if (body.get("whatsappNumber") != null) salon.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("establishedYear") != null && !str(body.get("establishedYear")).isBlank()) {
            try { salon.setEstablishedYear(Integer.parseInt(str(body.get("establishedYear")))); } catch (Exception ignored) {}
        }
        if (body.get("address") != null) salon.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) salon.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) salon.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) salon.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("website") != null) salon.setWebsite(blankToNull(str(body.get("website"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { salon.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { salon.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null) salon.setCategoriesOffered(csv(body.get("categoriesOffered")));
        if (body.get("audience") != null) salon.setAudience(blankToNull(str(body.get("audience"))));
        if (body.get("doorService") != null) salon.setDoorService(bool(body.get("doorService")));
        if (body.get("femaleStaff") != null) salon.setFemaleStaff(bool(body.get("femaleStaff")));
        if (body.get("facilities") != null) salon.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) salon.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) salon.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) salon.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) salon.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) salon.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) salon.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) salon.setBio(blankToNull(str(body.get("bio"))));
        if (body.get("hygieneNotes") != null) salon.setHygieneNotes(blankToNull(str(body.get("hygieneNotes"))));
        if (body.get("availabilityHours") != null) salon.setAvailabilityHours(blankToNull(str(body.get("availabilityHours"))));
        if (body.get("upiId") != null) salon.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) salon.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (body.get("profileImageUrl") != null) salon.setProfileImageUrl(blankToNull(str(body.get("profileImageUrl"))));
        if (salon.getOpenTime() != null && salon.getCloseTime() != null) {
            salon.setAvailabilityHours(salon.getOpenTime().format(TIME_FMT) + " – " + salon.getCloseTime().format(TIME_FMT));
        }
        upsertFirstService(salon, body);
    }

    private void upsertFirstService(Salon salon, Map<String, Object> body) {
        String name = str(body.get("firstServiceName"));
        if (name.isBlank()) return;
        List<Service1> existing = salon.getId() == null ? List.of() : serviceRepository.findBySalonId(salon.getId());
        Service1 service = (existing == null || existing.isEmpty()) ? new Service1() : existing.get(0);
        service.setSalon(salon);
        service.setName(name);
        if (body.get("firstServiceCategory") != null) {
            ServiceCategory cat = ServiceCategory.fromFlexible(str(body.get("firstServiceCategory")));
            if (cat != null) service.setCategory(cat.normalized());
        }
        if (body.get("firstServiceDuration") != null && !str(body.get("firstServiceDuration")).isBlank()) {
            try { service.setDurationMinutes(Integer.parseInt(str(body.get("firstServiceDuration")))); } catch (Exception ignored) {}
        }
        if (body.get("firstServiceBuffer") != null && !str(body.get("firstServiceBuffer")).isBlank()) {
            try { service.setBufferMinutes(Integer.parseInt(str(body.get("firstServiceBuffer")))); } catch (Exception ignored) {}
        }
        if (body.get("firstServicePrice") != null && !str(body.get("firstServicePrice")).isBlank()) {
            try { service.setPrice(Double.parseDouble(str(body.get("firstServicePrice")))); } catch (Exception ignored) {}
        }
        if (body.get("firstServiceMode") != null) {
            service.setServiceMode(blankToNull(str(body.get("firstServiceMode")).toUpperCase()));
        }
        if (service.getDurationMinutes() == null) service.setDurationMinutes(30);
        if (service.getPrice() == null) service.setPrice(0d);
        serviceRepository.save(service);
    }

    public Map<String, Object> profilePayload(Salon salon) {
        refreshCompletion(salon);
        List<String> missing = missingItems(salon);
        List<Service1> services = salon.getId() == null ? List.of() : serviceRepository.findBySalonId(salon.getId());
        Service1 first = (services == null || services.isEmpty()) ? null : services.get(0);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", salon.getId());
        m.put("name", salon.getName());
        m.put("username", salon.getUsername());
        m.put("email", salon.getEmail());
        m.put("phone", salon.getPhone());
        m.put("whatsappNumber", salon.getWhatsappNumber());
        m.put("contactPerson", salon.getContactPerson());
        m.put("designation", salon.getDesignation());
        m.put("salonType", salon.getSalonType());
        m.put("establishedYear", salon.getEstablishedYear());
        m.put("city", salon.getCity());
        m.put("state", salon.getState());
        m.put("pincode", salon.getPincode());
        m.put("address", salon.getAddress());
        m.put("website", salon.getWebsite());
        m.put("latitude", salon.getLatitude());
        m.put("longitude", salon.getLongitude());
        m.put("bio", salon.getBio());
        m.put("hygieneNotes", salon.getHygieneNotes());
        m.put("availabilityHours", salon.getAvailabilityHours());
        m.put("openDays", splitCsv(salon.getOpenDays()));
        m.put("openTime", salon.getOpenTime() == null ? null : salon.getOpenTime().format(TIME_FMT));
        m.put("closeTime", salon.getCloseTime() == null ? null : salon.getCloseTime().format(TIME_FMT));
        m.put("breakStart", salon.getBreakStart() == null ? null : salon.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", salon.getBreakEnd() == null ? null : salon.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", salon.getBlockedDates());
        m.put("categoriesOffered", splitCsv(salon.getCategoriesOffered()));
        m.put("audience", salon.getAudience());
        m.put("doorService", Boolean.TRUE.equals(salon.getDoorService()));
        m.put("femaleStaff", Boolean.TRUE.equals(salon.getFemaleStaff()));
        m.put("facilities", splitCsv(salon.getFacilities()));
        m.put("upiId", salon.getUpiId());
        m.put("bankDetails", salon.getBankDetails());
        m.put("payoutBalance", salon.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(salon.getGalleryPhotos()));
        m.put("profileImageUrl", salon.getProfileImageUrl());
        m.put("firstServiceName", first == null ? null : first.getName());
        m.put("firstServiceCategory", first == null || first.getCategory() == null ? null : first.getCategory().name());
        m.put("firstServiceDuration", first == null ? null : first.getDurationMinutes());
        m.put("firstServiceBuffer", first == null ? null : first.getBufferMinutes());
        m.put("firstServicePrice", first == null ? null : first.getPrice());
        m.put("firstServiceMode", first == null ? null : first.getServiceMode());
        m.put("approved", salon.isApproved());
        m.put("partnerProfileStatus", salon.getPartnerProfileStatus() == null
                ? null : salon.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(salon.getPartnerProfileStatus()));
        m.put("profileCompletionPct", salon.getProfileCompletionPct() == null
                ? 0 : salon.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(salon, missing));
        m.put("rejectionReason", salon.getRejectionReason());
        m.put("changesRequestedNote", salon.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(salon, missing));
        m.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        return m;
    }

    private boolean canSubmit(Salon salon, List<String> missing) {
        PartnerProfileStatus s = salon.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(Salon salon, List<String> missing) {
        PartnerProfileStatus s = salon.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your salon profile is under admin review. You'll be notified once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED) {
            return "Your salon is approved and visible to clients.";
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

    private static boolean bool(Object v) {
        if (v instanceof Boolean b) return b;
        return "true".equalsIgnoreCase(str(v)) || "1".equals(str(v));
    }

    private static LocalTime parseTime(Object v) {
        String s = str(v);
        if (s.isBlank()) return null;
        try {
            if (s.length() == 5) return LocalTime.parse(s);
            return LocalTime.parse(s, TIME_FMT);
        } catch (Exception e) {
            try { return LocalTime.parse(s); } catch (Exception ignored) { return null; }
        }
    }
}
