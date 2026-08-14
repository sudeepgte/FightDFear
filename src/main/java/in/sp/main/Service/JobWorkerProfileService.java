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

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Util.JobCategories;

@Service
public class JobWorkerProfileService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("H:mm");

    @Autowired
    private JobApplicationRepository jobAppRepo;
    @Autowired
    private UserRepository userRepository;

    public JobApplication latestFor(User user) {
        if (user == null || user.getId() == null) return null;
        return jobAppRepo.findByUser_Id(user.getId()).stream()
                .max((a, b) -> {
                    var at = a.getAppliedAt();
                    var bt = b.getAppliedAt();
                    if (at == null && bt == null) return 0;
                    if (at == null) return -1;
                    if (bt == null) return 1;
                    return at.compareTo(bt);
                })
                .orElse(null);
    }

    public List<String> missingItems(JobApplication app, User user) {
        List<String> missing = new ArrayList<>();
        String name = user == null ? null : user.getFullName();
        if (PartnerLifecycleSupport.blank(name)) missing.add("1.1 Full name");
        if (app == null) {
            missing.add("1.2 Role type");
            missing.add("1.5 Phone");
            missing.add("2.1 Landmark / address");
            missing.add("2.3 City");
            missing.add("2.4 State");
            missing.add("2.5 Pincode");
            missing.add("3.1 Work categories");
            missing.add("4.1 Who I serve");
            missing.add("6.1 Open days");
            missing.add("6.2 Open time");
            missing.add("6.3 Close time");
            missing.add("7.1 About");
            missing.add("8. First offering");
            return missing;
        }
        if (PartnerLifecycleSupport.blank(app.getJobCategory()) && PartnerLifecycleSupport.blank(app.getCategoriesOffered())) {
            missing.add("1.2 Role type");
        }
        String phone = user == null ? null : user.getPhoneNumber();
        if (PartnerLifecycleSupport.blank(phone) || !phone.trim().matches("\\d{10}")) {
            missing.add("1.5 Official phone");
        }
        if (PartnerLifecycleSupport.blank(app.getAddress())) missing.add("2.1 Landmark / address");
        if (PartnerLifecycleSupport.blank(app.getCity())) missing.add("2.3 City");
        if (PartnerLifecycleSupport.blank(app.getState())) missing.add("2.4 State");
        if (PartnerLifecycleSupport.blank(app.getPincode()) || !app.getPincode().trim().matches("\\d{6}")) {
            missing.add("2.5 Pincode");
        }
        if (PartnerLifecycleSupport.blank(app.getJobCategory()) && PartnerLifecycleSupport.blank(app.getCategoriesOffered())) {
            missing.add("3.1 Work categories");
        }
        if (PartnerLifecycleSupport.blank(app.getAudience())) missing.add("4.1 Who I serve");
        if (PartnerLifecycleSupport.blank(app.getOpenDays())) missing.add("6.1 Open days");
        if (app.getOpenTime() == null) missing.add("6.2 Open time");
        if (app.getCloseTime() == null) missing.add("6.3 Close time");
        if (PartnerLifecycleSupport.blank(app.getBio())) missing.add("7.1 About");
        if (PartnerLifecycleSupport.blank(app.getJobSubCategory())
                || app.getHourlyRate() == null
                || app.getHourlyRate() < 0
                || PartnerLifecycleSupport.blank(app.getServiceMode())) {
            missing.add("8. First offering");
        }
        return missing;
    }

    public int completionPct(JobApplication app, User user) {
        int total = 14;
        int filled = total - missingItems(app, user).size();
        if (filled < 0) filled = 0;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public JobApplication applyFields(User user, Map<String, Object> body) {
        JobApplication app = latestFor(user);
        if (app == null) {
            app = new JobApplication();
            app.setUser(user);
            app.setDocumentPath("");
            app.setHourlyRate(0d);
            app.setJobCategory("Housekeeping");
            app.setJobSubCategory("Housekeeper");
            app.setStatus(VerificationStatus.PENDING);
            app.setAppliedAt(java.time.LocalDateTime.now());
        }
        if (body.get("fullName") != null && user != null) {
            user.setFullName(blankToNull(str(body.get("fullName"))));
            userRepository.save(user);
        }
        if (body.get("phone") != null && user != null) {
            user.setPhoneNumber(blankToNull(str(body.get("phone"))));
            userRepository.save(user);
        }
        if (body.get("designation") != null) app.setDesignation(blankToNull(str(body.get("designation"))));
        if (body.get("whatsappNumber") != null) app.setWhatsappNumber(blankToNull(str(body.get("whatsappNumber"))));
        if (body.get("yearsExperience") != null && !str(body.get("yearsExperience")).isBlank()) {
            try { app.setYearsExperience(Integer.parseInt(str(body.get("yearsExperience")))); } catch (Exception ignored) {}
        }
        if (body.get("address") != null) app.setAddress(blankToNull(str(body.get("address"))));
        if (body.get("city") != null) app.setCity(blankToNull(str(body.get("city"))));
        if (body.get("state") != null) app.setState(blankToNull(str(body.get("state"))));
        if (body.get("pincode") != null) app.setPincode(blankToNull(str(body.get("pincode"))));
        if (body.get("latitude") != null && !str(body.get("latitude")).isBlank()) {
            try { app.setLatitude(Double.parseDouble(str(body.get("latitude")))); } catch (Exception ignored) {}
        }
        if (body.get("longitude") != null && !str(body.get("longitude")).isBlank()) {
            try { app.setLongitude(Double.parseDouble(str(body.get("longitude")))); } catch (Exception ignored) {}
        }
        if (body.get("categoriesOffered") != null) app.setCategoriesOffered(csv(body.get("categoriesOffered")));
        if (body.get("jobCategory") != null) {
            String cat = JobCategories.normalize(str(body.get("jobCategory")));
            if (cat != null) app.setJobCategory(cat);
        }
        if (body.get("jobSubCategory") != null) app.setJobSubCategory(blankToNull(str(body.get("jobSubCategory"))));
        if (body.get("audience") != null) app.setAudience(csv(body.get("audience")));
        if (body.get("doorService") != null) app.setDoorService(bool(body.get("doorService")));
        if (body.get("languages") != null) app.setLanguages(csv(body.get("languages")));
        if (body.get("skills") != null) app.setSkills(csv(body.get("skills")));
        if (body.get("facilities") != null) app.setFacilities(csv(body.get("facilities")));
        if (body.get("openDays") != null) app.setOpenDays(csv(body.get("openDays")));
        if (body.get("openTime") != null) app.setOpenTime(parseTime(body.get("openTime")));
        if (body.get("closeTime") != null) app.setCloseTime(parseTime(body.get("closeTime")));
        if (body.get("breakStart") != null) app.setBreakStart(parseTime(body.get("breakStart")));
        if (body.get("breakEnd") != null) app.setBreakEnd(parseTime(body.get("breakEnd")));
        if (body.get("blockedDates") != null) app.setBlockedDates(csv(body.get("blockedDates")));
        if (body.get("bio") != null) app.setBio(blankToNull(str(body.get("bio"))));
        if (body.get("hourlyRate") != null && !str(body.get("hourlyRate")).isBlank()) {
            try { app.setHourlyRate(Double.parseDouble(str(body.get("hourlyRate")))); } catch (Exception ignored) {}
        }
        if (body.get("durationMinutes") != null && !str(body.get("durationMinutes")).isBlank()) {
            try { app.setDurationMinutes(Integer.parseInt(str(body.get("durationMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("bufferMinutes") != null && !str(body.get("bufferMinutes")).isBlank()) {
            try { app.setBufferMinutes(Integer.parseInt(str(body.get("bufferMinutes")))); } catch (Exception ignored) {}
        }
        if (body.get("serviceMode") != null) app.setServiceMode(blankToNull(str(body.get("serviceMode")).toUpperCase()));
        if (body.get("workType") != null) app.setWorkType(blankToNull(str(body.get("workType"))));
        if (body.get("upiId") != null) app.setUpiId(blankToNull(str(body.get("upiId"))));
        if (body.get("bankDetails") != null) app.setBankDetails(blankToNull(str(body.get("bankDetails"))));
        if (body.get("note") != null) app.setNote(blankToNull(str(body.get("note"))));
        if (!PartnerLifecycleSupport.blank(app.getCategoriesOffered()) && PartnerLifecycleSupport.blank(app.getJobCategory())) {
            String first = splitCsv(app.getCategoriesOffered()).stream().findFirst().orElse(null);
            if (first != null) app.setJobCategory(JobCategories.normalize(first) == null ? first : JobCategories.normalize(first));
        }
        return jobAppRepo.save(app);
    }

    public Map<String, Object> profilePayload(User user) {
        JobApplication app = latestFor(user);
        List<String> missing = missingItems(app, user);
        int pct = completionPct(app, user);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("id", app == null ? null : app.getId());
        m.put("fullName", user == null ? null : user.getFullName());
        m.put("email", user == null ? null : user.getEmail());
        m.put("phone", user == null ? null : user.getPhoneNumber());
        m.put("designation", app == null ? null : app.getDesignation());
        m.put("whatsappNumber", app == null ? null : app.getWhatsappNumber());
        m.put("yearsExperience", app == null ? null : app.getYearsExperience());
        m.put("address", app == null ? null : app.getAddress());
        m.put("city", app == null ? null : app.getCity());
        m.put("state", app == null ? null : app.getState());
        m.put("pincode", app == null ? null : app.getPincode());
        m.put("latitude", app == null ? null : app.getLatitude());
        m.put("longitude", app == null ? null : app.getLongitude());
        m.put("jobCategory", app == null ? null : app.getJobCategory());
        m.put("jobSubCategory", app == null ? null : app.getJobSubCategory());
        m.put("categoriesOffered", splitCsv(app == null ? null : app.getCategoriesOffered()));
        m.put("audience", splitCsv(app == null ? null : app.getAudience()));
        m.put("doorService", app != null && Boolean.TRUE.equals(app.getDoorService()));
        m.put("languages", splitCsv(app == null ? null : app.getLanguages()));
        m.put("skills", splitCsv(app == null ? null : app.getSkills()));
        m.put("facilities", splitCsv(app == null ? null : app.getFacilities()));
        m.put("openDays", splitCsv(app == null ? null : app.getOpenDays()));
        m.put("openTime", app == null || app.getOpenTime() == null ? null : app.getOpenTime().format(TIME_FMT));
        m.put("closeTime", app == null || app.getCloseTime() == null ? null : app.getCloseTime().format(TIME_FMT));
        m.put("breakStart", app == null || app.getBreakStart() == null ? null : app.getBreakStart().format(TIME_FMT));
        m.put("breakEnd", app == null || app.getBreakEnd() == null ? null : app.getBreakEnd().format(TIME_FMT));
        m.put("blockedDates", app == null ? null : app.getBlockedDates());
        m.put("bio", app == null ? null : app.getBio());
        m.put("hourlyRate", app == null ? null : app.getHourlyRate());
        m.put("durationMinutes", app == null ? null : app.getDurationMinutes());
        m.put("bufferMinutes", app == null ? null : app.getBufferMinutes());
        m.put("serviceMode", app == null ? null : app.getServiceMode());
        m.put("workType", app == null ? null : app.getWorkType());
        m.put("upiId", app == null ? null : app.getUpiId());
        m.put("bankDetails", app == null ? null : app.getBankDetails());
        m.put("payoutBalance", app == null ? 0 : app.getPayoutBalance());
        m.put("galleryPhotos", splitCsv(app == null ? null : app.getGalleryPhotos()));
        m.put("profileImageUrl", app == null ? null : app.getProfileImageUrl());
        m.put("applicationStatus", app == null || app.getStatus() == null ? null : app.getStatus().name());
        m.put("isVerifiedWorker", app != null && app.getStatus() == VerificationStatus.VERIFIED);
        m.put("profileCompletionPct", pct);
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", missing.isEmpty() && (app == null || app.getStatus() != VerificationStatus.VERIFIED));
        m.put("needsProfileCompletion", missing.isEmpty() == false);
        m.put("nextStepGuidance", missing.isEmpty()
                ? "All required items are ready. Submit for admin verification."
                : "Complete " + missing.get(0) + " to submit verification.");
        m.put("cancelPolicy", WomenJobsCareService.CANCEL_POLICY);
        return m;
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
}
