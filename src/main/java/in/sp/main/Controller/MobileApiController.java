package in.sp.main.Controller;

import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.BroadcastMessageRepository;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.Service.TrustedContactService;
import in.sp.main.Service.UserFollowService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * JSON profile + trusted contacts for the Android / Flutter safety MVP.
 * Auth: JWT cookie or Authorization: Bearer (hydrates session via JwtAuthenticationFilter).
 */
@RestController
@RequestMapping("/api")
public class MobileApiController {

    @Autowired
    private TrustedContactService trustedContactService;

    @Autowired
    private BroadcastMessageRepository broadcastMessageRepository;

    @Autowired
    private UserFollowService userFollowService;

    @Autowired
    private MartialArtsCenterService martialArtsCenterService;

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    @Autowired
    private in.sp.main.Repository.UserRepository userRepository;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private Map<String, Object> userDto(User user) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("userId", user.getId());
        dto.put("email", user.getEmail());
        dto.put("name", user.getFullName());
        dto.put("fullName", user.getFullName());
        dto.put("phone", user.getPhoneNumber());
        dto.put("phoneNumber", user.getPhoneNumber());
        dto.put("homeAddress", user.getHomeAddress());
        dto.put("city", user.getCity());
        dto.put("dob", user.getDob());
        dto.put("age", user.getAge());
        dto.put("gender", user.getGender() == null ? null : user.getGender().name());
        dto.put("whatsappNumber", user.getWhatsappNumber());
        dto.put("profilePhoto", user.getProfilePhoto());
        dto.put("rewardPoints", user.getRewardPoints() != null ? user.getRewardPoints() : 0);
        dto.put("walletBalance", user.getWalletBalance() != null ? user.getWalletBalance() : 0.0);
        dto.put("status", user.getVerificationStatus() == null ? null : user.getVerificationStatus().name());

