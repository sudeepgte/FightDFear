package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.ServiceCategory;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.SalonProfileService;
import in.sp.main.Service.SalonRegistrationService;
import in.sp.main.Service.StylistProfileService;
import in.sp.main.Service.StylistRegistrationService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

/**
 * Public mobile APIs for Glow Space provider onboarding.
 */
@RestController
@RequestMapping("/api/glow/provider")
public class MobileGlowProviderAuthController {

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private SalonRegistrationService salonRegistrationService;

    @Autowired
    private SalonProfileService salonProfileService;

    @Autowired
    private StylistRegistrationService stylistRegistrationService;

    @Autowired
    private StylistProfileService stylistProfileService;

    // ── Salon OTP / quick register / profile ───────────────────────────────

    @PostMapping("/salon/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendSalonEmailOtp(@RequestBody Map<String, String> body) {
        try {
            salonRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            return okMessage("OTP sent to your email");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/salon/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifySalonEmailOtp(@RequestBody Map<String, String> body) {
        try {
            salonRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            return okMessage("Email verified");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/salon/register-quick")
    public ResponseEntity<Map<String, Object>> registerSalonQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            Salon salon = salonRegistrationService.registerQuick(
                    str(body, "username"),
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
            res.put("salonId", salon.getId());
            res.put("partnerProfileStatus", salon.getPartnerProfileStatus() == null
                    ? null : salon.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", salon.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/salon/profile")
    public ResponseEntity<Map<String, Object>> getSalonProfile(HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        salon = salonRepository.findById(salon.getId()).orElse(salon);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(salonProfileService.profilePayload(salon));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/salon/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateSalonProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        salon = salonRepository.findById(salon.getId()).orElse(salon);
        salonProfileService.applyFields(salon, body);
        salonProfileService.refreshCompletion(salon);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(salonProfileService.profilePayload(salon));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/salon/submit-verification")
    public ResponseEntity<Map<String, Object>> submitSalonVerification(HttpSession session) {
        Salon salon = requireSalon(session);
        if (salon == null) return unauthorized();
        try {
            Salon s = salonRepository.findById(salon.getId()).orElse(salon);
            salonRegistrationService.submitForVerification(s);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(salonProfileService.profilePayload(s));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    // ── Stylist OTP / quick register / profile ─────────────────────────────

    @PostMapping("/stylist/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendStylistEmailOtp(@RequestBody Map<String, String> body) {
        try {
            stylistRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            return okMessage("OTP sent to your email");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/stylist/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyStylistEmailOtp(@RequestBody Map<String, String> body) {
        try {
            stylistRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            return okMessage("Email verified");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/stylist/register-quick")
    public ResponseEntity<Map<String, Object>> registerStylistQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            Stylist stylist = stylistRegistrationService.registerQuick(
                    str(body, "firstName"),
                    str(body, "email"),
                    str(body, "contactNumber").isBlank() ? str(body, "phone") : str(body, "contactNumber"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("stylistId", stylist.getId());
            res.put("partnerProfileStatus", stylist.getPartnerProfileStatus() == null
                    ? null : stylist.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", stylist.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/stylist/profile")
    public ResponseEntity<Map<String, Object>> getStylistProfile(HttpSession session) {
        Stylist stylist = requireStylist(session);
        if (stylist == null) return unauthorized();
        stylist = stylistRepository.findById(stylist.getId()).orElse(stylist);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(stylistProfileService.profilePayload(stylist));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/stylist/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateStylistProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Stylist stylist = requireStylist(session);
        if (stylist == null) return unauthorized();
        stylist = stylistRepository.findById(stylist.getId()).orElse(stylist);
        if (body != null) {
            if (body.get("firstName") != null) {
                String v = String.valueOf(body.get("firstName")).trim();
                stylist.setFirstName(v.isBlank() ? null : v);
            }
            if (body.get("lastName") != null) {
                String v = String.valueOf(body.get("lastName")).trim();
                stylist.setLastName(v.isBlank() ? null : v);
            }
            if (body.get("contactNumber") != null || body.get("phone") != null) {
                Object raw = body.get("contactNumber") != null ? body.get("contactNumber") : body.get("phone");
                String v = String.valueOf(raw).trim();
                stylist.setContactNumber(v.isBlank() ? null : v);
            }
            if (body.get("specialization") != null) {
                String v = String.valueOf(body.get("specialization")).trim();
                stylist.setSpecialization(v.isBlank() ? null : v);
            }
            if (body.get("bio") != null) {
                String v = String.valueOf(body.get("bio")).trim();
                stylist.setBio(v.isBlank() ? null : v);
            }
            if (body.get("availabilityHours") != null) {
                String v = String.valueOf(body.get("availabilityHours")).trim();
                stylist.setAvailabilityHours(v.isBlank() ? null : v);
            }
            if (body.get("profileImage") != null) {
                String v = String.valueOf(body.get("profileImage")).trim();
                stylist.setProfileImage(v.isBlank() ? null : v);
            }
            if (body.containsKey("experienceInYears")) {
                Object raw = body.get("experienceInYears");
                if (raw == null || String.valueOf(raw).isBlank()) {
                    stylist.setExperienceInYears(null);
                } else {
                    try {
                        stylist.setExperienceInYears(Integer.parseInt(String.valueOf(raw).trim()));
                    } catch (NumberFormatException e) {
                        return badRequest("Invalid experienceInYears");
                    }
                }
            }
        }
        stylistProfileService.refreshCompletion(stylist);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(stylistProfileService.profilePayload(stylist));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/stylist/submit-verification")
    public ResponseEntity<Map<String, Object>> submitStylistVerification(HttpSession session) {
        Stylist stylist = requireStylist(session);
        if (stylist == null) return unauthorized();
        try {
            Stylist s = stylistRepository.findById(stylist.getId()).orElse(stylist);
            stylistRegistrationService.submitForVerification(s);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(stylistProfileService.profilePayload(s));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    // ── Login (allows incomplete profiles) ─────────────────────────────────

    @PostMapping("/login/salon")
    public ResponseEntity<Map<String, Object>> loginSalon(
            @RequestBody Map<String, String> body,
            HttpSession session) {
        String login = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        if (login.isBlank()) {
            login = trim(body == null ? null : body.get("username")).toLowerCase(Locale.ROOT);
        }
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (login.isBlank() || password.isBlank()) {
            return badRequest("Email and password are required");
        }
        Optional<Salon> salonOpt = salonRepository.findByUsername(login);
        if (salonOpt.isEmpty()) {
            salonOpt = Optional.ofNullable(salonRepository.findByEmail(login));
        }
        if (salonOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(error("Glow Space account not found"));
        }
        Salon salon = salonOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, salon.getPassword(), hashed -> {
            salon.setPassword(hashed);
            salonRepository.save(salon);
        });
        if (!ok) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        }

        PartnerProfileStatus status = salon.getPartnerProfileStatus();
        if (status == null) {
            salonProfileService.setLifecycleStatus(salon,
                    PartnerLifecycleSupport.fromApprovedFlag(salon.isApproved()));
            if (!salon.isApproved()) {
                salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            salonProfileService.refreshCompletion(salon);
        } else if (status == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your salon account has been suspended"));
        } else {
            salonProfileService.refreshCompletion(salon);
            // Keep approved flag in sync with lifecycle
            if (salon.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED && !salon.isApproved()) {
                salon.setApproved(true);
                salonRepository.save(salon);
            } else if (salon.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED && salon.isApproved()) {
                salon.setApproved(false);
                salonRepository.save(salon);
            }
        }

        session.setAttribute("loggedSalon", salon);
        String token = jwtUtil.generateToken(salon.getUsername(), "SALON");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "SALON");
        res.put("salon", salonSummary(salon));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(salon.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                salonProfileService.isReadyForVerification(salon)
                        && salon.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/login/stylist")
    public ResponseEntity<Map<String, Object>> loginStylist(
            @RequestBody Map<String, String> body,
            HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) {
            return badRequest("Email and password are required");
        }
        Optional<Stylist> stylistOpt = stylistRepository.findByEmail(email);
        if (stylistOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(error("Stylist not found"));
        }
        Stylist stylist = stylistOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, stylist.getPassword(), hashed -> {
            stylist.setPassword(hashed);
            stylistRepository.save(stylist);
        });
        if (!ok) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        }

        PartnerProfileStatus status = stylist.getPartnerProfileStatus();
        if (status == null) {
            stylistProfileService.setLifecycleStatus(stylist,
                    PartnerLifecycleSupport.fromApprovedFlag(stylist.isApproved()));
            if (!stylist.isApproved()) {
                stylistProfileService.setLifecycleStatus(stylist, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            stylistProfileService.refreshCompletion(stylist);
        } else if (status == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your stylist account has been suspended"));
        } else {
            stylistProfileService.refreshCompletion(stylist);
            if (stylist.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED && !stylist.isApproved()) {
                stylist.setApproved(true);
                stylistRepository.save(stylist);
            } else if (stylist.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED && stylist.isApproved()) {
                stylist.setApproved(false);
                stylistRepository.save(stylist);
            }
        }

        session.setAttribute("loggedStylist", stylist);
        String token = jwtUtil.generateToken(stylist.getEmail(), "STYLIST");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "STYLIST");
        res.put("stylist", stylistSummary(stylist));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(stylist.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                stylistProfileService.isReadyForVerification(stylist)
                        && stylist.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    // ── Legacy full register ───────────────────────────────────────────────

    @PostMapping("/register/salon")
    @Transactional
    public ResponseEntity<Map<String, Object>> registerSalon(@RequestBody Map<String, Object> body) {
        Map<String, Object> res = new LinkedHashMap<>();
        if (body == null) return badRequest("Request body is required");

        String name = strObj(body.get("name"));
        String username = strObj(body.get("username")).toLowerCase(Locale.ROOT);
        String phone = strObj(body.get("phone"));
        String city = strObj(body.get("city"));
        String password = body.get("password") == null ? "" : body.get("password").toString();
        String confirmPassword = body.get("confirmPassword") == null ? "" : body.get("confirmPassword").toString();
        String bio = strObj(body.get("bio"));
        String availabilityHours = strObj(body.get("availabilityHours"));
        String address = strObj(body.get("address"));

        if (name.isBlank() || username.isBlank()) {
            return badRequest("name and username are required");
        }
        if (username.length() < 3) return badRequest("Username must be at least 3 characters");
        String phoneErr = MobileValidation.requirePhone(phone, false);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        Optional<Salon> existing = salonRepository.findByUsername(username);
        if (existing.isPresent()) {
            res.put("success", false);
            res.put("error", "Username already registered");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(res);
        }

        Salon salon = new Salon();
        salon.setName(name);
        salon.setUsername(username);
        salon.setPassword(passwordService.encode(password));
        salon.setPhone(phone.isBlank() ? null : phone);
        salon.setCity(city.isBlank() ? null : city);
        salon.setAddress(address.isBlank() ? null : address);
        salon.setBio(bio.isBlank() ? null : bio);
        salon.setAvailabilityHours(availabilityHours.isBlank() ? null : availabilityHours);
        salon.setHygieneCertificateUrl("mobile-pending");
        salon.setApproved(false);
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.REGISTERED);
        salonRepository.save(salon);
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.PROFILE_INCOMPLETE);
        salonProfileService.refreshCompletion(salon);

        int seeded = 0;
        try {
            seeded = seedServices(salon, body.get("services"), body.get("categories"));
        } catch (Exception ex) {
            seeded = 0;
            res.put("seedWarning", "Services could not be seeded automatically: " + ex.getMessage());
        }

        res.put("success", true);
        res.put("message", "Glow Space registration submitted. Complete profile and await admin verification.");
        res.put("providerType", "SALON");
        res.put("salonId", salon.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", salon.getPartnerProfileStatus() == null
                ? null : salon.getPartnerProfileStatus().name());
        res.put("servicesSeeded", seeded);
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/register/stylist")
    public ResponseEntity<Map<String, Object>> registerStylist(@RequestBody Map<String, String> body) {
        Map<String, Object> res = new LinkedHashMap<>();
        if (body == null) return badRequest("Request body is required");

        String firstName = trim(body.get("firstName"));
        String lastName = trim(body.get("lastName"));
        String email = MobileValidation.normalizeEmail(body.get("email"));
        String contactNumber = trim(body.get("contactNumber"));
        String password = body.getOrDefault("password", "");
        String confirmPassword = body.getOrDefault("confirmPassword", "");
        String specialization = trim(body.get("specialization"));
        String bio = trim(body.get("bio"));
        String availabilityHours = trim(body.get("availabilityHours"));

        if (firstName.isBlank()) return badRequest("firstName is required");
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(contactNumber, false);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (stylistRepository.findByEmail(email).isPresent()) {
            res.put("success", false);
            res.put("error", "Email already registered");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(res);
        }

        Stylist stylist = new Stylist();
        stylist.setFirstName(firstName);
        stylist.setLastName(lastName.isBlank() ? null : lastName);
        stylist.setEmail(email);
        stylist.setContactNumber(contactNumber.isBlank() ? null : contactNumber);
        stylist.setPassword(passwordService.encode(password));
        stylist.setSpecialization(specialization.isBlank() ? null : specialization);
        stylist.setBio(bio.isBlank() ? null : bio);
        stylist.setAvailabilityHours(availabilityHours.isBlank() ? null : availabilityHours);
        stylist.setAvailable(true);
        stylist.setRating(0.0);
        stylist.setIsIndependent(true);
        stylist.setApproved(false);
        stylistProfileService.setLifecycleStatus(stylist, PartnerProfileStatus.REGISTERED);
        stylistRepository.save(stylist);
        stylistProfileService.setLifecycleStatus(stylist, PartnerProfileStatus.PROFILE_INCOMPLETE);
        stylistProfileService.refreshCompletion(stylist);

        res.put("success", true);
        res.put("message", "Stylist registration submitted. Complete profile and await admin verification.");
        res.put("providerType", "STYLIST");
        res.put("stylistId", stylist.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", stylist.getPartnerProfileStatus() == null
                ? null : stylist.getPartnerProfileStatus().name());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    private int seedServices(Salon salon, Object servicesRaw, Object categoriesRaw) {
        List<Service1> toSave = new ArrayList<>();

        if (servicesRaw instanceof List<?> list && !list.isEmpty()) {
            for (Object item : list) {
                if (!(item instanceof Map<?, ?> m)) continue;
                String serviceName = strObj(m.get("name"));
                if (serviceName.isBlank()) continue;
                ServiceCategory cat = ServiceCategory.fromFlexible(strObj(m.get("category")));
                if (cat == null) cat = ServiceCategory.HAIR;
                cat = cat.normalized();

                Service1 s = new Service1();
                s.setSalon(salon);
                s.setName(serviceName);
                s.setCategory(cat);
                s.setPrice(asDouble(m.get("price"), defaultPrice(cat)));
                s.setDurationMinutes(asInt(m.get("durationMinutes"), defaultDuration(cat)));
                toSave.add(s);
            }
        } else if (categoriesRaw instanceof List<?> cats && !cats.isEmpty()) {
            for (Object c : cats) {
                ServiceCategory cat = ServiceCategory.fromFlexible(strObj(c));
                if (cat == null) continue;
                cat = cat.normalized();
                for (String starter : starterServices(cat)) {
                    Service1 s = new Service1();
                    s.setSalon(salon);
                    s.setName(starter);
                    s.setCategory(cat);
                    s.setPrice(defaultPrice(cat));
                    s.setDurationMinutes(defaultDuration(cat));
                    toSave.add(s);
                }
            }
        }

        if (!toSave.isEmpty()) {
            serviceRepository.saveAll(toSave);
        }
        return toSave.size();
    }

    private static List<String> starterServices(ServiceCategory cat) {
        return switch (cat) {
            case HAIR -> List.of("Hair Cut (Women)", "Hair Spa", "Hair Coloring");
            case SKIN_CARE -> List.of("Facial", "Clean-Up", "De-Tan");
            case MAKEUP -> List.of("Party Makeup", "Bridal Makeup", "Saree Draping");
            case NAIL_CARE -> List.of("Manicure", "Pedicure", "Nail Art");
            case SPA_MASSAGE -> List.of("Full Body Spa", "Head Massage", "Foot Massage");
            case WAXING -> List.of("Full Arms Wax", "Underarms Wax", "Full Legs Wax");
            case THREADING -> List.of("Eyebrows", "Upper Lip", "Full Face");
            case EYE_BROW -> List.of("Eyebrow Shaping", "Eyelash Extensions");
            case BRIDAL -> List.of("Bridal Makeup", "Bridal Hair Styling", "Pre-Bridal Package");
            case MEHENDI -> List.of("Bridal Mehendi", "Arabic Mehendi");
            case WELLNESS -> List.of("Personal Grooming", "Lifestyle Consultation");
            case COSMETIC -> List.of("Skin Brightening", "Anti-Aging Treatment");
            case TRAINING -> List.of("Makeup Classes", "Self Grooming Workshop");
            case PACKAGES -> List.of("Wedding Package", "Festival Offer Package");
            default -> List.of(cat.displayLabel() + " Service");
        };
    }

    private static double defaultPrice(ServiceCategory cat) {
        return switch (cat) {
            case BRIDAL, PACKAGES -> 2999;
            case COSMETIC -> 1999;
            case MAKEUP -> 1499;
            case SPA_MASSAGE -> 999;
            case HAIR -> 499;
            case SKIN_CARE -> 699;
            case TRAINING -> 2499;
            case MEHENDI -> 799;
            default -> 299;
        };
    }

    private static int defaultDuration(ServiceCategory cat) {
        return switch (cat) {
            case SPA_MASSAGE, BRIDAL, PACKAGES, COSMETIC -> 60;
            case MAKEUP, HAIR -> 45;
            case TRAINING -> 90;
            default -> 30;
        };
    }

    private static double asDouble(Object v, double fallback) {
        if (v == null) return fallback;
        try {
            return Double.parseDouble(v.toString().trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static int asInt(Object v, int fallback) {
        if (v == null) return fallback;
        try {
            return Integer.parseInt(v.toString().trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return body.get(key).toString().trim();
    }

    private static String strObj(Object v) {
        return v == null ? "" : v.toString().trim();
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(error("Login required"));
    }

    private ResponseEntity<Map<String, Object>> okMessage(String message) {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", message);
        return ResponseEntity.ok(res);
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", false);
        res.put("error", msg);
        return res;
    }

    private Salon requireSalon(HttpSession session) {
        if (session == null) return null;
        Object s = session.getAttribute("loggedSalon");
        return s instanceof Salon ? (Salon) s : null;
    }

    private Stylist requireStylist(HttpSession session) {
        if (session == null) return null;
        Object s = session.getAttribute("loggedStylist");
        return s instanceof Stylist ? (Stylist) s : null;
    }

    private static Map<String, Object> salonSummary(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("username", s.getUsername());
        m.put("phone", s.getPhone());
        m.put("city", s.getCity());
        m.put("address", s.getAddress());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("approved", s.isApproved());
        m.put("profileImageUrl", s.getProfileImageUrl());
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("profileCompletionPct", s.getProfileCompletionPct());
        return m;
    }

    private static Map<String, Object> stylistSummary(Stylist s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("firstName", s.getFirstName());
        m.put("lastName", s.getLastName());
        m.put("email", s.getEmail());
        m.put("contactNumber", s.getContactNumber());
        m.put("specialization", s.getSpecialization());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("approved", s.isApproved());
        m.put("profileImage", s.getProfileImage());
        m.put("salonId", s.getSalon() == null ? null : s.getSalon().getId());
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("profileCompletionPct", s.getProfileCompletionPct());
        return m;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
