package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.GlowCareService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.SalonProfileService;
import in.sp.main.Repository.Booking1Repository;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceRepository;
import in.sp.main.Repository.StylistRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.*;

/**
 * Salon owner APIs for Flutter Glow Space dashboard.
 */
@RestController
@RequestMapping("/api/glow/salon")
public class MobileGlowSalonController {

    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private Booking1Repository bookingRepo;
    @Autowired
    private ServiceRepository serviceRepo;
    @Autowired
    private StylistRepository stylistRepo;
    @Autowired
    private GlowCareService glowCareService;
    @Autowired
    private SalonProfileService salonProfileService;
    @Autowired
    private FileUploadService fileUploadService;

    @GetMapping("/me")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        Salon fresh = salonRepository.findById(salon.getId()).orElse(salon);

        List<Booking1> bookings = bookingRepo.findBySalon(fresh);
        List<Service1> services = serviceRepo.findBySalonId(fresh.getId());
        List<Stylist> stylists = stylistRepo.findBySalonId(fresh.getId());

        long pending = bookings.stream().filter(b -> "PENDING".equalsIgnoreCase(b.getStatus())).count();
        long confirmed = bookings.stream().filter(b -> "CONFIRMED".equalsIgnoreCase(b.getStatus())
                || "PAID".equalsIgnoreCase(b.getStatus())).count();
        double earnings = bookings.stream()
                .filter(b -> "CONFIRMED".equalsIgnoreCase(b.getStatus()) || "PAID".equalsIgnoreCase(b.getStatus())
                        || "COMPLETED".equalsIgnoreCase(b.getStatus()))
                .mapToDouble(Booking1::getPrice)
                .sum();