        int completionPct = calculateCompletionPercentage(user);
        dto.put("completionPercentage", completionPct);
        dto.put("profileCompletionPct", completionPct);
        dto.put("missingItems", missingProfileItems(user));
        return dto;
    }

    private int calculateCompletionPercentage(User user) {
        if (user == null) return 0;
        int score = 0;
        if (user.getFullName() != null && !user.getFullName().isBlank()) score += 10;
        if (user.getEmail() != null && !user.getEmail().isBlank()) score += 10;
        if (user.getPhoneNumber() != null && !user.getPhoneNumber().isBlank()) score += 10;
        boolean hasLocation = (user.getHomeAddress() != null && !user.getHomeAddress().isBlank())
                || (user.getCity() != null && !user.getCity().isBlank());
        if (hasLocation) score += 10;
        if (user.getGender() != null) score += 10;

        boolean hasEmergencyContact = false;
        try {
            if (user.getEmergencyContacts() != null && !user.getEmergencyContacts().isEmpty()) {
                hasEmergencyContact = true;
            }
        } catch (Exception ignored) {}
        if (!hasEmergencyContact && user.getId() != null) {
            try {
                List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(user.getId());
                if (contacts != null && !contacts.isEmpty()) {
                    hasEmergencyContact = true;
                }
            } catch (Exception ignored) {}
        }
        if (hasEmergencyContact) score += 15;
        if (user.getWhatsappNumber() != null && !user.getWhatsappNumber().isBlank()) score += 15;
        if ((user.getDob() != null && !user.getDob().isBlank()) || user.getAge() != null) score += 5;
        boolean hasPhoto = user.getProfilePhoto() != null && !user.getProfilePhoto().isBlank();
        if (hasPhoto) score += 15;
        if (!hasPhoto && score >= 100) score = 85;
        return Math.min(100, Math.max(0, score));
    }

    private List<String> missingProfileItems(User user) {
        List<String> missing = new ArrayList<>();
        if (user == null) return missing;
        if (user.getFullName() == null || user.getFullName().isBlank()) missing.add("Full name");
        if (user.getEmail() == null || user.getEmail().isBlank()) missing.add("Email");
        if (user.getPhoneNumber() == null || user.getPhoneNumber().isBlank()) missing.add("Phone number");
        if ((user.getHomeAddress() == null || user.getHomeAddress().isBlank())
                && (user.getCity() == null || user.getCity().isBlank())) {
            missing.add("Location / city");
        }
        if (user.getGender() == null) missing.add("Gender");
        boolean hasEmergencyContact = false;
        try {
            if (user.getEmergencyContacts() != null && !user.getEmergencyContacts().isEmpty()) {
                hasEmergencyContact = true;
            }
        } catch (Exception ignored) {}
        if (!hasEmergencyContact && user.getId() != null) {
            try {
                List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(user.getId());
                if (contacts != null && !contacts.isEmpty()) hasEmergencyContact = true;
            } catch (Exception ignored) {}
        }
        if (!hasEmergencyContact) missing.add("Emergency contact");
        if (user.getWhatsappNumber() == null || user.getWhatsappNumber().isBlank()) {
            missing.add("Emergency WhatsApp number");
        }
        if ((user.getDob() == null || user.getDob().isBlank()) && user.getAge() == null) {
            missing.add("Date of birth");
        }
        if (user.getProfilePhoto() == null || user.getProfilePhoto().isBlank()) {
            missing.add("Profile photo");
        }
        return missing;
    }

    private Map<String, Object> contactDto(TrustedContact c) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", c.getId());
        dto.put("name", c.getName());
        dto.put("phone", c.getPhone());
        dto.put("email", c.getEmail());
        dto.put("whatsappNumber", c.getWhatsappNumber() != null && !c.getWhatsappNumber().isBlank()
                ? c.getWhatsappNumber() : c.getPhone());
        dto.put("relation", c.getRelation());
        dto.put("isPrimary", c.isPrimary());
        dto.put("canReceiveSMS", c.isCanReceiveSMS());
        dto.put("canReceiveEmail", c.isCanReceiveEmail());
        dto.put("canReceiveCall", c.isCanReceiveCall());
        dto.put("canReceiveWhatsApp", c.isCanReceiveWhatsApp());
        return dto;
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.putAll(userDto(user));
        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<Map<String, Object>> updateMe(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        if (body != null) {
            if (body.containsKey("fullName")) user.setFullName(stringVal(body.get("fullName")));
            if (body.containsKey("phoneNumber")) user.setPhoneNumber(stringVal(body.get("phoneNumber")));
            if (body.containsKey("homeAddress")) user.setHomeAddress(stringVal(body.get("homeAddress")));
            if (body.containsKey("city")) user.setCity(stringVal(body.get("city")));
            if (body.containsKey("dob")) user.setDob(stringVal(body.get("dob")));
            if (body.containsKey("whatsappNumber")) user.setWhatsappNumber(stringVal(body.get("whatsappNumber")));
            if (body.containsKey("gender")) {
                String g = stringVal(body.get("gender"));
                if (!g.isBlank()) {
                    try {
                        user.setGender(Gender.valueOf(g.toUpperCase(Locale.ROOT)));
                    } catch (Exception ignored) {}
                }
            }
            if (body.containsKey("age")) {
                try {
                    user.setAge(Integer.parseInt(body.get("age").toString()));
                } catch (Exception ignored) {}
            }
        }
        User saved = userRepository.save(user);
        session.setAttribute("user", saved);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.putAll(userDto(saved));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/me/photo")
    public ResponseEntity<Map<String, Object>> uploadPhoto(
            @RequestParam("file") MultipartFile file,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Please select a valid image file."));
        }
        try {
            String url = fileUploadService.saveFile(file);
            user.setProfilePhoto(url);
            User saved = userRepository.save(user);
            session.setAttribute("user", saved);
            Map<String, Object> response = new LinkedHashMap<>();
            response.put("success", true);
            response.put("message", "Profile photo updated successfully");
            response.putAll(userDto(saved));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Upload failed: " + e.getMessage()));
        }
    }

    @GetMapping("/me/dashboard")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        User sessionUser = requireUser(session);
        if (sessionUser == null || sessionUser.getId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }

        try {
            User user = userRepository.findById(sessionUser.getId()).orElse(sessionUser);

            List<BroadcastMessage> broadcasts = broadcastMessageRepository.findAllByOrderBySentAtDesc();
            long unreadCount;
            if (user.getLastReadBroadcastTime() == null) {
                unreadCount = broadcasts.size();
            } else {
                unreadCount = broadcasts.stream()
                        .filter(b -> b.getSentAt() != null
                                && b.getSentAt().isAfter(user.getLastReadBroadcastTime()))
                        .count();
            }

            int pendingRequestCount = userFollowService.getPendingRequestCount(user.getId());
            int approvedCentreCount = martialArtsCenterService.getApprovedCentersForDiscovery().size();
            boolean isWorker = jobApplicationRepository.existsByUser_IdAndStatusIn(
                    user.getId(), List.of(VerificationStatus.VERIFIED));

            List<Map<String, Object>> recentBroadcasts = new ArrayList<>();
            broadcasts.stream().limit(5).forEach(b -> {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id", b.getId());
                item.put("title", b.getTitle());
                item.put("message", b.getMessage());
                item.put("type", b.getType());
                item.put("sentAt", b.getSentAt() == null ? null : b.getSentAt().toString());
                recentBroadcasts.add(item);
            });

            Map<String, Object> response = new LinkedHashMap<>();
            response.put("success", true);
            response.put("name", user.getFullName());
            response.put("unreadBroadcastCount", unreadCount);
            response.put("approvedCentreCount", approvedCentreCount);
            response.put("pendingRequestCount", pendingRequestCount);
            response.put("isWorker", isWorker);
            response.put("recentBroadcasts", recentBroadcasts);
            return ResponseEntity.ok(response);
        } catch (Exception ex) {
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("success", false);
            err.put("error", "Dashboard load failed: " + ex.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
        }
    }

    @GetMapping("/me/trusted-contacts")
    public ResponseEntity<Map<String, Object>> listContacts(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        List<TrustedContact> contacts = trustedContactService.getTrustedContactsByUserId(user.getId());
        List<Map<String, Object>> items = new ArrayList<>();
        for (TrustedContact c : contacts) {
            items.add(contactDto(c));
        }
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("contacts", items);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/me/trusted-contacts")
    public ResponseEntity<Map<String, Object>> addContact(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        String name = body == null ? null : stringVal(body.get("name"));
        String phone = body == null ? null : stringVal(body.get("phone"));
        if (name == null || name.isBlank()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "name is required"));
        }
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", phoneErr));
        }

        TrustedContact contact = new TrustedContact();
        contact.setName(name.trim());
        contact.setPhone(MobileValidation.trim(phone));
        String email = stringVal(body.get("email"));
        if (email != null && !email.isBlank() && !MobileValidation.isEmail(email)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "Enter a valid email address"));
        }
        contact.setEmail(email == null || email.isBlank() ? null : MobileValidation.trim(email));
        String wa = stringVal(body.get("whatsappNumber"));
        if (wa == null || wa.isBlank()) {
            wa = phone;
        }
        String waErr = MobileValidation.requirePhone(wa, true);
        if (waErr != null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "WhatsApp " + waErr.toLowerCase()));
        }
        contact.setWhatsappNumber(MobileValidation.trim(wa));
        contact.setRelation(stringVal(body.getOrDefault("relation", "")));
        contact.setPrimary(boolVal(body.get("isPrimary"), false));
        contact.setCanReceiveSMS(boolVal(body.get("canReceiveSMS"), true));
        contact.setCanReceiveEmail(boolVal(body.get("canReceiveEmail"), email != null && !email.isBlank()));
        contact.setCanReceiveCall(boolVal(body.get("canReceiveCall"), true));
        contact.setCanReceiveWhatsApp(boolVal(body.get("canReceiveWhatsApp"), true));

        TrustedContact saved = trustedContactService.createTrustedContact(user.getId(), contact);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("contact", contactDto(saved));
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/me/trusted-contacts/{contactId}")
    public ResponseEntity<Map<String, Object>> updateContact(
            @PathVariable Long contactId,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        TrustedContact existing = trustedContactService.getTrustedContactById(contactId);
        if (existing == null || existing.getUser() == null
                || !existing.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "error", "Access denied"));
        }

        if (body != null) {
            if (body.containsKey("name")) {
                String n = stringVal(body.get("name"));
                if (n == null || n.isBlank()) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("success", false, "error", "name is required"));
                }
                existing.setName(n.trim());
            }
            if (body.containsKey("phone")) {
                String phoneErr = MobileValidation.requirePhone(stringVal(body.get("phone")), true);
                if (phoneErr != null) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("success", false, "error", phoneErr));
                }
                existing.setPhone(MobileValidation.trim(stringVal(body.get("phone"))));
            }
            if (body.containsKey("email")) {
                String email = stringVal(body.get("email"));
                if (email != null && !email.isBlank() && !MobileValidation.isEmail(email)) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("success", false, "error", "Enter a valid email address"));
                }
                existing.setEmail(email == null || email.isBlank() ? null : MobileValidation.trim(email));
            }
            if (body.containsKey("whatsappNumber")) {
                String wa = stringVal(body.get("whatsappNumber"));
                if (wa == null || wa.isBlank()) {
                    wa = existing.getPhone();
                }
                String waErr = MobileValidation.requirePhone(wa, true);
                if (waErr != null) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("success", false, "error", "WhatsApp " + waErr.toLowerCase()));
                }
                existing.setWhatsappNumber(MobileValidation.trim(wa));
            }
            if (body.containsKey("relation")) existing.setRelation(stringVal(body.get("relation")));
            if (body.containsKey("isPrimary")) existing.setPrimary(boolVal(body.get("isPrimary"), existing.isPrimary()));
            if (body.containsKey("canReceiveSMS")) existing.setCanReceiveSMS(boolVal(body.get("canReceiveSMS"), existing.isCanReceiveSMS()));
            if (body.containsKey("canReceiveEmail")) existing.setCanReceiveEmail(boolVal(body.get("canReceiveEmail"), existing.isCanReceiveEmail()));
            if (body.containsKey("canReceiveCall")) existing.setCanReceiveCall(boolVal(body.get("canReceiveCall"), existing.isCanReceiveCall()));
            if (body.containsKey("canReceiveWhatsApp")) existing.setCanReceiveWhatsApp(boolVal(body.get("canReceiveWhatsApp"), existing.isCanReceiveWhatsApp()));
        }

        TrustedContact updated = trustedContactService.updateTrustedContact(contactId, existing);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("contact", contactDto(updated != null ? updated : existing));
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/me/trusted-contacts/{contactId}")
    public ResponseEntity<Map<String, Object>> deleteContact(
            @PathVariable Long contactId,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        TrustedContact existing = trustedContactService.getTrustedContactById(contactId);
        if (existing == null || existing.getUser() == null
                || !existing.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "error", "Access denied"));
        }
        trustedContactService.deleteTrustedContact(contactId);
        return ResponseEntity.ok(Map.of("success", true, "message", "Contact deleted"));
    }

    private static String stringVal(Object o) {
        return o == null ? null : String.valueOf(o);
    }

    private static boolean boolVal(Object o, boolean defaultValue) {
        if (o == null) return defaultValue;
        if (o instanceof Boolean b) return b;
        return Boolean.parseBoolean(String.valueOf(o));
    }
}
