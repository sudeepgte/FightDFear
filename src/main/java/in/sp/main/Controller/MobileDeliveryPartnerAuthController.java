package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Repository.DeliveryPartnerRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Service.DeliveryPartnerProfileService;
import in.sp.main.Service.DeliveryPartnerRegistrationService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.ProductDeliveryTrackingService;
import in.sp.main.Service.WomenProductOrderLifecycleService;
import in.sp.main.Service.WomenProductsCareService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/delivery")
public class MobileDeliveryPartnerAuthController {

    private static final Set<String> VEHICLES = Set.of("Bike", "Scooter", "Van", "Cycle");

    @Autowired
    private DeliveryPartnerRepository deliveryRepo;
    @Autowired
    private WomenProductOrderRepository orderRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private DeliveryPartnerRegistrationService registrationService;
    @Autowired
    private DeliveryPartnerProfileService profileService;
    @Autowired
    private ProductDeliveryTrackingService trackingService;
    @Autowired
    private WomenProductsCareService productsCareService;
    @Autowired
    private WomenProductOrderLifecycleService orderLifecycle;
    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            registrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            return ResponseEntity.ok(ok(Map.of("message", "OTP sent to your email")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            registrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            return ResponseEntity.ok(ok(Map.of("message", "Email verified")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            DeliveryPartner p = registrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("deliveryId", p.getId());
            res.put("partnerProfileStatus", p.getPartnerProfileStatus() == null
                    ? null : p.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", p.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<DeliveryPartner> opt = deliveryRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Delivery partner not found"));
        }
        DeliveryPartner p = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            deliveryRepo.save(p);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (p.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED || p.isSuspended()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your delivery account has been suspended"));
        }
        profileService.refreshCompletion(p);

        session.setAttribute("loggedDelivery", p);
        String token = jwtUtil.generateToken(p.getEmail(), "DELIVERY");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "DELIVERY");
        res.put("partner", summary(p));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(p.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                profileService.isReadyForVerification(p)
                        && p.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        p = deliveryRepo.findById(p.getId()).orElse(p);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(profileService.profilePayload(p));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        p = deliveryRepo.findById(p.getId()).orElse(p);
        if (body != null) {
            if (body.get("fullName") != null) p.setFullName(String.valueOf(body.get("fullName")).trim());
            if (body.get("phone") != null) {
                String phone = String.valueOf(body.get("phone")).trim();
                String err = MobileValidation.requirePhone(phone, true);
                if (err != null) return badRequest(err);
                p.setPhone(phone);
            }
            if (body.get("city") != null) p.setCity(blankToNull(String.valueOf(body.get("city"))));
            if (body.get("serviceArea") != null) p.setServiceArea(blankToNull(String.valueOf(body.get("serviceArea"))));
            if (body.get("licenseNumber") != null) p.setLicenseNumber(blankToNull(String.valueOf(body.get("licenseNumber"))));
            if (body.get("bio") != null) p.setBio(blankToNull(String.valueOf(body.get("bio"))));
            if (body.get("vehicleType") != null) {
                String v = String.valueOf(body.get("vehicleType")).trim();
                String matched = VEHICLES.stream().filter(x -> x.equalsIgnoreCase(v)).findFirst().orElse(null);
                if (matched == null) return badRequest("Vehicle must be Bike, Scooter, Van, or Cycle");
                p.setVehicleType(matched);
            }
            profileService.applyExtraFields(p, body);
        }
        profileService.refreshCompletion(p);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(profileService.profilePayload(p));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        try {
            DeliveryPartner partner = deliveryRepo.findById(p.getId()).orElse(p);
            registrationService.submitForVerification(partner);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(profileService.profilePayload(partner));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        p = deliveryRepo.findById(p.getId()).orElse(p);
        List<Map<String, Object>> available = orderRepo
                .findByStatusAndDeliveryPartnerIsNullOrderByOrderTimeDesc("READY_FOR_PICKUP")
                .stream().map(this::orderDto).toList();
        List<WomenProductOrder> mine = orderRepo.findByDeliveryPartnerOrderByOrderTimeDesc(p);
        List<Map<String, Object>> assigned = mine.stream()
                .filter(o -> !"DELIVERED".equalsIgnoreCase(normStatus(o.getStatus()))
                        && !"CANCELLED".equalsIgnoreCase(normStatus(o.getStatus())))
                .map(this::orderDto)
                .toList();
        List<Map<String, Object>> completed = mine.stream()
                .filter(o -> "DELIVERED".equalsIgnoreCase(normStatus(o.getStatus())))
                .map(this::orderDto)
                .toList();
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("partner", summary(p));
        data.put("available", available);
        data.put("assigned", assigned);
        data.put("completed", completed);
        data.put("approved", p.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        double totalEarnings = mine.stream()
                .filter(o -> "DELIVERED".equalsIgnoreCase(normStatus(o.getStatus())))
                .mapToDouble(o -> {
                    double t = o.getTotalPrice() == null ? 0 : o.getTotalPrice();
                    return Math.max(30.0, t * 0.10);
                })
                .sum();
        data.put("totalEarnings", totalEarnings);
        data.put("payoutBalance", p.getPayoutBalance());
        data.put("upiId", p.getUpiId() == null ? "" : p.getUpiId());
        data.put("cancelPolicy", WomenProductsCareService.CANCEL_POLICY);
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        try {
            return ResponseEntity.ok(productsCareService.requestDeliveryPayout(deliveryRepo.findById(p.getId()).orElse(p)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/photos")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        p = deliveryRepo.findById(p.getId()).orElse(p);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                p.setProfilePhotoPath(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (p.getGalleryPhotos() != null && !p.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(p.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                p.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(x -> !x.isEmpty()).toList()));
            }
            deliveryRepo.save(p);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", p.getProfilePhotoPath());
            res.put("galleryPhotos", p.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(error("Upload failed: " + ex.getMessage()));
        }
    }

    @PostMapping("/orders/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getDeliveryPartner() == null || !o.getDeliveryPartner().getId().equals(p.getId())) {
            return badRequest("Order not found");
        }
        o.setDeliveryNotes(body == null ? "" : body.getOrDefault("coachNotes", body.getOrDefault("deliveryNotes", "")));
        orderRepo.save(o);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved", "deliveryNotes", o.getDeliveryNotes())));
    }

    @PostMapping("/orders/{id}/accept")
    @Transactional
    public ResponseEntity<Map<String, Object>> accept(@PathVariable Long id, HttpSession session) {
        DeliveryPartner p = requireApproved(session);
        if (p == null) return unauthorized();
        if (p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your profile must be approved before you can accept deliveries."));
        }
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            WomenProductOrder updated = orderLifecycle.acceptByPartner(o, deliveryRepo.findById(p.getId()).orElse(p));
            return ResponseEntity.ok(ok(Map.of("message", "Order accepted", "order", orderDto(updated))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/orders/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        DeliveryPartner p = requireApproved(session);
        if (p == null) return unauthorized();
        if (p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your profile must be approved before you can update deliveries."));
        }
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            WomenProductOrder updated = orderLifecycle.applyDeliveryStatus(
                    o, deliveryRepo.findById(p.getId()).orElse(p), trim(body == null ? null : body.get("status")));
            return ResponseEntity.ok(ok(Map.of("message", "Status updated", "order", orderDto(updated))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/orders/{id}/track")
    public ResponseEntity<Map<String, Object>> track(@PathVariable Long id, HttpSession session) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getDeliveryPartner() == null || !o.getDeliveryPartner().getId().equals(p.getId())) {
            return badRequest("Order not found");
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.putAll(trackingService.trackPayload(o));
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/orders/{id}/location")
    @Transactional
    public ResponseEntity<Map<String, Object>> pingLocation(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        DeliveryPartner p = requireApproved(session);
        if (p == null) return unauthorized();
        if (p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your profile must be approved before you can share live location."));
        }
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getDeliveryPartner() == null || !o.getDeliveryPartner().getId().equals(p.getId())) {
            return badRequest("Order not found");
        }
        if (!ProductDeliveryTrackingService.isLive(o.getStatus())) {
            return badRequest("Live location is only shared while the order is assigned or out for delivery.");
        }
        Double lat = asDouble(body == null ? null : body.get("lat"));
        Double lng = asDouble(body == null ? null : body.get("lng"));
        if (lat == null || lng == null) return badRequest("lat and lng are required");
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return badRequest("Invalid coordinates");
        trackingService.updateCourierLocation(o, lat, lng);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Location updated");
        data.putAll(trackingService.trackPayload(o));
        return ResponseEntity.ok(ok(data));
    }

    private DeliveryPartner requirePartner(HttpSession session) {
        Object s = session == null ? null : session.getAttribute("loggedDelivery");
        return s instanceof DeliveryPartner ? (DeliveryPartner) s : null;
    }

    private DeliveryPartner requireApproved(HttpSession session) {
        return requirePartner(session);
    }

    private Map<String, Object> summary(DeliveryPartner p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("email", p.getEmail());
        m.put("phone", p.getPhone());
        m.put("city", p.getCity());
        m.put("vehicleType", p.getVehicleType());
        m.put("serviceArea", p.getServiceArea());
        m.put("rating", p.getRating());
        m.put("partnerProfileStatus", p.getPartnerProfileStatus() == null
                ? null : p.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(p.getPartnerProfileStatus()));
        m.put("profileCompletionPct", p.getProfileCompletionPct() == null ? 0 : p.getProfileCompletionPct());
        m.put("missingItems", profileService.missingItems(p));
        DeliveryPartnerProfileService.putExtra(m, p);
        return m;
    }

    private Map<String, Object> orderDto(WomenProductOrder o) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", o.getId());
        m.put("quantity", o.getQuantity());
        m.put("totalPrice", o.getTotalPrice());
        m.put("status", WomenProductOrderLifecycleService.canonical(o.getStatus()));
        m.put("statusLabel", WomenProductOrderLifecycleService.displayLabel(o.getStatus()));
        m.put("nextStatuses", WomenProductOrderLifecycleService.deliveryNextStatuses(o.getStatus()));
        m.put("shippingAddress", o.getShippingAddress());
        m.put("orderTime", o.getOrderTime() == null ? null : o.getOrderTime().toString());
        m.put("assignedAt", o.getAssignedAt() == null ? null : o.getAssignedAt().toString());
        m.put("pickedUpAt", o.getPickedUpAt() == null ? null : o.getPickedUpAt().toString());
        m.put("deliveredAt", o.getDeliveredAt() == null ? null : o.getDeliveredAt().toString());
        m.put("trackingNote", o.getTrackingNote());
        m.put("deliveryNotes", o.getDeliveryNotes());
        m.put("canLiveTrack", ProductDeliveryTrackingService.isLive(o.getStatus()));
        m.put("etaMinutes", o.getEtaMinutes());
        m.put("remainingKm", o.getRemainingKm());
        if (o.getProduct() != null) {
            m.put("productId", o.getProduct().getId());
            m.put("productName", o.getProduct().getName());
        }
        if (o.getSeller() != null) {
            m.put("sellerName", o.getSeller().getBusinessName());
            m.put("pickupAddress", o.getSeller().getAddress());
            m.put("sellerPhone", o.getSeller().getPhone());
        }
        if (o.getUser() != null) {
            m.put("buyerName", o.getUser().getFullName());
            m.put("buyerPhone", o.getUser().getPhoneNumber());
        }
        return m;
    }

    private static String normStatus(String status) {
        return WomenProductOrderLifecycleService.canonical(status);
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Delivery login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
    }

    private static Double asDouble(Object v) {
        if (v == null) return null;
        if (v instanceof Number n) return n.doubleValue();
        try { return Double.parseDouble(v.toString().trim()); } catch (Exception e) { return null; }
    }

    private static String blankToNull(String v) {
        if (v == null) return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }
}
