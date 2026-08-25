package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.FinancialEnrollment;
import in.sp.main.Entities.FinancialLiveSession;
import in.sp.main.Entities.FinancialVideo;
import in.sp.main.Entities.FinancialWorkshop;
import in.sp.main.Entities.User;
import in.sp.main.Repository.FinancialEnrollmentRepository;
import in.sp.main.Repository.FinancialLiveSessionRepository;
import in.sp.main.Repository.FinancialVideoRepository;
import in.sp.main.Repository.FinancialWorkshopRepository;

@Service
public class FinancialLiteracyCatalogService {

    private static final List<String> ACTIVE = List.of("pending", "approved", "paid");

    @Autowired private FinancialVideoRepository videoRepo;
    @Autowired private FinancialLiveSessionRepository liveRepo;
    @Autowired private FinancialWorkshopRepository workshopRepo;
    @Autowired private FinancialEnrollmentRepository enrollmentRepo;
    @Autowired private FinancialLiteracyCareService careService;

    public boolean isPublicVideo(FinancialVideo v) {
        if (v == null || !v.isPublished()) return false;
        return v.getEducator() == null || FinancialEducatorProfileService.isApproved(v.getEducator());
    }

    public boolean isPublicLive(FinancialLiveSession s) {
        if (s == null || !s.isPublished()) return false;
        return s.getEducator() == null || FinancialEducatorProfileService.isApproved(s.getEducator());
    }

    public boolean isPublicWorkshop(FinancialWorkshop w) {
        if (w == null || !w.isPublished()) return false;
        return w.getEducator() == null || FinancialEducatorProfileService.isApproved(w.getEducator());
    }