        Map<String, Object> meta = new LinkedHashMap<>();
        meta.put("bookingCount", bookings.size());
        meta.put("pendingCount", pending);
        meta.put("confirmedCount", confirmed);
        meta.put("serviceCount", services.size());
        meta.put("stylistCount", stylists.size());
        meta.put("earnings", earnings);
        meta.put("payoutBalance", fresh.getPayoutBalance());
        meta.put("upiId", fresh.getUpiId());
        meta.put("bankDetails", fresh.getBankDetails());
        meta.put("payoutRequestedAt", fresh.getPayoutRequestedAt() == null
                ? null : fresh.getPayoutRequestedAt().toString());
        meta.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        meta.put("todaySlots", glowCareService.slotsFor(fresh, LocalDate.now(), 30));
        meta.put("nextSlot", glowCareService.nextSlot(fresh));
        meta.put("partnerProfileStatus", fresh.getPartnerProfileStatus() == null
                ? null : fresh.getPartnerProfileStatus().name());
        meta.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(fresh.getPartnerProfileStatus()));
        meta.put("profileCompletionPct", fresh.getProfileCompletionPct() == null ? 0 : fresh.getProfileCompletionPct());
        meta.put("canManageServices", true);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("salon", salonDto(fresh));
        body.put("meta", meta);
        body.put("bookings", bookings.stream()
                .sorted((a, b) -> Long.compare(b.getId(), a.getId()))
                .map(this::bookingDto)
                .toList());
        body.put("services", services.stream().map(this::serviceDto).toList());
        body.put("stylists", stylists.stream().map(this::stylistDto).toList());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/bookings/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();

        Booking1 booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getSalon() == null
                || !booking.getSalon().getId().equals(salon.getId())) {
            return badRequest("Booking not found");
        }
        String status = body == null ? "" : str(body.get("status")).toUpperCase(Locale.ROOT);
        if (status.isBlank()) return badRequest("status is required");
        String current = booking.getStatus() == null ? "PENDING" : booking.getStatus().toUpperCase(Locale.ROOT);
        boolean allowed = switch (current) {
            case "PENDING" -> status.equals("CONFIRMED") || status.equals("CANCELLED") || status.equals("REJECTED");
            case "CONFIRMED", "PAID" -> status.equals("COMPLETED") || status.equals("CANCELLED");
            default -> false;
        };
        if (!allowed) {
            return badRequest("Cannot change booking from " + current + " to " + status);
        }
        booking.setStatus(status);
        bookingRepo.save(booking);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Booking updated");
        res.put("status", status);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/services")
    @Transactional
    public ResponseEntity<Map<String, Object>> saveService(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();

        try {
            Service1 service;
            Object idObj = body.get("id");
            if (idObj != null && !idObj.toString().isBlank()) {
                service = serviceRepo.findById(Long.parseLong(idObj.toString())).orElse(new Service1());
                if (service.getSalon() != null && !service.getSalon().getId().equals(salon.getId())) {
                    return badRequest("Service does not belong to this salon");
                }
            } else {
                service = new Service1();
            }
            service.setSalon(salonRepository.findById(salon.getId()).orElse(salon));
            if (body.get("name") != null) service.setName(body.get("name").toString());
            if (body.get("price") != null) service.setPrice(Double.parseDouble(body.get("price").toString()));
            if (body.get("durationMinutes") != null) {
                service.setDurationMinutes(Integer.parseInt(body.get("durationMinutes").toString()));
            }
            if (body.get("ingredients") != null) service.setIngredients(body.get("ingredients").toString());
            if (body.get("allergenInfo") != null) service.setAllergenInfo(body.get("allergenInfo").toString());
            if (body.get("category") != null && !body.get("category").toString().isBlank()) {
                ServiceCategory cat = ServiceCategory.fromFlexible(body.get("category").toString());
                if (cat != null) service.setCategory(cat.normalized());
            }
            if (body.get("bufferMinutes") != null && !body.get("bufferMinutes").toString().isBlank()) {
                service.setBufferMinutes(Integer.parseInt(body.get("bufferMinutes").toString()));
            }
            if (body.get("serviceMode") != null && !body.get("serviceMode").toString().isBlank()) {
                service.setServiceMode(body.get("serviceMode").toString().trim().toUpperCase(Locale.ROOT));
            }
            Service1 saved = serviceRepo.save(service);
            salonProfileService.refreshCompletion(salonRepository.findById(salon.getId()).orElse(salon));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Service saved");
            res.put("service", serviceDto(saved));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Save failed: " + ex.getMessage());
        }
    }

    @DeleteMapping("/services/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteService(@PathVariable Long id, HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        Service1 service = serviceRepo.findById(id).orElse(null);
        if (service == null || service.getSalon() == null
                || !service.getSalon().getId().equals(salon.getId())) {
            return badRequest("Service not found");
        }
        try {
            serviceRepo.deleteById(id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Service deleted"));
        } catch (Exception ex) {
            return badRequest("Cannot delete service (it may have bookings).");
        }
    }

    @PostMapping("/settings")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateSettings(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        Salon fresh = salonRepository.findById(salon.getId()).orElse(salon);
        if (body.get("name") != null) fresh.setName(str(body.get("name")));
        if (body.get("phone") != null) fresh.setPhone(str(body.get("phone")));
        if (body.get("city") != null) fresh.setCity(str(body.get("city")));
        if (body.get("address") != null) fresh.setAddress(str(body.get("address")));
        if (body.get("bio") != null) fresh.setBio(str(body.get("bio")));
        if (body.get("availabilityHours") != null) fresh.setAvailabilityHours(str(body.get("availabilityHours")));
        if (body.get("upiId") != null) fresh.setUpiId(str(body.get("upiId")));
        if (body.get("bankDetails") != null) fresh.setBankDetails(str(body.get("bankDetails")));
        salonRepository.save(fresh);
        session.setAttribute("loggedSalon", fresh);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile updated");
        res.put("salon", salonDto(fresh));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/bookings/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingNotes(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        Booking1 booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getSalon() == null
                || !booking.getSalon().getId().equals(salon.getId())) {
            return badRequest("Booking not found");
        }
        booking.setCoachNotes(str(body == null ? null : body.get("coachNotes")));
        bookingRepo.save(booking);
        return ResponseEntity.ok(Map.of("success", true, "message", "Notes saved", "booking", bookingDto(booking)));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        try {
            Salon fresh = salonRepository.findById(salon.getId()).orElse(salon);
            return ResponseEntity.ok(glowCareService.requestPayout(fresh));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/photos")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        Salon fresh = salonRepository.findById(salon.getId()).orElse(salon);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                fresh.setProfileImageUrl(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (fresh.getGalleryPhotos() != null && !fresh.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(fresh.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                fresh.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(s -> !s.isEmpty()).toList()));
            }
            salonRepository.save(fresh);
            session.setAttribute("loggedSalon", fresh);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", fresh.getProfileImageUrl());
            res.put("galleryPhotos", fresh.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Upload failed: " + ex.getMessage());
        }
    }

    private Map<String, Object> salonDto(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("username", s.getUsername());
        m.put("phone", s.getPhone());
        m.put("whatsappNumber", s.getWhatsappNumber());
        m.put("city", s.getCity());
        m.put("state", s.getState());
        m.put("pincode", s.getPincode());
        m.put("address", s.getAddress());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("openDays", s.getOpenDays());
        m.put("openTime", s.getOpenTime() == null ? null : s.getOpenTime().toString());
        m.put("closeTime", s.getCloseTime() == null ? null : s.getCloseTime().toString());
        m.put("upiId", s.getUpiId());
        m.put("payoutBalance", s.getPayoutBalance());
        m.put("profileImageUrl", s.getProfileImageUrl());
        m.put("approved", s.isApproved());
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(s.getPartnerProfileStatus()));
        m.put("profileCompletionPct", s.getProfileCompletionPct() == null ? 0 : s.getProfileCompletionPct());
        m.put("canManageServices", s.isApproved()
                || s.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        return m;
    }

    private Map<String, Object> bookingDto(Booking1 b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("status", b.getStatus());
        m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
        m.put("preferredTime", b.getPreferredTime() == null ? null : b.getPreferredTime().toString());
        m.put("bookingType", b.getBookingType());
        m.put("address", b.getAddress());
        m.put("price", b.getPrice());
        m.put("notes", b.getNotes());
        m.put("coachNotes", b.getCoachNotes());
        m.put("cancelReason", b.getCancelReason());
        m.put("createdAt", b.getCreatedAt() == null ? null : b.getCreatedAt().toString());
        m.put("canCancelFree", glowCareService.canCancelFree(b));
        m.put("joinWindowOpen", glowCareService.joinWindowOpen(b));
        m.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        m.put("customerName", b.getUser() == null ? null : b.getUser().getFullName());
        m.put("customerEmail", b.getUser() == null ? null : b.getUser().getEmail());
        if (b.getService() != null) {
            m.put("itemType", "SERVICE");
            m.put("itemName", b.getService().getName());
        } else if (b.getTreatment() != null) {
            m.put("itemType", "TREATMENT");
            m.put("itemName", b.getTreatment().getServiceName());
        } else if (b.getOffer() != null) {
            m.put("itemType", "OFFER");
            m.put("itemName", b.getOffer().getTitle());
        }
        return m;
    }

    private Map<String, Object> serviceDto(Service1 s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("price", s.getPrice());
        m.put("durationMinutes", s.getDurationMinutes());
        ServiceCategory cat = s.getCategory() == null ? null : s.getCategory().normalized();
        m.put("category", cat == null ? null : cat.name());
        m.put("categoryLabel", cat == null ? null : cat.displayLabel());
        m.put("ingredients", s.getIngredients());
        m.put("allergenInfo", s.getAllergenInfo());
        m.put("bufferMinutes", s.getBufferMinutes());
        m.put("serviceMode", s.getServiceMode());
        return m;
    }

    private Map<String, Object> stylistDto(Stylist s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("firstName", s.getFirstName());
        m.put("lastName", s.getLastName());
        m.put("email", s.getEmail());
        m.put("specialization", s.getSpecialization());
        m.put("approved", s.isApproved());
        m.put("available", s.getAvailable());
        return m;
    }

    private boolean isApproved(Salon salon) {
        if (salon == null) return false;
        if (salon.isApproved()) return true;
        return salon.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED;
    }

    private Salon requireSalon(HttpSession session) {
        if (session == null) return null;
        Object s = session.getAttribute("loggedSalon");
        return s instanceof Salon ? (Salon) s : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "error", "Salon login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static String str(Object v) {
        return v == null ? "" : v.toString().trim();
    }
}
