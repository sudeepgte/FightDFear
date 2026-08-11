package in.sp.main.Controller;

import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.BroadcastMessageRepository;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.Service.TrustedContactService;
import in.sp.main.Service.UserFollowService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
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

    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private Map<String, Object> userDto(User user) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("userId", user.getId());
        dto.put("email", user.getEmail());
        dto.put("name", user.getFullName());
        dto.put("phone", user.getPhoneNumber());
        dto.put("homeAddress", user.getHomeAddress());
        dto.put("profilePhoto", user.getProfilePhoto());
        dto.put("status", user.getVerificationStatus() == null ? null : user.getVerificationStatus().name());
        return dto;
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
        }
        User saved = userRepository.save(user);
        session.setAttribute("user", saved);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.putAll(userDto(saved));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me/dashboard")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }

        List<BroadcastMessage> broadcasts = broadcastMessageRepository.findAllByOrderBySentAtDesc();
        long unreadCount = 0;
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
        boolean isWorker = jobApplicationRepository.findByStatus(VerificationStatus.VERIFIED)
                .stream()
                .anyMatch(app -> app.getUser() != null && app.getUser().getId().equals(user.getId()));

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