    public List<Map<String, Object>> publicVideos() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (FinancialVideo v : videoRepo.findByPublishedTrueOrderByCreatedAtDesc()) {
            if (isPublicVideo(v)) out.add(videoMap(v, false));
        }
        return out;
    }

    public List<Map<String, Object>> publicLiveSessions() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (FinancialLiveSession s : liveRepo.findByPublishedTrueOrderByCreatedAtDesc()) {
            if (isPublicLive(s)) out.add(liveMap(s));
        }
        return out;
    }

    public List<Map<String, Object>> publicWorkshops() {
        List<Map<String, Object>> out = new ArrayList<>();
        for (FinancialWorkshop w : workshopRepo.findByPublishedTrueOrderByCreatedAtDesc()) {
            if (isPublicWorkshop(w)) out.add(workshopMap(w));
        }
        return out;
    }

    public Map<String, Object> videoMap(FinancialVideo v, boolean includeEmbed) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", String.valueOf(v.getId()));
        m.put("numericId", v.getId());
        m.put("title", v.getTitle());
        String cat = v.getCategory();
        if ("Others".equalsIgnoreCase(cat) && v.getCustomCategory() != null && !v.getCustomCategory().isBlank()) {
            cat = v.getCustomCategory().trim();
        }
        m.put("category", cat);
        m.put("rawCategory", v.getCategory());
        m.put("customCategory", v.getCustomCategory());
        m.put("description", v.getDescription());
        m.put("videoUrl", v.getVideoUrl());
        m.put("duration", v.getDuration());
        m.put("level", v.getLevel());
        m.put("host", v.getEducator() == null ? "Fight D Fear" : v.getEducator().getFullName());
        m.put("city", v.getEducator() == null ? null : v.getEducator().getCity());
        m.put("rating", v.getEducator() == null ? 0 : v.getEducator().getRating());
        m.put("fee", 0);
        if (includeEmbed) m.put("embedUrl", youtubeEmbed(v.getVideoUrl()));
        return m;
    }

    public Map<String, Object> liveMap(FinancialLiveSession s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", String.valueOf(s.getId()));
        m.put("numericId", s.getId());
        m.put("title", s.getTitle());
        m.put("speaker", s.getSpeaker());
        m.put("host", s.getSpeaker());
        m.put("date", s.getDate());
        m.put("time", s.getTime());
        String meetingUrlVal = s.getMeetingUrl();
        if (meetingUrlVal != null) {
            meetingUrlVal = meetingUrlVal.trim();
            if (meetingUrlVal.contains("/admin") || meetingUrlVal.equalsIgnoreCase("admin")) {
                meetingUrlVal = "";
            } else if (!meetingUrlVal.isBlank() && !meetingUrlVal.startsWith("http://") && !meetingUrlVal.startsWith("https://")) {
                meetingUrlVal = "https://" + meetingUrlVal;
            }
        }
        m.put("meetingUrl", meetingUrlVal);
        int totalSeats = s.getSeats() == null ? 0 : s.getSeats();
        long takenSeats = enrollmentRepo.countByLiveSession_IdAndStatusIn(s.getId(), ACTIVE);
        int availableSeats = Math.max(0, totalSeats - (int) takenSeats);

        m.put("seats", totalSeats);
        m.put("registeredSeats", (int) takenSeats);
        m.put("seatsLeft", availableSeats);
        m.put("formattedDate", formatDateUserFriendly(s.getDate()));
        m.put("formattedTime", formatTimeUserFriendly(s.getTime()));
        m.put("sessionStatus", computeLiveSessionStatus(s));
        m.put("fee", s.getFee());
        String rawCat = s.getCategory();
        String displayCat = ("Others".equalsIgnoreCase(rawCat) && !blank(s.getCustomCategory())) ? s.getCustomCategory() : rawCat;
        m.put("category", displayCat);
        m.put("rawCategory", rawCat);
        m.put("customCategory", s.getCustomCategory());
        m.put("city", s.getEducator() == null ? null : s.getEducator().getCity());
        m.put("rating", s.getEducator() == null ? 0 : s.getEducator().getRating());
        m.put("cancelPolicy", FinancialLiteracyCareService.CANCEL_POLICY);
        m.put("description", s.getDescription());
        return m;
    }

    public static String formatDateUserFriendly(String dateStr) {
        if (blank(dateStr)) return "";
        try {
            java.time.LocalDate d = java.time.LocalDate.parse(dateStr.trim());
            return d.format(java.time.format.DateTimeFormatter.ofPattern("d MMMM yyyy", java.util.Locale.ENGLISH));
        } catch (Exception e) {
            return dateStr;
        }
    }

    public static String formatTimeUserFriendly(String timeStr) {
        if (blank(timeStr)) return "";
        try {
            if (timeStr.contains("-")) {
                String[] parts = timeStr.split("-");
                String start = formatSingleTime12Hour(parts[0].trim());
                String end = parts.length > 1 ? formatSingleTime12Hour(parts[1].trim()) : "";
                return end.isBlank() ? start : (start + " – " + end);
            }
            return formatSingleTime12Hour(timeStr.trim());
        } catch (Exception e) {
            return timeStr;
        }
    }

    private static String formatSingleTime12Hour(String t) {
        if (blank(t)) return "";
        try {
            java.time.LocalTime lt = java.time.LocalTime.parse(t.length() == 5 ? t : (t + ":00"));
            return lt.format(java.time.format.DateTimeFormatter.ofPattern("h:mm a", java.util.Locale.ENGLISH));
        } catch (Exception e) {
            return t;
        }
    }

    public String computeLiveSessionStatus(FinancialLiveSession s) {
        if (s == null || !s.isPublished()) return "CANCELLED";
        if (blank(s.getDate())) return "UPCOMING";
        try {
            java.time.LocalDate date = java.time.LocalDate.parse(s.getDate().trim());
            String startTimeStr = "00:00";
            String endTimeStr = "23:59";
            if (!blank(s.getTime())) {
                String[] parts = s.getTime().split("-");
                startTimeStr = parts[0].trim();
                if (parts.length > 1 && !parts[1].isBlank()) {
                    endTimeStr = parts[1].trim();
                } else {
                    java.time.LocalTime st = java.time.LocalTime.parse(startTimeStr.length() == 5 ? startTimeStr : (startTimeStr + ":00"));
                    endTimeStr = st.plusHours(1).toString();
                }
            }
            java.time.LocalDateTime start = java.time.LocalDateTime.of(date, java.time.LocalTime.parse(startTimeStr.length() == 5 ? startTimeStr : (startTimeStr + ":00")));
            java.time.LocalDateTime end = java.time.LocalDateTime.of(date, java.time.LocalTime.parse(endTimeStr.length() == 5 ? endTimeStr : (endTimeStr + ":00")));
            java.time.LocalDateTime now = java.time.LocalDateTime.now();

            if (now.isBefore(start.minusMinutes(15))) {
                return "UPCOMING";
            } else if (!now.isBefore(start.minusMinutes(15)) && !now.isAfter(end)) {
                return "LIVE NOW";
            } else {
                return "COMPLETED";
            }
        } catch (Exception e) {
            return "UPCOMING";
        }
    }

    public Map<String, Object> workshopMap(FinancialWorkshop w) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", String.valueOf(w.getId()));
        m.put("numericId", w.getId());
        m.put("title", w.getTitle());
        m.put("venue", w.getVenue());
        m.put("date", w.getDate());
        m.put("time", w.getTime());
        m.put("formattedDate", formatDateUserFriendly(w.getDate()));
        m.put("formattedTime", formatTimeUserFriendly(w.getTime()));
        m.put("city", w.getCity());
        m.put("seats", w.getSeats());
        m.put("seatsLeft", seatsLeftWorkshop(w));
        m.put("fee", w.getFee());
        String rawCat = w.getCategory();
        String displayCat = ("Others".equalsIgnoreCase(rawCat) && !blank(w.getCustomCategory())) ? w.getCustomCategory() : rawCat;
        m.put("category", displayCat);
        m.put("rawCategory", rawCat);
        m.put("customCategory", w.getCustomCategory());
        m.put("rating", w.getEducator() == null ? 0 : w.getEducator().getRating());
        m.put("cancelPolicy", FinancialLiteracyCareService.CANCEL_POLICY);
        m.put("description", w.getDescription());
        m.put("host", w.getEducator() == null ? "Fight D Fear" : w.getEducator().getFullName());
        return m;
    }

    public Map<String, Object> enrollmentMap(FinancialEnrollment e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", String.valueOf(e.getId()));
        m.put("numericId", e.getId());
        m.put("fullName", e.getFullName());
        m.put("mobile", e.getMobile());
        m.put("email", e.getEmail());
        m.put("occupation", e.getOccupation());
        m.put("city", e.getCity());
        m.put("status", e.getStatus());
        m.put("kind", e.getKind());
        if (e.getLiveSession() != null) {
            m.put("sessionId", String.valueOf(e.getLiveSession().getId()));
            m.put("title", e.getLiveSession().getTitle());
        }
        if (e.getWorkshop() != null) {
            m.put("workshopId", String.valueOf(e.getWorkshop().getId()));
            m.put("title", e.getWorkshop().getTitle());
        }
        m.put("createdAt", e.getCreatedAt() == null ? null : e.getCreatedAt().toString());
        double fee = careService.feeOf(e);
        String pay = e.getPaymentStatus() == null ? (fee > 0 ? "PENDING" : "FREE") : e.getPaymentStatus();
        m.put("paymentStatus", pay);
        m.put("amount", e.getAmount());
        m.put("coachNotes", e.getCoachNotes());
        m.put("rating", e.getRating());
        m.put("review", e.getReview());
        m.put("canCancel", careService.canCancel(e));
        m.put("needsPayment", fee > 0 && !"PAID".equalsIgnoreCase(pay)
                && !"cancelled".equalsIgnoreCase(e.getStatus())
                && !"rejected".equalsIgnoreCase(e.getStatus()));
        m.put("canReview", "completed".equalsIgnoreCase(e.getStatus()) && e.getRating() == null);
        m.put("cancelPolicy", FinancialLiteracyCareService.CANCEL_POLICY);
        return m;
    }

    public int seatsLeftLive(FinancialLiveSession s) {
        int cap = s.getSeats() == null ? 0 : s.getSeats();
        long taken = enrollmentRepo.countByLiveSession_IdAndStatusIn(s.getId(), ACTIVE);
        return Math.max(0, cap - (int) taken);
    }

    public int seatsLeftWorkshop(FinancialWorkshop w) {
        int cap = w.getSeats() == null ? 0 : w.getSeats();
        long taken = enrollmentRepo.countByWorkshop_IdAndStatusIn(w.getId(), ACTIVE);
        return Math.max(0, cap - (int) taken);
    }

    @Transactional
    public FinancialVideo addVideo(String title, String category, String customCategory, String description, String videoUrl, FinancialEducator educator) {
        if (blank(title)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Video Title cannot be empty.");
        }
        if (blank(description)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Description cannot be empty.");
        }
        if (blank(category)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Category cannot be empty.");
        }
        if ("Others".equalsIgnoreCase(category.trim()) && blank(customCategory)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Custom category cannot be empty when 'Others' is selected.");
        }
        if (blank(videoUrl)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Video URL / uploaded video cannot be empty.");
        }

        FinancialVideo v = new FinancialVideo();
        v.setTitle(title.trim());
        v.setCategory(category.trim());
        if ("Others".equalsIgnoreCase(category.trim()) && !blank(customCategory)) {
            v.setCustomCategory(customCategory.trim());
        } else {
            v.setCustomCategory(null);
        }
        v.setDescription(description.trim());
        v.setVideoUrl(videoUrl.trim());
        v.setDuration(null);
        v.setLevel(null);
        v.setPublished(true);
        v.setEducator(educator);
        return videoRepo.save(v);
    }

    @Transactional
    public FinancialVideo addVideo(String title, String category, String description, String videoUrl, FinancialEducator educator) {
        return addVideo(title, category, null, description, videoUrl, educator);
    }

    @Transactional
    public FinancialVideo updateVideo(Long id, String title, String category, String customCategory, String description, String videoUrl) {
        if (id == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid video ID");
        }
        FinancialVideo v = videoRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Video not found"));
        
        if (blank(title)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Video Title cannot be empty.");
        }
        if (blank(description)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Description cannot be empty.");
        }
        if (blank(category)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Category cannot be empty.");
        }
        if ("Others".equalsIgnoreCase(category.trim()) && blank(customCategory)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Custom category cannot be empty when 'Others' is selected.");
        }
        if (blank(videoUrl)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Video URL / uploaded video cannot be empty.");
        }

        v.setTitle(title.trim());
        v.setCategory(category.trim());
        if ("Others".equalsIgnoreCase(category.trim()) && !blank(customCategory)) {
            v.setCustomCategory(customCategory.trim());
        } else {
            v.setCustomCategory(null);
        }
        v.setDescription(description.trim());
        v.setVideoUrl(videoUrl.trim());
        v.setDuration(null);
        v.setLevel(null);
        return videoRepo.save(v);
    }

    @Transactional
    public boolean deleteVideo(Long id) {
        if (id != null && videoRepo.existsById(id)) {
            videoRepo.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional
    public FinancialLiveSession addLive(String title, String speaker, String date, String time,
                                        String meetingUrl, Integer seats, String description, FinancialEducator educator) {
        return addLive(title, speaker, date, time, meetingUrl, seats, description, educator, null, "Saving", null);
    }

    public FinancialLiveSession addLive(String title, String speaker, String date, String time,
                                        String meetingUrl, Integer seats, String description, FinancialEducator educator,
                                        Double fee, String category) {
        return addLive(title, speaker, date, time, meetingUrl, seats, description, educator, fee, category, null);
    }

    public FinancialLiveSession addLive(String title, String speaker, String date, String time,
                                        String meetingUrl, Integer seats, String description, FinancialEducator educator,
                                        Double fee, String category, String customCategory) {
        if (blank(title)) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Title is required");
        FinancialLiveSession s = new FinancialLiveSession();
        s.setTitle(title.trim());
        s.setSpeaker(speaker);
        s.setDate(date);
        s.setTime(time);
        String formattedUrl = meetingUrl == null ? "" : meetingUrl.trim();
        if (!formattedUrl.isBlank() && !formattedUrl.startsWith("http://") && !formattedUrl.startsWith("https://")) {
            formattedUrl = "https://" + formattedUrl;
        }
        s.setMeetingUrl(formattedUrl);
        s.setSeats(seats == null ? 20 : seats);
        s.setDescription(description);
        s.setFee(fee == null ? 0d : Math.max(0, fee));
        s.setCategory(blank(category) ? (educator == null ? "Saving" : educator.getExpertise()) : category.trim());
        if ("Others".equalsIgnoreCase(s.getCategory()) && !blank(customCategory)) {
            s.setCustomCategory(customCategory.trim());
        } else {
            s.setCustomCategory(null);
        }
        s.setPublished(true);
        s.setEducator(educator);
        return liveRepo.save(s);
    }

    @Transactional
    public FinancialLiveSession updateLive(Long id, String title, String speaker, String date, String time,
                                           String meetingUrl, Integer seats, String description, String category, String customCategory) {
        if (id == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid live session ID");
        FinancialLiveSession s = liveRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Live session not found"));
        if (blank(title)) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Title is required");
        s.setTitle(title.trim());
        s.setSpeaker(speaker);
        s.setDate(date);
        s.setTime(time);
        String formattedUrl = meetingUrl == null ? "" : meetingUrl.trim();
        if (!formattedUrl.isBlank() && !formattedUrl.startsWith("http://") && !formattedUrl.startsWith("https://")) {
            formattedUrl = "https://" + formattedUrl;
        }
        s.setMeetingUrl(formattedUrl);
        s.setSeats(seats == null ? 20 : seats);
        s.setDescription(description);
        s.setCategory(blank(category) ? "Saving" : category.trim());
        if ("Others".equalsIgnoreCase(s.getCategory()) && !blank(customCategory)) {
            s.setCustomCategory(customCategory.trim());
        } else {
            s.setCustomCategory(null);
        }
        return liveRepo.save(s);
    }

    @Transactional
    public boolean deleteLive(Long id) {
        if (id != null && liveRepo.existsById(id)) {
            liveRepo.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional
    public FinancialWorkshop addWorkshop(String title, String venue, String date, String time,
                                         String city, Integer seats, String description, FinancialEducator educator) {
        return addWorkshop(title, venue, date, time, city, seats, description, educator, null, null, null);
    }

    public FinancialWorkshop addWorkshop(String title, String venue, String date, String time,
                                         String city, Integer seats, String description, FinancialEducator educator,
                                         Double fee, String category) {
        return addWorkshop(title, venue, date, time, city, seats, description, educator, fee, category, null);
    }

    public FinancialWorkshop addWorkshop(String title, String venue, String date, String time,
                                         String city, Integer seats, String description, FinancialEducator educator,
                                         Double fee, String category, String customCategory) {
        if (blank(title)) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Title is required");
        FinancialWorkshop w = new FinancialWorkshop();
        w.setTitle(title.trim());
        w.setVenue(venue);
        w.setDate(date);
        w.setTime(time);
        w.setCity(city);
        w.setSeats(seats == null ? 20 : seats);
        w.setDescription(description);
        w.setFee(fee == null ? 0d : Math.max(0, fee));
        w.setCategory(blank(category) ? (educator == null ? "Saving" : educator.getExpertise()) : category.trim());
        if ("Others".equalsIgnoreCase(w.getCategory()) && !blank(customCategory)) {
            w.setCustomCategory(customCategory.trim());
        } else {
            w.setCustomCategory(null);
        }
        w.setPublished(true);
        w.setEducator(educator);
        return workshopRepo.save(w);
    }

    @Transactional
    public FinancialWorkshop updateWorkshop(Long id, String title, String venue, String date, String time,
                                            String city, Integer seats, String description, String category, String customCategory) {
        if (id == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid workshop ID");
        FinancialWorkshop w = workshopRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Workshop not found"));
        if (blank(title)) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Title is required");
        w.setTitle(title.trim());
        w.setVenue(venue);
        w.setDate(date);
        w.setTime(time);
        w.setCity(city);
        w.setSeats(seats == null ? 20 : seats);
        w.setDescription(description);
        w.setCategory(blank(category) ? "Saving" : category.trim());
        if ("Others".equalsIgnoreCase(w.getCategory()) && !blank(customCategory)) {
            w.setCustomCategory(customCategory.trim());
        } else {
            w.setCustomCategory(null);
        }
        return workshopRepo.save(w);
    }

    @Transactional
    public boolean deleteWorkshop(Long id) {
        if (id != null && workshopRepo.existsById(id)) {
            workshopRepo.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional
    public FinancialEnrollment registerLive(String sessionId, User user, String fullName, String mobile,
                                            String email, String occupation) {
        FinancialLiveSession s = liveRepo.findById(parseId(sessionId)).orElse(null);
        if (!isPublicLive(s)) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Live session not found");
        if (seatsLeftLive(s) <= 0) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No seats left");
        if (user != null && enrollmentRepo.existsByUser_IdAndLiveSession_IdAndStatusIn(user.getId(), s.getId(), ACTIVE)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You already registered for this session");
        }
        FinancialEnrollment e = new FinancialEnrollment();
        e.setKind("LIVE");
        e.setLiveSession(s);
        e.setUser(user);
        e.setFullName(nz(fullName, user == null ? null : user.getFullName()));
        e.setMobile(nz(mobile, user == null ? null : user.getPhoneNumber()));
        e.setEmail(nz(email, user == null ? null : user.getEmail()));
        e.setOccupation(occupation);
        e.setStatus("pending");
        double fee = careService.feeOf(s);
        e.setAmount(fee);
        e.setPaymentStatus(fee > 0 ? "PENDING" : "FREE");
        FinancialEnrollment saved = enrollmentRepo.save(e);
        careService.notifyRegistered(saved);
        return saved;
    }

    @Transactional
    public FinancialEnrollment registerWorkshop(String workshopId, User user, String fullName, String mobile,
                                                String email, String city, String occupation) {
        FinancialWorkshop w = workshopRepo.findById(parseId(workshopId)).orElse(null);
        if (!isPublicWorkshop(w)) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Workshop not found");
        if (seatsLeftWorkshop(w) <= 0) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No seats left");
        if (user != null && enrollmentRepo.existsByUser_IdAndWorkshop_IdAndStatusIn(user.getId(), w.getId(), ACTIVE)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You already registered for this workshop");
        }
        FinancialEnrollment e = new FinancialEnrollment();
        e.setKind("WORKSHOP");
        e.setWorkshop(w);
        e.setUser(user);
        e.setFullName(nz(fullName, user == null ? null : user.getFullName()));
        e.setMobile(nz(mobile, user == null ? null : user.getPhoneNumber()));
        e.setEmail(nz(email, user == null ? null : user.getEmail()));
        e.setCity(city);
        e.setOccupation(occupation);
        e.setStatus("pending");
        double fee = careService.feeOf(w);
        e.setAmount(fee);
        e.setPaymentStatus(fee > 0 ? "PENDING" : "FREE");
        FinancialEnrollment saved = enrollmentRepo.save(e);
        careService.notifyRegistered(saved);
        return saved;
    }

    @Transactional
    public FinancialEnrollment setEnrollmentStatus(Long id, String status) {
        FinancialEnrollment e = enrollmentRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Registration not found"));
        e.setStatus(status);
        return enrollmentRepo.save(e);
    }

    @Transactional
    public FinancialEnrollment cancel(Long id, User user) {
        FinancialEnrollment e = enrollmentRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Registration not found"));
        if (user != null && (e.getUser() == null || !e.getUser().getId().equals(user.getId()))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your registration");
        }
        return careService.cancel(e);
    }

    public FinancialEnrollment findEnrollment(String registrationId) {
        return enrollmentRepo.findById(parseId(registrationId)).orElse(null);
    }

    public FinancialVideo findVideo(String id) {
        return videoRepo.findById(parseId(id)).orElse(null);
    }

    public FinancialLiveSession findLive(String id) {
        return liveRepo.findById(parseId(id)).orElse(null);
    }

    public FinancialWorkshop findWorkshop(String id) {
        return workshopRepo.findById(parseId(id)).orElse(null);
    }

    public List<Map<String, Object>> liveRegistrations() {
        return enrollmentRepo.findByKindOrderByCreatedAtDesc("LIVE").stream().map(this::enrollmentMap).toList();
    }

    public List<Map<String, Object>> workshopRegistrations() {
        return enrollmentRepo.findByKindOrderByCreatedAtDesc("WORKSHOP").stream().map(this::enrollmentMap).toList();
    }

    public static String youtubeEmbed(String url) {
        if (url == null || url.isBlank()) return "";
        String videoId = null;
        if (url.contains("v=")) {
            int start = url.indexOf("v=") + 2;
            int end = url.indexOf("&", start);
            videoId = end == -1 ? url.substring(start) : url.substring(start, end);
        } else if (url.contains("youtu.be/")) {
            int start = url.indexOf("youtu.be/") + 9;
            int end = url.indexOf("?", start);
            videoId = end == -1 ? url.substring(start) : url.substring(start, end);
        } else if (url.contains("/embed/")) {
            return url;
        }
        if (videoId != null && !videoId.isBlank()) {
            return "https://www.youtube.com/embed/" + videoId;
        }
        return url;
    }

    private static boolean blank(String s) { return s == null || s.isBlank(); }

    private static String nz(String preferred, String fallback) {
        if (preferred != null && !preferred.isBlank()) return preferred.trim();
        return fallback;
    }

    private static Long parseId(String id) {
        try {
            return Long.parseLong(id == null ? "" : id.trim());
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid id");
        }
    }
}
